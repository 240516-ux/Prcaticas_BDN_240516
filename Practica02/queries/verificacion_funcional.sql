USE bd_test;
/* Verificación automática: OK significa que se cumple el resultado esperado de las semillas. */
SELECT IF((SELECT COUNT(*) FROM tb_products)=5000,'OK','ERROR') AS resultado,'Total de productos' AS prueba;
SELECT IF((SELECT COUNT(*) FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test')=6,'OK','ERROR'),'Triggers de trazabilidad';
SELECT IF((SELECT COUNT(*) FROM vw_trazabilidad_productos WHERE inserted_by='bryan.javier')=5000,'OK','ERROR'),'Bryan inserto 5000';
SELECT IF(NOT EXISTS(SELECT 1 FROM vw_trazabilidad_productos WHERE inserted_by LIKE '%@%'),'OK','ERROR'),'Usuarios visibles sin host';
SELECT IF(NOT EXISTS(SELECT 1 FROM tb_products p WHERE NOT EXISTS(SELECT 1 FROM tb_logs l WHERE l.table_name='tb_products' AND l.table_operation='Create' AND l.record_id=p.ID)),'OK','ERROR'),'Productos con trazabilidad';
SELECT IF((SELECT COUNT(*) FROM mysql.user WHERE Host='%' AND User IN ('alan.cruz','marco.ramirez','luis.david','bryan.javier','ivan.ojeda','ivan.macin') AND account_locked='N')=6,'OK','ERROR'),'Seis cuentas remotas';
SELECT IF((SELECT COUNT(*) FROM mysql.default_roles WHERE HOST='%' AND ((USER='alan.cruz' AND DEFAULT_ROLE_USER='superadmin') OR (USER='marco.ramirez' AND DEFAULT_ROLE_USER='admin') OR (USER='luis.david' AND DEFAULT_ROLE_USER='support') OR (USER IN ('bryan.javier','ivan.ojeda') AND DEFAULT_ROLE_USER='seller')))=5,'OK','ERROR'),'Roles predeterminados';

/* Integridad de llaves y auditoría */
SELECT IF(NOT EXISTS(SELECT 1 FROM tb_logs WHERE db_user LIKE '%@%'),'OK','ERROR'),'Nombre sin host en tb_logs';
SELECT IF((SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA='bd_test' AND CONSTRAINT_TYPE='PRIMARY KEY')=3,'OK','ERROR'),'Llaves primarias';
SELECT IF(NOT EXISTS(SELECT 1 FROM tb_users u WHERE NOT EXISTS(SELECT 1 FROM tb_logs l WHERE l.table_name='tb_users' AND l.table_operation='Create' AND l.record_id=u.ID)),'OK','ERROR'),'Usuarios con trazabilidad';
SELECT IF((SELECT COUNT(*) FROM tb_users WHERE nick IN ('alan.cruz','marco.ramirez','luis.david','bryan.javier','ivan.ojeda','ivan.macin') AND email LIKE '%@example.test')=6,'OK','ERROR'),'Seis usuarios de demostracion';
SELECT IF(EXISTS(SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA='bd_test' AND TABLE_NAME='tb_products' AND INDEX_NAME='SKU' AND COLUMN_NAME='SKU' AND NON_UNIQUE=0),'OK','ERROR'),'Indice unico SKU';
SELECT IF((SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA='bd_test' AND TABLE_NAME='tb_users' AND COLUMN_NAME IN ('email','nick') AND NON_UNIQUE=0)=2,'OK','ERROR'),'Indices unicos email y nick';

SELECT IF(NOT EXISTS(SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='bd_test' AND TABLE_NAME='tb_logs' AND COLUMN_NAME='connection_host'),'OK','ERROR'),'Bitacora sin columna de host';
