@echo off
set "BATFILE=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((Get-Content -LiteralPath '%~f0' -Raw) -split '(?m)^#PS#')[1]"
exit /b
#PS#
# Self-elevate to admin
$me = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $me.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath $env:ComSpec -ArgumentList "/c `"$env:BATFILE`"" -Verb RunAs
    exit
}

function Get-SqlServices {
    @(Get-Service | Where-Object { $_.Name -eq 'MSSQLSERVER' -or $_.Name -like 'MSSQL$*' })
}

while ($true) {
    Clear-Host
    $svcs = Get-SqlServices
    if ($svcs.Count -eq 0) {
        Write-Host "No SQL Server instances found on this machine." -ForegroundColor Yellow
        break
    }

    Write-Host "SQL Server instances:`n"
    for ($i = 0; $i -lt $svcs.Count; $i++) {
        $s = $svcs[$i]
        $color = if ($s.Status -eq 'Running') { 'Green' } else { 'DarkGray' }
        $start = (Get-CimInstance Win32_Service -Filter "Name='$($s.Name)'").StartMode
        Write-Host ("[{0}] {1,-25} {2,-10} (startup: {3})" -f ($i + 1), $s.Name, $s.Status, $start) -ForegroundColor $color
    }

    Write-Host ""
    $pick = Read-Host "Enter a number to toggle on/off (Enter to quit)"
    if ([string]::IsNullOrWhiteSpace($pick)) { break }
    if ($pick -notmatch '^\d+$' -or [int]$pick -lt 1 -or [int]$pick -gt $svcs.Count) { continue }

    $target = $svcs[[int]$pick - 1]
    try {
        if ($target.Status -eq 'Running') {
            Write-Host "Stopping $($target.Name)..."
            Stop-Service -Name $target.Name -Force -ErrorAction Stop
        } else {
            Write-Host "Starting $($target.Name)..."
            Start-Service -Name $target.Name -ErrorAction Stop
        }
    } catch {
        Write-Host "Failed: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to continue"
    }
}
