# Continuación segura después del error 1419

Estado: bloqueado por autorización/configuración del administrador. El alumno informa que `log_bin_trust_function_creators` aparece en `OFF`; este valor no se consultó directamente durante la revisión local. El error fue informado por el alumno; todavía falta una captura legible del mensaje completo. La captura DOCX 35 muestra datos y cero logs, no acredita por sí sola el inventario de triggers.

1. Conectar al MySQL propio, puerto 40517, esquema bd_test_alan, usando solicitud interactiva de contraseña.
2. Ejecutar `sql/validacion_mysql.sql`. Registrar versión, cuenta, esquema, variables de binlog, inventario de triggers y conteos. No repetir INSERT anteriores.
3. Entregar al administrador el mensaje 1419 y los resultados de lectura pertinentes por un medio privado. El administrador debe decidir la política de creación de programas almacenados con binlog. No cambiar variables globales, privilegios, contenedores ni archivos del servidor desde esta práctica.
4. Una vez autorizado, volver a inventariar objetos: preparar una instalación que cree solamente cada trigger o vista ausente. Comparar cada definición con mysql.sql; no ejecutar su CREATE DATABASE, tablas ni reemplazos indiscriminadamente. Si existe un objeto diferente, solicitar revisión antes de reemplazarlo.
5. Registrar conteos antes y después de instalar los objetos. La creación de triggers no reconstruye operaciones pasadas: conservar cero logs históricos si eso refleja lo ocurrido.
6. Programar pruebas aisladas autorizadas; confirmar que cada nueva operación produce exactamente un log. Las pruebas con escrituras no están ejecutadas ni incluidas en los validadores de lectura.

No se prepara un script de reimportación automático: faltan el inventario actual y la decisión del administrador. No se inventan logs retrospectivos.

Referencia oficial: https://dev.mysql.com/doc/refman/8.4/en/stored-programs-logging.html

## Evidencia nueva: caps.docx

CAPS-12 y CAPS-13 muestran log_bin_trust_function_creators OFF; CAPS-13 muestra cinco usuarios, cuatro productos y cero logs. Ahora existe evidencia visual de OFF, aunque no una consulta actual ejecutada por Codex. SHOW TRIGGERS no muestra filas en esa sesión; su alcance depende de permisos. No se ve el mensaje 1419 completo ni una solución aplicada. El relato del reinicio proviene del alumno y no fue ejecutado ni comprobado por Codex.
