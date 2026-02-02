# ============================================================
# Einsatzueberwachung - Verbesserter Starter mit IP-Anzeige
# ============================================================

param(
    [switch]$NetworkMode
)

$ErrorActionPreference = "Stop"

# Farben
$Colors = @{
    Header = 'Cyan'
    Success = 'Green'
    Warning = 'Yellow'
    Error = 'Red'
    Info = 'Gray'
}

function Show-StartupInfo {
    Clear-Host
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host "   EINSATZUEBERWACHUNG - Server Start" -ForegroundColor $Colors.Header
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host ""
}

function Get-LocalIPAddresses {
    $ips = @()
    $adapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
        $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" 
    }
    
    foreach ($adapter in $adapters) {
        $ips += $adapter.IPAddress
    }
    
    return $ips
}

function Show-AccessInfo {
    param(
        [string]$LocalUrl,
        [string[]]$NetworkUrls
    )
    
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Success
    Write-Host "   SERVER GESTARTET!" -ForegroundColor $Colors.Success
    Write-Host "============================================================" -ForegroundColor $Colors.Success
    Write-Host ""
    Write-Host "Lokaler Zugriff (auf diesem PC):" -ForegroundColor $Colors.Info
    Write-Host "  $LocalUrl" -ForegroundColor White
    Write-Host ""
    
    if ($NetworkUrls.Count -gt 0) {
        Write-Host "Netzwerk-Zugriff (von anderen Geraeten):" -ForegroundColor $Colors.Info
        foreach ($url in $NetworkUrls) {
            Write-Host "  $url" -ForegroundColor White
        }
        Write-Host ""
    }
    
    Write-Host "QR-Code fuer mobilen Zugriff:" -ForegroundColor $Colors.Info
    Write-Host "  Browser oeffnet automatisch mit QR-Code" -ForegroundColor $Colors.Warning
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host ""
    Write-Host "Zum Beenden druecken Sie STRG+C" -ForegroundColor $Colors.Warning
    Write-Host ""
}

function Test-DotNet {
    try {
        $version = dotnet --version
        if ($version -match '^8\.') {
            Write-Host "[OK] .NET 8 SDK gefunden: $version" -ForegroundColor $Colors.Success
            return $true
        } else {
            Write-Host "[WARNUNG] .NET Version $version gefunden, aber .NET 8 wird benoetigt!" -ForegroundColor $Colors.Warning
            return $false
        }
    } catch {
        Write-Host "[FEHLER] .NET 8 SDK ist nicht installiert!" -ForegroundColor $Colors.Error
        Write-Host ""
        Write-Host "Bitte installieren Sie .NET 8 SDK von:" -ForegroundColor $Colors.Warning
        Write-Host "https://dotnet.microsoft.com/download/dotnet/8.0" -ForegroundColor $Colors.Info
        Write-Host ""
        Read-Host "Druecken Sie Enter zum Beenden"
        return $false
    }
}

function Start-Application {
    param([bool]$IsNetworkMode)
    
    $projectPath = ".\Einsatzueberwachung.Web\Einsatzueberwachung.Web.csproj"
    
    if (!(Test-Path $projectPath)) {
        Write-Host "[FEHLER] Projekt nicht gefunden: $projectPath" -ForegroundColor $Colors.Error
        Read-Host "Druecken Sie Enter zum Beenden"
        exit 1
    }
    
    # Bestimme URLs
    $localUrl = "https://localhost:7059"
    $httpUrl = "http://localhost:5222"
    $ips = Get-LocalIPAddresses
    $networkUrls = @()
    
    if ($IsNetworkMode) {
        Write-Host "Starte im Netzwerk-Modus..." -ForegroundColor $Colors.Info
        foreach ($ip in $ips) {
            $networkUrls += "http://${ip}:5222"
        }
    } else {
        Write-Host "Starte im Lokal-Modus..." -ForegroundColor $Colors.Info
    }
    
    Write-Host ""
    Write-Host "Starte Server..." -ForegroundColor $Colors.Info
    
    # Zeige Zugriffsinformationen
    Show-AccessInfo -LocalUrl $localUrl -NetworkUrls $networkUrls
    
    # Browser oeffnen (lokaler Zugriff)
    Start-Sleep -Seconds 2
    Start-Process $localUrl
    
    # Starte dotnet
    if ($IsNetworkMode) {
        $env:ASPNETCORE_URLS = "https://localhost:7059;http://localhost:5222;http://0.0.0.0:5222"
        dotnet run --project $projectPath --configuration Release
    } else {
        dotnet run --project $projectPath --configuration Release
    }
}

# MAIN
Show-StartupInfo

if (!(Test-DotNet)) {
    exit 1
}

# Frage nach Netzwerk-Modus
Write-Host "Wie moechten Sie die Anwendung starten?" -ForegroundColor $Colors.Info
Write-Host ""
Write-Host "[1] Lokal (nur auf diesem PC erreichbar)" -ForegroundColor White
Write-Host "[2] Netzwerk (auch von anderen Geraeten/Tablets erreichbar)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Bitte waehlen Sie (1 oder 2)"

if ($choice -eq "2") {
    $NetworkMode = $true
    Write-Host ""
    Write-Host "Hinweis: Firewall-Regel kann noetig sein!" -ForegroundColor $Colors.Warning
    Write-Host "Port 5222 muss freigegeben werden." -ForegroundColor $Colors.Info
    Write-Host ""
    Start-Sleep -Seconds 2
}

Start-Application -IsNetworkMode $NetworkMode
