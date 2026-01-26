#!/usr/bin/env powershell
# Installer Builder fuer Einsatzueberwachung
# Baut das Installer-Projekt und erstellt eine standalone EXE

param(
    [switch]$Sign,
    [switch]$Upload
)

$ErrorActionPreference = "Stop"

function Write-Header {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "   EINSATZUEBERWACHUNG INSTALLER BUILDER" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Test-DotNet {
    try {
        $version = dotnet --version
        Write-Host "[OK] .NET gefunden: $version" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[ERROR] .NET nicht installiert!" -ForegroundColor Red
        return $false
    }
}

function Build-Installer {
    Write-Host "Baue Installer..." -ForegroundColor Yellow
    
    $installerDir = ".\Einsatzueberwachung.Installer"
    if (!(Test-Path $installerDir)) {
        Write-Host "[ERROR] Installer-Verzeichnis nicht gefunden!" -ForegroundColor Red
        return $false
    }

    $fullInstallerPath = (Resolve-Path $installerDir).Path
    Push-Location $installerDir
    
    try {
        Write-Host "  Cleanup..." -ForegroundColor Gray
        if (Test-Path "bin") { 
            Remove-Item "bin" -Recurse -Force | Out-Null 
        }
        if (Test-Path "obj") { 
            Remove-Item "obj" -Recurse -Force | Out-Null 
        }
        
        Write-Host "  Publish Release..." -ForegroundColor Gray
        $output = dotnet publish "Einsatzueberwachung.Installer.csproj" -c Release -o ".\output" --self-contained 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Build erfolgreich" -ForegroundColor Green
            
            $fullExePath = Join-Path $fullInstallerPath "output\EinsatzueberwachungSetup.exe"
            if (Test-Path $fullExePath) {
                $sizeBytes = (Get-Item $fullExePath).Length
                $sizeMB = [Math]::Round($sizeBytes / 1MB, 2)
                Write-Host "[OK] EXE erstellt: $fullExePath ($sizeMB MB)" -ForegroundColor Green
                return $fullExePath
            }
        }
        else {
            Write-Host "[ERROR] Build fehlgeschlagen!" -ForegroundColor Red
            Write-Host $output
            return $false
        }
    }
    finally {
        Pop-Location
    }
}

function Sign-Installer {
    param([string]$exePath)
    
    if (-not $Sign) {
        Write-Host "  [INFO] Signatur uebersprungen" -ForegroundColor Gray
        return $true
    }
    
    Write-Host "Signiere Installer..." -ForegroundColor Yellow
    Write-Host "[INFO] Code signing nicht implementiert" -ForegroundColor Yellow
    return $true
}

function Test-Installer {
    param([string]$exePath)
    
    Write-Host "Teste Installer..." -ForegroundColor Yellow
    
    if (!(Test-Path $exePath)) {
        Write-Host "[ERROR] EXE nicht gefunden!" -ForegroundColor Red
        return $false
    }
    
    try {
        $fileInfo = Get-Item $exePath
        $sizeMB = [Math]::Round($fileInfo.Length / 1MB, 2)
        Write-Host "[OK] EXE-Datei: $($fileInfo.Name)" -ForegroundColor Green
        Write-Host "[OK] Groesse: $sizeMB MB" -ForegroundColor Green
        Write-Host "[OK] Installer bereit zum Verteilen" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[ERROR] Fehler: $_" -ForegroundColor Red
        return $false
    }
}

function Publish-Installer {
    param([string]$exePath)
    
    if (-not $Upload) {
        Write-Host "  [INFO] Upload uebersprungen" -ForegroundColor Gray
        return $true
    }
    
    Write-Host "Veroeffentliche Installer..." -ForegroundColor Yellow
    Write-Host "  Bitte manuell auf GitHub hochladen:" -ForegroundColor Cyan
    Write-Host "      1. Neue Release erstellen" -ForegroundColor Gray
    Write-Host "      2. Installer als Asset hochladen" -ForegroundColor Gray
    Write-Host "      3. Release Notes schreiben" -ForegroundColor Gray
    Write-Host "  Datei: $exePath" -ForegroundColor Gray
    
    return $true
}

# MAIN
Write-Header

if (!(Test-DotNet)) {
    exit 1
}

$installerPath = Build-Installer
if (-not $installerPath) {
    Write-Host "[ERROR] Build fehlgeschlagen!" -ForegroundColor Red
    exit 1
}

Sign-Installer $installerPath | Out-Null

if (!(Test-Installer $installerPath)) {
    exit 1
}

Publish-Installer $installerPath | Out-Null

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "   BUILD ERFOLGREICH!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Naechste Schritte:" -ForegroundColor Yellow
Write-Host "1. Testen Sie den Installer auf einem sauberen PC" -ForegroundColor Gray
Write-Host "2. Wenn alles ok: Push zu GitHub" -ForegroundColor Gray
Write-Host "3. GitHub Release erstellen und EXE hochladen" -ForegroundColor Gray
Write-Host ""

exit 0
