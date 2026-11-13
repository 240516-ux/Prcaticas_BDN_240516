-- Rutina reutilizable; no ejecuta cargas por si sola.
USE bd_test;
DELIMITER $$
CREATE PROCEDURE sp_p03_productos_vendedor(IN p_lote VARCHAR(32),IN p_cantidad INT,IN p_precio DECIMAL(10,2),IN p_stock INT)
SQL SECURITY INVOKER
BEGIN
 DECLARE v_i INT DEFAULT 1; DECLARE v_user INT; DECLARE v_product INT UNSIGNED;
 DECLARE v_cat INT UNSIGNED; DECLARE v_cat_count INT; DECLARE v_offset INT;
 DECLARE v_iniciada BOOLEAN DEFAULT FALSE;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF v_iniciada THEN ROLLBACK; END IF; RESIGNAL; END;
 IF LOCATE('`seller`@',CURRENT_ROLE())=0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requiere rol seller activo';
 END IF;
 IF p_lote IS NULL OR NOT REGEXP_LIKE(p_lote,'^[A-Za-z0-9_-]{1,32}$','c') OR p_cantidad IS NULL OR p_cantidad<1 OR p_cantidad>20000
 OR p_precio IS NULL OR p_precio<0 OR p_stock IS NULL OR p_stock<0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Parametros de productos invalidos';
 END IF;
 IF (SELECT COUNT(*) FROM tb_users WHERE nick=SUBSTRING_INDEX(USER(),'@',1))<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No hay perfil unico con el alias exacto de la cuenta; no se supone un ID';
 END IF;
 SELECT ID INTO v_user FROM tb_users WHERE nick=SUBSTRING_INDEX(USER(),'@',1);
 SELECT COUNT(*) INTO v_cat_count FROM tbc_categories WHERE status=b'1';
 IF v_cat_count=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requieren categorias propias activas'; END IF;
 IF EXISTS(SELECT 1 FROM tb_products WHERE LEFT(SKU,CHAR_LENGTH(CONCAT('P03-',p_lote,'-')))=CONCAT('P03-',p_lote,'-')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Lote de productos existente; no se duplica';
 END IF;
 SET TRANSACTION READ WRITE;
 START TRANSACTION; SET v_iniciada=TRUE;
 WHILE v_i<=p_cantidad DO
  SET v_offset=MOD(v_i-1,v_cat_count);
  SELECT ID INTO v_cat FROM tbc_categories WHERE status=b'1' ORDER BY ID LIMIT v_offset,1;
  INSERT INTO tb_products(SKU,name,description,current_price,current_stock,status)
  VALUES(CONCAT('P03-',p_lote,'-',LPAD(v_i,5,'0')),CONCAT('Producto simulado ',p_lote,' ',v_i),
   'Simulacion autorizada de Practica03',p_precio,p_stock,IF(MOD(v_i,10)=0,0,1));
  SET v_product=LAST_INSERT_ID();
  INSERT INTO tbd_products_users_providers(user_ID,product_ID,type_ownership,avalaible_date,last_update)
  VALUES(v_user,v_product,'Owner',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
  INSERT INTO tbd_products_categories(category_ID,product_ID,status) VALUES(v_cat,v_product,b'1');
  SET v_i=v_i+1;
 END WHILE;
 COMMIT; SET v_iniciada=FALSE;
 SELECT p_lote AS lote,p_cantidad AS productos,SUBSTRING_INDEX(USER(),'@',1) AS realizado_por;
END$$
DELIMITER ;
