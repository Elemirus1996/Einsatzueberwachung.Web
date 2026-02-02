#!/usr/bin/env powershell
# ============================================================
# GitHub Release Upload Script
# ============================================================
# Lädt den Installer zur GitHub Release hoch

param(
    [Parameter(Mandatory=$false)]
    [string]$Version = "v3.2",
    
    [Parameter(Mandatory=$false)]
    [string]$InstallerPath = "..\Installer\Output\EinsatzueberwachungSetup.exe",
    
    [Parameter(Mandatory=$false)]
    [string]$Token
)

$ErrorActionPreference = "Stop"

$owner = "Elemirus1996"
$repo = "Einsatzueberwachung.Web"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "   GITHUB RELEASE UPLOAD" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Token prüfen
if ([string]::IsNullOrEmpty($Token)) {
    Write-Host "Bitte öffnen Sie https://github.com/settings/tokens und erstellen Sie einen Personal Access Token mit 'repo' Berechtigung." -ForegroundColor Yellow
    Write-Host ""
    $Token = Read-Host "Geben Sie Ihr GitHub Personal Access Token ein"
}

# Datei prüfen
$fullPath = Resolve-Path $InstallerPath -ErrorAction Stop
$fileInfo = Get-Item $fullPath
$sizeMB = [Math]::Round($fileInfo.Length / 1MB, 2)

Write-Host "[INFO] Datei: $($fileInfo.Name)" -ForegroundColor Cyan
Write-Host "[INFO] Groesse: $sizeMB MB" -ForegroundColor Cyan
Write-Host ""

# Release ID holen
Write-Host "[INFO] Hole Release-Informationen..." -ForegroundColor Gray
$headers = @{
    "Authorization" = "Bearer $Token"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

try {
    $releaseUrl = "https://api.github.com/repos/$owner/$repo/releases/tags/$Version"
    $release = Invoke-RestMethod -Uri $releaseUrl -Headers $headers -Method Get
    Write-Host "[OK] Release gefunden: $($release.name)" -ForegroundColor Green
    Write-Host "[INFO] Release ID: $($release.id)" -ForegroundColor Gray
}
catch {
    Write-Host "[ERROR] Release $Version nicht gefunden!" -ForegroundColor Red
    Write-Host "Bitte erstellen Sie zuerst die Release auf GitHub:" -ForegroundColor Yellow
    Write-Host "https://github.com/$owner/$repo/releases/new?tag=$Version" -ForegroundColor Cyan
    exit 1
}

# Asset hochladen
Write-Host ""
Write-Host "[INFO] Lade Installer hoch..." -ForegroundColor Yellow

$uploadUrl = $release.upload_url -replace '\{\?name,label\}', "?name=$($fileInfo.Name)"

try {
    $fileBytes = [System.IO.File]::ReadAllBytes($fullPath)
    
    $uploadHeaders = @{
        "Authorization" = "Bearer $Token"
        "Content-Type" = "application/octet-stream"
        "Accept" = "application/vnd.github+json"
    }
    
    $asset = Invoke-RestMethod -Uri $uploadUrl -Headers $uploadHeaders -Method Post -Body $fileBytes
    
    Write-Host "[OK] Upload erfolgreich!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Download-URL:" -ForegroundColor Cyan
    Write-Host $asset.browser_download_url -ForegroundColor White
    Write-Host ""
    Write-Host "Release-Seite:" -ForegroundColor Cyan
    Write-Host "https://github.com/$owner/$repo/releases/tag/$Version" -ForegroundColor White
    Write-Host ""
}
catch {
    Write-Host "[ERROR] Upload fehlgeschlagen: $_" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host "============================================================" -ForegroundColor Green
Write-Host "   UPLOAD ABGESCHLOSSEN!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
