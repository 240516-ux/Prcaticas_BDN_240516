# Bases de Datos en la Nube — 240516

Alan Cruz Baltazar · Grupo 7A.

## Manual y reporte

La documentación de entrega se encuentra en `Practica_PostgreSQL/docs/`, que contiene únicamente archivos PDF:

- [Manual de Bases de Datos en la Nube](Practica_PostgreSQL/docs/Manual_Bases_Datos_Nube_FINAL.pdf): edición provisional de 78 páginas con 39 capturas integradas.
- [Reporte de la Unidad 1](Practica_PostgreSQL/docs/Reporte_Unidad1_240516.pdf): mismo contenido del manual, con el nombre de entrega solicitado.
- [Borrador anterior](Practica_PostgreSQL/docs/Manual_BDs_Nube_BORRADOR.pdf): versión histórica, no utilizar como entrega actual.

Las capturas incluidas en el manual permanecen dentro del PDF. La carpeta independiente de evidencias y los archivos auxiliares de documentación se retiraron del proyecto; sus originales y la versión Word se conservaron en un archivo privado fuera del repositorio.

## Archivos técnicos

- [Docker Compose](Practica_PostgreSQL/docker-compose.yml): PostgreSQL 40516, MySQL 40517 y pgAdmin 40518.
- [Scripts SQL del manual](Practica_PostgreSQL/sql/): revisar cada script antes de ejecutarlo; no reimportar scripts completos sobre bases existentes.
- [Práctica 03](Practica03/): avances seguros de la práctica anterior.
- [Diagrama del esquema](docs/diagramas/bd_test.html), con versiones [PNG](docs/diagramas/bd_test.png) y [SVG](docs/diagramas/bd_test.svg).

## Estado de la entrega

El nombre FINAL del PDF no implica cumplimiento completo. Siguen pendientes la resolución del error MySQL 1419, la comprobación de permisos y conexiones externas, las pruebas oficiales sin evidencia, la aclaración de los casos 9/10 y los respaldos actuales. La portada requiere equipo y fecha real de entrega; las conclusiones deben personalizarse.

Algunas referencias impresas en el PDF corresponden a documentos auxiliares históricos que ya no se incluyen en esta estructura simplificada.

## Seguridad

No publicar `.env`, contraseñas, tokens, claves privadas ni respaldos sensibles. La rama local conserva historial sensible y no debe enviarse directamente al remoto. La entrega remota se publica desde una historia limpia, conservando los originales locales por separado.