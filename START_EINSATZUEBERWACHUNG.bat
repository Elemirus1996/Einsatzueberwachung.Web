@echo off
REM ========================================
REM Einsatzueberwachung - Schnellstart
REM ========================================

title Einsatzueberwachung wird gestartet...

echo.
echo ========================================
echo  Einsatzueberwachung - Schnellstart
echo ========================================
echo.

REM Pruefe ob .NET 8 installiert ist
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [FEHLER] .NET 8 SDK ist nicht installiert!
    echo.
    echo Bitte installieren Sie .NET 8 SDK von:
    echo https://dotnet.microsoft.com/download/dotnet/8.0
    echo.
    pause
    exit /b 1
)

echo [OK] .NET SDK gefunden
echo.

REM Wechsle ins Projektverzeichnis
cd /d "%~dp0Einsatzueberwachung.Web"

echo Starte Anwendung...
echo Browser oeffnet automatisch unter: https://localhost:7059
echo.
echo ========================================
echo  Druecken Sie STRG+C zum Beenden
echo ========================================
echo.

REM Starte die Anwendung
dotnet run --launch-profile https

pause
