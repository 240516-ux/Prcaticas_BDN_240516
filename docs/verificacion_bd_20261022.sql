-- Auditoría de solo lectura. Ejecutar en la conexión 127.0.0.1:40516.
USE bd_test;
SELECT DATABASE(),VERSION(),@@event_scheduler;
SELECT 'tb_carts' AS tabla,COUNT(*) AS total FROM `tb_carts`;
SELECT 'tb_logs' AS tabla,COUNT(*) AS total FROM `tb_logs`;
SELECT 'tb_logs_productos' AS tabla,COUNT(*) AS total FROM `tb_logs_productos`;
SELECT 'tb_products' AS tabla,COUNT(*) AS total FROM `tb_products`;
SELECT 'tb_users' AS tabla,COUNT(*) AS total FROM `tb_users`;
SELECT 'tbc_categories' AS tabla,COUNT(*) AS total FROM `tbc_categories`;
SELECT 'tbc_payment_methods_types' AS tabla,COUNT(*) AS total FROM `tbc_payment_methods_types`;
SELECT 'tbd_cart_items' AS tabla,COUNT(*) AS total FROM `tbd_cart_items`;
SELECT 'tbd_products_categories' AS tabla,COUNT(*) AS total FROM `tbd_products_categories`;
SELECT 'tbd_user_payment_methods' AS tabla,COUNT(*) AS total FROM `tbd_user_payment_methods`;

-- logs_por_entidad
SELECT table_name,table_operation,COUNT(*) total FROM tb_logs GROUP BY table_name,table_operation;

-- productos_por_actor
SELECT inserted_by,COUNT(*) total FROM vw_trazabilidad_productos GROUP BY inserted_by;

-- categorizacion_ids_duplicados
SELECT COUNT(*) total FROM (SELECT log_id FROM vw_trazabilidad_categorizacion_productos GROUP BY log_id HAVING COUNT(*)>1) x;

-- categorizacion_creaciones_duplicadas
SELECT COUNT(*) total FROM (SELECT record_key FROM tb_logs WHERE table_name='tbd_products_categories' AND table_operation='Create' GROUP BY record_key HAVING COUNT(*)>1) x;

-- relaciones_sin_log_creacion
SELECT COUNT(*) total FROM tbd_products_categories pc WHERE NOT EXISTS(SELECT 1 FROM tb_logs l WHERE l.table_name='tbd_products_categories' AND l.table_operation='Create' AND l.record_key=CONCAT(pc.category_ID,':',pc.product_ID));

-- logs_relaciones_sin_registro
SELECT table_operation,COUNT(*) total FROM tb_logs l WHERE table_name='tbd_products_categories' AND NOT EXISTS(SELECT 1 FROM tbd_products_categories pc WHERE l.record_key=CONCAT(pc.category_ID,':',pc.product_ID)) GROUP BY table_operation;

-- logs_relacion_clave_json_incoherente
SELECT COUNT(*) total FROM tb_logs WHERE table_name='tbd_products_categories' AND table_operation='Create' AND (NOT(record_key <=> CONCAT(JSON_UNQUOTE(JSON_EXTRACT(operation_description,'$.category_ID')),':',JSON_UNQUOTE(JSON_EXTRACT(operation_description,'$.product_ID')))));

-- productos_sin_log
SELECT COUNT(*) total FROM tb_products p WHERE NOT EXISTS(SELECT 1 FROM tb_logs_productos l WHERE l.record_id=p.ID AND l.table_name='tb_products' AND l.table_operation='Create');

-- productos_creaciones_duplicadas
SELECT COUNT(*) total FROM (SELECT record_id FROM tb_logs_productos WHERE table_name='tb_products' AND table_operation='Create' GROUP BY record_id HAVING COUNT(*)>1) x;

-- bitacora_usuario_campos_incoherentes
SELECT COUNT(*) total FROM vw_bitacora_usuarios v JOIN tb_logs l ON l.ID=v.log_id WHERE NOT(v.realizado_por <=> l.db_user) OR NOT(v.usuario <=> JSON_UNQUOTE(JSON_EXTRACT(l.operation_description,IF(l.table_operation='Update','$.despues.nick','$.nick')))) OR NOT(v.email <=> JSON_UNQUOTE(JSON_EXTRACT(l.operation_description,IF(l.table_operation='Update','$.despues.email','$.email')))) OR NOT(v.rol <=> COALESCE(NULLIF(l.actor_roles,''),'SIN ROL'));

-- usuarios_referencias_historicas
SELECT l.table_operation,IF(u.ID IS NULL,'ausente_actual','presente_actual') estado,COUNT(*) total FROM tb_logs l LEFT JOIN tb_users u ON u.ID=l.record_id WHERE l.table_name='tb_users' GROUP BY l.table_operation,estado;

-- usuarios_actuales_alias
SELECT ID,nick,status+0 status FROM tb_users ORDER BY ID;

-- trazabilidad_usuarios_incoherente
SELECT COUNT(*) total FROM vw_trazabilidad_usuarios v JOIN tb_logs l ON l.record_id=v.id AND l.table_name='tb_users' AND l.table_operation='Create' LEFT JOIN tb_users u ON u.ID=v.id WHERE NOT(v.nick <=> COALESCE(u.nick,JSON_UNQUOTE(JSON_EXTRACT(l.operation_description,'$.nick')))) OR NOT(v.email <=> COALESCE(u.email,JSON_UNQUOTE(JSON_EXTRACT(l.operation_description,'$.email')))) OR NOT(v.inserted_by <=> l.db_user);

-- relaciones_activas_entidades_inactivas
SELECT COUNT(*) total FROM tbd_products_categories pc JOIN tb_products p ON p.ID=pc.product_ID JOIN tbc_categories c ON c.ID=pc.category_ID WHERE pc.status=b'1' AND (p.status=b'0' OR c.status=b'0');

-- funcion_vs_vista
SELECT COUNT(*) total FROM vw_total_products_by_category WHERE category_id IS NOT NULL AND total_products<>fn_total_products_by_category(category_id);

-- huerfanos_fk_cart_items_cart
SELECT COUNT(*) total FROM `tbd_cart_items` a WHERE a.`cart_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_carts` b WHERE a.`cart_ID`=b.`ID`);

-- huerfanos_fk_category
SELECT COUNT(*) total FROM `tbd_products_categories` a WHERE a.`category_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbc_categories` b WHERE a.`category_ID`=b.`ID`);

-- huerfanos_fk_product
SELECT COUNT(*) total FROM `tbd_products_categories` a WHERE a.`product_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_products` b WHERE a.`product_ID`=b.`ID`);

-- huerfanos_fk_superior_category
SELECT COUNT(*) total FROM `tbc_categories` a WHERE a.`sup_id_category` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbc_categories` b WHERE a.`sup_id_category`=b.`ID`);

-- huerfanos_fk_user_payment_methods_type
SELECT COUNT(*) total FROM `tbd_user_payment_methods` a WHERE a.`payment_method_type_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbc_payment_methods_types` b WHERE a.`payment_method_type_ID`=b.`ID`);

-- huerfanos_fk_user_payment_methods_user
SELECT COUNT(*) total FROM `tbd_user_payment_methods` a WHERE a.`user_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`user_ID`=b.`ID`);
SELECT TRIGGER_NAME,EVENT_OBJECT_TABLE,ACTION_TIMING,EVENT_MANIPULATION,ACTION_STATEMENT FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test';
SELECT TABLE_NAME,VIEW_DEFINITION FROM information_schema.VIEWS WHERE TABLE_SCHEMA='bd_test';
SELECT * FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA='bd_test';
SELECT * FROM information_schema.STATISTICS WHERE TABLE_SCHEMA='bd_test';
SELECT ROUTINE_NAME,ROUTINE_TYPE,ROUTINE_DEFINITION FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='bd_test';
SELECT * FROM information_schema.PARAMETERS WHERE SPECIFIC_SCHEMA='bd_test';
SELECT EVENT_NAME,STATUS,EVENT_DEFINITION FROM information_schema.EVENTS WHERE EVENT_SCHEMA='bd_test';
SELECT ID,nick,email,status+0 AS status FROM tb_users ORDER BY ID;
SELECT * FROM tb_logs WHERE table_name='tb_users' ORDER BY ID;
SELECT * FROM vw_bitacora_usuarios ORDER BY log_id;
SELECT * FROM vw_trazabilidad_usuarios ORDER BY id;
