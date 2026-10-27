# Revisión técnica local

## Alcance comprobado

Se leyeron Compose, README y ambos scripts, sin abrir `.env`. No se ejecutaron importaciones ni consultas en los servidores. El esquema del manual es `bd_test_alan`; el proyecto anterior utiliza `bd_test` y no se intervino.

| Elemento | MySQL | PostgreSQL |
|---|---|---|
| Tablas del script | tb_users, tb_products, tb_logs | Las mismas tres |
| Identidad | AUTO_INCREMENT | GENERATED ALWAYS AS IDENTITY |
| Auditoría del script | 6 triggers, uno por evento y tabla | 2 triggers, cada uno cubre 3 eventos |
| Funciones del script | Ninguna | audit_users, audit_products |
| Vistas | 2 filtros de tb_logs | 2 filtros de tb_logs |
| Detalles históricos | JSON parcial | JSONB de la fila |

Seis filas de information_schema.triggers en PostgreSQL representan dos triggers con tres eventos, no seis objetos distintos. No se traslada el conteo de 45 triggers de la Práctica 03 a este manual.

## Problemas confirmados en archivos y propuestas separadas

- Los triggers no guardan el actor de conexión. `record_id` identifica la fila afectada, no quien ejecutó la acción. No se atribuye la operación a username ni role_name. Propuesta futura: incluir identidad de sesión en JSON, definiendo primero cómo se identifica un usuario aplicativo cuando la conexión es compartida.
- UPDATE guarda el estado nuevo, no el anterior. DELETE conserva datos OLD. No existe FK desde los logs a la fila afectada; esto permite conservar eliminaciones. No unir obligatoriamente el historial a una fila que pudo borrarse.
- MySQL incluye CREATE TRIGGER sin protección para reejecución; PostgreSQL incluye DROP TRIGGER y reemplazos de funciones/vistas. No ejecutar scripts completos sobre el despliegue existente.
- CREATE TABLE IF NOT EXISTS no valida una estructura ya creada. Comparar columnas antes de continuar.
- username y email son UNIQUE; email permite NULL. No existen CHECK de precio o stock no negativos. Las pruebas no deben afirmar que esos valores se rechazan.
- role_name no tiene catálogo/FK ni validación contra siete roles. No se modifica sin confirmar la rúbrica.
- PostgreSQL 18 usa el montaje `/var/lib/postgresql` de Compose: conservarlo. MySQL tiene volumen persistente. pgAdmin no declara volumen propio: proponer persistencia en `/var/lib/pgadmin` solamente después de respaldar su configuración; un volumen vacío puede ocultar la configuración existente.
- Los puertos publicados no restringen por sí solos el origen. Solicitar revisión de firewall/TLS o túnel al administrador sin cambiar reglas compartidas.
- depends_on no demuestra que la base esté lista; comprobar disponibilidad por separado.
- El respaldo de septiembre es anterior al despliegue: no acredita un respaldo completo actual ni debe importarse automáticamente.

No se modifican Compose ni los dos scripts originales: las decisiones con posible impacto quedan aisladas en esta propuesta. Las validaciones nuevas son de lectura y no reparan objetos automáticamente.

## Complemento tras revisar caps.docx

Se mantienen sin cambios las estructuras y los scripts originales. CAPS-17/18 y CAPS-21/22 demuestran dos UPDATE distintos sobre el producto 1, con stock 11 y 12 y logs 8/10; CAPS-19/20 muestra UPDATE de usuario 2 y log 9. Esto acredita ejecución histórica de UPDATE, pero no OLD y NEW juntos ni actor de sesión. Las filas DELETE de metadatos demuestran declaración del evento, no una prueba DELETE ejecutada. El inventario completo y sus limitaciones están en evidencias/caps/.

La variable OFF de MySQL ahora tiene soporte visual CAPS-12/13; la solución de 1419 no está acreditada. En esta revisión solo se crearon consultas adicionales de lectura; no se alteraron triggers, roles ni permisos.

## Diferencias respecto a la rúbrica: corrección mínima pendiente

| Archivo / objeto | Diferencia comprobada | Corrección necesaria y límite |
|---|---|---|
| sql/mysql.sql y sql/postgresql.sql | No crean los siete roles, cinco cuentas ni sus GRANT | Obtener privilegios/cuentas actuales, confirmar política e identidades; preparar cambio mínimo solo después de autorización. No ejecutar los scripts completos |
| MySQL, auditoría | El script define seis triggers; CAPS-13 no demuestra instalación funcional y muestra OFF/0 logs | Administrador revisa instancia; después inventariar e instalar solo objetos ausentes autorizados, sin reimportar datos |
| PostgreSQL, auditoría | Dos triggers multievento; INSERT/UPDATE observados, actor no explícito y UPDATE guarda NEW | Confirmar si clase exige OLD/NEW juntos o actor; no ampliar por iniciativa propia ni modificar historial |
| Tablas | Los archivos crean tres tablas; restricciones exactas de clase incompletamente cotejadas | Contrastar con definición oficial; no agregar tablas de Práctica03 sin confirmación |
| Docker Compose | Motores con volúmenes; no se consultaron montajes remotos, logs ni reglas de red | Verificar lo existente mediante lectura autorizada. Volumen pgAdmin adicional no se impone como requisito independiente |
| Conexiones | docker exec es comprobación interna | Demostrar conexiones de clientes externos exigidas por la rúbrica; no repetir escrituras |
| Respaldos | Solo dump antiguo encontrado; comandos nuevos preparados | Exportaciones autorizadas a destinos nuevos y verificación posterior; todavía no existen respaldos actuales comprobados |

Los SQL y Compose se conservaron sin cambios. No se añadieron pruebas, funcionalidades, cargas o tablas. Los nuevos procedimientos previos de permisos son lectura preparada, no evidencia de ejecución.
