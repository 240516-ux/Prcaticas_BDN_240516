param(
    [ValidateSet('02', '03')][string]$Practica = '03',
    [string]$Server = '127.0.0.1',
    [ValidateRange(1,65535)][int]$Port = 40516,
    [string]$User = 'root',
    [string]$MySqlDump = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe'
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'mysql_herramientas.ps1')
$root = Split-Path -Parent $PSScriptRoot
$backupDir = Join-Path $root "Practica$Practica\backups"
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss_fff'
$file = Join-Path $backupDir "respaldo_completo_$stamp.sql"
$data = Invoke-PracticaMySql -Executable $MySqlDump -Server $Server -Port $Port -User $User `
    -Options @('--default-character-set=utf8mb4', '--routines', '--events', '--triggers',
               '--single-transaction', '--set-gtid-purged=OFF', '--databases', 'bd_test')
[IO.File]::WriteAllText($file, $data, (New-Object Text.UTF8Encoding($false)))
# El dump contiene todos los objetos y datos de bd_test; las cuentas del servidor van aparte.
$users = Join-Path $root "Practica$Practica\scripts\remote_users_privileges_creation.sql"
Copy-Item -LiteralPath $users -Destination (Join-Path $backupDir "usuarios_y_roles_$stamp.sql")
Write-Output "Respaldo completo: $file"
Write-Output 'También se guardó el script de las seis cuentas y sus roles.'
