# Usuarios y roles: evidencia y decisiones pendientes

Los nombres de rol a revisar son `superadmin`, `admin`, `seller`, `buyer`, `support`, `common` y `not_registered`.

| Alias observado | role_name observado | Fuente |
|---|---|---|
| alan.cruz | superadmin | DOCX 34 y 35 |
| marco.ramirez | admin | DOCX 34 y 35 |
| luis.david | support | DOCX 34 y 35 |
| bryan.javier | seller | DOCX 34 y 35 |
| sharely.gonzales | seller | DOCX 34 y 35 |

El alumno confirma que Sharely Lilian es **una sola persona**. El alias documentado sigue siendo el observado, `sharely.gonzales`; no se deduce un alias del nombre personal. La selección de usuarios y roles fue una elección del alumno basada en prácticas anteriores, no una asignación verificada contra la rúbrica. No se crean ni renombran cuentas.

La captura PostgreSQL incluye además `prueba_manual`, con rol common. No se elimina para forzar un conteo de cinco. Los integrantes Linux del documento de conexión no establecen quiénes son los cinco usuarios exigidos en las bases.

`tb_users.role_name` es texto de la aplicación: no crea roles ni concede permisos del motor. Los scripts existentes no contienen CREATE ROLE, CREATE USER ni GRANT. La cuenta de conexión `alan_admin` debe distinguirse de estas filas. Consultar los validadores con una cuenta autorizada y confirmar privilegios reales; no publicar contraseñas ni hashes.
