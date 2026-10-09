param(
    [ValidateSet('02', '03')][string]$Practica = '03',
    [string]$Server = '127.0.0.1',
    [ValidateRange(1,65535)][int]$Port = 40516,
    [string]$User = 'root',
    [string]$MySql = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'mysql_herramientas.ps1')
$root = Split-Path -Parent $PSScriptRoot
$query = Join-Path $root "Practica$Practica\queries\verificacion_funcional.sql"
$result = Invoke-PracticaMySql -Executable $MySql -Server $Server -Port $Port -User $User `
    -Options @('--default-character-set=utf8mb4', '--batch', '--skip-column-names') `
    -InputSql (Get-Content -LiteralPath $query -Raw -Encoding UTF8)
Write-Output $result.Trim()
$lines = @($result -split '\r?\n' | Where-Object { $_.Trim() })
if ($lines.Count -eq 0 -or @($lines | Where-Object { $_ -notmatch '^OK\t' }).Count -gt 0) {
    throw 'La verificación detectó resultados distintos de los esperados. Revisa las filas ERROR.'
}
Write-Output "Práctica ${Practica}: todas las comprobaciones pasaron."
