# ?? Release Notes - Version 1.5.0 "Mobile Dashboard"

**Release Datum:** Januar 2025  
**Branch:** main  
**Tag:** v1.5.0

---

## ?? Highlights

Version 1.5.0 bringt das **Mobile Dashboard** - eine vollständig mobile-optimierte Ansicht für Einsatzkräfte mit Echtzeit-Updates via SignalR.

### ?? Hauptfeatures

#### 1. Mobile Dashboard
- **Route:** `/mobile/dashboard`
- **Features:**
  - ?? Responsive Design für alle mobilen Geräte
  - ?? Live-Updates via SignalR
  - ?? Echtzeit Team-Übersicht
  - ?? Live-Timer mit Farbcodierung
  - ?? Chronologische Notizen-Ansicht

#### 2. QR-Code Verbindung
- **Route:** `/mobile/connect`
- **Features:**
  - ?? QR-Code für schnelle Verbindung
  - ?? Automatische IP-Erkennung
  - ?? PIN-geschützter Zugang
  - ?? Verbindungsanleitung

#### 3. Netzwerk-Server
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

---

## ?? Technische Details

### Neue Abhängigkeiten
```xml
<PackageReference Include="Microsoft.AspNetCore.SignalR.Client" Version="8.0.0" />
<PackageReference Include="Microsoft.AspNetCore.Authentication.JwtBearer" Version="8.0.0" />
<PackageReference Include="QRCoder" Version="1.4.3" />
<PackageReference Include="Swashbuckle.AspNetCore" Version="6.5.0" />
```

### Neue Dateien
```
Einsatzueberwachung.Web/
??? Components/Pages/
?   ??? MobileDashboard.razor          # Mobile Hauptansicht
?   ??? MobileConnect.razor            # QR-Code Seite
??? Controllers/
?   ??? AuthController.cs              # PIN-Authentifizierung
?   ??? EinsatzController.cs           # Mobile API
?   ??? NetworkController.cs           # Netzwerk-Info
??? Hubs/
?   ??? EinsatzHub.cs                  # SignalR Hub
??? Services/
?   ??? SignalRBroadcastService.cs     # Broadcast Service
??? wwwroot/
    ??? mobile-dashboard.css           # Mobile Styles
    ??? mobile-connect.css             # Connect Styles

Scripts/
??? Configure-Firewall.ps1             # Firewall Setup
??? START_NETWORK_SERVER.bat           # Network Starter

Dokumentation/
??? MOBILE_README.md
??? MOBILE_QUICK_START.md
??? MOBILE_DEPLOYMENT_CHECKLIST.md
??? MOBILE_VISUAL_GUIDE.md
??? MOBILE_SUMMARY.md
??? MOBILE_IMPLEMENTATION.md
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

### 2. Checkout Version 1.5.0
```bash
git checkout v1.5.0
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
- `MOBILE_README.md` - Hauptdokumentation
- `MOBILE_QUICK_START.md` - Schnellstart
- `MOBILE_VISUAL_GUIDE.md` - Visueller Guide

---

## ?? Migration von v1.0/v2.0

**Keine Breaking Changes!**

Version 1.5.0 ist vollständig rückwärtskompatibel. Alle bestehenden Features funktionieren weiterhin.

**Neue Features sind optional:**
- Mobile Dashboard kann genutzt werden, muss aber nicht
- Ohne Netzwerk-Start funktioniert alles wie bisher
- Keine Code-Änderungen in bestehenden Komponenten

---

## ?? Credits

Entwickelt für Rettungshundestaffeln von:
- **Elemirus1996**

**Feedback & Issues:**
- GitHub: https://github.com/Elemirus1996/Einsatzueberwachung.Web/issues

---

## ?? Nächste Schritte (v2.0)

- [ ] Leaflet.js Karten-Integration
- [ ] QuestPDF für professionelle Berichte
- [ ] Entity Framework + SQLite
- [ ] Einsatz-Historie

---

**? Wenn dieses Projekt hilfreich ist, gib bitte einen Stern auf GitHub!**

