# ========================================
# Desktop-Shortcut Creator für Einsatzüberwachung
# ========================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Desktop-Shortcut Creator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Aktuelles Verzeichnis
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$targetPath = Join-Path $scriptPath "START_EINSATZUEBERWACHUNG.bat"

# Desktop-Pfad
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "Einsatzueberwachung.lnk"

# Prüfe ob BAT-Datei existiert
if (-not (Test-Path $targetPath)) {
    Write-Host "[FEHLER] START_EINSATZUEBERWACHUNG.bat nicht gefunden!" -ForegroundColor Red
    Write-Host "Pfad: $targetPath" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Druecken Sie Enter zum Beenden"
    exit 1
}

Write-Host "Erstelle Desktop-Shortcut..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Ziel: $targetPath" -ForegroundColor Gray
Write-Host "Desktop: $shortcutPath" -ForegroundColor Gray
Write-Host ""

try {
    # Erstelle Shortcut
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $targetPath
    $Shortcut.WorkingDirectory = $scriptPath
    $Shortcut.Description = "Einsatzueberwachung - Schnellstart"
    
    # Optional: Icon setzen (falls vorhanden)
    $iconPath = Join-Path $scriptPath "einsatz-icon.ico"
    if (Test-Path $iconPath) {
        $Shortcut.IconLocation = $iconPath
        Write-Host "[INFO] Icon gefunden und gesetzt" -ForegroundColor Green
    } else {
        Write-Host "[INFO] Kein Icon gefunden (einsatz-icon.ico)" -ForegroundColor Yellow
        Write-Host "       Standard-Icon wird verwendet" -ForegroundColor Yellow
    }
    
    $Shortcut.Save()
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " SUCCESS!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Desktop-Shortcut wurde erstellt:" -ForegroundColor Green
    Write-Host "$shortcutPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Sie koennen nun die Anwendung direkt vom Desktop starten!" -ForegroundColor Cyan
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "[FEHLER] Shortcut konnte nicht erstellt werden:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
}

Write-Host ""
Write-Host "Moechten Sie einen weiteren Shortcut erstellen?" -ForegroundColor Yellow
Write-Host ""
Write-Host "[1] HTTP-Version (START_HTTP.bat)" -ForegroundColor White
Write-Host "[2] Menu-Version (STARTER_MENU.bat)" -ForegroundColor White
Write-Host "[3] Nein, fertig" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Ihre Wahl (1-3)"

switch ($choice) {
    "1" {
        $targetPath2 = Join-Path $scriptPath "START_HTTP.bat"
        $shortcutPath2 = Join-Path $desktopPath "Einsatzueberwachung (HTTP).lnk"
        
        if (Test-Path $targetPath2) {
            $Shortcut2 = $WScriptShell.CreateShortcut($shortcutPath2)
            $Shortcut2.TargetPath = $targetPath2
            $Shortcut2.WorkingDirectory = $scriptPath
            $Shortcut2.Description = "Einsatzueberwachung - HTTP Start"
            $Shortcut2.Save()
            
            Write-Host ""
            Write-Host "[OK] HTTP-Shortcut erstellt!" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "[FEHLER] START_HTTP.bat nicht gefunden!" -ForegroundColor Red
        }
    }
    "2" {
        $targetPath3 = Join-Path $scriptPath "STARTER_MENU.bat"
        $shortcutPath3 = Join-Path $desktopPath "Einsatzueberwachung (Menu).lnk"
        
        if (Test-Path $targetPath3) {
            $Shortcut3 = $WScriptShell.CreateShortcut($shortcutPath3)
            $Shortcut3.TargetPath = $targetPath3
            $Shortcut3.WorkingDirectory = $scriptPath
            $Shortcut3.Description = "Einsatzueberwachung - Starter Menu"
            $Shortcut3.Save()
            
            Write-Host ""
            Write-Host "[OK] Menu-Shortcut erstellt!" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "[FEHLER] STARTER_MENU.bat nicht gefunden!" -ForegroundColor Red
        }
    }
    default {
        Write-Host ""
        Write-Host "Fertig!" -ForegroundColor Green
    }
}

Write-Host ""
Read-Host "Druecken Sie Enter zum Beenden"
