# Automatisches Ersetzen von häufigen Emoji-Problemen
# BACKUP ERSTELLEN VOR AUSFÜHRUNG!

$replacements = @{
    # Häufige Patterns
    '>?? ' = '><i class="bi bi-'
    '??</' = '</i></'
    
    # Spezifische Icons
    '?? Team-Verwaltung' = '<i class="bi bi-people-fill"></i> Team-Verwaltung'
    '?? Einsatzüberwachung' = '<i class="bi bi-alarm-fill"></i> Einsatzüberwachung'
    '?? Einstellungen' = '<i class="bi bi-gear-fill"></i> Einstellungen'
    '?? Karte' = '<i class="bi bi-map-fill"></i> Karte'
    '?? Suchgebiete' = '<i class="bi bi-geo-alt-fill"></i> Suchgebiete'
    '?? Neues Team' = '<i class="bi bi-plus-circle-fill"></i> Neues Team'
    '?? Bearbeiten' = '<i class="bi bi-pencil-fill"></i> Bearbeiten'
    '??? Löschen' = '<i class="bi bi-trash-fill"></i> Löschen'
    '?? Speichern' = '<i class="bi bi-save-fill"></i> Speichern'
    '?? Hunde-Team' = '<i class="bi bi-heart-fill"></i> Hunde-Team'
    '?? Drohnen-Team' = '<i class="bi bi-triangle-fill"></i> Drohnen-Team'
    '??? Support-Team' = '<i class="bi bi-tools"></i> Support-Team'
    '?? Drohne' = '<i class="bi bi-triangle-fill"></i> Drohne'
    '?? Personal' = '<i class="bi bi-people-fill"></i> Personal'
    '?? Hunde' = '<i class="bi bi-heart-fill"></i> Hunde'
    '??? Support' = '<i class="bi bi-tools"></i> Support'
    '??' = '' # Entferne einfache ??
    '???' = '' # Entferne dreifache ?
}

Write-Host "?? Starte automatische Emoji-Ersetzung..." -ForegroundColor Cyan
Write-Host "??  Stelle sicher, dass ein Backup existiert!`n" -ForegroundColor Yellow

$files = Get-ChildItem -Path "Einsatzueberwachung.Web\Components\Pages" -Filter "*.razor"

$totalReplacements = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileReplacements = 0
    
    foreach ($pattern in $replacements.Keys) {
        $replacement = $replacements[$pattern]
        if ($content -match [regex]::Escape($pattern)) {
            $content = $content -replace [regex]::Escape($pattern), $replacement
            $fileReplacements++
        }
    }
    
    if ($fileReplacements -gt 0) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "? $($file.Name): $fileReplacements Ersetzungen" -ForegroundColor Green
        $totalReplacements += $fileReplacements
    }
}

Write-Host "`n?? Fertig! Gesamt: $totalReplacements Ersetzungen" -ForegroundColor Green
Write-Host "?? Prüfe mit: dotnet build" -ForegroundColor Cyan
