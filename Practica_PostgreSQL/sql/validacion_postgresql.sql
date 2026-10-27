-- SOLO LECTURA. Conectar explícitamente a bd_test_alan, puerto 40516.
-- Detenerse si la primera consulta no identifica el servidor/esquema esperados.
SELECT current_database(), current_user, session_user, version(), now(), current_setting('TimeZone');
SHOW search_path;
SELECT table_schema, table_name, table_type FROM information_schema.tables
 WHERE table_schema='public' ORDER BY table_name;
SELECT table_name, column_name, data_type, udt_name, character_maximum_length,
 numeric_precision, numeric_scale, is_nullable, column_default, is_identity
 FROM information_schema.columns WHERE table_schema='public' ORDER BY table_name, ordinal_position;
SELECT table_name, constraint_name, constraint_type FROM information_schema.table_constraints
 WHERE table_schema='public' ORDER BY table_name, constraint_name;
SELECT c.relname AS tabla, k.conname, pg_get_constraintdef(k.oid) AS definicion
 FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid
 JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' ORDER BY c.relname,k.conname;
SELECT tablename,indexname,indexdef FROM pg_indexes WHERE schemaname='public';
SELECT 'tb_users' AS tabla, count(*) AS total FROM public.tb_users
 UNION ALL SELECT 'tb_products',count(*) FROM public.tb_products
 UNION ALL SELECT 'tb_logs',count(*) FROM public.tb_logs;
SELECT role_name,count(*) AS usuarios FROM public.tb_users GROUP BY role_name;
SELECT table_name,operation,count(*) AS total FROM public.tb_logs GROUP BY table_name,operation;
SELECT c.relname AS tabla,t.tgname,pg_get_triggerdef(t.oid) AS definicion,t.tgenabled
 FROM pg_trigger t JOIN pg_class c ON c.oid=t.tgrelid JOIN pg_namespace n ON n.oid=c.relnamespace
 WHERE NOT t.tgisinternal AND n.nspname='public' ORDER BY c.relname,t.tgname;
SELECT count(*) AS objetos_trigger FROM pg_trigger t
 JOIN pg_class c ON c.oid=t.tgrelid JOIN pg_namespace n ON n.oid=c.relnamespace
 WHERE NOT t.tgisinternal AND n.nspname='public';
SELECT trigger_name,event_manipulation,event_object_table FROM information_schema.triggers
 WHERE trigger_schema='public' ORDER BY trigger_name,event_manipulation;
SELECT viewname,definition FROM pg_views WHERE schemaname='public';
SELECT p.proname,pg_get_functiondef(p.oid) FROM pg_proc p
 JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public' AND p.prokind IN ('f','p');
SELECT rolname,rolcanlogin,rolsuper,rolcreaterole,rolcreatedb FROM pg_roles
 WHERE rolname IN ('alan_admin','superadmin','admin','seller','buyer','support','common','not_registered');
SELECT r.rolname AS rol,m.rolname AS miembro FROM pg_auth_members a
 JOIN pg_roles r ON r.oid=a.roleid JOIN pg_roles m ON m.oid=a.member;
-- Ejecutar individualmente solo tras confirmar que existen las vistas:
-- SELECT count(*) FROM public.vw_trazabilidad_usuarios;
-- SELECT count(*) FROM public.tb_logs WHERE table_name='tb_users';
-- SELECT count(*) FROM public.vw_trazabilidad_productos;
-- SELECT count(*) FROM public.tb_logs WHERE table_name='tb_products';
