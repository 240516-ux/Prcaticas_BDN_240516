# Función compartida: la contraseña se introduce de forma interactiva.
function Invoke-PracticaMySql {
    param([string]$Executable, [string]$Server, [int]$Port, [string]$User,
          [string[]]$Options, [string]$InputSql = '')
    if (-not (Test-Path -LiteralPath $Executable -PathType Leaf)) {
        throw "No se encontró el cliente MySQL: $Executable"
    }
    if ($Server -notmatch '^[a-zA-Z0-9._:%-]+$' -or $User -notmatch '^[a-zA-Z0-9._-]+$') {
        throw 'El servidor o usuario contiene caracteres no admitidos.'
    }
    $secret = Read-Host "Contraseña de $User" -AsSecureString
    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
    $process = New-Object System.Diagnostics.Process
    try {
        $settings = New-Object System.Diagnostics.ProcessStartInfo
        $settings.FileName = $Executable
        $settings.Arguments = (@('--no-defaults', "--host=$Server", "--port=$Port", "--user=$User") + $Options) -join ' '
        $settings.UseShellExecute = $false
        $settings.CreateNoWindow = $true
        $settings.RedirectStandardInput = $true
        $settings.RedirectStandardOutput = $true
        $settings.RedirectStandardError = $true
        $settings.StandardOutputEncoding = [Text.Encoding]::UTF8
        $settings.StandardErrorEncoding = [Text.Encoding]::UTF8
        $settings.StandardInputEncoding = New-Object Text.UTF8Encoding($false)
        $settings.EnvironmentVariables['MYSQL_PWD'] = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
        $process.StartInfo = $settings
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        $process.StandardInput.Write($InputSql)
        $process.StandardInput.Close()
        $process.WaitForExit()
        $result = $stdout.GetAwaiter().GetResult()
        $errors = $stderr.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) { throw $errors }
        if ($errors) { Write-Warning $errors }
        return $result
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
        $secret.Dispose()
        $process.Dispose()
    }
}
