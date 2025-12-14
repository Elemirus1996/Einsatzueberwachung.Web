# Einsatzüberwachung Web

Moderne, touch-optimierte Web-Anwendung für die Koordination und Überwachung von Rettungshunde-Einsätzen.

## ?? Features

### ? Implementiert

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

### ?? Geplant / TODO

- **Karten-Integration**
  - Leaflet.js oder OpenLayers einbinden
  - Einsatzort auf Karte markieren
  - Suchgebiete als Polygone zeichnen
  - GPS-Koordinaten für ELW-Position

- **PDF-Export**
  - QuestPDF-Integration für professionelle PDFs
  - Logo und Staffel-Design im Export
  - Kartenausschnitt im Bericht

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

## ??? Technologie-Stack

- **.NET 8** - Framework
- **Blazor Server** - Interactive Server Components
- **Bootstrap 5** - CSS-Framework (mit Custom Styles)
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

```bash
cd Einsatzueberwachung.Web
dotnet run
```

Oder in Visual Studio:
- Lösung öffnen
- `Einsatzueberwachung.Web` als Startprojekt festlegen
- F5 drücken

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
- **/einsatz/teams** - Teams zusammenstellen
- **/einsatz/monitor** - Live-Überwachung
- **/einsatz/karte** - Karte & Suchgebiete
- **/einsatz/bericht** - Bericht & Export
- **/stammdaten** - Personal & Hunde verwalten
- **/einstellungen** - Konfiguration

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
