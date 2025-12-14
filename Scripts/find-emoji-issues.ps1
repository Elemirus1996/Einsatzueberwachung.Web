# PowerShell Script zum Finden und Ersetzen von Emoji-Platzhaltern
# Führe aus: .\find-emoji-issues.ps1

Write-Host "?? Suche nach Emoji-Problemen (??)" -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan

$files = Get-ChildItem -Path "Einsatzueberwachung.Web\Components" -Recurse -Include *.razor

$findings = @()

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $lines = Get-Content $file.FullName
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '\?\?') {
            $findings += [PSCustomObject]@{
                File = $file.Name
                Line = $i + 1
                Content = $lines[$i].Trim()
                FullPath = $file.FullName
            }
        }
    }
}

if ($findings.Count -eq 0) {
    Write-Host "? Keine Probleme gefunden! Alle Emojis wurden ersetzt." -ForegroundColor Green
} else {
    Write-Host "??  Gefundene Probleme: $($findings.Count)`n" -ForegroundColor Yellow
    
    $findings | Group-Object File | ForEach-Object {
        Write-Host "`n?? $($_.Name)" -ForegroundColor Magenta
        Write-Host ("=" * 50) -ForegroundColor DarkGray
        
        $_.Group | ForEach-Object {
            Write-Host "  Zeile $($_.Line): " -NoNewline -ForegroundColor Gray
            Write-Host $_.Content -ForegroundColor White
        }
    }
    
    Write-Host "`n`n?? Zusammenfassung:" -ForegroundColor Cyan
    Write-Host "Betroffene Dateien: $($findings | Select-Object -Unique File | Measure-Object | Select-Object -ExpandProperty Count)"
    Write-Host "Gesamt-Probleme: $($findings.Count)"
    
    Write-Host "`n?? Tipp: Verwende ICON_MIGRATION_GUIDE.md für Icon-Mappings" -ForegroundColor Green
}
