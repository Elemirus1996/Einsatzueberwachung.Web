@echo off
setlocal enabledelayedexpansion

REM ========================================
REM Einsatzueberwachung - Erweiterter Starter
REM ========================================

title Einsatzueberwachung Starter

:MENU
cls
echo.
echo ========================================
echo  EINSATZUEBERWACHUNG - STARTER
echo ========================================
echo.
echo Bitte waehlen Sie eine Option:
echo.
echo [1] Anwendung starten (HTTPS - Empfohlen)
echo [2] Anwendung starten (HTTP)
echo [3] .NET SDK Informationen anzeigen
echo [4] Entwicklungszertifikat installieren
echo [5] Anwendung erstellen (Build)
echo [6] Anwendung veroeffentlichen (Publish)
echo [7] Browser manuell oeffnen
echo [8] Hilfe anzeigen
echo [9] Beenden
echo.
echo ========================================
echo.

set /p choice="Ihre Wahl (1-9): "

if "%choice%"=="1" goto START_HTTPS
if "%choice%"=="2" goto START_HTTP
if "%choice%"=="3" goto INFO
if "%choice%"=="4" goto TRUST_CERT
if "%choice%"=="5" goto BUILD
if "%choice%"=="6" goto PUBLISH
if "%choice%"=="7" goto OPEN_BROWSER
if "%choice%"=="8" goto HELP
if "%choice%"=="9" goto END

echo.
echo [FEHLER] Ungueltige Eingabe!
timeout /t 2 >nul
goto MENU

:START_HTTPS
cls
echo.
echo ========================================
echo  STARTE ANWENDUNG (HTTPS)
echo ========================================
echo.
cd /d "%~dp0Einsatzueberwachung.Web"
echo Anwendung wird gestartet...
echo Browser oeffnet unter: https://localhost:7059
echo.
echo Druecken Sie STRG+C zum Beenden
echo.
dotnet run --launch-profile https
pause
goto MENU

:START_HTTP
cls
echo.
echo ========================================
echo  STARTE ANWENDUNG (HTTP)
echo ========================================
echo.
cd /d "%~dp0Einsatzueberwachung.Web"
echo Anwendung wird gestartet...
echo Browser oeffnet unter: http://localhost:5222
echo.
echo Druecken Sie STRG+C zum Beenden
echo.
dotnet run --launch-profile http
pause
goto MENU

:INFO
cls
echo.
echo ========================================
echo  .NET SDK INFORMATIONEN
echo ========================================
echo.
dotnet --info
echo.
echo ========================================
echo  INSTALLIERTE WORKLOADS
echo ========================================
echo.
dotnet workload list
echo.
pause
goto MENU

:TRUST_CERT
cls
echo.
echo ========================================
echo  ENTWICKLUNGSZERTIFIKAT INSTALLIEREN
echo ========================================
echo.
echo Installiert das HTTPS-Entwicklungszertifikat...
echo Sie werden nach Administratorrechten gefragt.
echo.
dotnet dev-certs https --trust
echo.
if %errorlevel% equ 0 (
    echo [OK] Zertifikat erfolgreich installiert!
) else (
    echo [FEHLER] Zertifikat konnte nicht installiert werden.
)
echo.
pause
goto MENU

:BUILD
cls
echo.
echo ========================================
echo  ANWENDUNG ERSTELLEN
echo ========================================
echo.
cd /d "%~dp0"
echo Erstelle Anwendung...
echo.
dotnet build
echo.
if %errorlevel% equ 0 (
    echo [OK] Build erfolgreich!
) else (
    echo [FEHLER] Build fehlgeschlagen!
)
echo.
pause
goto MENU

:PUBLISH
cls
echo.
echo ========================================
echo  ANWENDUNG VEROEFFENTLICHEN
echo ========================================
echo.
cd /d "%~dp0"
echo Veroeffentliche Anwendung...
echo Zielordner: publish\
echo.
dotnet publish Einsatzueberwachung.Web\Einsatzueberwachung.Web.csproj -c Release -o publish
echo.
if %errorlevel% equ 0 (
    echo [OK] Veroeffentlichung erfolgreich!
    echo Dateien befinden sich in: publish\
) else (
    echo [FEHLER] Veroeffentlichung fehlgeschlagen!
)
echo.
pause
goto MENU

:OPEN_BROWSER
cls
echo.
echo ========================================
echo  BROWSER OEFFNEN
echo ========================================
echo.
echo [1] HTTPS (https://localhost:7059)
echo [2] HTTP (http://localhost:5222)
echo [3] Zurueck
echo.
set /p browserChoice="Ihre Wahl: "

if "%browserChoice%"=="1" (
    start https://localhost:7059
    echo Browser geoeffnet: https://localhost:7059
    timeout /t 2 >nul
    goto MENU
)
if "%browserChoice%"=="2" (
    start http://localhost:5222
    echo Browser geoeffnet: http://localhost:5222
    timeout /t 2 >nul
    goto MENU
)
goto MENU

:HELP
cls
echo.
echo ========================================
echo  HILFE
echo ========================================
echo.
echo SCHNELLSTART:
echo 1. Waehlen Sie Option [1] fuer den normalen Start
echo 2. Die Anwendung startet und oeffnet den Browser
echo 3. Zum Beenden: STRG+C druecken
echo.
echo PROBLEME:
echo - Falls HTTPS nicht funktioniert: Option [4] ausfuehren
echo - Falls Port belegt ist: Option [2] (HTTP) verwenden
echo - Weitere Hilfe: Siehe QUICK_START.md
echo.
echo SYSTEMVORAUSSETZUNGEN:
echo - .NET 8 SDK muss installiert sein
echo - Download: https://dotnet.microsoft.com/download/dotnet/8.0
echo.
echo DOKUMENTATION:
echo - QUICK_START.md - Schnellstartanleitung
echo - DEVELOPER_SETUP.md - Entwicklersetup
echo - README.md - Projektdokumentation
echo.
pause
goto MENU

:END
cls
echo.
echo Auf Wiedersehen!
echo.
timeout /t 1 >nul
exit /b 0
