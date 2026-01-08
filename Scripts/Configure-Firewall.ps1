# PowerShell Script zum Erstellen einer Firewall-Regel für Netzwerk-Zugriff
# Muss als Administrator ausgeführt werden!

Write-Host "???????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host " Einsatzüberwachung - Firewall-Konfiguration" -ForegroundColor Cyan
Write-Host "???????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host ""

# Prüfe Administrator-Rechte
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[FEHLER] Dieses Script muss als Administrator ausgeführt werden!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Rechtsklick auf die Datei ? 'Als Administrator ausführen'" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host "[OK] Administrator-Rechte vorhanden" -ForegroundColor Green
Write-Host ""

# Prüfe ob Regeln bereits existieren
$existingRuleHTTP = Get-NetFirewallRule -DisplayName "Einsatzueberwachung HTTP" -ErrorAction SilentlyContinue
$existingRuleHTTPS = Get-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS" -ErrorAction SilentlyContinue

if ($existingRuleHTTP) {
    Write-Host "[INFO] Firewall-Regel 'Einsatzueberwachung HTTP' existiert bereits" -ForegroundColor Yellow
    $remove = Read-Host "Möchten Sie die Regel neu erstellen? (j/n)"
    if ($remove -eq "j") {
        Remove-NetFirewallRule -DisplayName "Einsatzueberwachung HTTP"
        Write-Host "[OK] Alte Regel entfernt" -ForegroundColor Green
    }
}

if ($existingRuleHTTPS) {
    Write-Host "[INFO] Firewall-Regel 'Einsatzueberwachung HTTPS' existiert bereits" -ForegroundColor Yellow
    $remove = Read-Host "Möchten Sie die Regel neu erstellen? (j/n)"
    if ($remove -eq "j") {
        Remove-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS"
        Write-Host "[OK] Alte Regel entfernt" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Erstelle Firewall-Regeln..." -ForegroundColor Cyan

try {
    # HTTP Regel (Port 5000)
    if (-not $existingRuleHTTP) {
        New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTP" `
            -Direction Inbound `
            -LocalPort 5000 `
            -Protocol TCP `
            -Action Allow `
            -Profile Domain,Private,Public `
            -Description "Erlaubt HTTP-Zugriff auf Einsatzüberwachung im Netzwerk (Port 5000)"
        
        Write-Host "[?] HTTP Firewall-Regel erstellt (Port 5000)" -ForegroundColor Green
    }

    # HTTPS Regel (Port 5001)
    if (-not $existingRuleHTTPS) {
        New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS" `
            -Direction Inbound `
            -LocalPort 5001 `
            -Protocol TCP `
            -Action Allow `
            -Profile Domain,Private,Public `
            -Description "Erlaubt HTTPS-Zugriff auf Einsatzüberwachung im Netzwerk (Port 5001)"
        
        Write-Host "[?] HTTPS Firewall-Regel erstellt (Port 5001)" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "???????????????????????????????????????????????????????" -ForegroundColor Green
    Write-Host " Firewall-Konfiguration erfolgreich abgeschlossen!" -ForegroundColor Green
    Write-Host "???????????????????????????????????????????????????????" -ForegroundColor Green
    Write-Host ""
    Write-Host "Der Server ist jetzt im Netzwerk erreichbar unter:" -ForegroundColor Cyan
    Write-Host "  http://[IHRE-IP]:5000" -ForegroundColor White
    Write-Host "  https://[IHRE-IP]:5001" -ForegroundColor White
    Write-Host ""
    Write-Host "QR-Code für mobile Geräte:" -ForegroundColor Cyan
    Write-Host "  http://[IHRE-IP]:5000/mobile/connect" -ForegroundColor White
    Write-Host ""

    # Zeige lokale IP-Adressen
    Write-Host "Ihre lokalen IP-Adressen:" -ForegroundColor Cyan
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" } | ForEach-Object {
        Write-Host "  $($_.IPAddress)" -ForegroundColor Yellow
    }
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "[FEHLER] Fehler beim Erstellen der Firewall-Regeln:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
}

Write-Host "Drücken Sie eine beliebige Taste zum Beenden..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
