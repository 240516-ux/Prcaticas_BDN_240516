-- Sustituye la version antigua solo tras respaldar y autorizar el reemplazo de la rutina.
-- La autorizacion se realiza por EXECUTE concedido a superadmin/admin/support;
-- no se infieren roles activos consultando mysql.role_edges desde un DEFINER.
USE bd_test;
DELIMITER $$
CREATE PROCEDURE sp_soft_delete_user(IN p_id INT)
SQL SECURITY DEFINER MODIFIES SQL DATA
BEGIN
 IF p_id IS NULL OR p_id<=0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Identificador de usuario invalido';
 END IF;
 IF NOT EXISTS(SELECT 1 FROM tb_users WHERE ID=p_id) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario no existe';
 END IF;
 IF EXISTS(SELECT 1 FROM tb_users WHERE ID=p_id AND status=b'0') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario ya esta inactivo';
 END IF;
 UPDATE tb_users SET status=b'0' WHERE ID=p_id AND status=b'1';
 IF ROW_COUNT()<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El estado cambio concurrentemente; volver a consultar';
 END IF;
 -- El trigger AFTER UPDATE registra una vez la cuenta real obtenida con USER().
END$$
DELIMITER ;
