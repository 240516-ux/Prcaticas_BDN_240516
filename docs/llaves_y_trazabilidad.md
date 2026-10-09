# Llaves e integridad de bd_test

El esquema se comparó con el clon completo del repositorio de referencia, rama Practica03. Se conservaron las llaves originales de las tablas de negocio.

| Tabla | Llave primaria | Llaves únicas | Llaves foráneas |
|---|---|---|---|
| tb_users | ID | email, nick | Ninguna |
| tb_products | ID | SKU | Ninguna |
| tbc_categories | ID | name | sup_id_category → tbc_categories.ID |
| tbd_products_categories | category_ID + product_ID | La combinación es única por su PK | category_ID → tbc_categories.ID; product_ID → tb_products.ID |
| tb_logs | ID | Ninguna adicional | Ninguna |

El índice de product_ID permite buscar relaciones desde un producto. El índice ix_trace de la bitácora permite buscar por tabla, ID de registro y operación. Las categorías raíz tienen sup_id_category NULL.

Las referencias impiden insertar relaciones con productos o categorías inexistentes. También impiden borrar físicamente un producto o categoría que siga relacionado. Los procedimientos de baja lógica cambian status sin romper las referencias.

La bitácora no tiene una llave foránea hacia los registros auditados: debe conservar el historial después de eliminarlos. record_id y record_key identifican la fila original; en relaciones, record_key guarda category_ID:product_ID.

## Nombres de los usuarios en los logs

db_user contiene solamente el nombre, por ejemplo bryan.javier. La bitácora no guarda el host de la conexión. Los triggers extraen únicamente el nombre de USER(); no asignan manualmente la autoría de las cargas.

La migración 01_normalizar_bitacora.sql convierte los registros anteriores y sustituye los triggers para que todas las operaciones futuras usen el mismo formato. Se probó ejecutándola dos veces, verificando que no cambian el número de logs, sus descripciones ni sus fechas.

## Datos y resultados verificados

- 15,000 productos: 5,000 insertados por Bryan y 10,000 por Iván Ojeda.
- 100 categorías y 41,696 relaciones insertadas por Luis David.
- Seis usuarios de aplicación de demostración, insertados por Luis David. Sus correos example.test son ficticios y no son las cuentas de conexión MySQL.
- 56,802 logs después de la carga completa; ninguno tiene un sufijo de host en db_user.
- No se encontraron relaciones huérfanas, padres inexistentes ni ciclos en la jerarquía actual de categorías.

Los logs de UPDATE y DELETE se producen al ejecutar esas operaciones. Las pruebas se realizaron dentro de transacciones que se revirtieron o en una instancia aislada, para no inventar actividad en la base de entrega. Workbench puede mostrar solamente las primeras 1,000 filas; SELECT COUNT(*) FROM bd_test.tb_logs devuelve el total real.

## Pruebas realizadas

Se comprobaron rechazos de SKU, email, nick, nombres de categoría y relaciones duplicados. También se probaron las referencias inexistentes, los borrados restringidos, los permisos de vendedores, los doce tipos de operaciones auditadas, los procedimientos, la función, el evento y la restauración de respaldos. La bitácora no copia contraseñas de tb_users.

Consultar Practica03/verificacion_integridad.txt para la evidencia de ejecución.

La corrección vigente elimina la columna connection_host de tb_logs y descarta el host de los registros de auditoría. Los triggers y respaldos vigentes guardan únicamente el nombre de usuario.
