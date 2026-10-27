# Pruebas: fuente del profesor y evidencia real

La fuente vigente de actividades es CASOS_SIMULACION.md/CSV: ocho apartados manuscritos, desglosados por motor con objetivo, actor, plantilla SQL, resultado esperado y observado. Los casos 9 y 10 no se encontraron; falta confirmación del docente. La matriz genérica U01-P05 anterior no sustituye los ejercicios de clase ni da por aprobadas pruebas.

No se ejecutan escrituras en esta revisión. CAPS-17/18/21/22 demuestran UPDATE de producto y CAPS-19/20 UPDATE de usuario desde la sesión visible; no acreditan cada actor Root/Support/sin rol ni autorización efectiva. La evidencia anterior se conserva, sin repetir operaciones ni cambiar datos para cuadrar cantidades.

Permisos: se prepararon validacion_permisos_postgresql.sql y validacion_permisos_mysql.sql, solo lectura, sin ejecutar. Support DELETE no está permitido por la referencia P02; debe aclararse si la consigna solicita demostrar su denegación. Los scripts del manual no crean roles/cuentas/grants. MySQL mantiene auditoría bloqueada por OFF.
