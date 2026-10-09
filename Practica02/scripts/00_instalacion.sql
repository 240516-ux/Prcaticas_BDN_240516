-- Instalación limpia: ejecutar solamente en una base nueva.
CREATE DATABASE IF NOT EXISTS bd_test CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE bd_test;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delete') NOT NULL,
  `db_user` varchar(80) NOT NULL,
  `operation_description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  `record_id` int unsigned DEFAULT NULL,
  `record_key` varchar(100) DEFAULT NULL,
  `actor_roles` varchar(255) DEFAULT NULL,
  KEY ix_trace (table_name, record_id, table_operation),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(80) NOT NULL,
  `nick` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER $$
-- Trazabilidad de Create: USER() identifica la conexión que realizó la operación.
CREATE TRIGGER trg_users_after_insert AFTER INSERT ON tb_users FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_users','Create',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', NEW.ID, 'email', NEW.email, 'nick', NEW.nick, 'status', NEW.status+0));
END$$
-- Trazabilidad de Update: USER() identifica la conexión que realizó la operación.
CREATE TRIGGER trg_users_after_update AFTER UPDATE ON tb_users FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_users','Update',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.ID, 'email', OLD.email, 'nick', OLD.nick, 'status', OLD.status+0), 'despues', JSON_OBJECT('ID', NEW.ID, 'email', NEW.email, 'nick', NEW.nick, 'status', NEW.status+0)));
END$$
-- Trazabilidad de Delete: USER() identifica la conexión que realizó la operación.
CREATE TRIGGER trg_users_after_delete AFTER DELETE ON tb_users FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_users','Delete',SUBSTRING_INDEX(USER(),'@',1),OLD.ID,CAST(OLD.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', OLD.ID, 'email', OLD.email, 'nick', OLD.nick, 'status', OLD.status+0));
END$$
-- Trazabilidad de Create: USER() identifica la conexión que realizó la operación.
CREATE TRIGGER trg_products_after_insert AFTER INSERT ON tb_products FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_products','Create',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', NEW.ID, 'SKU', NEW.SKU, 'name', NEW.name, 'current_price', NEW.current_price, 'current_stock', NEW.current_stock, 'status', NEW.status+0));
END$$
-- Trazabilidad de Update: USER() identifica la conexión que realizó la operación.
CREATE TRIGGER trg_products_after_update AFTER UPDATE ON tb_products FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_products','Update',SUBSTRING_INDEX(USER(),'@',1),NEW.ID,CAST(NEW.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.ID, 'SKU', OLD.SKU, 'name', OLD.name, 'current_price', OLD.current_price, 'current_stock', OLD.current_stock, 'status', OLD.status+0), 'despues', JSON_OBJECT('ID', NEW.ID, 'SKU', NEW.SKU, 'name', NEW.name, 'current_price', NEW.current_price, 'current_stock', NEW.current_stock, 'status', NEW.status+0)));
END$$
-- Trazabilidad de Delete: USER() identifica la conexión que realizó la operación.
CREATE TRIGGER trg_products_after_delete AFTER DELETE ON tb_products FOR EACH ROW
BEGIN
 INSERT INTO tb_logs(table_name,table_operation,db_user,record_id,record_key,actor_roles,operation_description)
 VALUES ('tb_products','Delete',SUBSTRING_INDEX(USER(),'@',1),OLD.ID,CAST(OLD.ID AS CHAR),
 (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ') FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),JSON_OBJECT('ID', OLD.ID, 'SKU', OLD.SKU, 'name', OLD.name, 'current_price', OLD.current_price, 'current_stock', OLD.current_stock, 'status', OLD.status+0));
END$$
DELIMITER ;
CREATE VIEW vw_trazabilidad_productos AS SELECT p.ID AS id,p.SKU,p.name,p.description, SUBSTRING_INDEX(b.db_user,'@',1) AS inserted_by,b.actor_roles AS roles,b.operation_description,b.operation_date FROM tb_products p JOIN tb_logs b ON b.record_id=p.ID AND b.table_name='tb_products' AND b.table_operation='Create';
CREATE VIEW vw_trazabilidad_usuarios AS SELECT p.ID AS id,p.nick,p.email, SUBSTRING_INDEX(b.db_user,'@',1) AS inserted_by,b.actor_roles AS roles,b.operation_description,b.operation_date FROM tb_users p JOIN tb_logs b ON b.record_id=p.ID AND b.table_name='tb_users' AND b.table_operation='Create';
