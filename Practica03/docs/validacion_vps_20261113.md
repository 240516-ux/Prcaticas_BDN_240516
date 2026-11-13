# Validación de `bd_test` en el VPS

13 de noviembre de 2026. Consultas de solo lectura en Workbench, MySQL 8.4.13, sesión `alan_admin`, sin rol activo.

| Comprobación | Resultado |
| --- | --- |
| Integridad referencial | 36 claves foráneas consultadas, incluidas las compuestas. Cero filas huérfanas. |
| Conteos | 7,506 usuarios, 7,500 perfiles, 22,007 productos y 92,846 entradas de auditoría. |
| Historial consolidado | 15,007 entradas con `legacy_product_log_id`. |
| Lotes de usuarios | T1: 500 usuarios y perfiles. T2: 2,000. T3: 5,000, con 4,013 activos y 987 inactivos. |
| Altas de productos de los lotes | 5,000 productos y 5,000 altas de `bryan.javier`. 2,000 productos y 2,000 altas de `ivan.ojeda`. Los lotes son restaurados. |
| Perfil de José Luis | Cero filas con el alias `joseluis.bernabe`. |
| Evento | `DISABLED`, última ejecución sin registro. 4,386 relaciones cumplen la condición de actualización comprobada. |

La sesión utilizada acredita consultas en el VPS. Quedan pendientes la sesión personal de Alan como `alan.cruz`, la revisión administrativa de los siete roles, el alta del perfil de José Luis, la evidencia de las cargas remotas y la ejecución controlada del evento.

Las consultas reproducibles están en [validacion_vps.sql](../queries/validacion_vps.sql).
