-- SOLO LECTURA: candidatos reales antes de una futura autorizacion.
USE bd_test;
SELECT DATABASE(),USER(),CURRENT_USER(),@@port,@@event_scheduler;
SHOW CREATE EVENT ev_actualizar_estado_relaciones;
SELECT pc.category_ID,pc.product_ID,pc.status+0 AS relacion,p.status+0 AS producto,c.status+0 AS categoria
FROM tbd_products_categories pc JOIN tb_products p ON p.ID=pc.product_ID JOIN tbc_categories c ON c.ID=pc.category_ID
WHERE pc.status=b'1' AND (p.status=b'0' OR c.status=b'0');
SELECT EVENT_NAME,STATUS,INTERVAL_VALUE,INTERVAL_FIELD,LAST_EXECUTED FROM information_schema.EVENTS WHERE EVENT_SCHEMA=DATABASE();
