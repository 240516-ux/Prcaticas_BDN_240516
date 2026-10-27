-- SOLO LECTURA. Motor: MySQL. Ejecutar conectado al servidor propio, puerto 40517.
USE bd_test_alan;
SELECT DATABASE() AS esquema, CURRENT_USER() AS cuenta_privilegios, USER() AS conexion,
       VERSION() AS version, NOW() AS fecha_servidor, UTC_TIMESTAMP() AS fecha_utc,
       @@session.time_zone AS zona_sesion;
SELECT TABLE_NAME, TABLE_TYPE FROM information_schema.TABLES
 WHERE TABLE_SCHEMA = DATABASE() ORDER BY TABLE_NAME;
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_KEY, EXTRA
 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() ORDER BY TABLE_NAME, ORDINAL_POSITION;
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE FROM information_schema.TABLE_CONSTRAINTS
 WHERE CONSTRAINT_SCHEMA = DATABASE() ORDER BY TABLE_NAME, CONSTRAINT_NAME;
SELECT TABLE_NAME, INDEX_NAME, NON_UNIQUE, SEQ_IN_INDEX, COLUMN_NAME
 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
 FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = DATABASE() ORDER BY TABLE_NAME, ORDINAL_POSITION;
SELECT 'tb_users' AS tabla, COUNT(*) AS total FROM tb_users
 UNION ALL SELECT 'tb_products', COUNT(*) FROM tb_products
 UNION ALL SELECT 'tb_logs', COUNT(*) FROM tb_logs;
SELECT role_name, COUNT(*) AS usuarios FROM tb_users GROUP BY role_name;
SELECT table_name, operation, COUNT(*) AS total FROM tb_logs GROUP BY table_name, operation;
SELECT TRIGGER_NAME, EVENT_OBJECT_TABLE, ACTION_TIMING, EVENT_MANIPULATION, ACTION_STATEMENT
 FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = DATABASE() ORDER BY EVENT_OBJECT_TABLE, TRIGGER_NAME;
SELECT TABLE_NAME, VIEW_DEFINITION, CHECK_OPTION, SECURITY_TYPE
 FROM information_schema.VIEWS WHERE TABLE_SCHEMA = DATABASE();
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = DATABASE();
SELECT EVENT_NAME, STATUS FROM information_schema.EVENTS WHERE EVENT_SCHEMA = DATABASE();
SELECT CURRENT_ROLE();
SHOW GRANTS;
SHOW VARIABLES WHERE Variable_name IN ('log_bin','log_bin_trust_function_creators','binlog_format');
-- Si el esquema o las tablas no coinciden, detenerse: no crear ni importar nada.
-- Metadatos sujetos a visibilidad/permisos; un resultado vacío no demuestra ausencia global.
-- Tras comprobar que existen ambas vistas, ejecutar individualmente:
-- SELECT COUNT(*) FROM vw_trazabilidad_usuarios;
-- SELECT COUNT(*) FROM tb_logs WHERE table_name='tb_users';
-- SELECT COUNT(*) FROM vw_trazabilidad_productos;
-- SELECT COUNT(*) FROM tb_logs WHERE table_name='tb_products';
