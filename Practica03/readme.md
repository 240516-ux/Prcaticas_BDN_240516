# Práctica 03 — Manipulación de datos en conexiones remotas

Alan Cruz Baltazar · Matrícula 240516 · Grupo 7A.

El esquema `bd_test` está desplegado en MySQL 8.4.13 del VPS. El proyecto integra el modelo de comercio electrónico, la auditoría de operaciones, las vistas de trazabilidad, las rutinas de carga y la gestión de accesos remotos.


## Explora bd_test

**25 tablas · 207 columnas · 36 claves foráneas · 25 vistas · 72 triggers**

| Recurso | Qué encontrarás |
| --- | --- |
| [Diccionario interactivo](docs/diccionario_datos.html) | Columnas, tipos, claves y referencias. Incluye búsqueda, filtros por módulo y navegación lateral. |
| [Diccionario CSV](docs/diccionario_datos.csv) | Las 207 columnas en formato tabular para revisar en GitHub o descargar. |
| [Visor del esquema](docs/index.html) | Explora tablas y relaciones, ajusta el zoom y copia el Mermaid. |
| [MERE de Archify](docs/diagramas/modelo_validado.html) | Diagrama entidad–relación del VPS con campos, claves y vistas por dominio. |
| [Validación del VPS](queries/validacion_vps.sql) | Consultas de lectura para revisar conteos, lotes, auditoría, relaciones y evento. |

Para usar los filtros y los diagramas, conserva junta la carpeta **docs** y abre los archivos HTML en Edge o Chrome. Los enlaces de GitHub muestran los archivos del repositorio. La publicación de GitHub Pages está pendiente.

## Actividades y resultados

| Actividad | Resultado comprobado | Pendiente |
| --- | --- | --- |
| Integrar el esquema y consultar sus objetos | En el VPS se observaron 25 tablas, 25 vistas, 72 triggers, dos funciones y cinco procedimientos. | Validar la integridad y los resultados de las vistas en el VPS. |
| Conectar vendedores remotos | Bryan y José Luis se conectaron con sus cuentas MySQL y el rol `seller`. José Luis confirmó cifrado TLS. | Dar de alta el perfil de José Luis en `tb_users` y comprobar los permisos efectivos de los siete roles. |
| Simular usuarios | El VPS contiene 7,500 perfiles y 7,506 usuarios contando los seis previos. La bitácora restaurada registra las 7,500 altas simuladas a nombre de `alan.cruz`. | Verificar el acceso remoto como `alan.cruz` con `superadmin` y acreditar la ejecución remota de los escenarios. |
| Poblar productos y conservar el historial | El VPS contiene 22,007 productos, incluidos 5,000 del lote `SELLER1` y 2,000 de `SELLER2` restaurados. | Acreditar las cargas remotas con sus autores reales y comprobar las relaciones con proveedores y categorías. |
| Probar la auditoría y el evento | En el laboratorio se comprobaron las operaciones de auditoría y una ejecución programada. El evento se observó desactivado en el VPS. | Demostrar la auditoría y una ejecución controlada del evento en el entorno de entrega. |
| Respaldar y entregar | El respaldo local final se restauró y verificó por separado. | Verificar un respaldo final del VPS y cerrar la entrega en GitHub. |

Los conteos del VPS corresponden a la evidencia disponible hasta el 11 de noviembre de 2026. Los lotes restaurados conservan su autoría original. Para acreditar una nueva carga remota, se debe acordar el lote con el docente y registrarlo por separado.

- [Diccionario de datos](docs/diccionario_datos.html) · [CSV](docs/diccionario_datos.csv)
- [MERE interactivo](docs/diagramas/modelo_validado.html) · [Fuente Archify](docs/diagramas/modelo_validado.erd.json)

El diccionario y el MERE reflejan la exportación de metadatos del VPS del 11 de noviembre de 2026: **25 tablas, 207 columnas, 36 claves foráneas, 25 vistas y 72 triggers**. La columna `tb_logs.legacy_product_log_id` explica el cambio frente a las 206 columnas de la prueba aislada. El MERE dibuja 34 relaciones y documenta dos autorreferencias. Archify aprobó la estructura y la correspondencia del HTML, pero detectó texto pequeño y desplazamiento vertical en algunos tamaños de pantalla. Usa las vistas por dominio o el diccionario para consultar los campos. Los documentos de octubre en la raíz conservan el avance histórico.

Para refrescar los metadatos, abre [exportar_metadatos_vps.sql](queries/exportar_metadatos_vps.sql) en `VPS_Practica03`, copia la celda JSON y utiliza `tools/documentar_mysql.py` con ese archivo.

## GitHub Pages

El [visor del modelo de datos](docs/index.html) abre en el navegador y permite buscar, filtrar, mover tablas y copiar el Mermaid completo. Incluye enlaces al diccionario y al MERE de Archify. Los totales corresponden a la exportación del VPS. El flujo `practica03-pages.yml` prepara exclusivamente el índice, el diccionario HTML y CSV y el diagrama HTML. Su publicación manual queda pendiente de verificar los documentos del VPS y revisar las credenciales históricas antes de publicar la rama.

## Siguiente paso en el VPS

José Luis queda como segundo vendedor. Su conexión con el rol seller está comprobada. Bryan debe incorporar su perfil en tb_users con el correo autorizado por José Luis. Los 2,000 productos históricos del lote SELLER2 conservan a su autor original.

## Validar en el VPS

Abre [validacion_vps.sql](queries/validacion_vps.sql) en Workbench, conectado a bd_test del VPS. El script consulta estructura, lotes, perfiles, auditoría y evento. Al final genera consultas SELECT para revisar claves foráneas, incluidas las compuestas. Ejecuta esas consultas y registra los resultados. El diccionario HTML se abre directamente en el navegador.
