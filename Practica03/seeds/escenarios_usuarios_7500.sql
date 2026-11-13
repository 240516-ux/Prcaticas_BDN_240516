-- SOLO LECTURA POR DEFECTO. No repetir si ya existen los lotes.
-- Ejecutar cada CALL seleccionado desde una conexion remota alan.cruz, con superadmin activo.
USE bd_test;
SELECT DATABASE(), USER(), CURRENT_USER(), CURRENT_ROLE(), @@port;
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(email,'@',1),'.',2) AS lote,COUNT(*) AS filas
FROM tb_users WHERE email LIKE 'p03.%@simulacion.invalid' GROUP BY lote;
-- Guardar la fecha real utilizada y reutilizarla en las validaciones de edad.
-- CALL sp_p03_simular_usuarios('T1',500,'Masculino','Estados Unidos',NULL,NULL,1.00000,CURRENT_DATE());
-- CALL sp_p03_simular_usuarios('T2',2000,'*','*',19,35,1.00000,CURRENT_DATE());
-- CALL sp_p03_simular_usuarios('T3',5000,'*','*',NULL,NULL,0.80000,CURRENT_DATE());
-- El 80/20 es probabilistico: no ajustar estados despues para forzar 4000/1000.
