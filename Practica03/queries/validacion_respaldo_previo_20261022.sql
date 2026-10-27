-- Solo lectura: registrar resultados localmente antes de cualquier migración.
-- Esta consulta NO sustituye un respaldo completo de mysqldump.
-- El manifiesto con tamaño, SHA256 y huellas permanece fuera del repositorio.
USE bd_test;
SELECT DATABASE() AS esquema, CURRENT_USER() AS cuenta, VERSION() AS version;
SELECT 'tb_users' AS tabla, COUNT(*) AS total FROM tb_users
UNION ALL SELECT 'tb_products',COUNT(*) FROM tb_products
UNION ALL SELECT 'tb_logs',COUNT(*) FROM tb_logs
UNION ALL SELECT 'tb_logs_productos',COUNT(*) FROM tb_logs_productos
UNION ALL SELECT 'tbc_categories',COUNT(*) FROM tbc_categories
UNION ALL SELECT 'tbd_products_categories',COUNT(*) FROM tbd_products_categories
UNION ALL SELECT 'tb_carts',COUNT(*) FROM tb_carts
UNION ALL SELECT 'tbd_cart_items',COUNT(*) FROM tbd_cart_items
UNION ALL SELECT 'tbc_payment_methods_types',COUNT(*) FROM tbc_payment_methods_types
UNION ALL SELECT 'tbd_user_payment_methods',COUNT(*) FROM tbd_user_payment_methods;
SELECT TABLE_NAME, TABLE_TYPE FROM information_schema.TABLES
WHERE TABLE_SCHEMA='bd_test';
SELECT TRIGGER_NAME, EVENT_OBJECT_TABLE, EVENT_MANIPULATION
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test';
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='bd_test';
SELECT EVENT_NAME, STATUS FROM information_schema.EVENTS
WHERE EVENT_SCHEMA='bd_test';
