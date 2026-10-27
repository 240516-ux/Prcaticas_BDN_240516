# Fuentes y nivel de certeza

- Manual_conexion_VPS_SafeAula.pdf: guía de conexión SSH y convivencia en VPS, siete páginas. No constituye la rúbrica de bases de datos. Sus ejemplos no se ejecutaron.
- Manual de instalación y configuración de PostgreSQL.docx: introducción y 35 imágenes. Se extrajeron copias sin modificar el documento original; inventario y hashes en evidencias/indice_originales.csv.
- Fotografía de notas del alumno: requisitos informales de manual, repositorio, Docker, pgAdmin, dos respaldos y capturas individuales. La mención de token y la rúbrica exacta siguen sin confirmar.
- docker-compose.yml, sql/mysql.sql y sql/postgresql.sql: estructura declarada local, no evidencia de ejecución en servidores.
- Aclaración del alumno: Sharely Lilian es una sola persona; los roles fueron seleccionados por él tomando prácticas anteriores. No prueba asignación exigida por el profesor.

## Documentación oficial consultada

- MySQL 8.4, registro binario y programas almacenados: https://dev.mysql.com/doc/refman/8.4/en/stored-programs-logging.html
- Imagen oficial PostgreSQL y persistencia por versión: https://hub.docker.com/_/postgres
- pgAdmin 9.17, despliegue y persistencia: https://www.pgadmin.org/docs/pgadmin4/9.17/container_deployment.html
- PostgreSQL 18, pertenencia a roles: https://www.postgresql.org/docs/18/role-membership.html

Separar siempre: revisión estática de archivos; observación histórica en una captura; estado actual consultado; requisito formal. En esta etapa no hubo consultas actuales al VPS.

## Fuente adicional revisada

`caps.docx`: 22 imágenes, sin texto sustantivo ni rúbrica. Inventario en evidencias/caps/inventario_caps.csv; originales extraídos y conservados fuera del repositorio, sin editar. Pruebas históricas observadas: identidades por motor, pgAdmin, vistas, eventos trigger, conteos, OFF MySQL y UPDATE PostgreSQL con logs. Los números de página no se determinaron; se registran orden de imagen y párrafo OOXML.

## Rúbrica oficial incorporada

Lista_Verificacion_Unidad_1_Bases_Datos_Nube.pdf, siete páginas, 56 indicadores y 100 puntos. Leída completa y extraída con verificación de numeración y puntos. Es la fuente principal que sustituye las suposiciones previas. P. 3 exige clientes externos sin consultas SSH/PuTTY; p. 5 remite los diez ejercicios a clase; pp. 6-7 requieren control de versiones, conclusiones personales y estructura obligatoria. La matriz literal está en CUMPLIMIENTO_RUBRICA.md/CSV.

## Actualización por instrucciones manuscritas

La fotografía aporta ocho apartados de simulación para ambos motores y exige respaldos completos con datos. Ver [CASOS_SIMULACION.md](CASOS_SIMULACION.md) y [RESPALDOS_PREPARACION.md](RESPALDOS_PREPARACION.md) en docs/. Los casos 9 y 10 no se encontraron en los materiales disponibles: quedan pendientes del docente. No se inventan dividiendo UPDATE/DELETE o la actividad de vendedores.

Root, Support, usuario sin rol y dos vendedores deben identificarse como cuentas/roles reales, no por filas de tb_users. El GRANT P02 bajo el comentario sin rol apunta actualmente a alan.cruz: incoherencia que no se copia ni modifica. Support carece de DELETE en esa referencia, por lo que hay que aclarar si se evalúa una denegación. Nuevos validadores de permisos son solo lectura y no fueron ejecutados.

Los nombres tb_buyer_orders, tbd_order_items y tbd_cart_items sí aparecen en materiales de Practica03 para bd_test, pero no en los SQL de bd_test_alan. Falta confirmar alcance y definición antes de crearlos; no se importó estructura.

Solo se encontró el dump MySQL antiguo en la carpeta de respaldos del manual; no acredita el VPS actual y no se halló exportación PostgreSQL de datos. Ahora se prepararon comandos de exportación privados con destinos nuevos, contraseña interactiva y verificación de salida, tamaño y SHA-256, sin ejecutarlos. La exigencia de ambos respaldos viene de esta fotografía; sustituye la conclusión anterior de que no existía tal instrucción adicional. No se afirma restaurabilidad.
