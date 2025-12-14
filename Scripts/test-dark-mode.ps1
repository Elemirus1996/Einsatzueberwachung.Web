# Dark Mode Test & Debug Script
# Testet ob Dark Mode korrekt funktioniert

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DARK MODE TEST & DEBUG SCRIPT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Prüfe ob Bootstrap 5.3+ verwendet wird
Write-Host "TEST 1: Bootstrap Version Check" -ForegroundColor Yellow
$appRazor = Get-Content "Einsatzueberwachung.Web/Components/App.razor" -Raw
if ($appRazor -match "bootstrap@5\.3") {
    Write-Host "? Bootstrap 5.3+ wird verwendet (Dark Mode Support)" -ForegroundColor Green
} else {
    Write-Host "? Bootstrap Version zu alt! Upgrade auf 5.3+ erforderlich" -ForegroundColor Red
}
Write-Host ""

# Test 2: Prüfe ob data-bs-theme Attribut gesetzt ist
Write-Host "TEST 2: HTML data-bs-theme Attribut Check" -ForegroundColor Yellow
if ($appRazor -match 'data-bs-theme="light"') {
    Write-Host "? data-bs-theme Attribut ist gesetzt" -ForegroundColor Green
} else {
    Write-Host "? data-bs-theme Attribut fehlt im HTML-Tag" -ForegroundColor Red
}
Write-Host ""

# Test 3: Prüfe ob Theme-Loader Script existiert
Write-Host "TEST 3: Theme Loader Script Check" -ForegroundColor Yellow
if ($appRazor -match "localStorage\.getItem\('theme'\)") {
    Write-Host "? Theme Loader Script vorhanden" -ForegroundColor Green
} else {
    Write-Host "? Theme Loader Script fehlt" -ForegroundColor Red
}
Write-Host ""

# Test 4: Prüfe ob dark-mode-base.css existiert
Write-Host "TEST 4: Dark Mode Base CSS Check" -ForegroundColor Yellow
if (Test-Path "Einsatzueberwachung.Web/wwwroot/dark-mode-base.css") {
    Write-Host "? dark-mode-base.css existiert" -ForegroundColor Green
    $darkCss = Get-Content "Einsatzueberwachung.Web/wwwroot/dark-mode-base.css" -Raw
    $darkRules = ([regex]::Matches($darkCss, '\[data-bs-theme="dark"\]')).Count
    Write-Host "   ?? Gefunden: $darkRules Dark Mode CSS Regeln" -ForegroundColor Gray
} else {
    Write-Host "? dark-mode-base.css fehlt" -ForegroundColor Red
}
Write-Host ""

# Test 5: Prüfe ob dark-mode-base.css in App.razor eingebunden ist
Write-Host "TEST 5: Dark Mode CSS Integration Check" -ForegroundColor Yellow
if ($appRazor -match "dark-mode-base\.css") {
    Write-Host "? dark-mode-base.css ist in App.razor eingebunden" -ForegroundColor Green
} else {
    Write-Host "? dark-mode-base.css ist NICHT in App.razor eingebunden" -ForegroundColor Red
}
Write-Host ""

# Test 6: Prüfe ob MainLayout Theme lädt
Write-Host "TEST 6: MainLayout Theme Loading Check" -ForegroundColor Yellow
$mainLayout = Get-Content "Einsatzueberwachung.Web/Components/Layout/MainLayout.razor" -Raw
if ($mainLayout -match "LoadAndApplyTheme") {
    Write-Host "? MainLayout lädt Theme beim Start" -ForegroundColor Green
} else {
    Write-Host "? MainLayout lädt kein Theme" -ForegroundColor Red
}
Write-Host ""

# Test 7: Prüfe ob NavMenu Toggle hat
Write-Host "TEST 7: NavMenu Theme Toggle Check" -ForegroundColor Yellow
$navMenu = Get-Content "Einsatzueberwachung.Web/Components/Layout/NavMenu.razor" -Raw
if ($navMenu -match "btn-theme-toggle") {
    Write-Host "? NavMenu hat Theme-Toggle Button" -ForegroundColor Green
} else {
    Write-Host "? NavMenu hat keinen Theme-Toggle Button" -ForegroundColor Red
}
Write-Host ""

# Test 8: Prüfe app.css für Dark Mode Styles
Write-Host "TEST 8: app.css Dark Mode Check" -ForegroundColor Yellow
$appCss = Get-Content "Einsatzueberwachung.Web/wwwroot/app.css" -Raw
$appDarkRules = ([regex]::Matches($appCss, '\[data-bs-theme="dark"\]')).Count
if ($appDarkRules -gt 50) {
    Write-Host "? app.css hat $appDarkRules Dark Mode Regeln" -ForegroundColor Green
} else {
    Write-Host "??  app.css hat nur $appDarkRules Dark Mode Regeln (sollte >50 sein)" -ForegroundColor Yellow
}
Write-Host ""

# Zusammenfassung
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ZUSAMMENFASSUNG" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "?? MANUELLE TEST-SCHRITTE:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Starten Sie die App mit:" -ForegroundColor White
Write-Host "   dotnet run --project Einsatzueberwachung.Web" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Öffnen Sie im Browser die Developer Tools (F12)" -ForegroundColor White
Write-Host ""
Write-Host "3. In der Console sollten Sie sehen:" -ForegroundColor White
Write-Host "   'Theme geladen: light' ODER 'Kein gespeichertes Theme gefunden'" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Testen Sie den Toggle:" -ForegroundColor White
Write-Host "   - Klicken Sie auf das ??/?? Icon oben links" -ForegroundColor Gray
Write-Host "   - Die Seite sollte SOFORT dunkel werden" -ForegroundColor Gray
Write-Host "   - Hintergrund sollte schwarz sein" -ForegroundColor Gray
Write-Host "   - Text sollte weiß/hellgrau sein" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Prüfen Sie in den Developer Tools:" -ForegroundColor White
Write-Host "   - Elements Tab -> <html> Element" -ForegroundColor Gray
Write-Host "   - Sollte haben: data-bs-theme='dark' oder 'light'" -ForegroundColor Gray
Write-Host ""
Write-Host "6. Wenn nichts passiert:" -ForegroundColor White
Write-Host "   - Leeren Sie den Browser-Cache (Ctrl+Shift+Delete)" -ForegroundColor Gray
Write-Host "   - Hard Reload (Ctrl+Shift+R)" -ForegroundColor Gray
Write-Host "   - Prüfen Sie Console auf Fehler" -ForegroundColor Gray
Write-Host ""

Write-Host "?? DEBUGGING BEFEHLE:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Im Browser Console eingeben:" -ForegroundColor White
Write-Host ""
Write-Host "// Aktuelles Theme prüfen" -ForegroundColor Gray
Write-Host "document.documentElement.getAttribute('data-bs-theme')" -ForegroundColor Cyan
Write-Host ""
Write-Host "// Theme manuell auf dark setzen" -ForegroundColor Gray
Write-Host "document.documentElement.setAttribute('data-bs-theme', 'dark')" -ForegroundColor Cyan
Write-Host ""
Write-Host "// Theme manuell auf light setzen" -ForegroundColor Gray
Write-Host "document.documentElement.setAttribute('data-bs-theme', 'light')" -ForegroundColor Cyan
Write-Host ""
Write-Host "// LocalStorage Theme prüfen" -ForegroundColor Gray
Write-Host "localStorage.getItem('theme')" -ForegroundColor Cyan
Write-Host ""
Write-Host "// LocalStorage Theme setzen" -ForegroundColor Gray
Write-Host "localStorage.setItem('theme', 'dark')" -ForegroundColor Cyan
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Script abgeschlossen!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
