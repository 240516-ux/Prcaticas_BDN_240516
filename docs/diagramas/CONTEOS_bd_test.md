# Conteos reales de bd_test

Consulta de solo lectura: 2026-10-22T12:21:39. MySQL 8.0.42.
Este informe describe datos. El diccionario y el ERD describen estructura; una tabla vacía sigue siendo una entidad válida.

| Módulo | Tabla | Registros |
|---|---|---:|
| Identidad | tb_users | 6 |
| Identidad | tb_people | 0 |
| Direcciones | tb_user_addresses | 0 |
| Direcciones | tbd_address_components | 0 |
| Pagos | tbc_payment_methods_types | 0 |
| Pagos | tbd_user_payment_methods | 0 |
| Catálogo | tb_products | 15007 |
| Catálogo | tbc_categories | 100 |
| Catálogo | tbd_products_users_providers | 0 |
| Catálogo | tbd_products_categories | 41713 |
| Ventas | tb_carts | 0 |
| Ventas | tbd_cart_items | 0 |
| Ventas | tb_buyer_orders | 0 |
| Ventas | tbd_order_items | 0 |
| Ventas | tbd_users_wishlist_products | 0 |
| Auditoría | tb_logs | 41839 |
| Auditoría | tb_logs_productos | 15007 |

## Objetos comprobados

- 17 tablas físicas; 135 columnas; 19 FK declaradas, incluidas 2 autorreferentes.
- 45 triggers: 3 por cada una de las 15 tablas de negocio; ninguno en las 2 bitácoras.
- 6 vistas, 3 procedimientos, 1 función y 1 evento DISABLED.
- Cero huérfanos en las 19 FK. Los chequeos de tablas vacías no prueban asignaciones de negocio cargadas.

## Vistas

| Vista | Filas |
|---|---:|
| vw_bitacora_usuarios | 26 |
| vw_total_products_by_category | 101 |
| vw_trazabilidad_categorias | 100 |
| vw_trazabilidad_categorizacion_productos | 41713 |
| vw_trazabilidad_productos | 15007 |
| vw_trazabilidad_usuarios | 15 |

## Conservación

No se ejecutaron migraciones, INSERT, UPDATE ni DELETE. Las huellas de datos y de estructura coincidieron al finalizar con esta captura. Se verifican específicamente las definiciones de los doce triggers originales y las seis vistas.
No se publican huellas individuales de contraseñas ni filas de personas. La evidencia detallada queda local.
El evento permanece desactivado. Las 3,686 relaciones activas con entidad inactiva son un pendiente previo; no se alteraron.

## Actualización de totales

Ejecutar [consultas de documentación](consultas_documentacion_bd_test.sql) desde Workbench. Los archivos publicados son una instantánea, no una conexión dinámica a MySQL.
