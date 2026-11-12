-- SOLO LECTURA DE DATOS. Los SET cambian unicamente variables de esta sesion.
USE bd_test;
SELECT DATABASE(),USER(),CURRENT_USER(),CURRENT_ROLE(),@@port,VERSION();
SELECT TABLE_TYPE,COUNT(*) AS objetos FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() GROUP BY TABLE_TYPE;
SELECT 'triggers' AS objeto,COUNT(*) AS total FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA=DATABASE()
UNION ALL SELECT ROUTINE_TYPE,COUNT(*) FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA=DATABASE() GROUP BY ROUTINE_TYPE
UNION ALL SELECT 'eventos',COUNT(*) FROM information_schema.EVENTS WHERE EVENT_SCHEMA=DATABASE();
-- VPS: 24 tablas operativas y tb_logs, que conserva el histórico consolidado.
SELECT COUNT(*) AS tablas_operativas FROM information_schema.TABLES
WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='BASE TABLE' AND TABLE_NAME NOT IN ('tb_logs','tb_logs_productos');
SELECT EVENT_OBJECT_TABLE,COUNT(*) AS triggers_por_tabla,GROUP_CONCAT(EVENT_MANIPULATION ORDER BY EVENT_MANIPULATION) AS eventos
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA=DATABASE() GROUP BY EVENT_OBJECT_TABLE;
SELECT EVENT_OBJECT_TABLE,ACTION_TIMING,EVENT_MANIPULATION,COUNT(*) AS repetidos
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA=DATABASE()
GROUP BY EVENT_OBJECT_TABLE,ACTION_TIMING,EVENT_MANIPULATION HAVING COUNT(*)<>1 OR ACTION_TIMING<>'AFTER';
SELECT TRIGGER_NAME FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA=DATABASE() AND EVENT_OBJECT_TABLE IN ('tb_logs','tb_logs_productos');
SELECT TABLE_NAME,VIEW_DEFINITION FROM information_schema.VIEWS WHERE TABLE_SCHEMA=DATABASE();
SELECT ROUTINE_NAME,ROUTINE_TYPE,SECURITY_TYPE,SQL_DATA_ACCESS FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA=DATABASE();
SELECT SPECIFIC_NAME,ORDINAL_POSITION,PARAMETER_MODE,PARAMETER_NAME,DTD_IDENTIFIER FROM information_schema.PARAMETERS WHERE SPECIFIC_SCHEMA=DATABASE() ORDER BY SPECIFIC_NAME,ORDINAL_POSITION;
SELECT EVENT_NAME,STATUS,LAST_EXECUTED,EVENT_DEFINITION
FROM information_schema.EVENTS WHERE EVENT_SCHEMA=DATABASE();
SELECT @@event_scheduler;
-- Candidatos de la condición observada en el evento. Contrastar con EVENT_DEFINITION.
SELECT COUNT(*) AS relaciones_candidatas
FROM tbd_products_categories pc
JOIN tb_products p ON p.ID=pc.product_ID
JOIN tbc_categories c ON c.ID=pc.category_ID
WHERE pc.status=b'1' AND (p.status=b'0' OR c.status=b'0');

SELECT 'tb_users' AS tabla,COUNT(*) AS filas FROM tb_users
UNION ALL SELECT 'tb_people',COUNT(*) FROM tb_people
UNION ALL SELECT 'tb_products',COUNT(*) FROM tb_products
UNION ALL SELECT 'tbc_categories',COUNT(*) FROM tbc_categories
UNION ALL SELECT 'tbd_products_categories',COUNT(*) FROM tbd_products_categories
UNION ALL SELECT 'tbd_products_users_providers',COUNT(*) FROM tbd_products_users_providers
UNION ALL SELECT 'tb_logs',COUNT(*) FROM tb_logs
UNION ALL SELECT 'historial de productos consolidado',COUNT(*)
FROM tb_logs WHERE legacy_product_log_id IS NOT NULL;

SELECT nick, COUNT(*) AS perfiles_de_aplicacion
FROM tb_users
WHERE nick IN ('alan.cruz', 'bryan.javier', 'joseluis.bernabe')
GROUP BY nick;

-- La fecha debe ser la misma que se uso en el CALL del lote. No usar la edad de hoy para certificar un lote antiguo.
SET @lote_t1=COALESCE(@lote_t1,'T1');
SET @lote_t2=COALESCE(@lote_t2,'T2');
SET @lote_t3=COALESCE(@lote_t3,'T3');
-- Si el CALL usó una fecha distinta de la fecha de alta, fijarla en esta sesión.
SET @fecha_referencia=NULL;
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(u.email,'@',1),'.',2) AS lote,COUNT(*) AS usuarios,
 COUNT(p.id) AS perfiles,SUM(u.status=b'1') AS activos,SUM(u.status=b'0') AS inactivos,
 ROUND(100*AVG(u.status=b'1'),2) AS porcentaje_activos,
 MIN(TIMESTAMPDIFF(YEAR,p.birth_date,COALESCE(@fecha_referencia,DATE(u.creation_date)))) AS edad_minima,
 MAX(TIMESTAMPDIFF(YEAR,p.birth_date,COALESCE(@fecha_referencia,DATE(u.creation_date)))) AS edad_maxima,
 COUNT(DISTINCT p.nationality) AS paises
FROM tb_users u LEFT JOIN tb_people p ON p.user_id=u.ID
WHERE (u.email LIKE CONCAT('p03.',@lote_t1,'.%@simulacion.invalid') OR u.email LIKE CONCAT('p03.',@lote_t2,'.%@simulacion.invalid') OR u.email LIKE CONCAT('p03.',@lote_t3,'.%@simulacion.invalid')) GROUP BY lote;
SELECT u.ID,u.nick,p.gender,p.nationality FROM tb_users u JOIN tb_people p ON p.user_id=u.ID
WHERE u.email LIKE CONCAT('p03.',@lote_t1,'.%@simulacion.invalid') AND (p.gender<>'Masculino' OR p.nationality<>'Estados Unidos');
SELECT u.ID,u.nick FROM tb_users u JOIN tb_people p ON p.user_id=u.ID
WHERE u.email LIKE CONCAT('p03.',@lote_t2,'.%@simulacion.invalid')
AND (p.birth_date IS NULL OR TIMESTAMPDIFF(YEAR,p.birth_date,COALESCE(@fecha_referencia,DATE(u.creation_date))) NOT BETWEEN 19 AND 35);
-- T3 es probabilistico: informar el resultado real, nunca corregir estados para forzar 80/20.
SELECT COUNT(*) AS usuarios_sin_perfil FROM tb_users u LEFT JOIN tb_people p ON p.user_id=u.ID
WHERE (u.email LIKE CONCAT('p03.',@lote_t1,'.%@simulacion.invalid') OR u.email LIKE CONCAT('p03.',@lote_t2,'.%@simulacion.invalid') OR u.email LIKE CONCAT('p03.',@lote_t3,'.%@simulacion.invalid')) AND p.id IS NULL;

SELECT b.db_user AS cuenta_historica,COUNT(*) AS altas
FROM tb_logs b
WHERE b.legacy_product_log_id IS NOT NULL
  AND b.table_name='tb_products' AND b.table_operation='Create'
GROUP BY b.db_user;

-- Los SKU identifican el lote. La bitácora registra la cuenta de alta.
SELECT CASE WHEN p.SKU LIKE 'P03-SELLER1-%' THEN 'SELLER1' ELSE 'SELLER2' END AS lote,
       b.db_user AS cuenta_de_alta, COUNT(DISTINCT p.ID) AS productos, COUNT(b.ID) AS auditorias
FROM tb_products p
LEFT JOIN tb_logs b ON b.record_id=p.ID
  AND b.table_name='tb_products' AND b.table_operation='Create'
  AND b.legacy_product_log_id IS NULL
WHERE p.SKU LIKE 'P03-SELLER1-%' OR p.SKU LIKE 'P03-SELLER2-%'
GROUP BY lote,b.db_user;
SELECT u.nick,COUNT(*) AS relaciones_proveedor FROM tbd_products_users_providers pp JOIN tb_users u ON u.ID=pp.user_ID GROUP BY u.ID,u.nick;
SELECT COUNT(*) AS productos_sin_proveedor FROM tb_products p WHERE NOT EXISTS(SELECT 1 FROM tbd_products_users_providers pp WHERE pp.product_ID=p.ID);
SELECT status+0 AS estado,COUNT(*) AS productos FROM tb_products GROUP BY status;
SELECT c.ID,c.name,c.sup_id_category,COUNT(pc.product_ID) AS productos
FROM tbc_categories c LEFT JOIN tbd_products_categories pc ON pc.category_ID=c.ID
GROUP BY c.ID,c.name,c.sup_id_category HAVING COUNT(pc.product_ID)<5;
SELECT * FROM vw_total_products_by_category ORDER BY category_id IS NULL,category_id;

-- Actor real, sin falsificar root/localhost historicos ni suplantar cuentas.
SELECT table_name,db_user,table_operation,COUNT(*) AS operaciones FROM tb_logs
GROUP BY table_name,db_user,table_operation ORDER BY table_name,db_user;
SELECT log_id,nick,email,realizado_por,roles,operation FROM vw_trazabilidad_usuarios ORDER BY log_id DESC LIMIT 25;
SELECT record_id,COUNT(*) AS altas_repetidas FROM tb_logs
WHERE table_name='tb_products' AND table_operation='Create' AND legacy_product_log_id IS NULL
GROUP BY record_id HAVING COUNT(*)>1;

-- Generar consultas de huerfanos para TODAS las FK reales, incluidas compuestas.
-- Copiar y ejecutar el resultado (son SELECT). No desactiva FOREIGN_KEY_CHECKS.
SET SESSION group_concat_max_len=1048576;
SELECT CONCAT('SELECT ''',TABLE_NAME,'.',CONSTRAINT_NAME,''' AS relacion,COUNT(*) AS huerfanos FROM `',TABLE_SCHEMA,'`.`',TABLE_NAME,
 '` a WHERE ',GROUP_CONCAT(CONCAT('a.`',COLUMN_NAME,'` IS NOT NULL') ORDER BY ORDINAL_POSITION SEPARATOR ' AND '),
 ' AND NOT EXISTS(SELECT 1 FROM `',REFERENCED_TABLE_SCHEMA,'`.`',REFERENCED_TABLE_NAME,'` b WHERE ',
 GROUP_CONCAT(CONCAT('a.`',COLUMN_NAME,'`=b.`',REFERENCED_COLUMN_NAME,'`') ORDER BY ORDINAL_POSITION SEPARATOR ' AND '),');') AS consulta_de_integridad
FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA=DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL
GROUP BY TABLE_SCHEMA,TABLE_NAME,CONSTRAINT_NAME,REFERENCED_TABLE_SCHEMA,REFERENCED_TABLE_NAME;

-- Validaciones de negocio que las FK por si solas no aseguran.
SELECT o.ID AS pedido_con_direccion_ajena FROM tb_orders o JOIN tb_user_addresses a ON a.ID=o.address_ID WHERE a.user_ID<>o.buyer_ID;
SELECT i.order_item_ID,SUM(i.quantity) AS devuelto,MAX(oi.quantity) AS comprado
FROM tbd_return_items i JOIN tbd_order_items oi ON oi.ID=i.order_item_ID
JOIN tb_returns r ON r.ID=i.return_ID WHERE r.return_status IN ('Approved','Received','Completed')
GROUP BY i.order_item_ID HAVING SUM(i.quantity)>MAX(oi.quantity);
SELECT p.ID AS pago,SUM(r.amount) AS reembolsado,MAX(p.amount) AS pagado
FROM tb_refunds r JOIN tb_payments p ON p.ID=r.payment_ID WHERE r.refund_status='Paid'
GROUP BY p.ID HAVING SUM(r.amount)>MAX(p.amount);
