# Documentación de la Práctica 02: Conexiones Remotas a Bases de Datos Relacionales

Base de datos: **bd_test**. MySQL 8.0. Ejecutar desde la raíz del repositorio usando el cliente mysql; si no está en PATH, usar la ruta completa al ejecutable. Sustituir el host y puerto por los del servidor cuando la conexión sea remota.

## Usuarios y privilegios

| Usuario | Acceso |
|---|---|
| alan.cruz | superadmin, administrador del servidor |
| marco.ramirez | admin de bd_test |
| luis.david | support |
| bryan.javier | seller |
| ivan.ojeda | seller |
| ivan.macin | CRUD directo, sin rol, como en el ejemplo del repositorio |

Las contraseñas proporcionadas están en el script de usuarios. Ejecutarlo con una cuenta que pueda crear usuarios, roles y objetos con DEFINER. La política de contraseñas del servidor debe permitir esas contraseñas.

## Instalación y carga

Usar una base nueva y vacía. Los scripts de instalación no son migraciones sobre una base existente.

1. Instalar las tablas, seis triggers y vistas de trazabilidad como administrador.
2. Crear usuarios y activar sus roles predeterminados.
3. Cargar los 5,000 productos con la conexión de Bryan.
4. Ejecutar las consultas de verificación como administrador.

```powershell
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p --execute="SOURCE Practica02/scripts/00_instalacion.sql"
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p --execute="SOURCE Practica02/scripts/remote_users_privileges_creation.sql"
mysql --local-infile=1 --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u bryan.javier -p --execute="SOURCE Practica02/seeds/carga_5k_productos_seller2.sql"
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u luis.david -p --execute="SOURCE Practica02/seeds/carga_usuarios_demostracion.sql"
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p --execute="SOURCE Practica02/queries/consultas_verificacion.sql"
```

El servidor debe tener `local_infile=ON`. El administrador puede habilitarlo con `SET GLOBAL local_infile=ON;`. El cliente también necesita `--local-infile=1`. La carga debe ejecutarse una sola vez sobre una base limpia: el SKU es único. Los IDs del CSV se omiten para que el servidor asigne los IDs locales. Las fechas del CSV se convierten con STR_TO_DATE y el estado se convierte a BIT.

## Resultado verificado

5,000 productos, seis triggers, cero productos sin traza. `vw_trazabilidad_productos` devuelve `bryan.javier`, rol `seller`, 5,000 productos. La vista muestra solamente el nombre de usuario, tanto en conexiones locales como remotas.

Los triggers extraen únicamente el nombre de USER(), y registran el ID de la fila y los roles del actor. Los vendedores pueden consultar la vista sin leer directamente mysql.role_edges ni modificar la bitácora.

## Respaldos

`backups/respaldo_funcional.sql` es un dump real generado después de ejecutar esta práctica con Bryan. Incluye datos, bitácora, triggers y vistas. Los respaldos con nombres de fecha conservan la estructura histórica del repositorio original, sin atribuir a tus usuarios los datos antiguos de otros alumnos.

La restauración reemplaza las tablas de bd_test. Elegir un solo respaldo; no ejecutar varios consecutivamente sobre datos que se quieran conservar. Los usuarios y roles se crean aparte con el script de usuarios.

```powershell
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p --execute="SOURCE Practica02/backups/respaldo_funcional.sql"
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 3306 -u root -p --execute="SOURCE Practica02/scripts/remote_users_privileges_creation.sql"
```

## Documentos y herramientas de entrega

Consultar [la guía de entrega](../docs/guia_de_entrega.md). Se incluyen las semillas CSV, los scripts de carga, las consultas, un respaldo completo y el script de cuentas y roles. Los archivos `respaldo_completo_*.sql` fueron generados con la herramienta incluida y contienen datos, bitácora y todos los objetos de bd_test. Los archivos `usuarios_y_roles_*.sql` guardan las seis cuentas remotas con host %.

```powershell
.\scripts\verificar_practica.ps1 -Practica 02
.\scripts\crear_respaldo.ps1 -Practica 02
```

El verificador devuelve OK o ERROR y detiene la ejecución si alguna comprobación falla. Las vistas muestran el nombre de usuario sin host; el host real se conserva dentro de la bitácora para auditoría. Las ramas locales son main, Practica02 y Practica03.

## Corrección de logs y llaves

La bitácora guarda únicamente el nombre en db_user; no existe una columna de host. Para corregir una instalación existente sin reinstalar ni perder datos, guardar un respaldo y ejecutar el script de migración de la etapa correspondiente.

```powershell
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 40516 -u root -p --execute="SOURCE Practica02/scripts/01_normalizar_bitacora.sql"
mysql --default-character-set=utf8mb4 -h 127.0.0.1 -P 40516 -u luis.david -p --execute="SOURCE Practica02/seeds/carga_usuarios_demostracion.sql"
.\scripts\verificar_practica.ps1 -Practica 02 -Port 40516
```

La semilla de usuarios es reejecutable y crea seis registros ficticios con correos example.test y hashes de secretos aleatorios. No usa direcciones personales ni sustituye las cuentas de conexión de MySQL. El CSV correspondiente se conserva en Practica02/seeds/usuarios_demostracion.csv.

Consultar [las llaves y la trazabilidad](../docs/llaves_y_trazabilidad.md). Los respaldos funcionales y completos incluyen esta corrección y los seis usuarios de demostración. Los respaldos históricos conservan sus tablas de etapa, con los triggers normalizados y los ajustes necesarios para ejecutar sus operaciones.

La corrección vigente elimina la columna connection_host de tb_logs y descarta el host de los registros de auditoría. Los triggers y respaldos vigentes guardan únicamente el nombre de usuario.
