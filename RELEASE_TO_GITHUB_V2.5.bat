@echo off
REM ========================================
REM GitHub Release Helper - Version 2.5.0
REM ========================================

title GitHub Release V2.5.0 - Einsatzueberwachung

echo.
echo ========================================
echo  GITHUB RELEASE V2.5.0
echo  Dark Mode ^& Enhanced Features
echo ========================================
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

REM Status anzeigen
echo ========================================
echo  AKTUELLER STATUS
echo ========================================
echo.
git status --short
echo.

REM Letzte Commits
echo ========================================
echo  LETZTE COMMITS
echo ========================================
echo.
git log --oneline -5
echo.

echo ========================================
echo  RELEASE VORBEREITEN
echo ========================================
echo.
echo Version: 2.5.0
echo Tag: v2.5.0
echo Titel: Dark Mode ^& Enhanced Features
echo.
echo Hauptfeatures:
echo - Dark Mode System mit Theme Toggle
echo - Erweiterte Karten-Funktionen
echo - Enhanced Notes System
echo - Mobile Dashboard Verbesserungen
echo - UI/UX Optimierungen
echo.

set /p confirm="Fortfahren? (j/n): "
if /i not "%confirm%"=="j" goto END

echo.
echo ========================================
echo  SCHRITT 1: ALLE AENDERUNGEN STAGEN
echo ========================================
echo.
git add .
echo [OK] Dateien hinzugefuegt
echo.

echo ========================================
echo  SCHRITT 2: COMMIT ERSTELLEN
echo ========================================
echo.
git commit -m "Release v2.5.0 - Dark Mode & Enhanced Features" -m "- Vollständiger Dark Mode Support mit Theme Toggle" -m "- Erweiterte Karten-Funktionen mit Leaflet.js" -m "- Enhanced Notes System mit Threads" -m "- Mobile Dashboard Verbesserungen" -m "- QuestPDF Integration" -m "- Performance-Optimierungen" -m "- UI/UX Verbesserungen"

if %errorlevel% neq 0 (
    echo [INFO] Keine Aenderungen zum Committen oder Commit fehlgeschlagen
    echo Fortfahren mit Tag-Erstellung...
)

echo.
echo ========================================
echo  SCHRITT 3: TAG ERSTELLEN
echo ========================================
echo.
git tag -a v2.5.0 -m "Version 2.5.0 - Dark Mode & Enhanced Features"

if %errorlevel% equ 0 (
    echo [OK] Tag v2.5.0 erstellt
) else (
    echo [WARNUNG] Tag konnte nicht erstellt werden (existiert evtl. schon)
    set /p deleteTag="Existierenden Tag loeschen? (j/n): "
    if /i "%deleteTag%"=="j" (
        git tag -d v2.5.0
        git tag -a v2.5.0 -m "Version 2.5.0 - Dark Mode & Enhanced Features"
        echo [OK] Tag neu erstellt
    )
)

echo.
echo ========================================
echo  SCHRITT 4: PUSH ZU GITHUB
echo ========================================
echo.
echo Pushe Code und Tags zu GitHub...
echo Repository: https://github.com/Elemirus1996/Einsatzueberwachung.Web
echo.

git push origin main
if %errorlevel% neq 0 (
    echo [FEHLER] Push fehlgeschlagen!
    echo.
    echo Moegliche Gruende:
    echo - Keine Berechtigung
    echo - Merge-Konflikt
    echo - Remote nicht konfiguriert
    echo.
    pause
    goto END
)

echo [OK] Code gepusht
echo.

git push origin v2.5.0
if %errorlevel% neq 0 (
    echo [FEHLER] Tag-Push fehlgeschlagen!
    echo.
    pause
    goto END
)

echo [OK] Tag gepusht
echo.

echo ========================================
echo  SUCCESS! RELEASE VORBEREITET
echo ========================================
echo.
echo Der Code und Tag v2.5.0 wurden auf GitHub gepusht!
echo.
echo NAECHSTE SCHRITTE:
echo.
echo 1. GitHub Repository oeffnen:
echo    https://github.com/Elemirus1996/Einsatzueberwachung.Web
echo.
echo 2. Zu "Releases" navigieren
echo.
echo 3. "Draft a new release" klicken
echo.
echo 4. Tag auswaehlen: v2.5.0
echo.
echo 5. Release-Titel: "Version 2.5.0 - Dark Mode ^& Enhanced Features"
echo.
echo 6. Beschreibung aus RELEASE_V2.5.md kopieren
echo.
echo 7. "Publish release" klicken
echo.
echo Release-Notizen befinden sich in:
echo - RELEASE_V2.5.md
echo - PRE_RELEASE_CHECKLIST_V2.5.md
echo.

set /p openGitHub="GitHub Repository jetzt oeffnen? (j/n): "
if /i "%openGitHub%"=="j" (
    start https://github.com/Elemirus1996/Einsatzueberwachung.Web/releases/new?tag=v2.5.0
)

echo.
echo ========================================
echo  RELEASE INFORMATIONEN
echo ========================================
echo.
echo Version: 2.5.0
echo Tag: v2.5.0
echo Datum: %date%
echo Branch: main
echo.
echo Hauptfeatures:
echo - Dark Mode System
echo - Erweiterte Karten
echo - Enhanced Notes
echo - Mobile Verbesserungen
echo.

:END
echo.
echo ========================================
echo  FERTIG
echo ========================================
echo.
pause
exit /b 0
