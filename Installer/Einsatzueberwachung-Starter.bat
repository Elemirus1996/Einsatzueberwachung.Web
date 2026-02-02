@echo off
REM ============================================================
REM Einsatzueberwachung - Batch Starter
REM ============================================================

setlocal enabledelayedexpansion

REM Bestimme das aktuelle Verzeichnis
set "SCRIPT_DIR=%~dp0"

REM Starte das PowerShell-Skript mit Bypass
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Einsatzueberwachung-Starter.ps1" %*

exit /b %errorlevel%
