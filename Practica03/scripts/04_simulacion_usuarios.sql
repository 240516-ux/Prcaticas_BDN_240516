-- Crear solo si no existe; una version distinta requiere respaldo y reemplazo autorizado.
-- Datos sinteticos de la practica, nunca cuentas de autenticacion del servidor.
USE bd_test;
DELIMITER $$
CREATE FUNCTION fn_p03_nacimiento(p_min INT, p_max INT, p_referencia DATE)
RETURNS DATE NOT DETERMINISTIC NO SQL SQL SECURITY INVOKER
BEGIN
 DECLARE v_edad INT; DECLARE v_inicio DATE; DECLARE v_fin DATE;
 IF p_min IS NULL OR p_max IS NULL OR p_referencia IS NULL OR p_min<0 OR p_max>120 OR p_min>p_max THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Intervalo de edad o fecha invalido';
 END IF;
 IF YEAR(p_referencia)-p_max-1<1000 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha y edad exceden el rango DATE de MySQL';
 END IF;
 SET v_edad=p_min+FLOOR(RAND()*(p_max-p_min+1));
 SET v_inicio=DATE_ADD(DATE_SUB(p_referencia,INTERVAL (v_edad+1) YEAR),INTERVAL 1 DAY);
 SET v_fin=DATE_SUB(p_referencia,INTERVAL v_edad YEAR);
 RETURN DATE_ADD(v_inicio,INTERVAL FLOOR(RAND()*(DATEDIFF(v_fin,v_inicio)+1)) DAY);
END$$

CREATE PROCEDURE sp_p03_simular_usuarios(
 IN p_lote VARCHAR(32), IN p_cantidad INT, IN p_genero VARCHAR(30),
 IN p_pais VARCHAR(80), IN p_edad_min INT, IN p_edad_max INT,
 IN p_prob_activo DECIMAL(6,5), IN p_fecha_referencia DATE)
SQL SECURITY INVOKER
BEGIN
 DECLARE v_i INT DEFAULT 1; DECLARE v_user INT; DECLARE v_estado INT;
 DECLARE v_genero VARCHAR(30); DECLARE v_pais VARCHAR(80); DECLARE v_fecha DATE;
 DECLARE v_iniciada BOOLEAN DEFAULT FALSE;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF v_iniciada THEN ROLLBACK; END IF; RESIGNAL; END;
 IF LOCATE('`superadmin`@',CURRENT_ROLE())=0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requiere rol superadmin activo';
 END IF;
 IF p_lote IS NULL OR NOT REGEXP_LIKE(p_lote,'^[A-Za-z0-9_-]{1,32}$','c') OR p_cantidad IS NULL OR p_cantidad<1 OR p_cantidad>10000 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Lote o cantidad invalido';
 END IF;
 IF p_prob_activo IS NULL OR p_prob_activo<0 OR p_prob_activo>1 OR p_fecha_referencia IS NULL OR p_fecha_referencia>CURRENT_DATE() THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Probabilidad o fecha invalida';
 END IF;
 IF p_genero IS NOT NULL AND p_genero<>'*' AND p_genero NOT IN ('Masculino','Femenino') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Genero permitido: Masculino, Femenino, NULL o *';
 END IF;
 IF p_pais IS NOT NULL AND p_pais<>'*' AND CHAR_LENGTH(TRIM(p_pais))=0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Pais vacio no permitido';
 END IF;
 IF (p_edad_min IS NULL)<>(p_edad_max IS NULL) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Proporcionar ambos limites de edad o ambos NULL';
 END IF;
 SET v_fecha=fn_p03_nacimiento(COALESCE(p_edad_min,18),COALESCE(p_edad_max,80),p_fecha_referencia);
 -- No se reanuda un lote parcial ni se confunde con personas originales.
 IF EXISTS(SELECT 1 FROM tb_users WHERE LEFT(email,CHAR_LENGTH(CONCAT('p03.',p_lote,'.')))=CONCAT('p03.',p_lote,'.')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El lote ya existe; no se duplican ni completan registros automaticamente';
 END IF;
 -- MySQL rechaza SET TRANSACTION si el llamador ya tiene una transaccion activa.
 -- En ese caso el handler no hace ROLLBACK de la transaccion del llamador.
 SET TRANSACTION READ WRITE;
 START TRANSACTION;
 SET v_iniciada=TRUE;
 WHILE v_i<=p_cantidad DO
  SET v_estado=IF(RAND()<p_prob_activo,1,0);
  SET v_genero=IF(p_genero IS NULL OR p_genero='*',IF(RAND()<0.5,'Masculino','Femenino'),p_genero);
  SET v_pais=IF(p_pais IS NULL OR p_pais='*',ELT(MOD(v_i-1,5)+1,'Mexico','Estados Unidos','Canada','Colombia','Chile'),p_pais);
  INSERT INTO tb_users(email,nick,password,status)
  VALUES(CONCAT('p03.',p_lote,'.',v_i,'@simulacion.invalid'),CONCAT('sim_',p_lote,'_',v_i),SHA2(RANDOM_BYTES(32),256),v_estado);
  SET v_user=LAST_INSERT_ID();
  INSERT INTO tb_people(user_id,first_name,last_name,second_last_name,birth_date,gender,nationality,status)
  VALUES(v_user,CONCAT('Simulado',LPAD(v_i,5,'0')),'Practica03',p_lote,
   fn_p03_nacimiento(COALESCE(p_edad_min,18),COALESCE(p_edad_max,80),p_fecha_referencia),v_genero,v_pais,v_estado);
  SET v_i=v_i+1;
 END WHILE;
 COMMIT;
 SET v_iniciada=FALSE;
 SELECT p_lote AS lote,p_cantidad AS insertados,SUBSTRING_INDEX(USER(),'@',1) AS realizado_por,
  p_fecha_referencia AS fecha_referencia,'Simulacion; no crea cuentas MySQL' AS alcance;
END$$
DELIMITER ;
