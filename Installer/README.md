# Einsatzüberwachung Inno Setup Installer

## Voraussetzungen

1. **Inno Setup 6** installieren:
   - Download: https://jrsoftware.org/isdl.php
   - Während Installation: "Install Inno Setup Preprocessor" auswählen

2. **.NET 8 SDK** (für Benutzer-PCs):
   - Download: https://dotnet.microsoft.com/download/dotnet/8.0

## Installer bauen

### Option 1: Mit Inno Setup IDE

1. Öffne `Installer\Einsatzueberwachung.iss` mit Inno Setup Compiler
2. Klick auf "Compile" (oder F9)
3. Fertig! Die EXE ist in: `Installer\Output\EinsatzueberwachungSetup.exe`

### Option 2: Mit Kommandozeile

```powershell
cd k:\Einsatzueberwachung.Web.Repo\Installer
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" Einsatzueberwachung.iss
```

## Was macht der Installer?

1. **Prüft .NET 8 SDK**
   - Wenn nicht vorhanden: Warnung mit Download-Link
   - Benutzer kann trotzdem installieren

2. **Installiert Dateien**
   - Kopiert alle Projekt-Dateien nach `C:\Program Files\Einsatzueberwachung`
   - Ohne bin/obj Verzeichnisse (werden beim ersten Start gebaut)

3. **Erstellt Verknüpfungen**
   - Desktop-Icon (optional)
   - Startmenü-Eintrag
   - Quick Launch (optional)

4. **Restore NuGet Packages**
   - Läuft automatisch nach Installation

## Verbesserter Starter

Der neue Starter (`Einsatzueberwachung-Starter.ps1`) zeigt:

- **Lokale IP-Adressen** für Netzwerk-Zugriff
- **Auswahl**: Lokal oder Netzwerk-Modus
- **Automatischer Browser-Start**
- **Übersichtliche Anzeige** aller Zugriffs-URLs

### Beispiel-Ausgabe:

```
============================================================
   SERVER GESTARTET!
============================================================

Lokaler Zugriff (auf diesem PC):
  https://localhost:7059

Netzwerk-Zugriff (von anderen Geraeten):
  http://192.168.1.100:5222
  http://10.0.0.5:5222

QR-Code fuer mobilen Zugriff:
  Browser oeffnet automatisch mit QR-Code

============================================================

Zum Beenden druecken Sie STRG+C
```

## Installer-Größe

- **~5-10 MB** (ohne .NET Runtime, nur Projekt-Dateien)
- Viel kleiner als vorher!

## GitHub Release

1. Baue Installer
2. Pushe Code zu GitHub
3. Erstelle Release auf GitHub
4. Lade `EinsatzueberwachungSetup.exe` als Asset hoch

## Vorteile vs. WinForms Installer

✅ **Professioneller** - Etablierter Windows-Standard
✅ **Kleiner** - Nur 5-10 MB statt 147 MB
✅ **Bessere UI** - Moderne Windows-Installer-Oberfläche
✅ **Kein GitHub-Download** - Keine Verbindungsprobleme
✅ **Flexibler** - Einfach anzupassen
✅ **Deinstallation** - Saubere Entfernung über Windows

## Fehlerbehebung

### "Inno Setup Compiler nicht gefunden"
- Installiere Inno Setup 6 von https://jrsoftware.org/isdl.php

### ".NET 8 nicht gefunden" beim Start
- Installiere .NET 8 SDK: https://dotnet.microsoft.com/download/dotnet/8.0

### "Projekt nicht gefunden"
- Stelle sicher, dass alle Dateien korrekt installiert wurden
- Prüfe Pfad: `C:\Program Files\Einsatzueberwachung\`

## Lizenz

Gleiche Lizenz wie Hauptprojekt
