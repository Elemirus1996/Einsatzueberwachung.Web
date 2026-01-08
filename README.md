# Einsatzüberwachung Web

**Version 2.5.0** - Moderne, touch-optimierte Web-Anwendung für die Koordination und Überwachung von Rettungshunde-Einsätzen mit Dark Mode Support.

## ?? Features

### ? NEU in v2.5.0

- **?? Dark Mode System**
  - Vollständiger Dark Mode für alle Komponenten
  - Theme Toggle in Navigation (??/?? Icon)
  - Persistente Theme-Einstellungen via localStorage
  - Cross-Tab Synchronisation - Theme wird in allen offenen Tabs synchronisiert
  - Bootstrap 5.3+ Integration mit data-bs-theme Attribut

- **??? Erweiterte Karten-Funktionen**
  - Leaflet.js Integration mit interaktiven Karten
  - Suchgebiete als Polygone zeichnen
  - Marker setzen und beschriften
  - Farben und Beschreibungen für Gebiete
  - Teams zu Gebieten zuweisen
  - Druck-Funktion mit Legende
  - Dark Mode Support für Karten

- **?? Enhanced Notes System**
  - Globale Notizen mit erweiterter Funktionalität
  - Team-spezifische Notizen
  - Notiz-Historie mit vollständigem Zeitstempel
  - Antworten-System (Threads)
  - Verschiedene Notiz-Typen (Manual, System, Warnings)
  - Dark Mode optimiert

- **?? PDF-Export mit QuestPDF**
  - Professionelle Einsatzberichte als PDF
  - Vollständiges Layout mit Styling
  - Logo und Staffel-Informationen
  - Alle Einsatzdaten strukturiert
  - Sofort druckbar

### ? Implementiert

- **?? Mobile Dashboard**
  - Mobile-optimierte Ansicht für Einsatzkräfte
  - ?? Echtzeit-Updates via SignalR
  - ?? Live Team-Übersicht mit Timer-Status
  - ?? Chronologische Notizen und Funksprüche
  - ?? PIN-geschützter Zugang (Standard: 1234)
  - ?? QR-Code für schnelle Verbindung
  - ?? Auto-Reconnect bei Verbindungsabbruch
  - ?? Dark Mode Support

- **Einsatz-Workflow**
  - Einsatz starten mit vollständigen Basisdaten
  - Team-Verwaltung (Hunde-Teams, Drohnen-Teams, Support-Teams)
  - Live-Einsatzmonitor mit Team-Timern
  - Automatische Warnungen bei Einsatzzeit-Limits
  - Funksprüche und Notizen dokumentieren
  - Suchgebiete verwalten
  - Einsatzbericht exportieren (TXT-Format)

- **Stammdaten**
  - Personal-Verwaltung mit Qualifikationen/Rollen
  - Hunde-Verwaltung mit Ausbildungen/Spezialisierungen
  - Aktiv/Inaktiv-Status für Personal und Hunde

- **Einstellungen**
  - Staffel-Informationen (Name, Adresse, Kontaktdaten, Logo)
  - Hell-/Dunkelmodus
  - Timer-Warnzeiten konfigurierbar
  - Update-Einstellungen

- **UI/UX**
  - Touch-optimierte Oberfläche (min. 48px Buttons)
  - Responsive Design für Tablets und Desktop
  - Material Design-inspirierte Farbcodes
  - Emoji-Icons für schnelle visuelle Orientierung
  - ?? Dark Mode mit Theme Toggle
  - ?? Toast-Benachrichtigungen
  - ?? Audio-Alerts für Warnungen

### ?? Geplant / In Entwicklung

- **GPS-Integration**
  - Live-Tracking für Teams
  - GPS-Koordinaten für ELW-Position
  - Wegpunkte und Routen

- **Datenbank/Persistence**
  - Optional: Entity Framework Core + SQLite
  - Historie vergangener Einsätze
  - Statistiken und Auswertungen

- **Erweiterte Features**
  - Druckansicht für Funkspruch-Logs
  - Export als Excel/CSV
  - Benachrichtigungen bei kritischen Warnungen
  - Multi-User-Support (optional)

## ??? Architektur

```
Einsatzueberwachung.Web/
??? Einsatzueberwachung.Domain/        # Domain-Models, Services, Interfaces
?   ??? Models/                         # Fachmodelle (Team, EinsatzData, etc.)
?   ??? Models/Enums/                   # Enumerations mit Extension-Methods
?   ??? Interfaces/                     # Service-Interfaces
?   ??? Services/                       # Implementierungen (MasterData, Einsatz, PDF, Settings)
?
??? Einsatzueberwachung.Web/           # Blazor Server (Haupt-Projekt)
?   ??? Components/
?   ?   ??? Layout/                     # MainLayout, NavMenu
?   ?   ??? Pages/                      # Razor-Seiten
?   ?       ??? Home.razor              # Dashboard
?   ?       ??? EinsatzStart.razor      # Einsatz starten
?   ?       ??? EinsatzTeams.razor      # Team-Verwaltung
?   ?       ??? EinsatzMonitor.razor    # Live-Monitor mit Timern
?   ?       ??? EinsatzKarte.razor      # Kartenansicht & Suchgebiete
?   ?       ??? EinsatzBericht.razor    # Bericht & Export
?   ?       ??? Stammdaten.razor        # Personal & Hunde
?   ?       ??? Einstellungen.razor     # App-Konfiguration
?   ??? wwwroot/
?   ?   ??? app.css                     # Touch-optimiertes CSS
?   ??? Program.cs                      # DI-Konfiguration
?
??? Einsatzueberwachung.Web.Client/    # WebAssembly (optional)
```

## ?? Design-Prinzipien

1. **Touch First**: Alle interaktiven Elemente mindestens 48x48px
2. **Klarheit**: Große Schrift, klare Hierarchie, Emoji-Icons
3. **Responsive**: Funktioniert auf Tablets (Haupt-Ziel) und Desktop
4. **Dark Mode**: Unterstützt Hell-/Dunkel-Modus
5. **Fachliche Nähe zur WPF-App**: Gleiche Begriffe, gleiche Workflows

## ?? Technologie-Stack

- **.NET 8** - Framework
- **Blazor Server** - Interactive Server Components
- **Bootstrap 5.3+** - CSS-Framework mit Dark Mode Support
- **SignalR** - Echtzeit-Kommunikation für Mobile Dashboard
- **JWT Authentication** - Sichere API-Authentifizierung
- **QRCoder** - QR-Code Generierung für mobile Verbindung
- **QuestPDF** - Professionelle PDF-Einsatzberichte
- **Leaflet.js** - Interaktive Karten mit Zeichnen-Tools
- **Bootstrap Icons** - Icon-System
- **JSON-basierte Persistenz** - SessionData, Settings (aktuell)

## ?? Fachlicher Kontext

Die Anwendung stammt aus dem Umfeld von Rettungshundestaffeln:

- **Teams** bestehen aus:
  - Hund + Hundeführer + Helfer
  - oder Drohnenpilot + Helfer
  - oder Support-Personal

- **Ausbildungen der Hunde**:
  - Fläche, Trümmer, Mantrailer, Wasserortung, Lawine, Gelände, Leichensuche, In Ausbildung

- **Qualifikationen des Personals**:
  - Hundeführer, Helfer, Führungsassistent, Gruppenführer, Zugführer, Verbandsführer, Drohnenpilot, Einsatzleiter

- **Timer-Warnungen**:
  - Erste Warnung (Standard: 45 Min)
  - Zweite Warnung (Standard: 60 Min)

## ?? Installation & Start

### Voraussetzungen
- .NET 8 SDK
- Visual Studio 2022 oder VS Code mit C# Extension

### Projekt starten

#### Nur lokaler Zugriff:
```bash
cd Einsatzueberwachung.Web
dotnet run
```

Oder in Visual Studio:
- Lösung öffnen
- `Einsatzueberwachung.Web` als Startprojekt festlegen
- F5 drücken

#### Mit Netzwerk-Zugriff (für Mobile Dashboard):

**Option 1: Batch-Script**
```batch
START_NETWORK_SERVER.bat
```

**Option 2: PowerShell**
```powershell
.\Scripts\Configure-Firewall.ps1
cd Einsatzueberwachung.Web
dotnet run --urls "http://0.0.0.0:5000"
```

Dann:
1. Im Browser zu `/mobile/connect` navigieren
2. QR-Code mit Smartphone scannen
3. PIN eingeben (Standard: 1234)
4. Mobile Dashboard nutzen

**Siehe auch:** `MOBILE_QUICK_START.md` für detaillierte Anleitung

## ?? Daten-Speicherort

Aktuell werden alle Daten als JSON-Dateien gespeichert:

```
%APPDATA%/Einsatzueberwachung.Web/
??? SessionData.json        # Personal & Hunde
??? StaffelSettings.json    # Staffel-Infos
??? AppSettings.json        # App-Einstellungen
```

Berichte werden exportiert nach:

```
%USERPROFILE%/Documents/Einsatzueberwachung/Berichte/
```

## ?? Navigation

- **/** - Home/Dashboard
- **/einsatz/start** - Neuen Einsatz starten
- **/einsatz/teams** - Teams zusammenstellen (deprecated, integriert in Monitor)
- **/einsatz/monitor** - Live-Überwachung mit Team-Verwaltung
- **/einsatz/karte** - Karte & Suchgebiete (Leaflet.js mit Zeichnen-Tools)
- **/einsatz/bericht** - Bericht & Export (PDF mit QuestPDF)
- **/stammdaten** - Personal & Hunde verwalten
- **/einstellungen** - Konfiguration & Theme-Einstellungen
- **/mobile** - Mobile Dashboard für Einsatzkräfte
- **/mobile/connect** - QR-Code und Verbindungsinfos

## ?? Dark Mode

**Neu in v2.5.0:** Vollständiger Dark Mode Support!

### Verwendung
- **Theme Toggle** in der Navigation (??/?? Icon)
- **Persistente Speicherung** - Theme wird bei jedem Start geladen
- **Cross-Tab Sync** - Änderungen werden in allen offenen Tabs übernommen

### Dokumentation
- **Quick Start:** `DARK_MODE_QUICKSTART.md`
- **Visual Guide:** `DARK_MODE_VISUAL_SUMMARY.md`
- **Implementation:** `DARK_MODE_IMPLEMENTATION.md`
- **Theme Sync:** `THEME_SYNC_SYSTEM.md`

## ??? Karten-Features

**Neu in v2.5.0:** Erweiterte Karten-Funktionen!

### Features
- **Leaflet.js** Integration
- **Zeichnen-Tools** für Polygone und Marker
- **Suchgebiete** mit Farben und Beschreibungen
- **Team-Zuweisung** zu Gebieten
- **Druck-Funktion** mit Legende
- **Dark Mode** Support

### Dokumentation
- **Quick Start:** `KARTEN_QUICKSTART.md`
- **Funktionalität:** `KARTEN_FUNKTIONALITAET.md`
- **Implementation:** `KARTEN_IMPLEMENTIERUNG.md`

## ?? Mobile Dashboard

**Erweitert in v2.5.0:** Dark Mode Support!

### Features
- **QR-Code Verbindung** für schnellen Zugang
- **Live-Updates** via SignalR
- **Team-Übersicht** mit Timer-Status
- **Notizen-Feed** chronologisch
- **Dark Mode** Support

### Dokumentation
- **Quick Start:** `MOBILE_QUICK_START.md`
- **Network Access:** `MOBILE_NETWORK_ACCESS.md`
- **QR Visual Guide:** `MOBILE_QR_VISUAL_GUIDE.md`

## ?? PDF-Export

**Neu in v2.5.0:** Professionelle PDFs mit QuestPDF!

### Features
- **Vollständiger Einsatzbericht** als PDF
- **Logo** und Staffel-Informationen
- **Alle Teams** mit Details
- **Alle Notizen** und Funksprüche
- **Professionelles Layout**
- **Sofort druckbar**

## ?? Fachliche Referenz

Diese Web-App basiert auf der WPF-Anwendung:
- **Repo**: https://github.com/Elemirus1996/Einsatzueberwachung

Die Domänenlogik und Datenstruktur wurde weitgehend 1:1 übernommen.
Das UI wurde für Touch-Bedienung und moderne Web-Standards neu gestaltet.

## ?? Lizenz

(Bitte Lizenz ergänzen)

## ?? Autor

Elemirus1996

---

*Entwickelt mit ?? für Rettungshundestaffeln*
