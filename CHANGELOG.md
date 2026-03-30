# 📋 CHANGELOG

## Version 4.3.2 - "Drohnenwetter-Seite" (März 2026)

### 🎯 Hauptverbesserungen

- ✈️ Neue Seite **Drohne** hinzugefügt
- 🌐 Direkte Integration von drohnenwetter.de in der Anwendung
- 📍 Übergabe des Einsatzstandorts (ELW-Koordinaten oder Einsatzadresse) an drohnenwetter.de
- 🧭 Neuer Navigationseintrag **Drohne** im Seitenmenü

---

## Version 4.3.1 - "Hotfix: Port 5001 & Fehlerbanner" (März 2026)

### 🎯 Hauptverbesserungen

- 🔁 Weiterleitung der Ladeseite auf `https://localhost:5001` korrigiert
- 🧭 Starter-Skripte auf Port 5001 (HTTPS) und 5000 (HTTP) vereinheitlicht
- 🛑 Dauerhaft sichtbares "An unhandled error has occurred"-Banner standardmäßig ausgeblendet

---

## Version 4.3.0 - "Ladeseite statt Splash" (März 2026)

### 🎯 Hauptverbesserungen

#### **Smarte Ladeseite** 🆕
- 🔄 Browser zeigt Ladeseite während Server startet (statt "Seite nicht erreichbar")
- ⏳ Automatische Weiterleitung zur App wenn Server bereit ist
- ❌ Splash-Screen entfernt (verursachte Probleme bei Navigation)
- 🎨 Schöne Ladeanimation mit Logo und Fortschrittsanzeige

### 🛠️ Technische Details
- **Neue Dateien:**
  - [loading.html](Installer/loading.html) - Eigenständige Ladeseite
- **Aktualisierte Dateien:**
  - [App.razor](Einsatzueberwachung.Web/Components/App.razor) - Splash-Screen entfernt
  - [Einsatzueberwachung-Starten.ps1](Einsatzueberwachung-Starten.ps1) - Öffnet Ladeseite
  - [Einsatzueberwachung-Starter.ps1](Installer/Einsatzueberwachung-Starter.ps1) - Öffnet Ladeseite

---

## Version 4.2.0 - "Stabilität & Zertifikate" (März 2026)

### 🎯 Hauptverbesserungen

#### **Verbesserter Start-Workflow** 🆕
- 🔒 HTTPS-Zertifikat wird automatisch als vertrauenswürdig installiert
- ⏳ Browser öffnet erst wenn Server bereit ist (kein "Seite nicht erreichbar" mehr)
- 🖥️ Sidebar bleibt auch im Vollbildmodus sichtbar
- 🎬 Splash-Screen verschwindet korrekt bei Navigation

### 🛠️ Technische Details
- **Aktualisierte Dateien:**
  - [Einsatzueberwachung-Starten.ps1](Einsatzueberwachung-Starten.ps1) - Wait-ForServer, Install-HttpsCertificate
  - [app.css](Einsatzueberwachung.Web/wwwroot/app.css) - Fullscreen behält Sidebar
  - [App.razor](Einsatzueberwachung.Web/Components/App.razor) - Splash-Screen Fix

---

## Version 4.1.0 - "Branding & UX-Verbesserungen" (März 2026)

### 🎯 Hauptverbesserungen

#### **Neues App-Branding** 🆕
- 🐕 Eigenes App-Logo (Rettungshund-Design) für alle Bereiche
- 🖼️ Logo in der Sidebar-Navigation
- 📱 Neue PWA-Icons (favicon, 192x192, 512x512)
- 🎬 Animierter Splash-Screen beim App-Start
- 📦 Installer zeigt das neue Logo im Setup-Wizard

#### **Verbessertes UI/UX** 🆕
- 📌 Header mit Uhrzeit bleibt beim Scrollen fixiert (sticky)
- 🖥️ Vollbild-Modus Button in der Header-Leiste (oder F11)
- 🏷️ Einheitliche Browser-Tab-Titel: "Seite | Einsatzüberwachung"
- 🔧 NavMenu-Toggle CSP-kompatibel (Fix für Kunden-Browser)

### 🛠️ Technische Details
- **Aktualisierte Dateien:**
  - [NavMenu.razor](Einsatzueberwachung.Web/Components/Layout/NavMenu.razor) - Logo statt Alarm-Icon
  - [MainLayout.razor](Einsatzueberwachung.Web/Components/Layout/MainLayout.razor) - Vollbild-Button
  - [App.razor](Einsatzueberwachung.Web/Components/App.razor) - Splash-Screen, CSP-Fix
  - Alle Seiten - Dynamische PageTitle
  - [Einsatzueberwachung.iss](Installer/Einsatzueberwachung.iss) - Setup-Icon

---

## Version 4.0.0 - "Archiv, Team-Automation & Wetter-Adresssuche" (März 2026)

### 🎯 Hauptverbesserungen

#### **Archivierteinsatz mit vollständiger Ressourcenübersicht** 🆕
- ✅ Beim Einsatzabschluss werden Beteiligte und Ressourcen vollständig mit archiviert
- 👥 Explizite Speicherung von `PersonalNamen`
- 🐕 Explizite Speicherung von `HundeNamen`
- 🚁 Explizite Speicherung von `DrohnenNamen`
- 📊 Neue Kennzahl `AnzahlRessourcen` (Personal + Hunde + Drohnen)
- 🧾 Verbesserte Detailansicht im Archiv mit Namenlisten statt nur Zählern

#### **Sicherere Abschluss-Abfrage im Einsatzmonitor** 🆕
- 🛑 Erweiterter Dialog "Einsatz beenden und archivieren"
- 🔍 Sichtbare Abfrage: Wer war vor Ort, welche Hunde und welche Drohnen waren im Einsatz
- ☑️ Pflicht-Bestätigung vor Archivierung, damit keine unvollständigen Abschlüsse passieren

#### **Team-Erstellung schneller gemacht** 🆕
- ⚡ Beim Auswählen eines Hundes wird der hinterlegte Hundeführer automatisch vorausgewählt
- 🧠 Nur aktive und qualifizierte Hundeführer werden automatisch übernommen

#### **Wetter über Adresse (Geocoding) implementiert** 🆕
- 🌍 `GetCurrentWeatherByAddressAsync()` nutzt jetzt Nominatim zur Adressauflösung
- 📍 Ermittelte Koordinaten werden automatisch an die bestehende BrightSky-Wetterabfrage übergeben
- 🪵 Erweiterte Fehlerbehandlung und Logging für Geocoding-Fehlerfälle

---

## Version 3.12.0 - "Verbesserter Kartendruck" (März 2026)

### 🖨️ Druckverbesserungen
- **Seite 1:** Karte im Querformat (A4 Landscape)
- **Seite 2:** Suchgebiete-Liste als Tabelle
- Uhrzeit und Navigation werden beim Drucken ausgeblendet
- Optimierte Kopfzeilen für beide Seiten

---

## Version 3.11.0 - "Tastenkürzel, Sound & Multi-Monitor" (März 2026)

### 🎯 Hauptverbesserungen

#### **Globale Tastenkürzel** 🆕
- ⌨️ **Schnelle Navigation**
  - `Ctrl+H` - Zur Startseite
  - `Ctrl+M` - Zur Kartenansicht
  - `Ctrl+E` - Zum Einsatzmonitor
  - `Ctrl+D` - Dark/Light Mode umschalten
  - `F2` oder `Ctrl+T` - Neues Team hinzufügen
  - `Ctrl+/` oder `?` - Tastenkürzel-Übersicht anzeigen

#### **Konfigurierbare Sound-Warnungen** 🔊
- 🔔 **Team-Timer-Warnungen**
  - Aktivierbar in den Einstellungen
  - Verschiedene Warntöne: Beep, Bell, Alarm
  - Lautstärke-Regler (0-100%)
  - Konfigurierbare Frequenz (Minuten vor Ablauf)
  - Wiederholende Warn-Option
- 🧪 **Test-Buttons** für jeden Sound direkt in Einstellungen

#### **Multi-Monitor Support** 🖥️
- 📺 **Popout-Fenster für zweiten Monitor**
  - Teams-Ansicht als separates Fenster
  - Notizen/Funkmeldungen als separates Fenster
  - Theme-Synchronisation zwischen Fenstern
  - Automatisches Schließen beim Schließen des Hauptfensters

### 🛠️ Technische Details
- 🗂️ **Neue Dateien**
  - `keyboard-shortcuts.js` - Globales Tastenkürzel-System
  - `multi-monitor.js` - Fenster-Management für Multi-Monitor
  - `PopoutTeams.razor` - Standalone Teams-Ansicht
  - `PopoutNotes.razor` - Standalone Notizen-Ansicht

- 🔧 **Erweiterte Dateien**
  - `audio-alerts.js` - Umfangreich erweitert für Sound-Warnungen
  - `SessionData.cs` - 8 neue Properties für Sound-Konfiguration
  - `Einstellungen.razor` - Sound-Konfiguration UI

- 🔤 **Encoding-Fix**
  - UTF-8 Umlaute in allen aktiven Projektdateien korrigiert
  - Betroffene Dateien: Services, Razor-Komponenten, Models

---

## Version 3.10.0 - "PDF Export & Theme Fix" (März 2026)

### 🎯 Hauptverbesserungen

#### **PDF-Export für Archiv** 🆕
- 📄 **Archiv-PDF-Export**
  - Archivierte Einsätze können direkt als PDF exportiert werden
  - Professionelles Layout mit Staffel-Header
  - Farbliche Unterscheidung: Einsatz (rot) / Übung (blau)
  - Statistik-Box mit Teams, Personal, Hunden, Drohnen
  - Ergebnisdarstellung mit Bemerkungen
  - Team-Tabelle mit Status und Zeiten

- 📥 **Direkter Browser-Download**
  - PDFs werden direkt im Browser heruntergeladen
  - Kein Server-Dateispeicher mehr nötig
  - Funktioniert auch im Netzwerk-Betrieb

#### **Theme-Switching ohne Neuladen** 🔧
- 🌙 **Sofortiger Theme-Wechsel**
  - Light/Dark Mode wechselt jetzt ohne Seiten-Reload
  - Optimierter MutationObserver verhindert Theme-Drift
  - `intentionalThemeChange`-Flag für saubere Übergänge
  - Broadcast-Channel für Tab-Synchronisation

### 🛠️ Technische Details
- 📦 **IPdfExportService erweitert**
  - `ExportArchivedEinsatzToPdfAsync()` - Archiv als PDF-Datei
  - `ExportArchivedEinsatzToPdfBytesAsync()` - für Browser-Download
  - `ExportEinsatzToPdfBytesAsync()` - Aktive Einsätze für Browser-Download

- 🎨 **theme-sync.js optimiert**
  - Flag-basierte Steuerung verhindert Race-Conditions
  - Debouncing für saubere Theme-Übergänge

---

## Version 3.9.0 - "Flugwetter" (Februar 2026)

### 🎯 Hauptverbesserungen

#### **Erweiterte Flugwetter-Anzeige** 🆕
- ✈️ **Flugkategorien nach FAA-Standard**
  - VFR (Visual Flight Rules) - Grün
  - MVFR (Marginal VFR) - Blau  
  - IFR (Instrument Flight Rules) - Gelb
  - LIFR (Low IFR) - Rot
  
- 🚁 **Drohnen-Flugbewertung**
  - Automatische Bewertung der Flugbedingungen
  - Windgrenzen-Prüfung (max. 38 km/h Böen)
  - Sichtweiten-Bewertung (min. 1 km für Sichtflug)
  - Wetterlage-Analyse (Regen, Gewitter, Nebel)

- 📊 **Erweiterte Flugwetter-Daten**
  - QNH (Luftdruck auf Meereshöhe)
  - Spread (Temperatur - Taupunkt) für Nebelwarnung
  - Wolkenuntergrenze in Metern und Fuß
  - Pseudo-METAR Anzeige

- 🔄 **Auto-Refresh**
  - Automatische Aktualisierung alle 10 Minuten
  - Visueller Hinweis im UI

#### **Technische Details**
- 🏗️ **FlugwetterData-Klasse**
  - Neue Datenstruktur für Flugwetter-Informationen
  - Kategorieberechnung nach FAA-Kriterien
  - Helper-Methoden für UI-Darstellung
  
- 🌐 **DWD Open Data Integration**
  - Nutzung der BrightSky API für Echtzeitdaten
  - Wolkenuntergrenze nach Spread-Formel (125m/°C)
  - Windrichtungs-Umrechnung für METAR

---

## Version 3.8.0 - "Archiv & Wetter" (Februar 2026)

### 🎯 Hauptverbesserungen

#### **Einsatz-Archiv** 🆕
- 📚 **Archivierung**
  - Abgeschlossene Einsätze und Übungen können archiviert werden
  - "Einsatz beenden"-Dialog im Monitor mit Ergebnis-Auswahl
  - Automatische Erfassung von Statistiken (Teams, Personal, Hunde, Drohnen)
  
- 🔍 **Archiv-Suche**
  - Durchsuchbare Liste aller archivierten Einsätze
  - Filter nach Zeitraum, Typ (Einsatz/Übung), und Freitext
  - Detailansicht mit allen Einsatzinformationen
  
- 📊 **Statistiken-Dashboard**
  - Übersicht über Gesamtzahlen
  - Jahresstatistik
  - Personal- und Hunde-Einsätze im Überblick
  
- 💾 **Export/Import**
  - JSON-Export aller archivierten Einsätze
  - Import von Archivdaten aus anderen Systemen

#### **DWD Wetter-Integration** 🆕
- 🌤️ **Echtzeit-Wetterdaten**
  - Integration mit dem Deutschen Wetterdienst (DWD)
  - Automatische Wetter-Anzeige basierend auf ELW-Position
  - Aktualisierung alle 10 Minuten
  
- 📍 **Wetter-Widget im Monitor**
  - Temperatur (inkl. gefühlte Temperatur)
  - Windgeschwindigkeit und -richtung
  - Niederschlag und Sichtweite
  - DWD-Wetterwarnungen

#### **Technische Details**
- 🏗️ **Archiv-Service**
  - JSON-basierte Datenspeicherung
  - Volltext-Suche über alle Felder
  - Caching für performante Abfragen
  
- 🌐 **Wetter-Service**
  - Nutzung der BrightSky API (Open Source DWD-Proxy)
  - 5-Minuten-Cache zur Reduzierung der API-Aufrufe
  - Wind-Chill/Heat-Index Berechnung

---

## Version 3.7.0 - "Excel Import/Export" (Februar 2026)

### 🎯 Hauptverbesserungen

#### **Excel Import/Export für Stammdaten** 🆕
- 📊 **Excel Export**
  - Export aller Stammdaten (Personal, Hunde, Drohnen) als Excel-Datei
  - Separate Arbeitsblätter für jede Kategorie
  - Formatierte Kopfzeilen mit Farbcodierung
  - Automatische Spaltenbreitenanpassung
  
- 📥 **Excel Import**
  - Import von Stammdaten aus Excel-Dateien
  - Unterstützung für mehrzeilige Importe
  - Automatische Duplikaterkennung (verhindert doppelte Einträge)
  - Intelligentes Parsing von Qualifikationen und Spezialisierungen
  - Verknüpfung von Hundeführern/Drohnenpiloten mit Personal
  
- 📄 **Import-Vorlage**
  - Downloadbare Excel-Vorlage mit Beispieldaten
  - Hinweise zu möglichen Qualifikationen und Spezialisierungen
  - Einfache Befüllung für neue Einträge

#### **Technische Details**
- 📦 **ClosedXML Integration**
  - Verwendung der ClosedXML-Bibliothek (MIT-Lizenz)
  - Keine externen Abhängigkeiten zu Microsoft Office
  - Plattformunabhängig (Windows, Linux, macOS)

---

## Version 3.6.0 - "UI Fixes & Stability" (Februar 2026)

### 🎯 Hauptverbesserungen

#### **UI/UX Fixes**
- 🎨 **Sidebar Navigation Fix**
  - Linkfarben in der Sidebar im Light Theme auf Weiß korrigiert
  - Bessere Lesbarkeit der Navigation auf dunklem Hintergrund
  
#### **Service Worker & PWA**
- ⚡ **Service Worker Optimierungen**
  - POST-Requests werden nicht mehr gecacht (Cache-Fehler behoben)
  - Stabilere Offline-Funktionalität
  
- 📱 **Manifest Korrekturen**
  - Icon-Größen in Shortcuts korrigiert (192x192)
  - Verbesserte PWA-Kompatibilität

#### **Technische Verbesserungen**
- 🛡️ **Stabilität**
  - Weniger Konsolenfehler
  - Besseres Error-Handling im Service Worker

---

## Version 3.0.0 - "Enhanced User Experience & Performance" (Januar 2026)

### 🎯 Hauptverbesserungen

#### **UI/UX Enhancements**
- 🎨 **Optimiertes Dashboard Design**
  - Verbesserte Benutzeroberfläche mit modernem Layout
  - Schnellere Navigation zwischen Seiten
  - Bessere mobile Responsive-Optimierung
  
- ⚡ **Performance-Verbesserungen**
  - Optimierte JavaScript-Ladezeiten
  - Besseres Caching von Komponenten
  - Reduzierte Netzwerk-Anfragen
  
- 🔄 **Erweiterte SignalR-Kommunikation**
  - Stabilere Echtzeit-Synchronisation
  - Besseres Error-Handling für Verbindungsfehler
  - Automatisches Reconnect-System

#### **Map & Karten-Enhancements**
- 🗺️ **Erweiterte Leaflet.js Funktionen**
  - Bessere Performance bei vielen Gebieten
  - Optimierte Gebiets-Rendering
  - Verbesserte Druck-Qualität von Karten
  
- 📍 **Team-Lokalisierung**
  - Teams auf Karten besser visualisieren
  - Echtzeit-Position Updates
  - Verbesserte Gebiet-Zuordnung

#### **Mobiles & Dark Mode**
- 📱 **Verbesserte Mobile Experience**
  - Touch-Optimierungen für kleinere Bildschirme
  - Bessere QR-Code-Lesbarkeit
  - Schnellere Mobile-Navigation
  
- 🌙 **Dark Mode Verbesserungen**
  - Konsistentere Farbschemas
  - Optimierte Kontraste für Lesbarkeit
  - Schnellere Theme-Umschaltung

#### **System & Stabilität**
- 🛡️ **Sicherheit & Stabilität**
  - Besseres JWT-Token-Handling
  - Verbesserte Error-Recovery
  - Stabilere WebSocket-Verbindungen
  
- 📊 **Logging & Diagnostik**
  - Bessere Fehlerprotokollierung
  - Detailliertere System-Logs
  - Besseres Debugging für Entwickler

#### **Dokumentation & Hilfe**
- 📖 **Verbesserte Dokumentation**
  - Aktualisierte HILFE.md
  - Bessere Fehlermeldungen
  - Hilfreiche Tooltips in der UI

### 🔄 Kompatibilität
- ✅ Vollständig kompatibel mit Version 2.5.0 Datenbanken
- ✅ Automatische Migrations bei Bedarf
- ✅ Keine Benutzer-Datenverluste

---

## Version 2.5.0 - "Dark Mode & Enhanced Features" (Januar 2025)

### 🌓 Hauptfeatures

#### **Dark Mode System**
- ? **Vollst�ndiger Dark Mode Support**
  - Alle Komponenten im Dark Mode optimiert
  - Theme Toggle in Navigation (??/?? Icon)
  - Bootstrap 5.3+ Integration mit data-bs-theme
  - Smooth Transitions zwischen Themes
  
- ?? **Persistente Theme-Einstellungen**
  - Theme wird in localStorage gespeichert
  - Automatisches Laden beim App-Start
  - Kein Flackern durch Inline-Script
  
- ?? **Cross-Tab Synchronisation**
  - Theme-�nderung synchronisiert alle offenen Tabs
  - BroadcastChannel API f�r Echtzeit-Sync
  - JavaScript theme-sync.js f�r Tab-Kommunikation
  
- ?? **ThemeService**
  - Zentrale Theme-Verwaltung in C#
  - Event-System f�r Theme-�nderungen
  - Integration in alle Komponenten

#### **Erweiterte Karten-Funktionen**
- ??? **Leaflet.js Integration**
  - Interaktive OpenStreetMap Karten
  - Zoom und Pan-Funktionen
  - Responsive Map-Container
  
- ?? **Zeichnen-Tools**
  - Polygone f�r Suchgebiete zeichnen
  - Marker setzen und beschriften
  - Leaflet.Draw Integration
  
- ?? **Gebiets-Management**
  - Farben f�r Suchgebiete zuweisen
  - Beschreibungen hinzuf�gen
  - Teams zu Gebieten zuordnen
  - Gebiet-Status verwalten
  
- ??? **Druck-Funktion**
  - Karten drucken mit Legende
  - print-map.css f�r optimalen Druck
  - Gebiets-Liste im Druck
  
- ?? **Dark Mode f�r Karten**
  - Optimierte Leaflet-Styles f�r Dark Mode
  - Angepasste Farben und Kontraste

#### **Enhanced Notes System**
- ?? **Erweiterte Notizen**
  - Globale Notizen mit vollst�ndiger Historie
  - Team-spezifische Notizen
  - Verschiedene Notiz-Typen:
    - Manual (Benutzer-Eingabe)
    - System (automatische Logs)
    - TeamStart/TeamStop/TeamReset
    - TeamWarning
    - EinsatzUpdate
  
- ?? **Threads und Antworten**
  - Antworten auf Notizen m�glich
  - Verschachtelte Thread-Ansicht
  - Zeitstempel f�r jede Antwort
  
- ?? **Notiz-Historie**
  - Vollst�ndige Historie aller �nderungen
  - GlobalNotesHistory Model
  - GlobalNotesReply f�r Antworten
  
- ?? **Dark Mode optimiert**
  - notes-enhanced.css f�r beide Themes
  - Angepasste Farben und Kontraste

#### **PDF-Export mit QuestPDF**
- ?? **Professionelle PDFs**
  - QuestPDF 2025.7.4 Integration
  - Vollst�ndiges Layout mit Styling
  - Einsatzberichte strukturiert
  
- ?? **Design**
  - Logo und Staffel-Informationen
  - Tabellen f�r Teams und Daten
  - Farbige Abschnitte
  - Professionelles Layout
  
- ?? **Inhalte**
  - Einsatz-Basisdaten
  - Alle Teams mit Details
  - Alle Notizen und Funkspr�che
  - Suchgebiete
  - Zeitstempel und Metadaten
  
- ??? **Export**
  - Sofort druckbar
  - PDF-Standardkonform
  - Optimierte Dateigr��e

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
- ?? Konsistente Farbschemata f�r Dark/Light Mode
- ?? Smooth Transitions f�r Theme-Wechsel
- ?? Verbesserte Kontraste f�r Barrierefreiheit
- ?? Optimierte Mobile-Layouts

### ?? Technische �nderungen

#### **Neue Services**
- ?? `ThemeService.cs` - Theme-Verwaltung
- ?? `PdfExportService.cs` - PDF-Export mit QuestPDF
- ?? `ToastService.cs` - Toast-Benachrichtigungen
- ?? `SignalRBroadcastService.cs` - Erweitert f�r neue Features

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

- ? Theme-Persistenz �ber Page-Reloads funktioniert
- ? Cross-Tab Theme-Sync ohne Verz�gerung
- ? SignalR Verbindungs-Stabilit�t verbessert
- ? Mobile Dashboard Responsive-Issues behoben
- ? Karten-Druck-Probleme gel�st
- ? PDF-Export mit allen Daten
- ? Notes-Threading funktioniert korrekt
- ? Icon-System konsistent

### ?? API-�nderungen

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
- ? XSS-Protection f�r Notes-System
- ? CSRF-Protection f�r API-Endpunkte
- ? Input-Validierung f�r alle Formulare

---

## Version 1.5.0 - "Mobile Dashboard" (Januar 2025)

### ?? Neue Features

#### **Mobiles Dashboard f�r Einsatzkr�fte**
- ?? **Mobile-First Dashboard** f�r Smartphones und Tablets
  - Responsive Design optimiert f�r mobile Ger�te
  - Schneller �berblick �ber laufenden Einsatz
  - Touch-optimierte Bedienung
  
- ?? **Echtzeit-Updates via SignalR**
  - Live-Aktualisierung aller Team-Daten
  - Automatische Timer-Updates
  - Push-Benachrichtigungen f�r wichtige �nderungen
  
- ?? **Team-�bersicht**
  - Alle aktiven Teams auf einen Blick
  - Status-Visualisierung (Aktiv/Warnung/Kritisch)
  - Timer mit Farbcodierung
  - Team-Mitglieder und Ausr�stung
  
- ?? **Notizen und Funkspr�che**
  - Chronologische Liste aller Notizen
  - Farbcodierung nach Typ (Funkspruch/Notiz/Wichtig)
  - Zeitstempel f�r alle Eintr�ge
  
- ?? **Sichere Verbindung**
  - PIN-basierte Authentifizierung
  - JWT-Token f�r sichere API-Zugriffe
  - QR-Code f�r schnelle Verbindung
  - Auto-Reconnect bei Verbindungsabbruch

### ?? Netzwerk-Features

#### **Netzwerk-Server**
- ?? **Zugriff �ber lokales Netzwerk**
  - Server l�uft auf allen Netzwerk-Interfaces
  - QR-Code mit automatischer IP-Erkennung
  - Firewall-Konfiguration automatisiert
  
- ?? **Sicherheit**
  - PIN-gesch�tzter Zugang (Standard: 1234)
  - Token-basierte Authentifizierung
  - Nur lesender Zugriff f�r mobile Ger�te
  
- ?? **Verbindungsseite**
  - `/mobile/connect` - QR-Code und Verbindungsinfos
  - Automatische IP-Adress-Erkennung
  - Anleitung f�r mobile Verbindung

### ?? Design-Verbesserungen

#### **Mobile Dashboard CSS**
- ?? Mobile-optimiertes Layout
- ?? Moderne Karten-Designs mit Schatten
- ?????? Status-Farben f�r Team-Timer
- ?? Smooth Animationen und �berg�nge
- ?? Dark-Mode Support

### ?? Technische �nderungen

#### **Neue Komponenten**
- ?? `MobileDashboard.razor` - Hauptansicht f�r mobile Ger�te
- ?? `MobileConnect.razor` - Verbindungsseite mit QR-Code
- ?? `SignalRBroadcastService.cs` - Echtzeit-Updates
- ?? `EinsatzHub.cs` - SignalR Hub f�r Live-Daten

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

- ?? `MOBILE_README.md` - Vollst�ndige mobile Dokumentation
- ?? `MOBILE_QUICK_START.md` - Schnellstart-Anleitung
- ?? `MOBILE_DEPLOYMENT_CHECKLIST.md` - Deployment-Checkliste
- ?? `MOBILE_VISUAL_GUIDE.md` - Visueller Guide
- ?? `MOBILE_SUMMARY.md` - Feature-�bersicht
- ?? `MOBILE_IMPLEMENTATION.md` - Technische Details
- ?? `MOBILE_NETWORK_ACCESS.md` - Netzwerk-Setup
- ?? `MOBILE_QR_VISUAL_GUIDE.md` - QR-Code Guide

### ?? Bug-Fixes

- ? SignalR-Verbindung bleibt stabil bei Netzwerk-Wechsel
- ? Timer-Updates werden korrekt synchronisiert
- ? Mobile Layout funktioniert auf allen Bildschirmgr��en
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
  - Keine separate `/einsatz/teams` Seite mehr n�tig
  - Teams k�nnen direkt aus dem Monitor-View erstellt werden
  - Schnellerer Workflow: Start ? Monitor ? Teams erstellen ? Fertig!

#### **Moderner Einsatzmonitor**
- ? **Einsatz-Info-Header** mit Badge-System
  - ?? Rot f�r Eins�tze
  - ?? Orange f�r �bungen
  - Gradient-Background mit Pulsieren
  
- ? **Verbesserte Team-Cards**
  - Farbcodierung nach Hundeausbildung
  - Hover-Effekte mit Transform
  - Status-Visualisierung (Running/Warning/Critical)
  - Inline-Bearbeitung mit Icon-Buttons (??/???)

- ? **Optimierter Timer**
  - Gr��ere Anzeige (3rem)
  - Blink-Animation bei kritischem Status
  - Farbcodierung: Gr�n ? Orange ? Rot
  - Pulse-Animation f�r kritische Warnungen

- ? **Chip-Design f�r Team-Mitglieder**
  - Moderne Pill-Form
  - Icons f�r schnelle Erkennung
  - Besondere Hervorhebung von Suchgebieten

#### **Moderne Modal-Dialoge**
- ? **Glassmorphism-Design**
  - Backdrop-Blur-Effekt
  - Smooth Slide-Up Animation
  - Gradient-Header in Primary-Color
  - Runder Close-Button mit Hover-Effect

- ? **Verbessertes Formular-Design**
  - Gro�e Touch-Inputs (min. 48px)
  - Button-Group f�r Team-Typen
  - Focus-States mit Glow-Effect
  - Bessere Validierung

### ?? Design-Verbesserungen

#### **CSS-�berarbeitung** (2000+ Zeilen)
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
  - `.empty-state` - Leerzust�nde
  - `.modal-modern` - Neue Modal-Styles

#### **Responsive Verbesserungen**
- ? Grid-Layout f�r gro�e Screens (2-Column)
- ? Stack-Layout f�r Tablets (1-Column)
- ? Optimierte Touch-Targets f�r Mobile
- ? Flexible Typography f�r alle Screens

### ?? Technische �nderungen

#### **Komponenten**
- ? `EinsatzMonitor.razor` - Komplett neu geschrieben
  - Team-CRUD direkt integriert
  - Bessere State-Management
  - Optimierte Event-Handling
  - IJSRuntime f�r confirm-Dialoge

- ? `Home.razor` - RenderMode hinzugef�gt
  - `@rendermode InteractiveServer` f�r reaktive Navigation

- ? `NavMenu.razor` - Vereinfacht
  - `/einsatz/teams` Link entfernt
  - Direkter Zugang zum Monitor

#### **Gel�schte Dateien**
- ? `EinsatzTeams.razor` - Nicht mehr ben�tigt (in Monitor integriert)

### ?? Bug-Fixes
- ? Navigation-Buttons auf Home-Page funktionieren jetzt
- ? RenderMode-Konflikte behoben
- ? Team-Bearbeitung direkt aus Monitor m�glich
- ? Timer-Updates werden korrekt angezeigt

### ?? Dokumentation
- ? `README_V2.md` - Komplett neue README
- ? `CHANGELOG.md` - Dieses Dokument
- ? Code-Kommentare in allen neuen Styles

---

## Version 1.0.0 - "Initial Release" (Januar 2024)

### ? Initiales Release

#### **Domain-Layer**
- ? Alle Modelle aus WPF �bertragen
- ? Services implementiert (MasterData, Einsatz, Settings, PDF)
- ? Enums mit Extension-Methods

#### **Web-UI**
- ? 8 funktionale Seiten erstellt
- ? Bootstrap-basiertes Design
- ? Touch-optimierte Buttons
- ? Responsive Layout

#### **Features**
- ? Vollst�ndiger Einsatz-Workflow
- ? Personal & Hunde-Verwaltung
- ? Team-Timer mit Warnungen
- ? Notizen & Funkspr�che
- ? PDF-Export (TXT)
- ? Hell-/Dunkelmodus

---

## Roadmap

### Version 2.1 (Q2 2024)
- [ ] Leaflet.js Karten-Integration
- [ ] Verbesserter PDF-Export mit QuestPDF
- [ ] Suchgebiete auf Karte zeichnen
- [ ] GPS-Integration f�r ELW-Position

### Version 3.0 (Q3 2024)
- [ ] Entity Framework Core + SQLite
- [ ] Historien-Funktion
- [ ] Statistiken & Auswertungen
- [ ] Multi-User Support

### Version 4.0 (Q4 2024)
- [ ] SignalR f�r Echtzeit-Sync
- [ ] PWA-Support
- [ ] Offline-Modus
- [ ] Mobile-Apps (MAUI)

---

## Breaking Changes

### v2.0.0
- ?? **Route entfernt**: `/einsatz/teams` existiert nicht mehr
  - Migration: Nutze `/einsatz/monitor` f�r Team-Verwaltung
  
- ?? **CSS-Klassen umbenannt**
  - `.teams-monitor-list` ? `.teams-monitor-grid`
  - `.monitor-team-card` ? `.team-card-monitor`
  - Alte Klassen werden nicht mehr unterst�tzt

---

## Migrationsanleitung v1 ? v2

### F�r Benutzer
1. Keine Aktion n�tig - Workflow automatisch vereinfacht
2. Teams jetzt im Monitor statt separater Seite erstellen
3. Navigation aktualisiert - ein Link weniger

### F�r Entwickler
1. `EinsatzTeams.razor` wurde gel�scht
2. Team-CRUD in `EinsatzMonitor.razor` integriert
3. Neue CSS-Klassen in `app.css` verwenden
4. Navigation in `NavMenu.razor` angepasst

---

*Stand: Januar 2024*
