# Propuesta separada de población con datos propios

Estado: NO EJECUTADA. No autoriza cargas ni deduce relaciones por ID, alias o actor de auditoría.
Se revisaron los CSV de semillas del proyecto:

| Archivo propio | Filas | Columnas |
|---|---:|---|
| Practica02/seeds/5000_productos.csv | 5000 | id, sku, name, description, current_price, current_stock, status, creation_date, last_update |
| Practica03/seeds/categorias_ecommerce_100.csv | 100 | ID, name, description, sup_id_category, status |
| Practica03/seeds/categorizacion_productos.csv | 10177 | category_ID, product_ID, status |
| Practica03/seeds/tb_products_10000_nuevos.csv | 10000 | SKU, name, description, current_price, current_stock, status, creation_date, last_update |
| Practica03/seeds/tbd_products_categories_10000_por_sku.csv | 31536 | product_SKU, category_ID, status |

Las semillas disponibles describen productos, categorías y categorización; esas entidades ya contienen datos. No se encontró un CSV propio de asignaciones proveedor/producto, personas, direcciones, carritos, pedidos, favoritos o métodos de pago.
El campo inserted_by es el actor de inserción; no demuestra propiedad ni condición de proveedor. No convertirlo en asignaciones de tbd_products_users_providers.

## Información necesaria antes de una carga

| Entidad | Evidencia propia necesaria | Validaciones propuestas |
|---|---|---|
| Proveedores | Relación explícita usuario–SKU, tipo de propiedad y fecha de disponibilidad | Alias y SKU existentes; clave compuesta sin duplicados; confirmar vigencia |
| Personas | Nombres y demás datos entregados por el titular, vinculados explícitamente a su cuenta | No inferir nombres del alias; un registro por user_id |
| Direcciones y componentes | Datos reales y jerarquía suministrados por su titular | FK válida; padre en la misma dirección; coordenadas coherentes |
| Carritos, pedidos y favoritos | Acciones o registros propios verificables | Proveedor asociado al producto; cantidades válidas; evitar duplicaciones |
| Métodos de pago | Catálogo autorizado y referencias emitidas por el proveedor | No guardar números completos ni credenciales; no inventar referencias |

Si se suministra esa evidencia, preparar una carga incremental separada con revisión previa. No existe una obligación estructural de poblar estas tablas para que el ERD esté completo.
