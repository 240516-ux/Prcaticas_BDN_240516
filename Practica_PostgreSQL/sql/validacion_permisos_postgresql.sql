-- SOLO LECTURA. Conectar mediante cada cuenta existente autorizada; no crear cuentas.
SELECT current_database(), session_user, current_user, current_setting('role');
-- Detenerse si la base no es bd_test_alan. Etiquetas role_name no son permisos.
SELECT rolname, rolcanlogin, rolsuper, rolcreaterole, rolcreatedb
FROM pg_roles WHERE rolname IN ('superadmin','admin','seller','buyer','support','common','not_registered','alan_admin');
SELECT r.rolname AS rol, m.rolname AS miembro
FROM pg_auth_members a JOIN pg_roles r ON r.oid=a.roleid
JOIN pg_roles m ON m.oid=a.member;
SELECT current_user AS actor, v.tabla,
 has_table_privilege(current_user,v.tabla,'SELECT') AS puede_leer,
 has_table_privilege(current_user,v.tabla,'INSERT') AS puede_insertar,
 has_table_privilege(current_user,v.tabla,'UPDATE') AS puede_modificar,
 has_table_privilege(current_user,v.tabla,'DELETE') AS puede_eliminar
FROM (VALUES ('public.tb_users'),('public.tb_products')) AS v(tabla);
-- Permisos de secuencias para columnas identity; no se consume ningún valor.
SELECT sequence_schema, sequence_name,
 has_sequence_privilege(current_user,quote_ident(sequence_schema)||'.'||quote_ident(sequence_name),'USAGE') AS uso
FROM information_schema.sequences WHERE sequence_schema='public';
-- Esta consulta no prueba ejecución DML, restricciones RLS ni privilegios de todas las sesiones.
