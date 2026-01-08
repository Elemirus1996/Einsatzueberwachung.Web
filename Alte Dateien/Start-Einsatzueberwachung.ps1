# ========================================
# Einsatzueberwachung - PowerShell Starter
# ========================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Einsatzueberwachung - Schnellstart" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Pruefe ob .NET 8 installiert ist
try {
    $dotnetVersion = dotnet --version
    Write-Host "[OK] .NET SDK gefunden: $dotnetVersion" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "[FEHLER] .NET 8 SDK ist nicht installiert!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Bitte installieren Sie .NET 8 SDK von:" -ForegroundColor Yellow
    Write-Host "https://dotnet.microsoft.com/download/dotnet/8.0" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Druecken Sie Enter zum Beenden"
    exit 1
}

# Wechsle ins Projektverzeichnis
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location "$scriptPath\Einsatzueberwachung.Web"

Write-Host "Starte Anwendung..." -ForegroundColor Yellow
Write-Host "Browser oeffnet automatisch unter: https://localhost:7059" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Druecken Sie STRG+C zum Beenden" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Starte die Anwendung
dotnet run --launch-profile https
