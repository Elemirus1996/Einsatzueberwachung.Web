@echo off
REM ============================================================
REM Einsatzueberwachung - Batch Starter
REM ============================================================

setlocal enabledelayedexpansion

REM Bestimme das aktuelle Verzeichnis
set "SCRIPT_DIR=%~dp0"

REM Starte das PowerShell-Skript mit Bypass und halte Fenster offen
powershell.exe -NoExit -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Einsatzueberwachung-Starter.ps1" %*
