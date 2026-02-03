# ============================================================
# Einsatzueberwachung - Universal Starter mit Desktop-Verknuepfung
# ============================================================
# Version: 4.0
# Beschreibung: Automatischer Start der Einsatzueberwachung mit
#               Update-Pruefung, allen Pruefungen und Optionen
# ============================================================

param(
    [switch]$CreateShortcut,
    [switch]$NetworkMode,
    [switch]$LocalMode,
    [switch]$SkipUpdateCheck
)

# Aktuelle Version (wird bei Updates automatisch angepasst)
$script:CurrentVersion = "3.8.0"
$script:GitHubRepo = "Elemirus1996/Einsatzueberwachung.Web"

# Farbdefinitionen fuer bessere Lesbarkeit
$script:Colors = @{
    Header = 'Cyan'
    Success = 'Green'
    Warning = 'Yellow'
    Error = 'Red'
    Info = 'Gray'
    Update = 'Magenta'
}

# ============================================================
# FUNKTIONEN
# ============================================================

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host "   EINSATZUEBERWACHUNG - Automatischer Start v4.0" -ForegroundColor $Colors.Header
    Write-Host "   Installierte Version: $script:CurrentVersion" -ForegroundColor $Colors.Info
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host ""
}

function Test-ForUpdates {
    Write-Host "Pruefe auf Updates..." -ForegroundColor $Colors.Info
    
    try {
        # GitHub API fuer neueste Release abfragen
        $apiUrl = "https://api.github.com/repos/$script:GitHubRepo/releases/latest"
        
        # TLS 1.2 aktivieren
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        $response = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 10 -ErrorAction Stop
        $latestVersion = $response.tag_name -replace '^v', ''
        $downloadUrl = $response.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -First 1 -ExpandProperty browser_download_url
        $releaseNotes = $response.body
        $releaseDate = [DateTime]::Parse($response.published_at).ToString("dd.MM.yyyy")
        
        # Versionen vergleichen
        $current = [Version]$script:CurrentVersion
        $latest = [Version]$latestVersion
        
        if ($latest -gt $current) {
            Write-Host ""
            Write-Host "============================================================" -ForegroundColor $Colors.Update
            Write-Host "   NEUE VERSION VERFUEGBAR!" -ForegroundColor $Colors.Update
            Write-Host "============================================================" -ForegroundColor $Colors.Update
            Write-Host ""
            Write-Host "  Installiert:  v$script:CurrentVersion" -ForegroundColor $Colors.Warning
            Write-Host "  Verfuegbar:   v$latestVersion (vom $releaseDate)" -ForegroundColor $Colors.Success
            Write-Host ""
            
            # Release-Notes anzeigen (gekuerzt)
            if ($releaseNotes) {
                Write-Host "  Was ist neu:" -ForegroundColor $Colors.Header
                $notes = $releaseNotes -split "`n" | Select-Object -First 10
                foreach ($line in $notes) {
                    if ($line.Trim()) {
                        Write-Host "    $($line.Trim())" -ForegroundColor $Colors.Info
                    }
                }
                Write-Host ""
            }
            
            Write-Host "============================================================" -ForegroundColor $Colors.Update
            Write-Host ""
            
            $choice = Read-Host "Update jetzt herunterladen und installieren? (J/N)"
            
            if ($choice -match '^[JjYy]') {
                if ($downloadUrl) {
                    Install-Update -DownloadUrl $downloadUrl -Version $latestVersion
                } else {
                    Write-Host "[!] Kein Installer in diesem Release gefunden." -ForegroundColor $Colors.Warning
                    Write-Host "    Bitte manuell herunterladen von:" -ForegroundColor $Colors.Info
                    Write-Host "    https://github.com/$script:GitHubRepo/releases/latest" -ForegroundColor $Colors.Info
                    Write-Host ""
                    Read-Host "Druecken Sie Enter um fortzufahren"
                }
            } else {
                Write-Host ""
                Write-Host "[i] Update uebersprungen. Sie koennen spaeter aktualisieren." -ForegroundColor $Colors.Info
                Write-Host ""
            }
        } else {
            Write-Host "[OK] Sie verwenden die neueste Version ($script:CurrentVersion)" -ForegroundColor $Colors.Success
        }
    } catch {
        Write-Host "[!] Update-Pruefung fehlgeschlagen (keine Internetverbindung?)" -ForegroundColor $Colors.Warning
        Write-Host "    $($_.Exception.Message)" -ForegroundColor $Colors.Info
    }
}

function Install-Update {
    param(
        [string]$DownloadUrl,
        [string]$Version
    )
    
    Write-Host ""
    Write-Host "Lade Update herunter..." -ForegroundColor $Colors.Info
    
    try {
        # Download-Pfad
        $downloadPath = Join-Path $env:TEMP "EinsatzueberwachungSetup_v$Version.exe"
        
        # Fortschrittsanzeige
        $ProgressPreference = 'Continue'
        
        # Download mit Invoke-WebRequest fuer Fortschrittsanzeige
        Write-Host "  Von: $DownloadUrl" -ForegroundColor $Colors.Info
        Write-Host "  Nach: $downloadPath" -ForegroundColor $Colors.Info
        Write-Host ""
        
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $downloadPath -TimeoutSec 120
        
        Write-Host "[OK] Download abgeschlossen!" -ForegroundColor $Colors.Success
        Write-Host ""
        
        # Installer starten
        Write-Host "Starte Installer..." -ForegroundColor $Colors.Info
        Write-Host "[i] Das aktuelle Fenster wird geschlossen." -ForegroundColor $Colors.Warning
        Write-Host ""
        
        Start-Sleep -Seconds 2
        
        # Installer ausfuehren und Script beenden
        Start-Process -FilePath $downloadPath
        exit 0
        
    } catch {
        Write-Host "[X] Download fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor $Colors.Error
        Write-Host ""
        Write-Host "    Bitte manuell herunterladen von:" -ForegroundColor $Colors.Info
        Write-Host "    https://github.com/$script:GitHubRepo/releases/latest" -ForegroundColor $Colors.Info
        Write-Host ""
        Read-Host "Druecken Sie Enter um fortzufahren"
    }
}

function Test-DotNetInstallation {
    Write-Host "Pruefe .NET Installation..." -ForegroundColor $Colors.Info
    
    try {
        $dotnetVersion = dotnet --version
        if ($dotnetVersion -match '^(8|9|1[0-9])\.') {
            Write-Host "[OK] .NET SDK gefunden: $dotnetVersion" -ForegroundColor $Colors.Success
            return $true
        } else {
            Write-Host "[!] .NET Version $dotnetVersion gefunden, aber .NET 8+ wird benoetigt!" -ForegroundColor $Colors.Warning
            return $false
        }
    } catch {
        Write-Host "[X] .NET SDK ist nicht installiert!" -ForegroundColor $Colors.Error
        Write-Host ""
        Write-Host "Bitte installieren Sie .NET 8+ SDK von:" -ForegroundColor $Colors.Warning
        Write-Host "https://dotnet.microsoft.com/download/dotnet/8.0" -ForegroundColor $Colors.Info
        Write-Host ""
        return $false
    }
}

function Get-LocalIPAddress {
    try {
        $adapters = Get-NetIPAddress -AddressFamily IPv4 | 
                    Where-Object { $_.InterfaceAlias -notlike '*Loopback*' -and $_.IPAddress -ne '127.0.0.1' }
        
        if ($adapters) {
            return $adapters[0].IPAddress
        }
    } catch {
        Write-Host "[!] Konnte lokale IP-Adresse nicht ermitteln" -ForegroundColor $Colors.Warning
    }
    return "localhost"
}

function Show-StartMenu {
    Write-Host ""
    Write-Host "Waehlen Sie den Start-Modus:" -ForegroundColor $Colors.Header
    Write-Host ""
    Write-Host "  [1] Lokaler Modus (nur dieser Computer)" -ForegroundColor White
    Write-Host "      >> https://localhost:7059" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "  [2] Netzwerk-Modus (Zugriff von anderen Geraeten)" -ForegroundColor White
    $localIP = Get-LocalIPAddress
    Write-Host "      >> https://${localIP}:7059" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "  [3] Desktop-Verknuepfung erstellen" -ForegroundColor White
    Write-Host ""
    Write-Host "  [0] Beenden" -ForegroundColor $Colors.Warning
    Write-Host ""
    
    $choice = Read-Host "Ihre Wahl"
    return $choice
}

function Start-LocalMode {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Success
    Write-Host "   STARTE LOKALEN MODUS" -ForegroundColor $Colors.Success
    Write-Host "============================================================" -ForegroundColor $Colors.Success
    Write-Host ""
    Write-Host "Die Anwendung wird gestartet..." -ForegroundColor $Colors.Info
    Write-Host "Browser oeffnet automatisch: https://localhost:7059" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host ">> Druecken Sie STRG+C zum Beenden" -ForegroundColor $Colors.Warning
    Write-Host ""
    
    # Wechsle ins Projektverzeichnis
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    Set-Location "$scriptPath\Einsatzueberwachung.Web"
    
    # Starte die Anwendung
    dotnet run --launch-profile https
}

function Start-NetworkMode {
    $localIP = Get-LocalIPAddress
    
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Success
    Write-Host "   STARTE NETZWERK-MODUS" -ForegroundColor $Colors.Success
    Write-Host "============================================================" -ForegroundColor $Colors.Success
    Write-Host ""
    Write-Host "Konfiguriere Firewall..." -ForegroundColor $Colors.Info
    
    # Pruefe Administrator-Rechte
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host "[!] Fuer Netzwerk-Modus werden Administrator-Rechte benoetigt!" -ForegroundColor $Colors.Warning
        Write-Host "    Starte Script neu mit erhoehten Rechten..." -ForegroundColor $Colors.Info
        
        # Starte Script neu als Administrator
        Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -NetworkMode"
        exit
    }
    
    # Konfiguriere Firewall
    try {
        $ruleName = "Einsatzueberwachung-Web"
        $existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
        
        if (-not $existingRule) {
            New-NetFirewallRule -DisplayName $ruleName `
                                -Direction Inbound `
                                -Action Allow `
                                -Protocol TCP `
                                -LocalPort 7059 `
                                -ErrorAction Stop | Out-Null
            Write-Host "[OK] Firewall-Regel erstellt" -ForegroundColor $Colors.Success
        } else {
            Write-Host "[OK] Firewall-Regel bereits vorhanden" -ForegroundColor $Colors.Success
        }
    } catch {
        Write-Host "[!] Firewall-Konfiguration fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor $Colors.Warning
    }
    
    Write-Host ""
    Write-Host "Die Anwendung wird gestartet..." -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "Zugriff ueber:" -ForegroundColor $Colors.Header
    Write-Host "  >> Lokal:    https://localhost:7059" -ForegroundColor $Colors.Success
    Write-Host "  >> Netzwerk: https://${localIP}:7059" -ForegroundColor $Colors.Success
    Write-Host ""
    Write-Host "QR-Code fuer mobilen Zugriff:" -ForegroundColor $Colors.Info
    Write-Host "  >> Oeffnen Sie die Einstellungen in der Anwendung" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host ">> Druecken Sie STRG+C zum Beenden" -ForegroundColor $Colors.Warning
    Write-Host ""
    
    # Wechsle ins Projektverzeichnis
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    Set-Location "$scriptPath\Einsatzueberwachung.Web"
    
    # Starte die Anwendung mit Netzwerk-URLs
    $env:ASPNETCORE_URLS = "https://*:7059;http://*:5059"
    dotnet run --no-launch-profile
}

function New-DesktopShortcut {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host "   DESKTOP-VERKNUEPFUNG ERSTELLEN" -ForegroundColor $Colors.Header
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host ""
    
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    $targetScript = $MyInvocation.MyCommand.Path
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    
    # Erstelle zwei Verknuepfungen
    $shortcuts = @(
        @{
            Name = "Einsatzueberwachung (Lokal)"
            File = "Einsatzueberwachung-Lokal.lnk"
            Args = "-ExecutionPolicy Bypass -File `"$targetScript`" -LocalMode"
            Description = "Startet Einsatzueberwachung im lokalen Modus"
        },
        @{
            Name = "Einsatzueberwachung (Netzwerk)"
            File = "Einsatzueberwachung-Netzwerk.lnk"
            Args = "-ExecutionPolicy Bypass -File `"$targetScript`" -NetworkMode"
            Description = "Startet Einsatzueberwachung im Netzwerk-Modus"
        }
    )
    
    $WScriptShell = New-Object -ComObject WScript.Shell
    
    foreach ($shortcut in $shortcuts) {
        $shortcutPath = Join-Path $desktopPath $shortcut.File
        
        try {
            $Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
            $Shortcut.TargetPath = "powershell.exe"
            $Shortcut.Arguments = $shortcut.Args
            $Shortcut.WorkingDirectory = $scriptPath
            $Shortcut.Description = $shortcut.Description
            $Shortcut.WindowStyle = 1  # Normal window
            $Shortcut.Save()
            
            Write-Host "[OK] Verknuepfung erstellt: $($shortcut.Name)" -ForegroundColor $Colors.Success
        } catch {
            Write-Host "[X] Fehler beim Erstellen von $($shortcut.Name): $($_.Exception.Message)" -ForegroundColor $Colors.Error
        }
    }
    
    Write-Host ""
    Write-Host "Desktop-Verknuepfungen wurden erstellt!" -ForegroundColor $Colors.Success
    Write-Host "Sie koennen die Anwendung nun per Doppelklick starten." -ForegroundColor $Colors.Info
    Write-Host ""
}

# ============================================================
# HAUPTPROGRAMM
# ============================================================

Show-Header

# Update-Pruefung als erstes (ausser wenn uebersprungen)
if (-not $SkipUpdateCheck) {
    Test-ForUpdates
    Write-Host ""
}

# Pruefe .NET Installation
if (-not (Test-DotNetInstallation)) {
    Write-Host ""
    Read-Host "Druecken Sie Enter zum Beenden"
    exit 1
}

Write-Host ""

# Pruefe Parameter fuer direkten Start
if ($CreateShortcut) {
    New-DesktopShortcut
    Read-Host "Druecken Sie Enter zum Beenden"
    exit 0
}

if ($LocalMode) {
    Start-LocalMode
    exit 0
}

if ($NetworkMode) {
    Start-NetworkMode
    exit 0
}

# Zeige Menue
while ($true) {
    $choice = Show-StartMenu
    
    switch ($choice) {
        '1' {
            Start-LocalMode
            break
        }
        '2' {
            Start-NetworkMode
            break
        }
        '3' {
            New-DesktopShortcut
            Write-Host ""
            Read-Host "Druecken Sie Enter um fortzufahren"
            Show-Header
            continue
        }
        '0' {
            Write-Host ""
            Write-Host "Auf Wiedersehen!" -ForegroundColor $Colors.Info
            Write-Host ""
            exit 0
        }
        default {
            Write-Host ""
            Write-Host "[!] Ungueltige Auswahl. Bitte waehlen Sie 0, 1, 2 oder 3." -ForegroundColor $Colors.Warning
            Start-Sleep -Seconds 2
            Show-Header
            continue
        }
    }
}
