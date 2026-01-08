# Repariert kaputte Umlaute in allen Projektdateien
$ErrorActionPreference = "Stop"

# Mapping von kaputten Zeichen zu korrekten Umlauten
$fixes = @{
    'fü¿½gen' = 'fügen'
    'wü¿½hlen' = 'wählen'
    'Hundefü¿½hrer' = 'Hundeführer'
    'ü¿½BUNG' = 'ÜBUNG'
    'fü¿½r' = 'für'
    'Straü¿½e' = 'Straße'
    'ü¿½nderung' = 'Änderung'
    'hinzufü¿½gen' = 'hinzufügen'
    'Lü¿½schen' = 'Löschen'
    'lü¿½schen' = 'löschen'
    'gelü¿½scht' = 'gelöscht'
    'Funksprü¿½che' = 'Funksprüche'
    'Hinzufü¿½gen' = 'Hinzufügen'
    'Fü¿½ge' = 'Füge'
    'hinzugefü¿½gt' = 'hinzugefügt'
    'Zurü¿½ck' = 'Zurück'
    'Straü¿½enkarte' = 'Straßenkarte'
    'Gesamtflü¿½che' = 'Gesamtfläche'
    'Flü¿½che' = 'Fläche'
    'Berechnete Flü¿½che' = 'Berechnete Fläche'
    'kü¿½nnen' = 'können'
    'Prü¿½fe' = 'Prüfe'
    'gewü¿½nschten' = 'gewünschten'
    'ü¿½ ' = '• '
    'verschieben' = 'verschieben'
}

$files = Get-ChildItem -Path "K:\Einsatzueberwachung.Web.Repo" -Include "*.razor","*.cs","*.js" -Recurse | 
    Where-Object { $_.FullName -notlike "*\obj\*" -and $_.FullName -notlike "*\bin\*" }

$fixed = 0
$filesFixed = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $original = $content
    $fileChanged = $false
    
    foreach ($broken in $fixes.Keys) {
        if ($content.Contains($broken)) {
            $content = $content.Replace($broken, $fixes[$broken])
            $fileChanged = $true
            $fixed++
        }
    }
    
    if ($fileChanged) {
        # Als UTF-8 mit BOM speichern
        $utf8 = New-Object System.Text.UTF8Encoding $true
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8)
        $filesFixed++
        Write-Host "✓ $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "$filesFixed Dateien repariert" -ForegroundColor Green
Write-Host "$fixed Ersetzungen durchgeführt" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
