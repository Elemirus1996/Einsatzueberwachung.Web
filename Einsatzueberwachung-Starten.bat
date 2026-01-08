@echo off
REM ============================================================
REM Einsatzüberwachung - Starter (Batch)
REM ============================================================
REM Diese Datei startet das PowerShell-Skript mit allen nötigen Einstellungen
REM ============================================================

setlocal enabledelayedexpansion

REM Bestimme das aktuelle Verzeichnis
set "SCRIPT_DIR=%~dp0"

REM Starte das PowerShell-Skript mit Bypass für ExecutionPolicy
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Einsatzueberwachung-Starten.ps1" %*

exit /b %errorlevel%
