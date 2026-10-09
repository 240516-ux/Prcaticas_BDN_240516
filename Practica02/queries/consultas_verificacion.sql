USE bd_test;

/* 1. Cuantas tablas existen en la base de datos bd_test? */
SHOW TABLES;

/* 2. Cuanto triggers existen en la base de datos bd_test? */
SHOW TRIGGERS FROM bd_test;

/* 3. Cuantos registros existen en la tabla users? */
-- Total de Usuarios
SELECT COUNT(*) AS total_registros FROM tb_users;
-- Visualizacion de los Usarios
SELECT * FROM tb_users;
-- Consulta para verificar que usuario de la base de datos , 
-- inserto a que usuario de la plataforma ecommerce, agregando el rol del SGBD */
SELECT u.nick, u.email, SUBSTRING_INDEX(b.db_user,'@',1) AS inserted_by, 
GROUP_CONCAT(DISTINCT re.FROM_USER  ORDER BY re.FROM_USER SEPARATOR ', ' ) AS roles,
    b.operation_description,
    b.operation_date
FROM tb_users u
JOIN tb_logs b
    ON b.operation_description LIKE CONCAT('%', u.nick, '%')
   AND b.operation_description LIKE CONCAT('%', u.email, '%')
LEFT JOIN mysql.role_edges re
    ON re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE b.table_operation = 'Create'
  AND b.table_name = 'tb_users'
GROUP BY u.nick, u.email, b.db_user, b.operation_description, b.operation_date
ORDER BY b.operation_date asc;
  
  
  

/* 4. Cuantos registros existen en la tabla bitácora? */
SELECT COUNT(*) AS total_registros FROM tb_logs;

/* 5. Consultar todas las operaciones realizadas en la base de datos */
SELECT ID,table_name,table_operation,SUBSTRING_INDEX(db_user,'@',1) AS db_user,operation_description,operation_date,operation_status FROM tb_logs ORDER BY ID;

/* 6. Verificar que los usuarios remotos hayan sido creados */
SELECT User, Host FROM mysql.user WHERE Host = '%'  AND account_locked = 'N';

/* 7. Verificar los roles creados */
SELECT DISTINCT FROM_USER AS rol,FROM_HOST AS host FROM mysql.role_edges;

/* 8. Verificar que usuarios tienen que roles */
SELECT  TO_USER AS usuario,  TO_HOST AS host, FROM_USER AS rol, FROM_HOST AS rol_host
FROM mysql.role_edges ORDER BY ROL,TO_USER, FROM_USER ;

/* 9. Verificar el total de procedimientos almacenados que existen en la base de datos bd_test */
SHOW PROCEDURE STATUS WHERE Db = 'bd_test';


/* 10. Verificación de Productos*/
SELECT * FROM tb_products;
/* 11. Contabilizar los productos */
SELECT COUNT(*) FROM tb_products;
/* 12. Consulta para saber la trazabilidad de los productos */
select * from vw_trazabilidad_productos ORDER BY operation_date desc limit 10;
/* 13. Consulta la trazabilidad de usuarios */
select * from vw_trazabilidad_usuarios ORDER BY operation_date asc;
/* 14. Contabilizar cuantos productos por tabla hay por usuario */
SELECT COUNT(*), vp.inserted_by
FROM vw_trazabilidad_productos vp
GROUP BY vp.inserted_by;






/* Verificación funcional y de atribución por usuario */
SELECT table_name,table_operation,SUBSTRING_INDEX(db_user,'@',1) AS usuario,actor_roles,COUNT(*) AS operaciones FROM tb_logs GROUP BY table_name,table_operation,usuario,actor_roles;
SELECT inserted_by,roles,COUNT(*) AS productos_insertados FROM vw_trazabilidad_productos GROUP BY inserted_by,roles;
SELECT COUNT(*) AS productos_sin_trazabilidad FROM tb_products p LEFT JOIN tb_logs b ON b.table_name='tb_products' AND b.table_operation='Create' AND b.record_id=p.ID WHERE b.ID IS NULL;
SELECT TRIGGER_NAME,EVENT_MANIPULATION,EVENT_OBJECT_TABLE FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test';
SELECT User AS usuario,Host AS acceso_remoto,plugin,account_locked FROM mysql.user WHERE Host='%' AND User IN ('alan.cruz','marco.ramirez','luis.david','bryan.javier','ivan.ojeda','ivan.macin');

/* Llaves reales y resumen completo de la bitácora, sin límite de Workbench */
SELECT TABLE_NAME,CONSTRAINT_NAME,CONSTRAINT_TYPE FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA='bd_test' ORDER BY TABLE_NAME,CONSTRAINT_NAME;
SELECT TABLE_NAME,COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA='bd_test' AND REFERENCED_TABLE_NAME IS NOT NULL;
SELECT COUNT(*) AS total_logs FROM tb_logs;
SELECT table_name,table_operation,db_user AS usuario,actor_roles,COUNT(*) AS operaciones FROM tb_logs GROUP BY table_name,table_operation,db_user,actor_roles;
