# ?? Release Notes - Version 2.5.0 "Dark Mode & Enhanced Features"

**Release Datum:** Januar 2025  
**Branch:** main  
**Tag:** v2.5.0

---

## ?? Highlights

Version 2.5.0 bringt **Dark Mode Support**, erweiterte Karten-Funktionen, verbesserte Notizen und mobile Dashboard-Features mit Echtzeit-Updates via SignalR.

### ?? Hauptfeatures

#### 1. Dark Mode System
- **Globaler Dark Mode** mit Theme Toggle
- **Persistente Theme-Einstellungen** über localStorage
- **Cross-Tab Synchronisation** - Theme wird in allen offenen Tabs synchronisiert
- **Theme Service** für zentrale Verwaltung
- **Bootstrap 5.3+ Integration** mit data-bs-theme Attribut
- **Optimierte Styles** für alle Komponenten im Dark Mode

#### 2. Mobile Dashboard
- **Route:** `/mobile`
- **Features:**
  - ?? Responsive Design für alle mobilen Geräte
  - ?? Live-Updates via SignalR
  - ?? Echtzeit Team-Übersicht
  - ?? Live-Timer mit Farbcodierung
  - ?? Chronologische Notizen-Ansicht
  - ?? Dark Mode Support

#### 3. QR-Code Verbindung
- **Route:** `/mobile/connect`
- **Features:**
  - ?? QR-Code für schnelle Verbindung
  - ?? Automatische IP-Erkennung
  - ?? PIN-geschützter Zugang
  - ?? Verbindungsanleitung
  - ?? Dark Mode Support

#### 4. Erweiterte Karten-Funktionen
- **Leaflet.js Integration** mit Zeichnen-Tools
- **Suchgebiete definieren** und Teams zuweisen
- **Gebiets-Management** mit Farben und Beschreibungen
- **Druck-Funktion** für Karten mit Legende
- **Dark Mode** für Karten-Ansicht

#### 5. Enhanced Notes System
- **Globale Notizen** mit erweiterten Funktionen
- **Team-spezifische Notizen**
- **Notiz-Historie** mit Zeitstempel
- **Antworten-System** (Threads)
- **Verschiedene Notiz-Typen** (Manual, System, Warnings)
- **Dark Mode** optimiert

#### 6. Netzwerk-Server
- **Start:** `START_NETWORK_SERVER.bat`
- **Features:**
  - ?? Zugriff über lokales Netzwerk
  - ?? Automatische Firewall-Konfiguration
  - ?? Sichere JWT-Authentifizierung

---

## ?? Zielgruppe

- **Einsatzleiter:** Desktop-Version für vollständige Kontrolle
- **Einsatzkräfte:** Mobile Dashboard für schnellen Überblick im Feld
- **Gruppenführer:** Tablet-Version für mittlere Bildschirme
- **Alle Nutzer:** Dark Mode für bessere Lesbarkeit bei Tag und Nacht

---

## ?? Technische Details

### Abhängigkeiten
```xml
<PackageReference Include="Microsoft.AspNetCore.SignalR.Client" Version="8.0.0" />
<PackageReference Include="Microsoft.AspNetCore.Authentication.JwtBearer" Version="8.0.0" />
<PackageReference Include="QRCoder" Version="1.4.3" />
<PackageReference Include="Swashbuckle.AspNetCore" Version="6.5.0" />
<PackageReference Include="QuestPDF" Version="2025.7.4" />
```

### Wichtige Dateien
```
Einsatzueberwachung.Web/
??? Components/
?   ??? Pages/
?   ?   ??? MobileDashboard.razor          # Mobile Hauptansicht
?   ?   ??? MobileConnect.razor            # QR-Code Seite
?   ?   ??? EinsatzMonitor.razor           # Monitor mit Dark Mode
?   ?   ??? EinsatzKarte.razor             # Karten-Ansicht
?   ?   ??? EinsatzBericht.razor           # PDF Export
?   ??? Shared/
?   ?   ??? NotesEnhanced.razor            # Erweiterte Notizen
?   ?   ??? TeamDialog.razor               # Team-Verwaltung
?   ?   ??? PageBase.razor                 # Base-Component mit Theme
?   ?   ??? Icon.razor                     # Icon-System
?   ??? Layout/
?       ??? MainLayout.razor               # Theme-Integration
?       ??? NavMenu.razor                  # Theme Toggle
??? Controllers/
?   ??? AuthController.cs                  # PIN-Authentifizierung
?   ??? EinsatzController.cs               # Mobile API
?   ??? ThreadsController.cs               # Notes-Threads API
?   ??? NetworkController.cs               # Netzwerk-Info
??? Hubs/
?   ??? EinsatzHub.cs                      # SignalR Hub
??? Services/
?   ??? SignalRBroadcastService.cs         # Broadcast Service
??? wwwroot/
    ??? dark-mode-base.css                 # Dark Mode Basis-Styles
    ??? theme-sync.js                      # Theme Synchronisation
    ??? mobile-dashboard.css               # Mobile Styles
    ??? mobile-connect.css                 # Connect Styles
    ??? notes-enhanced.css                 # Notes Styles
    ??? leaflet-custom.css                 # Karten Styles
    ??? leaflet-interop.js                 # Leaflet Integration
    ??? audio-alerts.js                    # Audio System

Einsatzueberwachung.Domain/
??? Services/
?   ??? ThemeService.cs                    # Theme-Verwaltung
?   ??? PdfExportService.cs                # PDF-Export mit QuestPDF
?   ??? EinsatzService.cs                  # Einsatz-Logik
?   ??? MasterDataService.cs               # Stammdaten
?   ??? SettingsService.cs                 # Einstellungen
?   ??? ToastService.cs                    # Toast-Benachrichtigungen
??? Models/
    ??? GlobalNotesEntry.cs                # Globale Notizen
    ??? GlobalNotesReply.cs                # Notiz-Antworten
    ??? GlobalNotesHistory.cs              # Notiz-Historie

Scripts/
??? Configure-Firewall.ps1                 # Firewall Setup
??? test-dark-mode.ps1                     # Dark Mode Tests
??? START_NETWORK_SERVER.bat               # Network Starter

Dokumentation/
??? DARK_MODE_QUICKSTART.md
??? DARK_MODE_VISUAL_SUMMARY.md
??? DARK_MODE_IMPLEMENTATION.md
??? DARK_MODE_GLOBAL_FIX.md
??? THEME_PERSISTENCE_FIX.md
??? THEME_SYNC_SYSTEM.md
??? KARTEN_QUICKSTART.md
??? KARTEN_FUNKTIONALITAET.md
??? KARTEN_IMPLEMENTIERUNG.md
??? NOTES_ENHANCED_DOCUMENTATION.md
??? MOBILE_README.md
??? MOBILE_QUICK_START.md
??? MOBILE_NETWORK_ACCESS.md
??? MOBILE_QR_VISUAL_GUIDE.md
```

---

## ?? Installation

### 1. Repository klonen
```bash
git clone https://github.com/Elemirus1996/Einsatzueberwachung.Web.git
cd Einsatzueberwachung.Web
```

### 2. Checkout Version 2.5.0
```bash
git checkout v2.5.0
```

### 3. Pakete wiederherstellen
```bash
dotnet restore
```

### 4. Starten

**Desktop-Version (nur lokal):**
```bash
cd Einsatzueberwachung.Web
dotnet run
```

**Mit Mobile Dashboard (Netzwerk):**
```batch
START_NETWORK_SERVER.bat
```

Oder manuell:
```powershell
.\Scripts\Configure-Firewall.ps1
cd Einsatzueberwachung.Web
dotnet run --urls "http://0.0.0.0:5000"
```

### 5. Mobile Verbindung
1. Desktop: Browser zu `http://localhost:5000/mobile/connect`
2. QR-Code mit Smartphone scannen
3. PIN eingeben: `1234`
4. Mobile Dashboard öffnet sich automatisch

### 6. Dark Mode nutzen
- **Toggle Button** in der Navigation (Sonne/Mond Icon)
- **Theme wird gespeichert** und bei jedem Start geladen
- **Cross-Tab Sync** - Änderungen werden in allen offenen Tabs übernommen

---

## ?? Sicherheit

### Standard-PIN
- **PIN:** `1234`
- **Ändern in:** `appsettings.json`
  ```json
  {
    "MobileSettings": {
      "AccessPin": "IHRE_PIN"
    }
  }
  ```

### JWT-Konfiguration
- **Secret:** Automatisch generiert
- **Lifetime:** 24 Stunden
- **Ändern in:** `appsettings.json`

### Firewall
- **Port:** 5000
- **Regel:** "Einsatzueberwachung Web Server"
- **Automatisch:** Via `Configure-Firewall.ps1`

---

## ?? Testen

### Lokaler Test
1. Server starten
2. Browser: `http://localhost:5000`
3. Desktop-Version testen
4. Dark Mode testen (Toggle in Navigation)

### Netzwerk-Test
1. `START_NETWORK_SERVER.bat` ausführen
2. Browser: `http://localhost:5000/mobile/connect`
3. QR-Code scannen oder mobile URL manuell eingeben
4. PIN eingeben
5. Mobile Dashboard testen

### SignalR-Test
1. Zwei Geräte verbinden (Desktop + Mobile)
2. Team im Desktop-Monitor erstellen
3. Prüfen: Erscheint sofort auf Mobile
4. Timer auf Desktop starten
5. Prüfen: Timer läuft auf Mobile mit

### Dark Mode Test
1. PowerShell: `.\Scripts\test-dark-mode.ps1`
2. Oder manuell Theme Toggle testen
3. Mehrere Browser-Tabs öffnen
4. Theme in einem Tab ändern
5. Prüfen: Alle Tabs wechseln synchron

---

## ?? Bekannte Probleme

### Keine kritischen Bugs bekannt

**Kleinere Einschränkungen:**
- Mobile Dashboard ist nur lesend (by design)
- QR-Code funktioniert nur im lokalen Netzwerk
- Bei IP-Wechsel muss QR-Code neu gescannt werden

---

## ?? Dokumentation

Vollständige Dokumentation in:
- `README.md` - Hauptdokumentation
- `DARK_MODE_QUICKSTART.md` - Dark Mode Guide
- `KARTEN_QUICKSTART.md` - Karten-Guide
- `MOBILE_QUICK_START.md` - Mobile Guide
- `NOTES_ENHANCED_DOCUMENTATION.md` - Notes System

---

## ?? Migration von v1.5/v2.0

**Keine Breaking Changes!**

Version 2.5.0 ist vollständig rückwärtskompatibel. Alle bestehenden Features funktionieren weiterhin.

**Neue Features sind optional:**
- Dark Mode kann genutzt werden, ist aber optional (Standard: Light Mode)
- Erweiterte Karten-Funktionen bauen auf bestehenden auf
- Enhanced Notes System ist abwärtskompatibel
- Mobile Dashboard funktioniert wie bisher

**Empfohlene Schritte:**
1. Dark Mode ausprobieren (Theme Toggle in Navigation)
2. Karten-Zeichnen-Tools testen
3. Enhanced Notes System nutzen
4. PDF-Export mit QuestPDF testen

---

## ?? Changelog (v1.5 ? v2.5)

### ? Neue Features
- **Dark Mode System** mit Cross-Tab Synchronisation
- **Theme Service** für zentrale Theme-Verwaltung
- **Erweiterte Karten-Funktionen** mit Zeichnen-Tools
- **Enhanced Notes System** mit Threads und Antworten
- **QuestPDF Integration** für professionelle PDF-Exporte
- **Toast-Benachrichtigungen** für besseres UX
- **Audio-Alerts** für Warnungen

### ?? Verbesserungen
- **Performance-Optimierungen** in SignalR
- **Besseres Error Handling** in allen Services
- **Responsive Design** Verbesserungen
- **Icon-System** mit Bootstrap Icons
- **Code-Cleanup** und Refactoring

### ?? Bugfixes
- Theme-Persistenz über Page-Reloads
- SignalR Verbindungsprobleme behoben
- Mobile Dashboard Responsive-Issues gefixt
- Karten-Druck-Probleme gelöst

---

## ?? Credits

Entwickelt für Rettungshundestaffeln von:
- **Elemirus1996**

**Feedback & Issues:**
- GitHub: https://github.com/Elemirus1996/Einsatzueberwachung.Web/issues

---

## ?? Nächste Schritte (v3.0)

- [ ] Entity Framework + SQLite für Persistenz
- [ ] Einsatz-Historie und Archivierung
- [ ] Export-Funktionen (Excel, CSV)
- [ ] Multi-User Support mit Rollen
- [ ] GPS-Integration für Live-Tracking
- [ ] Erweiterte Statistiken und Reports

---

**? Wenn dieses Projekt hilfreich ist, gib bitte einen Stern auf GitHub!**
