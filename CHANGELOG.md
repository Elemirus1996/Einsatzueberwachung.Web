# ?? CHANGELOG

## Version 2.5.0 - "Dark Mode & Enhanced Features" (Januar 2025)

### ?? Hauptfeatures

#### **Dark Mode System**
- ? **Vollständiger Dark Mode Support**
  - Alle Komponenten im Dark Mode optimiert
  - Theme Toggle in Navigation (??/?? Icon)
  - Bootstrap 5.3+ Integration mit data-bs-theme
  - Smooth Transitions zwischen Themes
  
- ?? **Persistente Theme-Einstellungen**
  - Theme wird in localStorage gespeichert
  - Automatisches Laden beim App-Start
  - Kein Flackern durch Inline-Script
  
- ?? **Cross-Tab Synchronisation**
  - Theme-Änderung synchronisiert alle offenen Tabs
  - BroadcastChannel API für Echtzeit-Sync
  - JavaScript theme-sync.js für Tab-Kommunikation
  
- ?? **ThemeService**
  - Zentrale Theme-Verwaltung in C#
  - Event-System für Theme-Änderungen
  - Integration in alle Komponenten

#### **Erweiterte Karten-Funktionen**
- ??? **Leaflet.js Integration**
  - Interaktive OpenStreetMap Karten
  - Zoom und Pan-Funktionen
  - Responsive Map-Container
  
- ?? **Zeichnen-Tools**
  - Polygone für Suchgebiete zeichnen
  - Marker setzen und beschriften
  - Leaflet.Draw Integration
  
- ?? **Gebiets-Management**
  - Farben für Suchgebiete zuweisen
  - Beschreibungen hinzufügen
  - Teams zu Gebieten zuordnen
  - Gebiet-Status verwalten
  
- ??? **Druck-Funktion**
  - Karten drucken mit Legende
  - print-map.css für optimalen Druck
  - Gebiets-Liste im Druck
  
- ?? **Dark Mode für Karten**
  - Optimierte Leaflet-Styles für Dark Mode
  - Angepasste Farben und Kontraste

#### **Enhanced Notes System**
- ?? **Erweiterte Notizen**
  - Globale Notizen mit vollständiger Historie
  - Team-spezifische Notizen
  - Verschiedene Notiz-Typen:
    - Manual (Benutzer-Eingabe)
    - System (automatische Logs)
    - TeamStart/TeamStop/TeamReset
    - TeamWarning
    - EinsatzUpdate
  
- ?? **Threads und Antworten**
  - Antworten auf Notizen möglich
  - Verschachtelte Thread-Ansicht
  - Zeitstempel für jede Antwort
  
- ?? **Notiz-Historie**
  - Vollständige Historie aller Änderungen
  - GlobalNotesHistory Model
  - GlobalNotesReply für Antworten
  
- ?? **Dark Mode optimiert**
  - notes-enhanced.css für beide Themes
  - Angepasste Farben und Kontraste

#### **PDF-Export mit QuestPDF**
- ?? **Professionelle PDFs**
  - QuestPDF 2025.7.4 Integration
  - Vollständiges Layout mit Styling
  - Einsatzberichte strukturiert
  
- ?? **Design**
  - Logo und Staffel-Informationen
  - Tabellen für Teams und Daten
  - Farbige Abschnitte
  - Professionelles Layout
  
- ?? **Inhalte**
  - Einsatz-Basisdaten
  - Alle Teams mit Details
  - Alle Notizen und Funksprüche
  - Suchgebiete
  - Zeitstempel und Metadaten
  
- ??? **Export**
  - Sofort druckbar
  - PDF-Standardkonform
  - Optimierte Dateigröße

#### **Mobile Dashboard Verbesserungen**
- ?? **Dark Mode Support**
  - Mobile Dashboard komplett Dark Mode ready
  - mobile-dashboard.css aktualisiert
  - Optimierte Lesbarkeit
  
- ?? **UI-Verbesserungen**
  - Bessere Touch-Targets
  - Optimierte Layouts
  - Smooth Animations
  
- ?? **SignalR Optimierungen**
  - Stabilere Verbindungen
  - Besseres Error Handling
  - Auto-Reconnect verbessert

### ?? Design & UI

#### **Neue CSS-Dateien**
- ?? `dark-mode-base.css` - Dark Mode Basis-Styles
- ??? `leaflet-custom.css` - Leaflet Anpassungen
- ??? `print-map.css` - Karten-Druck-Styles
- ?? `notes-enhanced.css` - Enhanced Notes Styles

#### **Neue JavaScript-Dateien**
- ?? `theme-sync.js` - Theme Synchronisation
- ??? `leaflet-interop.js` - Leaflet .NET Interop
- ?? `audio-alerts.js` - Audio-Benachrichtigungen

#### **Design-Verbesserungen**
- ?? Konsistente Farbschemata für Dark/Light Mode
- ?? Smooth Transitions für Theme-Wechsel
- ?? Verbesserte Kontraste für Barrierefreiheit
- ?? Optimierte Mobile-Layouts

### ?? Technische Änderungen

#### **Neue Services**
- ?? `ThemeService.cs` - Theme-Verwaltung
- ?? `PdfExportService.cs` - PDF-Export mit QuestPDF
- ?? `ToastService.cs` - Toast-Benachrichtigungen
- ?? `SignalRBroadcastService.cs` - Erweitert für neue Features

#### **Neue Komponenten**
- ?? `PageBase.razor` - Base-Component mit Theme-Support
- ?? `ToastNotification.razor` - Toast-System
- ? `LoadingSpinner.razor` - Loading-Indicator
- ?? `Icon.razor` - Icon-System mit Bootstrap Icons

#### **Aktualisierte Komponenten**
- ?? `EinsatzMonitor.razor` - Dark Mode + Enhanced Notes
- ??? `EinsatzKarte.razor` - Leaflet.js Integration
- ?? `EinsatzBericht.razor` - QuestPDF Export
- ?? `MobileDashboard.razor` - Dark Mode Support
- ?? `MobileConnect.razor` - Dark Mode Support
- ?? `MainLayout.razor` - Theme Integration
- ?? `NavMenu.razor` - Theme Toggle Button

#### **Neue Controller**
- ?? `ThreadsController.cs` - Notes-Threads API

#### **NuGet-Pakete**
- ?? `QuestPDF` 2025.7.4 - PDF-Export

### ?? Dokumentation

#### **Dark Mode Guides**
- ?? `DARK_MODE_QUICKSTART.md` - Schnellstart
- ?? `DARK_MODE_VISUAL_SUMMARY.md` - Visueller Guide
- ?? `DARK_MODE_IMPLEMENTATION.md` - Implementation
- ?? `DARK_MODE_GLOBAL_FIX.md` - Global Fix
- ?? `THEME_PERSISTENCE_FIX.md` - Persistence
- ?? `THEME_SYNC_SYSTEM.md` - Sync-System
- ?? `THEME_SYNC_QUICK_TEST.md` - Tests
- ?? `DARK_MODE_QUICK_FIX.md` - Quick Fix
- ?? `CHANGELOG_V2.1.0_DARK_MODE.md` - Dark Mode Changelog

#### **Karten Guides**
- ??? `KARTEN_QUICKSTART.md` - Schnellstart
- ?? `KARTEN_FUNKTIONALITAET.md` - Funktionen
- ?? `KARTEN_IMPLEMENTIERUNG.md` - Implementation
- ?? `CHANGELOG_KARTEN_V2.0.1.md` - Karten Changelog
- ??? `KARTEN_DRUCK_UPDATE.md` - Druck-Update

#### **Weitere Guides**
- ?? `NOTES_ENHANCED_DOCUMENTATION.md` - Notes System
- ?? `ICON_MIGRATION_GUIDE.md` - Icon-System
- ?? `IMPLEMENTATION_SUMMARY.md` - Implementation

#### **Release Dokumentation**
- ?? `RELEASE_V2.5.md` - Release Notes
- ? `PRE_RELEASE_CHECKLIST_V2.5.md` - Checkliste
- ?? `VERSION_2.5_VISUAL_OVERVIEW.md` - Visual Overview
- ?? `GITHUB_RELEASE_SUMMARY_V2.5.md` - GitHub Release
- ? `READY_TO_RELEASE_V2.5.md` - Ready Checklist
- ?? `RELEASE_TO_GITHUB_V2.5.bat` - Release Script

#### **Scripts**
- ?? `Scripts/test-dark-mode.ps1` - Dark Mode Tests
- ?? `Scripts/find-emoji-issues.ps1` - Emoji-Checker
- ?? `Scripts/auto-replace-emojis.ps1` - Emoji-Replacer

### ?? Bug-Fixes

- ? Theme-Persistenz über Page-Reloads funktioniert
- ? Cross-Tab Theme-Sync ohne Verzögerung
- ? SignalR Verbindungs-Stabilität verbessert
- ? Mobile Dashboard Responsive-Issues behoben
- ? Karten-Druck-Probleme gelöst
- ? PDF-Export mit allen Daten
- ? Notes-Threading funktioniert korrekt
- ? Icon-System konsistent

### ?? API-Änderungen

#### **Neue Endpunkte**
- `POST /api/threads/reply` - Antwort auf Notiz
- `GET /api/threads/{noteId}/replies` - Alle Antworten

#### **Erweiterte Endpunkte**
- `GET /api/einsatz/current` - Jetzt mit Theme-Info
- `GET /api/einsatz/notes` - Jetzt mit Thread-Support

### ? Performance-Verbesserungen

- ?? Theme-Wechsel instant ohne Flackern
- ??? Leaflet.js optimierte Tile-Loading
- ?? QuestPDF schnelle PDF-Generierung
- ?? SignalR reduzierte Latenz
- ?? Effizienteres localStorage-Management

### ?? Sicherheit

- ? JWT-Token mit erweiterter Validierung
- ? XSS-Protection für Notes-System
- ? CSRF-Protection für API-Endpunkte
- ? Input-Validierung für alle Formulare

---

## Version 1.5.0 - "Mobile Dashboard" (Januar 2025)

### ?? Neue Features

#### **Mobiles Dashboard für Einsatzkräfte**
- ?? **Mobile-First Dashboard** für Smartphones und Tablets
  - Responsive Design optimiert für mobile Geräte
  - Schneller Überblick über laufenden Einsatz
  - Touch-optimierte Bedienung
  
- ?? **Echtzeit-Updates via SignalR**
  - Live-Aktualisierung aller Team-Daten
  - Automatische Timer-Updates
  - Push-Benachrichtigungen für wichtige Änderungen
  
- ?? **Team-Übersicht**
  - Alle aktiven Teams auf einen Blick
  - Status-Visualisierung (Aktiv/Warnung/Kritisch)
  - Timer mit Farbcodierung
  - Team-Mitglieder und Ausrüstung
  
- ?? **Notizen und Funksprüche**
  - Chronologische Liste aller Notizen
  - Farbcodierung nach Typ (Funkspruch/Notiz/Wichtig)
  - Zeitstempel für alle Einträge
  
- ?? **Sichere Verbindung**
  - PIN-basierte Authentifizierung
  - JWT-Token für sichere API-Zugriffe
  - QR-Code für schnelle Verbindung
  - Auto-Reconnect bei Verbindungsabbruch

### ?? Netzwerk-Features

#### **Netzwerk-Server**
- ?? **Zugriff über lokales Netzwerk**
  - Server läuft auf allen Netzwerk-Interfaces
  - QR-Code mit automatischer IP-Erkennung
  - Firewall-Konfiguration automatisiert
  
- ?? **Sicherheit**
  - PIN-geschützter Zugang (Standard: 1234)
  - Token-basierte Authentifizierung
  - Nur lesender Zugriff für mobile Geräte
  
- ?? **Verbindungsseite**
  - `/mobile/connect` - QR-Code und Verbindungsinfos
  - Automatische IP-Adress-Erkennung
  - Anleitung für mobile Verbindung

### ?? Design-Verbesserungen

#### **Mobile Dashboard CSS**
- ?? Mobile-optimiertes Layout
- ?? Moderne Karten-Designs mit Schatten
- ?????? Status-Farben für Team-Timer
- ?? Smooth Animationen und Übergänge
- ?? Dark-Mode Support

### ?? Technische Änderungen

#### **Neue Komponenten**
- ?? `MobileDashboard.razor` - Hauptansicht für mobile Geräte
- ?? `MobileConnect.razor` - Verbindungsseite mit QR-Code
- ?? `SignalRBroadcastService.cs` - Echtzeit-Updates
- ?? `EinsatzHub.cs` - SignalR Hub für Live-Daten

#### **Neue Controller**
- ?? `AuthController.cs` - PIN-Authentifizierung
- ?? `EinsatzController.cs` - Mobile API-Endpunkte
- ?? `NetworkController.cs` - Netzwerk-Informationen

#### **Neue Scripts**
- ?? `Configure-Firewall.ps1` - Automatische Firewall-Konfiguration
- ?? `START_NETWORK_SERVER.bat` - Server mit Netzwerk-Zugriff starten

#### **NuGet-Pakete**
- ?? `Microsoft.AspNetCore.SignalR.Client` - SignalR Support
- ?? `Microsoft.AspNetCore.Authentication.JwtBearer` - JWT Auth
- ?? `QRCoder` - QR-Code Generierung
- ?? `Swashbuckle.AspNetCore` - API-Dokumentation

### ?? Dokumentation

- ?? `MOBILE_README.md` - Vollständige mobile Dokumentation
- ?? `MOBILE_QUICK_START.md` - Schnellstart-Anleitung
- ?? `MOBILE_DEPLOYMENT_CHECKLIST.md` - Deployment-Checkliste
- ?? `MOBILE_VISUAL_GUIDE.md` - Visueller Guide
- ?? `MOBILE_SUMMARY.md` - Feature-Übersicht
- ?? `MOBILE_IMPLEMENTATION.md` - Technische Details
- ?? `MOBILE_NETWORK_ACCESS.md` - Netzwerk-Setup
- ?? `MOBILE_QR_VISUAL_GUIDE.md` - QR-Code Guide

### ?? Bug-Fixes

- ? SignalR-Verbindung bleibt stabil bei Netzwerk-Wechsel
- ? Timer-Updates werden korrekt synchronisiert
- ? Mobile Layout funktioniert auf allen Bildschirmgrößen
- ? QR-Code wird korrekt mit aktueller IP generiert

### ?? API-Endpunkte

- `POST /api/auth/login` - PIN-Authentifizierung
- `GET /api/einsatz/current` - Aktuelle Einsatzdaten
- `GET /api/einsatz/teams` - Alle Teams
- `GET /api/einsatz/notes` - Alle Notizen
- `GET /api/network/info` - Netzwerk-Informationen

---

## Version 2.0.0 - "Modern Monitor" (Januar 2024)

### ? Neue Features

#### **Vereinfachter Workflow**
- ? **Team-Verwaltung direkt im Monitor integriert**
  - Keine separate `/einsatz/teams` Seite mehr nötig
  - Teams können direkt aus dem Monitor-View erstellt werden
  - Schnellerer Workflow: Start ? Monitor ? Teams erstellen ? Fertig!

#### **Moderner Einsatzmonitor**
- ? **Einsatz-Info-Header** mit Badge-System
  - ?? Rot für Einsätze
  - ?? Orange für Übungen
  - Gradient-Background mit Pulsieren
  
- ? **Verbesserte Team-Cards**
  - Farbcodierung nach Hundeausbildung
  - Hover-Effekte mit Transform
  - Status-Visualisierung (Running/Warning/Critical)
  - Inline-Bearbeitung mit Icon-Buttons (??/???)

- ? **Optimierter Timer**
  - Größere Anzeige (3rem)
  - Blink-Animation bei kritischem Status
  - Farbcodierung: Grün ? Orange ? Rot
  - Pulse-Animation für kritische Warnungen

- ? **Chip-Design für Team-Mitglieder**
  - Moderne Pill-Form
  - Icons für schnelle Erkennung
  - Besondere Hervorhebung von Suchgebieten

#### **Moderne Modal-Dialoge**
- ? **Glassmorphism-Design**
  - Backdrop-Blur-Effekt
  - Smooth Slide-Up Animation
  - Gradient-Header in Primary-Color
  - Runder Close-Button mit Hover-Effect

- ? **Verbessertes Formular-Design**
  - Große Touch-Inputs (min. 48px)
  - Button-Group für Team-Typen
  - Focus-States mit Glow-Effect
  - Bessere Validierung

### ?? Design-Verbesserungen

#### **CSS-Überarbeitung** (2000+ Zeilen)
- ? **Monitor-spezifische Styles**
  - `.monitor-container` - Optimiertes Layout
  - `.monitor-header` - Gradient-Background
  - `.monitor-grid` - 2-Column Layout
  - `.team-card-monitor` - Modernes Card-Design
  - `.timer-section` - Zentrierte Timer-Anzeige
  - `.notes-section` - Dedizierte Notizen-Sidebar

- ? **Animationen**
  - `@keyframes pulse-badge` - Pulsierende Badges
  - `@keyframes blink-timer` - Blinkender Timer
  - `@keyframes fadeIn` - Modal-Overlay
  - `@keyframes slideUp` - Modal erscheinen
  - `@keyframes pulse-critical` - Kritische Warnung

- ? **Neue Komponenten**
  - `.einsatz-info-card` - Header-Card
  - `.badge-einsatz` / `.badge-uebung` - Status-Badges
  - `.member-chip` - Team-Mitglieder Chips
  - `.warning-badge` - Timer-Warnungen
  - `.btn-icon` - Icon-only Buttons
  - `.empty-state` - Leerzustände
  - `.modal-modern` - Neue Modal-Styles

#### **Responsive Verbesserungen**
- ? Grid-Layout für große Screens (2-Column)
- ? Stack-Layout für Tablets (1-Column)
- ? Optimierte Touch-Targets für Mobile
- ? Flexible Typography für alle Screens

### ?? Technische Änderungen

#### **Komponenten**
- ? `EinsatzMonitor.razor` - Komplett neu geschrieben
  - Team-CRUD direkt integriert
  - Bessere State-Management
  - Optimierte Event-Handling
  - IJSRuntime für confirm-Dialoge

- ? `Home.razor` - RenderMode hinzugefügt
  - `@rendermode InteractiveServer` für reaktive Navigation

- ? `NavMenu.razor` - Vereinfacht
  - `/einsatz/teams` Link entfernt
  - Direkter Zugang zum Monitor

#### **Gelöschte Dateien**
- ? `EinsatzTeams.razor` - Nicht mehr benötigt (in Monitor integriert)

### ?? Bug-Fixes
- ? Navigation-Buttons auf Home-Page funktionieren jetzt
- ? RenderMode-Konflikte behoben
- ? Team-Bearbeitung direkt aus Monitor möglich
- ? Timer-Updates werden korrekt angezeigt

### ?? Dokumentation
- ? `README_V2.md` - Komplett neue README
- ? `CHANGELOG.md` - Dieses Dokument
- ? Code-Kommentare in allen neuen Styles

---

## Version 1.0.0 - "Initial Release" (Januar 2024)

### ? Initiales Release

#### **Domain-Layer**
- ? Alle Modelle aus WPF übertragen
- ? Services implementiert (MasterData, Einsatz, Settings, PDF)
- ? Enums mit Extension-Methods

#### **Web-UI**
- ? 8 funktionale Seiten erstellt
- ? Bootstrap-basiertes Design
- ? Touch-optimierte Buttons
- ? Responsive Layout

#### **Features**
- ? Vollständiger Einsatz-Workflow
- ? Personal & Hunde-Verwaltung
- ? Team-Timer mit Warnungen
- ? Notizen & Funksprüche
- ? PDF-Export (TXT)
- ? Hell-/Dunkelmodus

---

## Roadmap

### Version 2.1 (Q2 2024)
- [ ] Leaflet.js Karten-Integration
- [ ] Verbesserter PDF-Export mit QuestPDF
- [ ] Suchgebiete auf Karte zeichnen
- [ ] GPS-Integration für ELW-Position

### Version 3.0 (Q3 2024)
- [ ] Entity Framework Core + SQLite
- [ ] Historien-Funktion
- [ ] Statistiken & Auswertungen
- [ ] Multi-User Support

### Version 4.0 (Q4 2024)
- [ ] SignalR für Echtzeit-Sync
- [ ] PWA-Support
- [ ] Offline-Modus
- [ ] Mobile-Apps (MAUI)

---

## Breaking Changes

### v2.0.0
- ?? **Route entfernt**: `/einsatz/teams` existiert nicht mehr
  - Migration: Nutze `/einsatz/monitor` für Team-Verwaltung
  
- ?? **CSS-Klassen umbenannt**
  - `.teams-monitor-list` ? `.teams-monitor-grid`
  - `.monitor-team-card` ? `.team-card-monitor`
  - Alte Klassen werden nicht mehr unterstützt

---

## Migrationsanleitung v1 ? v2

### Für Benutzer
1. Keine Aktion nötig - Workflow automatisch vereinfacht
2. Teams jetzt im Monitor statt separater Seite erstellen
3. Navigation aktualisiert - ein Link weniger

### Für Entwickler
1. `EinsatzTeams.razor` wurde gelöscht
2. Team-CRUD in `EinsatzMonitor.razor` integriert
3. Neue CSS-Klassen in `app.css` verwenden
4. Navigation in `NavMenu.razor` angepasst

---

*Stand: Januar 2024*
