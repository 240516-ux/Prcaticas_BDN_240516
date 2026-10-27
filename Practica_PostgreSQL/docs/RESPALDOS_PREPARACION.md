# Respaldos de la simulación: estado y procedimiento preparado

No se generó ningún respaldo en esta revisión. La fotografía pide respaldo completo con todos los datos de MySQL y PostgreSQL: esta instrucción complementa la rúbrica, aunque su lista de indicadores no lo detalla. Los respaldos son privados y no se publican automáticamente.

## Hallazgo local comprobado

Solo se encontró en Practica_PostgreSQL/respaldos/respaldo_30092026.sql un archivo anterior, de 2 970 514 bytes, con definiciones de tb_users, tb_products y tb_logs y marcador de finalización de mysqldump. Eso no certifica que corresponda al VPS actual ni que contenga todas sus rutinas, eventos o cuentas. No se restauró. No se encontró archivo PostgreSQL .dump/.backup ni exportación SQL PostgreSQL de datos en el proyecto; sql/postgresql.sql es creación de objetos, no respaldo. No se buscó indiscriminadamente en directorios personales ajenos a los materiales proporcionados.

## Alcance y permisos

Los comandos siguientes son para ejecución MANUAL posterior, desde un cliente autorizado, sin escrituras en la base. No fueron ejecutados. Tener clientes de versión compatible (pg_dump 18 para servidor 18; mysqldump compatible con MySQL 8.4), conectividad y permisos de lectura/exportación. Si falta acceso, detenerse: no modificar GRANT ni configuración global. Capturar identidad y conteos antes/después por lectura; el dump refleja su propia instantánea y conteos externos pueden variar si otros escriben.

Un respaldo de bd_test_alan incluye sus datos y objetos exportables, pero no representa un respaldo de todo el servidor ni sus cuentas globales. pg_dump no crea roles globales; el administrador deberá proporcionar, por canal privado, el complemento autorizado de roles necesarios. En un VPS compartido no ejecutar pg_dumpall global indiscriminado ni copiar cuentas de compañeros. mysqldump de esta base no incluye mysql.* ni cuentas del servidor. Documentar ese alcance, sin afirmar respaldo completo de seguridad/servidor.

## Comandos preparados en PowerShell: exportación MySQL

Ejecutar este bloque solo tras revisar y autorizar la exportación. El host se introduce sin publicarlo; la contraseña la solicita el cliente. Se crea una carpeta NUEVA con GUID fuera del repositorio; no se reutilizan archivos. Los comandos no imprimen datos de la base ni restauran nada.

```powershell
$ErrorActionPreference = 'Stop'
$destino = Join-Path $env:USERPROFILE ('Documents/Respaldos_privados_BDN/' + [guid]::NewGuid().ToString('N'))
if (Test-Path -LiteralPath $destino) { throw 'El destino ya existe' }
New-Item -ItemType Directory -Path $destino | Out-Null
$servidorBD = Read-Host 'Servidor autorizado (no compartir capturas de este dato)'
$archivoMysql = Join-Path $destino 'bd_test_alan_mysql.sql'
& mysqldump --host=$servidorBD --port=40517 --user=alan_admin --password --single-transaction --routines --events --triggers --hex-blob --no-tablespaces --set-gtid-purged=OFF --databases bd_test_alan --result-file=$archivoMysql
if ($LASTEXITCODE -ne 0) { throw 'Exportación MySQL falló; conservar archivo parcial sin declararlo válido' }
if ((Get-Item -LiteralPath $archivoMysql).Length -eq 0) { throw 'Archivo vacío' }
Get-Item -LiteralPath $archivoMysql | Select-Object Name,Length
Get-FileHash -LiteralPath $archivoMysql -Algorithm SHA256
```

No se usa redirección de PowerShell para evitar conversiones de codificación. --single-transaction es consistente para tablas transaccionales: confirmar motores y evitar DDL concurrente; no garantiza consistencia de tablas no transaccionales. Rutinas/eventos/triggers necesitan privilegios apropiados. OFF no se resuelve durante una exportación; el dump no inventa triggers ausentes. No mostrar contenido ni errores que expongan datos sensibles en capturas públicas.

## Comandos preparados: exportación PostgreSQL

Bloque independiente; crea su propio destino nuevo. --format=custom conserva datos y estructura de la base; --create conserva la definición de base donde corresponda. No se excluyen ACL ni propietarios. La lista del archivo se genera localmente para revisión, sin restauración.

```powershell
$ErrorActionPreference = 'Stop'
$destino = Join-Path $env:USERPROFILE ('Documents/Respaldos_privados_BDN/' + [guid]::NewGuid().ToString('N'))
if (Test-Path -LiteralPath $destino) { throw 'El destino ya existe' }
New-Item -ItemType Directory -Path $destino | Out-Null
$servidorBD = Read-Host 'Servidor autorizado (no compartir capturas de este dato)'
$archivoPg = Join-Path $destino 'bd_test_alan_postgresql.dump'
& pg_dump --host=$servidorBD --port=40516 --username=alan_admin --password --dbname=bd_test_alan --format=custom --create --file=$archivoPg
if ($LASTEXITCODE -ne 0) { throw 'Exportación PostgreSQL falló; conservar archivo parcial sin declararlo válido' }
if ((Get-Item -LiteralPath $archivoPg).Length -eq 0) { throw 'Archivo vacío' }
$inventarioPg = Join-Path $destino 'inventario_pg_restore.txt'
& pg_restore --list --file=$inventarioPg $archivoPg
if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer el catálogo del respaldo' }
Get-Item -LiteralPath $archivoPg | Select-Object Name,Length
Get-FileHash -LiteralPath $archivoPg -Algorithm SHA256
```

## Verificación posterior necesaria

Registrar salida exitosa, tamaño, SHA-256 y fecha; cotejar inventario con tablas/datos/vistas/triggers/funciones/eventos que existan en cada motor. Un marcador final o pg_restore --list no prueban restaurabilidad ni por sí solos presencia completa de cada dato. Solo una restauración independiente autorizada, fuera de las bases existentes, permite probar recuperación y conteos. No se incluye comando de restauración para evitar aplicarlo por accidente al VPS. Conservar cualquier archivo parcial para diagnóstico privado; nunca reemplazar un respaldo anterior ni publicarlo.

Fuentes oficiales: [MySQL 8.4 mysqldump](https://dev.mysql.com/doc/refman/8.4/en/mysqldump.html), [PostgreSQL 18 pg_dump](https://www.postgresql.org/docs/18/app-pgdump.html), [PostgreSQL 18 pg_dumpall y objetos globales](https://www.postgresql.org/docs/18/app-pg-dumpall.html).
