-- Conservar el evento previo desactivado. No se toca event_scheduler global.
USE bd_test;
-- Crear solo si no existe. Si ya existe, inspeccionar SHOW CREATE EVENT y no reemplazarlo automaticamente.
CREATE EVENT IF NOT EXISTS ev_actualizar_estado_relaciones
ON SCHEDULE EVERY 1 DAY DISABLE
DO UPDATE tbd_products_categories pc
JOIN tb_products p ON p.ID=pc.product_ID JOIN tbc_categories c ON c.ID=pc.category_ID
SET pc.status=b'0' WHERE pc.status=b'1' AND (p.status=b'0' OR c.status=b'0');
SELECT EVENT_NAME,STATUS,EVENT_DEFINITION FROM information_schema.EVENTS WHERE EVENT_SCHEMA='bd_test';
SELECT @@event_scheduler;
-- Su habilitacion modifica relaciones: requiere autorizacion y prueba previa aislada.
