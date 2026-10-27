
CREATE TABLE IF NOT EXISTS tb_users (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(80) NOT NULL UNIQUE,
    email VARCHAR(150) UNIQUE,
    role_name VARCHAR(30) NOT NULL DEFAULT 'common',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tb_products (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price NUMERIC(10,2) NOT NULL DEFAULT 0,
    stock INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tb_logs (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name VARCHAR(64) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    record_id INTEGER,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details JSONB
);

CREATE OR REPLACE FUNCTION audit_users()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO tb_logs (table_name, operation, record_id, details)
    VALUES (
        'tb_users',
        TG_OP,
        CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
        CASE
            WHEN TG_OP = 'DELETE'
                THEN to_jsonb(OLD)
            ELSE to_jsonb(NEW)
        END
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION audit_products()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO tb_logs (table_name, operation, record_id, details)
    VALUES (
        'tb_products',
        TG_OP,
        CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
        CASE
            WHEN TG_OP = 'DELETE'
                THEN to_jsonb(OLD)
            ELSE to_jsonb(NEW)
        END
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_audit_users ON tb_users;
CREATE TRIGGER trg_audit_users
AFTER INSERT OR UPDATE OR DELETE ON tb_users
FOR EACH ROW EXECUTE FUNCTION audit_users();

DROP TRIGGER IF EXISTS trg_audit_products ON tb_products;
CREATE TRIGGER trg_audit_products
AFTER INSERT OR UPDATE OR DELETE ON tb_products
FOR EACH ROW EXECUTE FUNCTION audit_products();

CREATE OR REPLACE VIEW vw_trazabilidad_usuarios AS
SELECT id, table_name, operation, record_id, changed_at, details
FROM tb_logs
WHERE table_name = 'tb_users';

CREATE OR REPLACE VIEW vw_trazabilidad_productos AS
SELECT id, table_name, operation, record_id, changed_at, details
FROM tb_logs
WHERE table_name = 'tb_products';
