-- SOLO LECTURA. PostgreSQL; no ejecutar contra MySQL.
-- Ejecutar primero identidad y detenerse si la base no es bd_test_alan.
SELECT current_database(), current_user, now(), current_setting('TimeZone');
-- No se realizaron consultas a la base desde esta revisión documental.
SELECT 'tb_users' AS tabla, count(*) AS registros FROM public.tb_users
UNION ALL SELECT 'tb_products', count(*) FROM public.tb_products
UNION ALL SELECT 'tb_logs', count(*) FROM public.tb_logs;
SELECT table_name, operation, count(*) AS eventos
FROM public.tb_logs GROUP BY table_name, operation ORDER BY table_name, operation;
-- Resumen sin correos ni JSON completo. No modifica ni vuelve a probar UPDATE.
SELECT id, table_name, operation, record_id, changed_at,
       CASE WHEN table_name='tb_products' THEN details->>'stock' END AS stock_registrado
FROM public.tb_logs
WHERE table_name IN ('tb_users','tb_products')
ORDER BY id DESC;
-- Los IDs máximos no representan COUNT(*). La referencia histórica puede no tener fila actual.
-- Estas comprobaciones son parciales; revisar definición de cada vista y contenido completo
-- solo después de confirmar que existen y que su salida es apta para mostrarse.
