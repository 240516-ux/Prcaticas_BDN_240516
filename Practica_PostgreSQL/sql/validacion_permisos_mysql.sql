-- SOLO LECTURA. Conectar mediante cada cuenta existente autorizada.
SELECT DATABASE(), USER(), CURRENT_USER(), CURRENT_ROLE();
-- Detenerse si la base no es bd_test_alan. No confundir CURRENT_USER con una fila tb_users.
SHOW GRANTS;
SELECT * FROM information_schema.APPLICABLE_ROLES;
SELECT * FROM information_schema.ENABLED_ROLES;
SELECT TABLE_SCHEMA,TABLE_NAME,PRIVILEGE_TYPE,IS_GRANTABLE
FROM information_schema.TABLE_PRIVILEGES WHERE TABLE_SCHEMA='bd_test_alan';
SELECT GRANTEE,TABLE_SCHEMA,PRIVILEGE_TYPE,IS_GRANTABLE
FROM information_schema.SCHEMA_PRIVILEGES WHERE TABLE_SCHEMA='bd_test_alan';
SHOW VARIABLES LIKE 'log_bin_trust_function_creators';
-- SHOW GRANTS debe interpretarse junto con roles activos y permisos globales/heredados.
-- Visibilidad limitada: la ausencia en TABLE_PRIVILEGES no demuestra denegación efectiva.
-- Si faltan roles o permisos, documentar antes de cualquier GRANT. No se ejecuta DML.
