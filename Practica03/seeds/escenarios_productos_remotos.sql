-- SOLO LECTURA: antes de cargar, contrastar los productos propios ya existentes.
USE bd_test;
SELECT DATABASE(),USER(),CURRENT_USER(),CURRENT_ROLE(),@@port;
SELECT db_user,table_operation,COUNT(*) AS operaciones FROM bd_test.tb_logs
WHERE table_name='tb_products' AND legacy_product_log_id IS NULL
GROUP BY db_user,table_operation;
SELECT user_ID,COUNT(*) AS ofertas FROM tbd_products_users_providers GROUP BY user_ID;
-- Confirmar cuales cuentas propias son seller1 y seller2. No cambiar db_user historico.
-- No ejecutar 7000 inserciones nuevas solo porque antes faltaban relaciones de proveedor.
-- Si el escenario realmente falta y esta autorizado, ejecutar desde la cuenta seller correspondiente:
-- CALL sp_p03_productos_vendedor('SELLER1',5000,100.00,20);
-- CALL sp_p03_productos_vendedor('SELLER2',2000,100.00,20);
