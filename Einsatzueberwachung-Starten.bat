@echo off
REM ============================================================
REM Einsatzüberwachung - Starter (Batch)
REM ============================================================
REM Diese Datei startet das PowerShell-Skript mit allen nötigen Einstellungen
REM ============================================================

setlocal enabledelayedexpansion

REM Bestimme das aktuelle Verzeichnis
set "SCRIPT_DIR=%~dp0"

REM Version aus dem PowerShell-Starter lesen (Single Source of Truth)
set "STARTER_VERSION=unbekannt"
for /f %%V in ('powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$path = Join-Path ''%SCRIPT_DIR%'' ''Einsatzueberwachung-Starten.ps1''; $content = Get-Content -LiteralPath $path -Raw; if ($content -match '\$script:CurrentVersion\s*=\s*\"([^\"]+)\"') { $matches[1] } else { ''unbekannt'' }"') do set "STARTER_VERSION=%%V"

echo ============================================================
echo   Einsatzueberwachung Starter v%STARTER_VERSION%
echo   Startet: Einsatzueberwachung-Starten.ps1
echo ============================================================
echo.

REM Starte das PowerShell-Skript mit Bypass für ExecutionPolicy
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Einsatzueberwachung-Starten.ps1" %*

exit /b %errorlevel%
