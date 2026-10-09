USE bd_test;
-- Conectar como el vendedor que realiza la carga; no ejecutar como root.
SELECT SUBSTRING_INDEX(USER(),'@',1) AS usuario_que_carga, CURRENT_ROLE() AS rol_activo;
LOAD DATA LOCAL INFILE 'Practica02/seeds/5000_productos.csv'
INTO TABLE tb_products CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(@original_id,SKU,name,description,current_price,current_stock,@status,@creation,@updated)
SET status=IF(@status='1',b'1',b'0'),
creation_date=STR_TO_DATE(@creation,'%d/%m/%Y %H:%i'),
last_update=STR_TO_DATE(TRIM(TRAILING '\r' FROM @updated),'%d/%m/%Y %H:%i');
SHOW WARNINGS;
SELECT inserted_by,roles,COUNT(*) AS productos_insertados FROM vw_trazabilidad_productos GROUP BY inserted_by,roles;
