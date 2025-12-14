@echo off
REM ========================================
REM GitHub Push Helper
REM ========================================

title GitHub Push - Einsatzueberwachung

echo.
echo ========================================
echo  GITHUB PUSH HELPER
echo ========================================
echo.
echo Repository: Elemirus1996/Einsatzueberwachung.Web
echo.

REM Git pruefen
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [FEHLER] Git ist nicht installiert!
    echo.
    echo Bitte installieren Sie Git von:
    echo https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo [OK] Git gefunden
echo.

REM Status zeigen
echo ========================================
echo  AKTUELLER GIT STATUS
echo ========================================
echo.
git status
echo.

echo ========================================
echo  NAECHSTE SCHRITTE
echo ========================================
echo.
echo [1] Alle neuen Dateien hinzufuegen
echo [2] Commit erstellen
echo [3] Auf GitHub pushen
echo [4] Status pruefen
echo [5] Abbrechen
echo.

set /p choice="Ihre Wahl (1-5): "

if "%choice%"=="1" goto ADD_FILES
if "%choice%"=="2" goto COMMIT
if "%choice%"=="3" goto PUSH
if "%choice%"=="4" goto STATUS
if "%choice%"=="5" goto END

:ADD_FILES
echo.
echo Fuege alle Dateien hinzu...
git add .
echo.
echo [OK] Dateien hinzugefuegt
echo.
git status
echo.
pause
goto END

:COMMIT
echo.
echo ========================================
echo  COMMIT ERSTELLEN
echo ========================================
echo.
echo Standard-Commit-Message:
echo "Add desktop shortcuts and comprehensive documentation"
echo.
set /p custom="Eigene Message? (Enter fuer Standard): "

if "%custom%"=="" (
    git commit -m "Add desktop shortcuts and comprehensive documentation" -m "- Added 5 different starter scripts for Windows" -m "- Complete German documentation for end users" -m "- Quick start guide with desktop shortcut creation" -m "- Developer setup guide" -m "- Visual guides and troubleshooting" -m "- .gitignore for .NET projects" -m "- Ready for one-click deployment from GitHub"
) else (
    git commit -m "%custom%"
)

echo.
echo [OK] Commit erstellt
echo.
pause
goto END

:PUSH
echo.
echo ========================================
echo  PUSH ZU GITHUB
echo ========================================
echo.
echo Repository: https://github.com/Elemirus1996/Einsatzueberwachung.Web
echo Branch: main
echo.
echo Druecken Sie ENTER zum Fortfahren oder STRG+C zum Abbrechen...
pause >nul

echo.
echo Pushe zu GitHub...
git push origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo  SUCCESS!
    echo ========================================
    echo.
    echo Dateien erfolgreich auf GitHub gepusht!
    echo.
    echo Repository: https://github.com/Elemirus1996/Einsatzueberwachung.Web
    echo.
    echo Naechste Schritte:
    echo 1. Besuchen Sie Ihr Repository auf GitHub
    echo 2. Pruefen Sie ob alle Dateien vorhanden sind
    echo 3. Erstellen Sie optional einen Release (v2.1.0)
    echo 4. Aktualisieren Sie die About-Section
    echo.
) else (
    echo.
    echo [FEHLER] Push fehlgeschlagen!
    echo.
    echo Moegliche Gruende:
    echo - Keine Berechtigung (Authentifizierung?)
    echo - Remote nicht konfiguriert
    echo - Merge-Konflikt
    echo.
    echo Versuchen Sie:
    echo git remote -v
    echo git pull origin main
    echo.
)

pause
goto END

:STATUS
echo.
echo ========================================
echo  GIT STATUS & INFO
echo ========================================
echo.
echo --- Status ---
git status
echo.
echo --- Remote ---
git remote -v
echo.
echo --- Letzter Commit ---
git log -1 --oneline
echo.
echo --- Branch ---
git branch
echo.
pause
goto END

:END
echo.
exit /b 0
