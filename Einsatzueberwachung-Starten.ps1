# ============================================================
# Einsatzüberwachung - Universal Starter mit Desktop-Verknüpfung
# ============================================================
# Version: 3.0
# Beschreibung: Automatischer Start der Einsatzüberwachung mit
#               allen notwendigen Prüfungen und Optionen
# ============================================================

param(
    [switch]$CreateShortcut,
    [switch]$NetworkMode,
    [switch]$LocalMode
)

# Farbdefinitionen für bessere Lesbarkeit
$script:Colors = @{
    Header = 'Cyan'
    Success = 'Green'
    Warning = 'Yellow'
    Error = 'Red'
    Info = 'Gray'
}

# ============================================================
# FUNKTIONEN
# ============================================================

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host "   EINSATZÜBERWACHUNG - Automatischer Start v3.0" -ForegroundColor $Colors.Header
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host ""
}

function Test-DotNetInstallation {
    Write-Host "Prüfe .NET Installation..." -ForegroundColor $Colors.Info
    
    try {
        $dotnetVersion = dotnet --version
        if ($dotnetVersion -match '^8\.') {
            Write-Host "[✓] .NET 8 SDK gefunden: $dotnetVersion" -ForegroundColor $Colors.Success
            return $true
        } else {
            Write-Host "[!] .NET Version $dotnetVersion gefunden, aber .NET 8 wird benötigt!" -ForegroundColor $Colors.Warning
            return $false
        }
    } catch {
        Write-Host "[✗] .NET 8 SDK ist nicht installiert!" -ForegroundColor $Colors.Error
        Write-Host ""
        Write-Host "Bitte installieren Sie .NET 8 SDK von:" -ForegroundColor $Colors.Warning
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
    Write-Host "Wählen Sie den Start-Modus:" -ForegroundColor $Colors.Header
    Write-Host ""
    Write-Host "  [1] Lokaler Modus (nur dieser Computer)" -ForegroundColor White
    Write-Host "      » https://localhost:7059" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "  [2] Netzwerk-Modus (Zugriff von anderen Geräten)" -ForegroundColor White
    $localIP = Get-LocalIPAddress
    Write-Host "      » https://${localIP}:7059" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "  [3] Desktop-Verknüpfung erstellen" -ForegroundColor White
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
    Write-Host "Browser öffnet automatisch: https://localhost:7059" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "» Drücken Sie STRG+C zum Beenden" -ForegroundColor $Colors.Warning
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
    
    # Prüfe Administrator-Rechte
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host "[!] Für Netzwerk-Modus werden Administrator-Rechte benötigt!" -ForegroundColor $Colors.Warning
        Write-Host "    Starte Script neu mit erhöhten Rechten..." -ForegroundColor $Colors.Info
        
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
            Write-Host "[✓] Firewall-Regel erstellt" -ForegroundColor $Colors.Success
        } else {
            Write-Host "[✓] Firewall-Regel bereits vorhanden" -ForegroundColor $Colors.Success
        }
    } catch {
        Write-Host "[!] Firewall-Konfiguration fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor $Colors.Warning
    }
    
    Write-Host ""
    Write-Host "Die Anwendung wird gestartet..." -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "Zugriff über:" -ForegroundColor $Colors.Header
    Write-Host "  » Lokal:    https://localhost:7059" -ForegroundColor $Colors.Success
    Write-Host "  » Netzwerk: https://${localIP}:7059" -ForegroundColor $Colors.Success
    Write-Host ""
    Write-Host "QR-Code für mobilen Zugriff:" -ForegroundColor $Colors.Info
    Write-Host "  » Öffnen Sie die Einstellungen in der Anwendung" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "» Drücken Sie STRG+C zum Beenden" -ForegroundColor $Colors.Warning
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
    Write-Host "   DESKTOP-VERKNÜPFUNG ERSTELLEN" -ForegroundColor $Colors.Header
    Write-Host "============================================================" -ForegroundColor $Colors.Header
    Write-Host ""
    
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    $targetScript = $MyInvocation.MyCommand.Path
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    
    # Erstelle zwei Verknüpfungen
    $shortcuts = @(
        @{
            Name = "Einsatzüberwachung (Lokal)"
            File = "Einsatzueberwachung-Lokal.lnk"
            Args = "-ExecutionPolicy Bypass -File `"$targetScript`" -LocalMode"
            Description = "Startet Einsatzüberwachung im lokalen Modus"
        },
        @{
            Name = "Einsatzüberwachung (Netzwerk)"
            File = "Einsatzueberwachung-Netzwerk.lnk"
            Args = "-ExecutionPolicy Bypass -File `"$targetScript`" -NetworkMode"
            Description = "Startet Einsatzüberwachung im Netzwerk-Modus"
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
            
            Write-Host "[✓] Verknüpfung erstellt: $($shortcut.Name)" -ForegroundColor $Colors.Success
        } catch {
            Write-Host "[✗] Fehler beim Erstellen von $($shortcut.Name): $($_.Exception.Message)" -ForegroundColor $Colors.Error
        }
    }
    
    Write-Host ""
    Write-Host "Desktop-Verknüpfungen wurden erstellt!" -ForegroundColor $Colors.Success
    Write-Host "Sie können die Anwendung nun per Doppelklick starten." -ForegroundColor $Colors.Info
    Write-Host ""
}

# ============================================================
# HAUPTPROGRAMM
# ============================================================

Show-Header

# Prüfe .NET Installation
if (-not (Test-DotNetInstallation)) {
    Write-Host ""
    Read-Host "Drücken Sie Enter zum Beenden"
    exit 1
}

Write-Host ""

# Prüfe Parameter für direkten Start
if ($CreateShortcut) {
    New-DesktopShortcut
    Read-Host "Drücken Sie Enter zum Beenden"
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

# Zeige Menü
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
            Read-Host "Drücken Sie Enter um fortzufahren"
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
            Write-Host "[!] Ungültige Auswahl. Bitte wählen Sie 0, 1, 2 oder 3." -ForegroundColor $Colors.Warning
            Start-Sleep -Seconds 2
            Show-Header
            continue
        }
    }
}
