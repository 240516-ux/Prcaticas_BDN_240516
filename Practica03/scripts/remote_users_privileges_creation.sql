-- Configuracion de roles solamente; NO crea cuentas, NO altera passwords y NO elimina roles anteriores.
-- Aplicar concesiones a cuentas existentes requiere autorizacion independiente.
USE bd_test;
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'common_user';
CREATE ROLE IF NOT EXISTS 'user_not_registered';
GRANT ALL PRIVILEGES ON bd_test.* TO 'superadmin','admin';
GRANT SELECT,INSERT,UPDATE ON bd_test.tb_users TO 'support';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbc_categories TO 'support';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbd_products_categories TO 'support';
GRANT SELECT,UPDATE ON bd_test.tb_products TO 'support';
GRANT SELECT,INSERT,UPDATE ON bd_test.tb_products TO 'seller';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbd_products_users_providers TO 'seller';
GRANT SELECT,INSERT ON bd_test.tbd_products_categories TO 'seller';
GRANT SELECT ON bd_test.tbc_categories TO 'seller';
GRANT SELECT(ID,nick) ON bd_test.tb_users TO 'seller';
GRANT SELECT,INSERT,UPDATE ON bd_test.tb_carts TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbd_cart_items TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tb_orders TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tb_buyer_orders TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbd_order_items TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbd_users_wishlist_products TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tb_user_addresses TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbd_address_components TO 'buyer';
GRANT SELECT,INSERT,UPDATE ON bd_test.tbd_user_payment_methods TO 'buyer';
GRANT SELECT ON bd_test.tb_products TO 'buyer';
GRANT SELECT ON bd_test.tbc_categories TO 'buyer';
GRANT SELECT ON bd_test.tb_products TO 'common_user';
GRANT SELECT ON bd_test.tbc_categories TO 'common_user';
GRANT SELECT ON bd_test.tb_products TO 'user_not_registered';
GRANT SELECT ON bd_test.tbc_categories TO 'user_not_registered';
GRANT SELECT ON bd_test.vw_total_products_by_category TO 'support';
GRANT SELECT ON bd_test.vw_total_products_by_category TO 'seller';
GRANT SELECT ON bd_test.vw_total_products_by_category TO 'buyer';
GRANT SELECT ON bd_test.vw_total_products_by_category TO 'common_user';
GRANT SELECT ON bd_test.vw_total_products_by_category TO 'user_not_registered';
GRANT EXECUTE ON PROCEDURE bd_test.sp_soft_delete_user TO 'superadmin','admin','support';
GRANT EXECUTE ON PROCEDURE bd_test.sp_p03_simular_usuarios TO 'superadmin';
GRANT EXECUTE ON FUNCTION bd_test.fn_p03_nacimiento TO 'superadmin';
GRANT EXECUTE ON PROCEDURE bd_test.sp_p03_productos_vendedor TO 'seller';
-- Support INSERT conserva la politica propia anterior; si clase exige rechazo, revisar GRANT/REVOKE antes de aplicarlo.
-- Estas concesiones son acumulativas: revisar SHOW GRANTS; no corrigen permisos directos excesivos.
-- No habilitan seguridad por fila; una aplicacion debe limitar compras y perfiles al propietario.
-- Cuentas propias existentes: asignar solo despues de verificar su existencia y autorizacion:
-- GRANT 'superadmin' TO 'alan.cruz'@'%';
-- SET DEFAULT ROLE 'superadmin' TO 'alan.cruz'@'%';
-- GRANT 'admin' TO 'marco.ramirez'@'%';
-- SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
-- GRANT 'support' TO 'luis.david'@'%';
-- SET DEFAULT ROLE 'support' TO 'luis.david'@'%';
-- GRANT 'seller' TO 'bryan.javier'@'%';
-- SET DEFAULT ROLE 'seller' TO 'bryan.javier'@'%';
-- GRANT 'seller' TO 'ivan.ojeda'@'%';
-- SET DEFAULT ROLE 'seller' TO 'ivan.ojeda'@'%';
SELECT USER(),CURRENT_USER(),CURRENT_ROLE();
SHOW GRANTS FOR CURRENT_USER;
