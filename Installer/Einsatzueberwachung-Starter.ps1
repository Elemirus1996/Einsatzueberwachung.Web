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

function Stop-OldServers {
    Write-Host "Pruefe auf laufende Server-Prozesse..." -ForegroundColor $Colors.Info
    
    # Finde alle dotnet-Prozesse die Einsatzueberwachung laufen
    $dotnetProcesses = Get-Process -Name "dotnet" -ErrorAction SilentlyContinue
    $killedAny = $false
    
    if ($dotnetProcesses) {
        foreach ($proc in $dotnetProcesses) {
            try {
                # Prüfe ob es ein Einsatzueberwachung-Prozess ist
                $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($proc.Id)" -ErrorAction SilentlyContinue).CommandLine
                if ($cmdLine -like "*Einsatzueberwachung*") {
                    Write-Host "[STOP] Beende alten Server-Prozess (PID: $($proc.Id))..." -ForegroundColor $Colors.Warning
                    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
                    $killedAny = $true
                }
            } catch {
                # Ignoriere Fehler beim Prüfen einzelner Prozesse
            }
        }
    }
    
    if ($killedAny) {
        Write-Host "[OK] Alte Server-Prozesse beendet" -ForegroundColor $Colors.Success
        Start-Sleep -Seconds 2
    } else {
        Write-Host "[OK] Keine laufenden Server gefunden" -ForegroundColor $Colors.Success
    }
    Write-Host ""
}

function Get-LocalIPAddresses {
    Write-Host "[DEBUG] Starte IP-Erkennung..." -ForegroundColor Gray
    
    $ipAddresses = @()
    
    try {
        # Finde alle aktiven IPv4-Adressen (außer localhost und APIPA)
        $allAdapters = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue
        
        Write-Host "[DEBUG] Gefundene Adapter: $($allAdapters.Count)" -ForegroundColor Gray
        
        if ($allAdapters) {
            foreach ($adapter in $allAdapters) {
                Write-Host "[DEBUG] Adapter: $($adapter.IPAddress) - InterfaceAlias: $($adapter.InterfaceAlias)" -ForegroundColor Gray
                
                # Filtere localhost und APIPA
                if ($adapter.IPAddress -notlike "127.*" -and $adapter.IPAddress -notlike "169.254.*") {
                    $ipAddresses += $adapter.IPAddress
                    Write-Host "[DEBUG] IP hinzugefügt: $($adapter.IPAddress)" -ForegroundColor Green
                }
            }
        }
    } catch {
        Write-Host "[WARN] Fehler beim Abrufen der IP-Adressen: $_" -ForegroundColor Yellow
    }
    
    # Eindeutige IPs als Array
    $uniqueIPs = @($ipAddresses | Select-Object -Unique)
    Write-Host "[DEBUG] Rückgabe: $($uniqueIPs.Count) eindeutige IPs" -ForegroundColor Gray
    
    return $uniqueIPs
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
        $majorVersion = [int]($version -split '\.' | Select-Object -First 1)
        
        if ($majorVersion -ge 8) {
            Write-Host "[OK] .NET $version gefunden" -ForegroundColor $Colors.Success
            return $true
        } else {
            Write-Host "[WARNUNG] .NET Version $version gefunden, aber .NET 8 oder hoeher wird benoetigt!" -ForegroundColor $Colors.Warning
            return $false
        }
    } catch {
        Write-Host "[FEHLER] .NET 8+ SDK ist nicht installiert!" -ForegroundColor $Colors.Error
        Write-Host ""
        Write-Host "Bitte installieren Sie .NET 8 SDK oder hoeher von:" -ForegroundColor $Colors.Warning
        Write-Host "https://dotnet.microsoft.com/download/dotnet" -ForegroundColor $Colors.Info
        Write-Host ""
        Read-Host "Druecken Sie Enter zum Beenden"
        return $false
    }
}

function Start-Application {
    param([bool]$IsNetworkMode)
    
    # Suche die .csproj Datei in aktuellen oder Unterverzeichnissen
    $projectPath = $null
    
    # Prüfe in Einsatzueberwachung.Web Unterverzeichnis
    if (Test-Path ".\Einsatzueberwachung.Web\Einsatzueberwachung.Web.csproj") {
        $projectPath = ".\Einsatzueberwachung.Web\Einsatzueberwachung.Web.csproj"
    }
    # Prüfe im aktuellen Verzeichnis
    elseif (Test-Path ".\Einsatzueberwachung.Web.csproj") {
        $projectPath = ".\Einsatzueberwachung.Web.csproj"
    }
    # Suche rekursiv
    else {
        $found = Get-ChildItem -Recurse -Filter "Einsatzueberwachung.Web.csproj" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $projectPath = $found.FullName
        }
    }
    
    if (!$projectPath -or !(Test-Path $projectPath)) {
        Write-Host "[FEHLER] Projekt nicht gefunden!" -ForegroundColor $Colors.Error
        Write-Host ""
        Write-Host "Aktuelles Verzeichnis: $(Get-Location)" -ForegroundColor $Colors.Info
        Write-Host "Verfuegbare Dateien:" -ForegroundColor $Colors.Info
        Get-ChildItem -Recurse -Filter "*.csproj" | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" }
        Write-Host ""
        Read-Host "Druecken Sie Enter zum Beenden"
        exit 1
    }
    
    Write-Host "[OK] Projekt gefunden: $projectPath" -ForegroundColor $Colors.Success
    Write-Host ""
    
    # Bestimme URLs
    $localUrl = "http://localhost:5000"
    $httpUrl = "http://localhost:5000"
    $ips = Get-LocalIPAddresses
    $networkUrls = @()
    
    if ($IsNetworkMode) {
        Write-Host "Starte im Netzwerk-Modus..." -ForegroundColor $Colors.Info
        foreach ($ip in $ips) {
            $networkUrls += "http://${ip}:5000"
        }
    } else {
        Write-Host "Starte im Lokal-Modus..." -ForegroundColor $Colors.Info
    }
    
    # Lösche alte Binaries um Sperr-Konflikte zu vermeiden
    Write-Host ""
    Write-Host "Räume alte Build-Artefakte auf..." -ForegroundColor $Colors.Info
    $projectDir = Split-Path $projectPath
    $binDir = Join-Path $projectDir "bin"
    $objDir = Join-Path $projectDir "obj"
    
    if (Test-Path $binDir) {
        Remove-Item $binDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    if (Test-Path $objDir) {
        Remove-Item $objDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    
    Write-Host ""
    Write-Host "Starte Server..." -ForegroundColor $Colors.Info
    
    # Zeige Zugriffsinformationen
    Show-AccessInfo -LocalUrl $localUrl -NetworkUrls $networkUrls
    
    # Browser oeffnen (verwende den tatsächlichen Port)
    Write-Host ""
    Write-Host "Öffne Browser..." -ForegroundColor $Colors.Info
    Start-Sleep -Seconds 2
    
    # Öffne immer localhost im Browser (auch im Netzwerk-Modus)
    $browserUrl = "http://localhost:5000"
    Write-Host "Öffne: $browserUrl" -ForegroundColor $Colors.Info
    Start-Process $browserUrl
    
    # Starte dotnet
    if ($IsNetworkMode) {
        $env:ASPNETCORE_URLS = "https://localhost:7059;http://0.0.0.0:5000"
        $env:ASPNETCORE_ENVIRONMENT = "Production"
        dotnet run --project $projectPath --configuration Release --no-launch-profile
    } else {
        $env:ASPNETCORE_URLS = "https://localhost:7059;http://localhost:5000"
        $env:ASPNETCORE_ENVIRONMENT = "Production"
        dotnet run --project $projectPath --configuration Release --no-launch-profile
    }
}

# MAIN
Show-StartupInfo

# Beende alte Server-Prozesse
Stop-OldServers

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
