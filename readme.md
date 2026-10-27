# Entrega del manual de Bases de Datos en la Nube - 240516

Rama de entrega: `Manual_VPS_BDs_Relacionales`. Esta historia reúne los avances seguros de Práctica 03 y del manual sin incluir los ancestros locales sensibles.

## Abrir la entrega

- [Reporte con el nombre de la rúbrica](Practica_PostgreSQL/docs/Reporte_Unidad1_240516.pdf).
- [Manual final local](Practica_PostgreSQL/docs/Manual_Bases_Datos_Nube_FINAL.pdf): 78 páginas, 17 capítulos y 39 capturas. Ambos PDF son idénticos.
- [Fuente editable](Practica_PostgreSQL/docs/MANUAL_ENTREGA.md).
- [README técnico del manual](Practica_PostgreSQL/README.md).
- [Matriz de los 56 indicadores](Practica_PostgreSQL/docs/CUMPLIMIENTO_RUBRICA.md).
- [Capturas realmente pendientes](Practica_PostgreSQL/docs/CAPTURAS_PENDIENTES.md).
- [Inventario de los 57 originales](Practica_PostgreSQL/evidencias/INVENTARIO_GENERAL.csv).
- [37 evidencias técnicas redactadas](Practica_PostgreSQL/evidencias/seguras/Evidencias_tecnicas_redactadas.pdf), más dos Docker seguras en evidencias/seleccionadas.

## Archivos técnicos y avances de Práctica 03

El proyecto del manual conserva su Compose y SQL revisados en `Practica_PostgreSQL/`. Los avances seguros de Práctica 03 se conservan en commits propios, con migraciones y consultas en `Practica03/`, diccionario y diagramas en `docs/`.

No se incluyen respaldos privados, .env, scripts con contraseñas ni evidencias originales sensibles. Los commits originales locales 338c15d y f6fe132 se conservan; esta entrega incorpora sus cambios documentales mediante commits nuevos para no arrastrar su historia sensible.

## Estado honesto de la entrega

La publicación de esta rama resuelve el acceso conjunto a los archivos seguros con el nombre solicitado. Las notas anteriores del PDF sobre el impedimento de publicar la rama local describen esa revisión histórica: la rama local original se conservó intacta y esta rama remota se construyó independientemente desde las dos entregas seguras.

No implica que todos los indicadores estén cumplidos: MySQL 1419, conexiones externas, permisos y casos oficiales completos, casos 9/10, alcance de los 5000 productos y DELETE de Support, respaldos actuales y datos pendientes de portada/conclusiones siguen sujetos a evidencia o confirmación. No se ejecutaron operaciones de VPS ni SQL para publicar estos archivos. La fusión a la rama predeterminada no se realizó.
