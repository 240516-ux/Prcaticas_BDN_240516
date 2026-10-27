# Implementación verificada de bd_test, 22/10/2026

Estado: etapas 1–5 ejecutadas en MySQL 8.0.42 con la cuenta de trabajo autorizada.
No se importaron registros externos. No se modificaron usuarios, productos ni bitácoras históricas.

## Respaldo y límites de la comprobación

Respaldo completo nuevo fuera del repositorio, finalización mysqldump con código 0.
Tamaño: 18351760 bytes. SHA256: `1932665f9624e6c052850f445d3fa379e56e2a33fed9e65020e79a86e640fbfb`.
Verificados tablas, INSERT de tablas no vacías, vistas, triggers, rutinas, evento y marcador final.
No se hizo una restauración independiente del respaldo. La prueba funcional aislada usó copias de estructura, sin restaurar datos del respaldo.

## Cambios aplicados

- Etapa 2: tb_carts.user_ID a INT firmado y FK hacia tb_users; proveedores vacíos con PK (user_ID,product_ID); detalle de carrito con FK compuesta al par proveedor/producto.
- Etapa 3: pedidos, direcciones, componentes de dirección, artículos de pedidos y wishlist según el SQL original; personas según el DBML adjunto. Todas vacías. Los IDs que referencian tb_users son INT firmado.
- Se preservó tbd_cart_items. No se creó su variante externa tbd_carts_items ni se renombraron columnas existentes.
- El DBML externo cambia usuarios, productos, categorías y proveedores respecto a la base real. Esas sustituciones no se aplicaron. Solo tb_people se tomó como entidad nueva independiente.
- En artículos de pedidos se usa FK compuesta proveedor/producto: las FK independientes externas no garantizarían el par. No se asignaron proveedores a productos existentes.
- Etapa 4: 33 triggers nuevos; los 12 originales conservaron su definición. No se añadieron triggers a las bitácoras.
- Etapa 5: 17 tablas, 135 columnas físicas, 19 FK, 45 triggers, 6 vistas, 3 procedimientos, 1 función y 1 evento desactivado.

## Conteos antes y después

| Tabla | Antes | Después |
|---|---:|---:|
| tb_buyer_orders | No existía | 0 |
| tb_carts | 0 | 0 |
| tb_logs | 41839 | 41839 |
| tb_logs_productos | 15007 | 15007 |
| tb_people | No existía | 0 |
| tb_products | 15007 | 15007 |
| tb_user_addresses | No existía | 0 |
| tb_users | 6 | 6 |
| tbc_categories | 100 | 100 |
| tbc_payment_methods_types | 0 | 0 |
| tbd_address_components | No existía | 0 |
| tbd_cart_items | 0 | 0 |
| tbd_order_items | No existía | 0 |
| tbd_products_categories | 41713 | 41713 |
| tbd_products_users_providers | No existía | 0 |
| tbd_user_payment_methods | 0 | 0 |
| tbd_users_wishlist_products | No existía | 0 |

Las huellas canónicas de las diez tablas originales coinciden con las del respaldo previo a la implementación. Las siete tablas nuevas permanecen vacías. Las seis FK originales y las cuatro rutinas originales se conservaron.

## Distribución de triggers

| Tabla de negocio | Triggers AFTER INSERT/UPDATE/DELETE |
|---|---:|
| tb_buyer_orders | 3 |
| tb_carts | 3 |
| tb_people | 3 |
| tb_products | 3 |
| tb_user_addresses | 3 |
| tb_users | 3 |
| tbc_categories | 3 |
| tbc_payment_methods_types | 3 |
| tbd_address_components | 3 |
| tbd_cart_items | 3 |
| tbd_order_items | 3 |
| tbd_products_categories | 3 |
| tbd_products_users_providers | 3 |
| tbd_user_payment_methods | 3 |
| tbd_users_wishlist_products | 3 |

El respaldo SQL original contiene 12 triggers en cuatro tablas. Los 45 actuales corresponden a las quince entidades de negocio finalmente incorporadas, tres eventos por entidad. No se alcanzó el total importando registros ni creando triggers sobre tb_logs o tb_logs_productos.

## Pruebas ejecutadas

- 45 operaciones controladas en un esquema aislado: INSERT, UPDATE y DELETE de cada entidad; un registro de auditoría por operación, tabla, actor, clave y snapshots comprobados.
- La FK compuesta rechazó un par de proveedor/producto cuyos componentes existían por separado.
- Auditoría BIGINT comprobada: record_key conserva el ID completo; record_id queda NULL cuando excede uint32. No se amplió tb_logs.
- ROLLBACK de las pruebas: todas las tablas del esquema aislado quedaron sin filas. El esquema de pruebas se conserva localmente; no se ejecutó DROP para limpiarlo.
- Las 19 FK declaradas tienen cero registros huérfanos en la base activa. Las nuevas tablas están vacías; esta comprobación no demuestra que existan asignaciones de negocio cargadas.
- 47 sentencias de la consulta final ejecutadas sin errores.
- Definiciones de seis vistas, doce triggers anteriores, cuatro rutinas y evento comparadas con el estado inicial.
- Ocho tablas originales conservaron exactamente su CREATE TABLE. Las dos restantes cambiaron solo según los ALTER autorizados.

## Vistas conservadas

| Vista | Filas |
|---|---:|
| vw_trazabilidad_productos | 15007 |
| vw_trazabilidad_usuarios | 15 |
| vw_bitacora_usuarios | 26 |
| vw_total_products_by_category | 101 |
| vw_trazabilidad_categorias | 100 |
| vw_trazabilidad_categorizacion_productos | 41713 |

## Alcance de la auditoría nueva

Los nuevos triggers registran USER() y roles asignados para host %, siguiendo la convención previa; no demuestran roles activos ni identifican a una persona física detrás de una cuenta compartida.
Para personas, direcciones, componentes y medios de pago se omiten valores personales y referencias de pago. Se registra que hubo una operación y su identidad, aunque un campo sensible omitido haya cambiado.
No se cambiaron contraseñas, cuentas MySQL, roles ni permisos. No se habilitó ev_actualizar_estado_relaciones: siguen pendientes las 3,686 relaciones activas con producto o categoría inactivos, cuya modificación no estaba autorizada.

## Reproducción y publicación

Scripts definitivos, en orden:
1. Practica03/migrations/20261022_02_carritos_proveedores.sql
2. Practica03/migrations/20261022_03_entidades_faltantes.sql
3. Practica03/migrations/20261022_04_auditoria_entidades.sql
4. Practica03/queries/validacion_implementacion_20261022.sql

Los CREATE/ALTER no son idempotentes: inspeccionar el estado y no repetir objetos ya existentes. DDL confirma implícitamente; no hay ROLLBACK global garantizado.
Los scripts PROPUESTA anteriores se conservan como borradores; no ejecutarlos nuevamente sobre el estado ya migrado.
El diccionario y ERD anteriores describen la instantánea previa de diez tablas, no este estado final de diecisiete. Este informe y los scripts definitivos registran el cambio.
Los scripts auxiliares, manifiestos y respaldos completos permanecen locales y fuera de estos commits. Push detenido por credenciales y datos sensibles heredados del historial remoto; no se reescribió el historial ni se eliminaron archivos.
