# Modelo físico de bd_test

[Abrir el ERD interactivo](bd_test.html) · [SVG completo](bd_test.svg) · [PNG completo](bd_test.png) · [Diccionario de datos](../diccionario_datos.md) · [Conteos reales](CONTEOS_bd_test.md) · [Triggers](TRIGGERS_bd_test.md)

La estructura se consultó directamente en MySQL el 22/10/2026 después de la implementación: **17 tablas físicas, 135 columnas, 19 claves foráneas, 45 triggers y 6 vistas**. No se ejecutaron migraciones ni se cargaron datos durante esta documentación.

## Organización

El diagrama agrupa las tablas por Identidad, Direcciones, Catálogo, Ventas, Pagos y Auditoría. Son módulos de documentación, no esquemas nuevos. Cada tabla principal muestra todas sus columnas y tipos físicos. El HTML permite ampliar y explorar el dibujo; por su tamaño completo, la página tiene desplazamiento vertical.

Los identificadores originales se conservan: `ID`, `id`, `nick`, `user_ID`, `user_id` y `avalaible_date` no se normalizaron ni se renombraron para copiar otro modelo.

## Cómo interpretar las relaciones

- Las **19 conexiones** corresponden una por una a restricciones declaradas en MySQL. Una FK compuesta se representa con una sola conexión; sus columnas, orden y reglas están en el diccionario y en `bd_test.estructura.json`.
- PK, FK y UK indican participación en claves. En una UK compuesta, cada columna por separado puede repetirse. Las líneas no identificadoras no significan ausencia de FK.
- La ausencia de filas hijas es compatible con la existencia del padre. La obligatoriedad de la referencia desde la fila hija se deriva de la nulabilidad de sus columnas; no de los conteos actuales.
- Las bitácoras no tienen FK a usuarios o productos: pueden conservar operaciones de registros eliminados. No se añadieron conexiones hipotéticas para representar la escritura de auditoría.

### Dos alias gráficos, ninguna tabla inventada

Archify 3.1 no permite que una arista vuelva al mismo recuadro. Para **no omitir las dos FK autorreferentes**, se muestra una segunda instancia de la misma tabla, marcada con `· padre`:

| Alias gráfico | Tabla física real | FK declarada | Correspondencia |
|---|---|---|---|
| `alias_categoria_padre` | `tbc_categories` | `fk_superior_category` | `sup_id_category` → `ID` |
| `alias_componente_padre` | `tbd_address_components` | `fk_component_parent` | `(address_ID, address_sup_ID)` → `(address_ID, ID)` |

Hay **17 tablas físicas y 2 alias de dibujo**. Los alias no son objetos de MySQL. La FK compuesta de componentes exige que el padre pertenezca a la misma dirección. `address_ID` participa también en la FK hacia `tb_user_addresses`.

## Archivos

| Archivo | Contenido |
|---|---|
| `bd_test.html` | ERD interactivo completo |
| `bd_test.svg` | Exportación vectorial completa, ampliable y con tema automático |
| `bd_test.png` | Exportación completa de 1892 × 2284 píxeles, sin controles del visor |
| `bd_test.erd.json` | Fuente Archify, módulos y 19 relaciones |
| `bd_test.estructura.json` | Catálogo de estructura obtenido de MySQL, sin filas de negocio |
| `CONTEOS_bd_test.md` | Conteos de tablas y vistas en una instantánea separada |
| `TRIGGERS_bd_test.md` | Inventario y comportamiento de los 45 triggers, separado de los datos |
| `consultas_documentacion_bd_test.sql` | Consultas de solo lectura para actualizar la documentación y detectar huérfanos |
| `PROPUESTA_datos_propios.md` | Información auténtica necesaria antes de poblar las entidades vacías; no ejecutada |

El diccionario en `docs/diccionario_datos.md`, CSV y Excel documenta las 135 columnas. Excel contiene hojas para tablas, columnas, relaciones, índices, restricciones, auditoría y vistas. No contiene contraseñas de usuarios ni filas de personas.

## Abrir y exportar

1. Descargar el repositorio o conservar la carpeta de documentación localmente.
2. Abrir `docs/diagramas/bd_test.html` con un navegador. No necesita MySQL ni un servidor para consultar la instantánea; GitHub puede mostrar el código HTML en lugar de ejecutarlo.
3. Para consultar una imagen directamente, abrir `bd_test.svg` en el navegador o `bd_test.png` en un visor. El SVG conserva nitidez al ampliar; el PNG incluye todo el esquema, no solo el área visible de una captura de pantalla.
4. Para repetir la exportación, abrir el menú **Exportar** del HTML y elegir **SVG · Auto** o **PNG**. La exportación canónica incluye el diagrama completo y retira controles, selección y otras superposiciones temporales.

Las imágenes se exportaron desde el propio visor de Archify. Se verificaron los 19 recuadros —17 tablas y dos alias— y las 19 relaciones del SVG contra la fuente del ERD. Las imágenes son instantáneas: si cambia la estructura, volver a verificar el catálogo y exportarlas.

## Verificación

La revisión compara cada entidad y columna física con `INFORMATION_SCHEMA`, y cada conexión con la FK real; los alias se resuelven a su tabla original antes de comparar. Se consultaron las 19 restricciones sin encontrar huérfanos. Las huellas de las 17 tablas y las definiciones de vistas y triggers se comparan antes y después para confirmar conservación.

Archify pasó sus comprobaciones de estructura, artefacto y navegador. Se revisaron capturas del diagrama y de las siete hojas de Excel. Algunos vínculos largos recorren los bordes entre módulos para evitar pasar por las tablas; no se retiraron relaciones para simplificar el dibujo.

Las tablas vacías no se rellenaron con datos de demostración. No se debe convertir `inserted_by` en una asignación de proveedor: registra al actor de una inserción, no la propiedad del producto.

El estado y el procedimiento pendiente para publicar en GitHub se documentan en [Publicación segura](../SEGURIDAD_PUBLICACION.md). No se incluyen contraseñas, respaldos ni rutas personales en estas entregas.
