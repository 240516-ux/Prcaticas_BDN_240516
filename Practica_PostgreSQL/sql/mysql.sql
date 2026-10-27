
CREATE DATABASE IF NOT EXISTS bd_test_alan;
USE bd_test_alan;

CREATE TABLE IF NOT EXISTS tb_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(80) NOT NULL UNIQUE,
    email VARCHAR(150) UNIQUE,
    role_name VARCHAR(30) NOT NULL DEFAULT 'common',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tb_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tb_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(64) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    record_id INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details JSON
);

DELIMITER //

CREATE TRIGGER trg_users_insert
AFTER INSERT ON tb_users
FOR EACH ROW
BEGIN
    INSERT INTO tb_logs
        (table_name, operation, record_id, details)
    VALUES
        ('tb_users', 'INSERT', NEW.id,
         JSON_OBJECT('username', NEW.username,
                     'role_name', NEW.role_name));
END//

CREATE TRIGGER trg_users_update
AFTER UPDATE ON tb_users
FOR EACH ROW
BEGIN
    INSERT INTO tb_logs
        (table_name, operation, record_id, details)
    VALUES
        ('tb_users', 'UPDATE', NEW.id,
         JSON_OBJECT('username', NEW.username,
                     'role_name', NEW.role_name));
END//

CREATE TRIGGER trg_users_delete
AFTER DELETE ON tb_users
FOR EACH ROW
BEGIN
    INSERT INTO tb_logs
        (table_name, operation, record_id, details)
    VALUES
        ('tb_users', 'DELETE', OLD.id,
         JSON_OBJECT('username', OLD.username,
                     'role_name', OLD.role_name));
END//

CREATE TRIGGER trg_products_insert
AFTER INSERT ON tb_products
FOR EACH ROW
BEGIN
    INSERT INTO tb_logs
        (table_name, operation, record_id, details)
    VALUES
        ('tb_products', 'INSERT', NEW.id,
         JSON_OBJECT('product_name', NEW.product_name,
                     'price', NEW.price,
                     'stock', NEW.stock));
END//

CREATE TRIGGER trg_products_update
AFTER UPDATE ON tb_products
FOR EACH ROW
BEGIN
    INSERT INTO tb_logs
        (table_name, operation, record_id, details)
    VALUES
        ('tb_products', 'UPDATE', NEW.id,
         JSON_OBJECT('product_name', NEW.product_name,
                     'price', NEW.price,
                     'stock', NEW.stock));
END//

CREATE TRIGGER trg_products_delete
AFTER DELETE ON tb_products
FOR EACH ROW
BEGIN
    INSERT INTO tb_logs
        (table_name, operation, record_id, details)
    VALUES
        ('tb_products', 'DELETE', OLD.id,
         JSON_OBJECT('product_name', OLD.product_name,
                     'price', OLD.price,
                     'stock', OLD.stock));
END//

DELIMITER ;

CREATE OR REPLACE VIEW vw_trazabilidad_usuarios AS
SELECT id, table_name, operation, record_id, changed_at, details
FROM tb_logs
WHERE table_name = 'tb_users';

CREATE OR REPLACE VIEW vw_trazabilidad_productos AS
SELECT id, table_name, operation, record_id, changed_at, details
FROM tb_logs
WHERE table_name = 'tb_products';
