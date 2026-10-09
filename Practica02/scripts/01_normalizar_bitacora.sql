-- Migración reejecutable; conservar un respaldo antes de aplicarla.
USE bd_test;
DROP PROCEDURE IF EXISTS _practica_normalizar_bitacora;
DELIMITER $$
CREATE PROCEDURE _practica_normalizar_bitacora()
BEGIN
 IF EXISTS(SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tb_logs' AND COLUMN_NAME='connection_host') THEN
  ALTER TABLE tb_logs DROP COLUMN connection_host;
 END IF;
 IF NOT EXISTS(SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tb_logs' AND COLUMN_NAME='record_id') THEN
  ALTER TABLE tb_logs ADD COLUMN record_id INT UNSIGNED DEFAULT NULL;
 END IF;
 IF NOT EXISTS(SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tb_logs' AND COLUMN_NAME='record_key') THEN
  ALTER TABLE tb_logs ADD COLUMN record_key VARCHAR(100) DEFAULT NULL;
 END IF;
 IF NOT EXISTS(SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tb_logs' AND COLUMN_NAME='actor_roles') THEN
  ALTER TABLE tb_logs ADD COLUMN actor_roles VARCHAR(255) DEFAULT NULL;
 END IF;
 IF NOT EXISTS(SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tb_logs' AND INDEX_NAME='ix_trace') THEN
  ALTER TABLE tb_logs ADD INDEX ix_trace(table_name,record_id,table_operation);
 END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_users_after_insert;
DROP TRIGGER IF EXISTS trg_users_after_update;
DROP TRIGGER IF EXISTS trg_users_after_delete;
DROP TRIGGER IF EXISTS trg_products_after_insert;
DROP TRIGGER IF EXISTS trg_products_after_update;
DROP TRIGGER IF EXISTS trg_products_after_delete;
CALL _practica_normalizar_bitacora();
DROP PROCEDURE _practica_normalizar_bitacora;
UPDATE tb_logs SET db_user=SUBSTRING_INDEX(db_user,'@',1) WHERE LOCATE('@',db_user)>0;
DELIMITER $$
DROP TRIGGER IF EXISTS trg_users_after_insert$$
CREATE TRIGGER trg_users_after_insert AFTER INSERT ON tb_users FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_users','Create',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', NEW.ID, 'email', NEW.email, 'nick', NEW.nick, 'status', NEW.status+0));
END$$
DROP TRIGGER IF EXISTS trg_users_after_update$$
CREATE TRIGGER trg_users_after_update AFTER UPDATE ON tb_users FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_users','Update',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.ID, 'email', OLD.email, 'nick', OLD.nick, 'status', OLD.status+0), 'despues', JSON_OBJECT('ID', NEW.ID, 'email', NEW.email, 'nick', NEW.nick, 'status', NEW.status+0)));
END$$
DROP TRIGGER IF EXISTS trg_users_after_delete$$
CREATE TRIGGER trg_users_after_delete AFTER DELETE ON tb_users FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_users','Delete',SUBSTRING_INDEX(USER(),'@',1),OLD.ID,CAST(OLD.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', OLD.ID, 'email', OLD.email, 'nick', OLD.nick, 'status', OLD.status+0));
END$$
DROP TRIGGER IF EXISTS trg_products_after_insert$$
CREATE TRIGGER trg_products_after_insert AFTER INSERT ON tb_products FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_products','Create',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', NEW.ID, 'SKU', NEW.SKU, 'name', NEW.name, 'current_price', NEW.current_price, 'current_stock', NEW.current_stock, 'status', NEW.status+0));
END$$
DROP TRIGGER IF EXISTS trg_products_after_update$$
CREATE TRIGGER trg_products_after_update AFTER UPDATE ON tb_products FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_products','Update',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.ID, 'SKU', OLD.SKU, 'name', OLD.name, 'current_price', OLD.current_price, 'current_stock', OLD.current_stock, 'status', OLD.status+0), 'despues', JSON_OBJECT('ID', NEW.ID, 'SKU', NEW.SKU, 'name', NEW.name, 'current_price', NEW.current_price, 'current_stock', NEW.current_stock, 'status', NEW.status+0)));
END$$
DROP TRIGGER IF EXISTS trg_products_after_delete$$
CREATE TRIGGER trg_products_after_delete AFTER DELETE ON tb_products FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_products','Delete',SUBSTRING_INDEX(USER(),'@',1),OLD.ID,CAST(OLD.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', OLD.ID, 'SKU', OLD.SKU, 'name', OLD.name, 'current_price', OLD.current_price, 'current_stock', OLD.current_stock, 'status', OLD.status+0));
END$$
DELIMITER ;
CREATE OR REPLACE VIEW vw_trazabilidad_productos AS SELECT p.ID AS id,p.SKU,p.name,p.description, SUBSTRING_INDEX(b.db_user,'@',1) AS inserted_by,b.actor_roles AS roles,b.operation_description,b.operation_date FROM tb_products p JOIN tb_logs b ON b.record_id=p.ID AND b.table_name='tb_products' AND b.table_operation='Create';
CREATE OR REPLACE VIEW vw_trazabilidad_usuarios AS SELECT p.ID AS id,p.nick,p.email, SUBSTRING_INDEX(b.db_user,'@',1) AS inserted_by,b.actor_roles AS roles,b.operation_description,b.operation_date FROM tb_users p JOIN tb_logs b ON b.record_id=p.ID AND b.table_name='tb_users' AND b.table_operation='Create';
