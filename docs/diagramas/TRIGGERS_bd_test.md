# Catálogo de triggers de bd_test

Fuente: INFORMATION_SCHEMA.TRIGGERS, comprobada directamente en MySQL el 22/10/2026.
Este documento describe estructura y comportamiento. Los conteos de bitácoras están en [CONTEOS_bd_test.md](CONTEOS_bd_test.md).
Hay **45 triggers AFTER** en **15 tablas de negocio**. Se conservaron los **12 originales**; los otros 33 se incorporaron durante la implementación autorizada. Las dos bitácoras no tienen triggers.

## Inventario completo

| Tabla | Trigger | Evento | Destino | Procedencia |
|---|---|---|---|---|
| tb_buyer_orders | trg_after_delete_buyer_orders | AFTER DELETE | tb_logs | Añadido en implementación |
| tb_buyer_orders | trg_after_insert_buyer_orders | AFTER INSERT | tb_logs | Añadido en implementación |
| tb_buyer_orders | trg_after_update_buyer_orders | AFTER UPDATE | tb_logs | Añadido en implementación |
| tb_carts | trg_carts_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tb_carts | trg_carts_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tb_carts | trg_carts_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tb_people | trg_people_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tb_people | trg_people_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tb_people | trg_people_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tb_products | trg_products_after_delete | AFTER DELETE | tb_logs_productos | Original conservado |
| tb_products | trg_products_after_insert | AFTER INSERT | tb_logs_productos | Original conservado |
| tb_products | trg_products_after_update | AFTER UPDATE | tb_logs_productos | Original conservado |
| tb_user_addresses | trg_user_addresses_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tb_user_addresses | trg_user_addresses_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tb_user_addresses | trg_user_addresses_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tb_users | trg_users_after_delete | AFTER DELETE | tb_logs | Original conservado |
| tb_users | trg_users_after_insert | AFTER INSERT | tb_logs | Original conservado |
| tb_users | trg_users_after_update | AFTER UPDATE | tb_logs | Original conservado |
| tbc_categories | trg_categories_after_delete | AFTER DELETE | tb_logs | Original conservado |
| tbc_categories | trg_categories_after_insert | AFTER INSERT | tb_logs | Original conservado |
| tbc_categories | trg_categories_after_update | AFTER UPDATE | tb_logs | Original conservado |
| tbc_payment_methods_types | trg_payment_methods_types_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tbc_payment_methods_types | trg_payment_methods_types_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tbc_payment_methods_types | trg_payment_methods_types_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tbd_address_components | trg_address_components_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tbd_address_components | trg_address_components_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tbd_address_components | trg_address_components_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tbd_cart_items | trg_cart_items_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tbd_cart_items | trg_cart_items_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tbd_cart_items | trg_cart_items_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tbd_order_items | trg_order_items_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tbd_order_items | trg_order_items_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tbd_order_items | trg_order_items_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tbd_products_categories | trg_products_categories_after_delete | AFTER DELETE | tb_logs | Original conservado |
| tbd_products_categories | trg_products_categories_after_insert | AFTER INSERT | tb_logs | Original conservado |
| tbd_products_categories | trg_products_categories_after_update | AFTER UPDATE | tb_logs | Original conservado |
| tbd_products_users_providers | trg_products_users_providers_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tbd_products_users_providers | trg_products_users_providers_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tbd_products_users_providers | trg_products_users_providers_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tbd_user_payment_methods | trg_user_payment_methods_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tbd_user_payment_methods | trg_user_payment_methods_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tbd_user_payment_methods | trg_user_payment_methods_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |
| tbd_users_wishlist_products | trg_users_wishlist_products_after_delete | AFTER DELETE | tb_logs | Añadido en implementación |
| tbd_users_wishlist_products | trg_users_wishlist_products_after_insert | AFTER INSERT | tb_logs | Añadido en implementación |
| tbd_users_wishlist_products | trg_users_wishlist_products_after_update | AFTER UPDATE | tb_logs | Añadido en implementación |

## Información registrada

- `table_name`: tabla afectada; `table_operation`: Create, Update o Delete.
- `db_user`: cuenta de conexión obtenida mediante USER(), separada del registro afectado. No se atribuyeron operaciones históricas a otra cuenta.
- `actor_roles`: roles asignados encontrados en mysql.role_edges para host %. No acredita roles activos ni cubre necesariamente concesiones de otros hosts.
- `record_key`: identidad completa del registro; en claves compuestas, los valores se unen en el orden definido para cada entidad.
- `operation_description`: JSON de la entidad; las modificaciones usan objetos antes/despues. Un UPDATE sin cambios efectivos también puede producir una entrada.
- Productos escriben en tb_logs_productos. Las demás entidades de negocio escriben en tb_logs. No hay FK desde las bitácoras hacia entidades eliminables.

## Límites de privacidad y tipos

Los nuevos triggers de personas, direcciones, componentes y métodos de pago omiten valores personales y referencias privadas. Es posible conocer que hubo una operación sin recuperar el valor de un campo omitido. No se guardan contraseñas en esos JSON.
Las entidades nuevas con ID BIGINT pueden superar el rango de record_id INT UNSIGNED: se conserva el ID en record_key y se utiliza NULL en record_id cuando no cabe. No se amplió la estructura de las bitácoras.
La columna record_id no tiene un significado universal de usuario: depende de la tabla afectada. Para relaciones compuestas se debe consultar también record_key y el JSON, evitando unir bitácoras de entidades diferentes solo por el número.

## Validación

Se volvió a comparar el catálogo de 45 triggers con MySQL: nombres, tablas, momento, evento y cuerpo coinciden. Hay exactamente uno por combinación tabla/AFTER/INSERT, UPDATE y DELETE.
Durante esta tarea no se ejecutaron pruebas con INSERT/UPDATE/DELETE ni se reemplazaron triggers. Las 45 pruebas funcionales aisladas de la implementación anterior están registradas en [el informe de implementación](../IMPLEMENTACION_20261022.md).
Los cuerpos reales están en [bd_test.estructura.json](bd_test.estructura.json). Los scripts de creación permanecen en las migraciones; esta documentación no debe ejecutarse como una migración.

## Consultas de solo lectura

```sql
SELECT EVENT_OBJECT_TABLE, ACTION_TIMING, EVENT_MANIPULATION, TRIGGER_NAME
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test'
ORDER BY EVENT_OBJECT_TABLE, EVENT_MANIPULATION;
SELECT EVENT_OBJECT_TABLE, ACTION_TIMING, EVENT_MANIPULATION, COUNT(*) AS total
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test'
GROUP BY EVENT_OBJECT_TABLE, ACTION_TIMING, EVENT_MANIPULATION
HAVING COUNT(*)<>1;
```
La segunda consulta debe devolver cero filas. No se fija un total artificial de triggers para ocultar duplicaciones.
