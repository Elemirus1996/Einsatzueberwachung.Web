# ?? Mobile Einsatzüberwachung - Vollständige Implementierung

## ? Was wurde implementiert?

Die mobile Einsatzüberwachung ermöglicht Einsatzleitern den Zugriff auf alle wichtigen Einsatzdaten über Smartphones und Tablets im lokalen Netzwerk, mit Architektur-Vorbereitung für zukünftige externe Zugriffe.

## ?? Implementierte Funktionen

### 1. REST API für mobile Clients

#### **Einsatz-Management** (`/api/einsatz`)
- ? Einsatz-Status abfragen
- ? Alle Teams mit Live-Daten
- ? Einzelnes Team Details
- ? Team-Timer steuern (Start/Stop/Reset)
- ? Suchgebiete mit GeoJSON abrufen

#### **Thread-System** (`/api/threads`)
- ? Alle Notizen/Threads abrufen
- ? Notizen filtern nach Team
- ? Einzelne Notiz mit allen Antworten
- ? Neue Notiz erstellen
- ? Antworten zu Notizen hinzufügen
- ? Notizen und Antworten bearbeiten
- ? Antworten löschen

#### **Authentifizierung** (`/api/auth`)
- ? JWT Token-basierter Login
- ? Token-Refresh-Mechanismus
- ? Rollenbased Access (vorbereitet)

### 2. SignalR Echtzeit-Kommunikation

#### **Hub-Endpunkt**: `/hubs/einsatz`

#### **Server ? Client Events:**
- ? `EinsatzStatus` - Vollständiger Status bei Verbindung
- ? `EinsatzChanged` - Einsatz-Änderungen
- ? `TeamAdded` - Neues Team
- ? `TeamRemoved` - Team entfernt
- ? `TeamUpdated` - Team-Status-Update
- ? `TeamStatusUpdate` - Update für abonnierte Teams
- ? `TeamWarning` - Warnung ausgelöst
- ? `NewNote` - Neue Notiz
- ? `NewThreadReply` - Neue Thread-Antwort

#### **Client ? Server Methods:**
- ? `JoinTeamGroup(teamId)` - Team-Updates abonnieren
- ? `LeaveTeamGroup(teamId)` - Deabonnieren
- ? `SendThreadMessage(...)` - Thread-Nachricht senden
- ? `CreateNote(...)` - Neue Notiz erstellen
- ? `Ping()` - Health-Check

#### **Automatische Event-Weiterleitung:**
- ? SignalRBroadcastService leitet alle Domain-Events automatisch an SignalR weiter
- ? IHostedService für automatischen Start/Stop

### 3. Mobile-Optimierte Blazor Seite

#### **Route**: `/mobile`

#### **Dashboard-Features:**
- ? Touch-optimierte Bedienung
- ? Responsive Design (Smartphone bis Tablet)
- ? Quick Stats (Teams, Aktiv, Warnung, Kritisch)
- ? Live-Timer (1 Sekunde Refresh)
- ? Farbcodierte Status-Indikatoren
- ? Team-Listen mit vollständigen Details
- ? Aktuelle Meldungen/Threads (Top 10)
- ? Timer-Steuerung (Start/Stop per Button)
- ? Navigation zu Karte und Monitor
- ? Dark Mode Support

#### **Visuelle Features:**
- ? Gradient-Backgrounds für bessere Lesbarkeit
- ? Puls-Animationen für kritische Zustände
- ? Status-Dots mit Animations
- ? Monospace-Timer-Display
- ? Touch-Feedback (Scale-Animationen)

### 4. Sicherheits-Implementierung

#### **Aktuelle Sicherheitsmaßnahmen:**
- ? JWT Token-Authentifizierung
- ? Token-Lebensdauer: 1 Stunde
- ? Token-Refresh-Mechanismus
- ? HTTPS-Unterstützung vorbereitet
- ? CORS für lokales Netzwerk
- ? Query-String Token für SignalR
- ? Authorization-Header für REST API

#### **Konfigurierbar:**
```json
{
  "Jwt": {
    "Key": "Sicherer-Secret-Key",
    "Issuer": "Einsatzueberwachung",
    "Audience": "EinsatzueberwachungMobile"
  },
  "Auth": {
    "Username": "einsatzleiter",
    "Password": "sicheres-passwort"
  }
}
```

#### **Für Production vorbereitet:**
- ?? User-Datenbank mit gehashten Passwörtern
- ?? IP-Whitelist für externe Zugriffe
- ?? Rate Limiting
- ?? Audit-Logging

### 5. API-Dokumentation

#### **Swagger UI** (Development-Modus)
- ? Automatisch generiert
- ? Interaktive API-Tests
- ? Zugriff: `http://localhost:5000/swagger`

## ?? Dateistruktur

```
Einsatzueberwachung.Web/
??? Controllers/
?   ??? EinsatzController.cs       # Team-Status & Timer API
?   ??? ThreadsController.cs       # Thread-System API
?   ??? AuthController.cs          # JWT Authentifizierung
?
??? Hubs/
?   ??? EinsatzHub.cs              # SignalR Real-time Hub
?
??? Services/
?   ??? SignalRBroadcastService.cs # Event ? SignalR Bridge
?
??? Components/
?   ??? Pages/
?       ??? MobileDashboard.razor  # Mobile UI
?
??? wwwroot/
?   ??? mobile-dashboard.css       # Mobile Styles
?
??? Program.cs                      # Konfiguration mit API & SignalR
??? appsettings.json               # JWT & Auth Config
```

## ?? Schnellstart

### 1. Server starten

```bash
cd Einsatzueberwachung.Web
dotnet run
```

Server läuft auf:
- HTTP: `http://localhost:5000`
- HTTPS: `https://localhost:5001`

### 2. Netzwerk-IP ermitteln

```powershell
# Windows
ipconfig
# Notiere IPv4-Adresse, z.B.: 192.168.1.100

# Linux/Mac
ifconfig
```

### 3. Mobile Zugriff

**Von Smartphone/Tablet im gleichen WLAN:**
```
http://[SERVER-IP]:5000/mobile

Beispiel: http://192.168.1.100:5000/mobile
```

### 4. API-Test

```bash
# Login
curl -X POST http://192.168.1.100:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"einsatzleiter","password":"einsatz2024"}'

# Teams abrufen (mit Token)
curl http://192.168.1.100:5000/api/einsatz/teams \
  -H "Authorization: Bearer [TOKEN]"
```

### 5. SignalR-Verbindung

```javascript
const connection = new signalR.HubConnectionBuilder()
    .withUrl("/hubs/einsatz", {
        accessTokenFactory: () => TOKEN
    })
    .withAutomaticReconnect()
    .build();

connection.on("TeamUpdated", (team) => {
    console.log("Team Update:", team);
});

await connection.start();
```

## ?? Konfiguration

### Firewall (Windows)

```powershell
New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTP" `
    -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS" `
    -Direction Inbound -LocalPort 5001 -Protocol TCP -Action Allow
```

### Server auf allen Interfaces

```powershell
dotnet run --urls "http://0.0.0.0:5000;https://0.0.0.0:5001"
```

### appsettings.json anpassen

```json
{
  "Jwt": {
    "Key": "DEIN-SICHERER-SCHLÜSSEL-MINDESTENS-32-ZEICHEN",
    "Issuer": "Einsatzueberwachung",
    "Audience": "EinsatzueberwachungMobile"
  },
  "Auth": {
    "Username": "dein-username",
    "Password": "dein-sicheres-passwort"
  }
}
```

## ?? Nutzungs-Szenarien

### Szenario 1: Einsatzleiter im Fahrzeug
- Tablet mit Mobile Dashboard
- Live-Timer-Überwachung
- Quick Access zu Team-Status
- Meldungen lesen und antworten

### Szenario 2: Team-Koordination
- Smartphone für unterwegs
- Team-Status schnell prüfen
- Timer per Button steuern
- Wichtige Updates sofort sehen

### Szenario 3: Externe Integration
- Mobile App mit REST API
- SignalR für Push-Benachrichtigungen
- Custom UI für spezifische Workflows
- Integration mit anderen Systemen

## ?? Sicherheits-Checkliste für Production

- [ ] JWT Secret Key ändern (mindestens 32 Zeichen)
- [ ] Username/Password ändern
- [ ] HTTPS aktivieren (SSL-Zertifikat)
- [ ] CORS auf spezifische Domains einschränken
- [ ] User-Datenbank implementieren
- [ ] Passwörter hashen (BCrypt/PBKDF2)
- [ ] Rate Limiting aktivieren
- [ ] Audit-Logging einrichten
- [ ] IP-Whitelist konfigurieren
- [ ] Firewall-Regeln verifizieren

## ?? API-Endpunkte Übersicht

| Kategorie | Methode | Endpoint | Beschreibung |
|-----------|---------|----------|--------------|
| **Auth** | POST | `/api/auth/login` | Login mit JWT |
| **Auth** | POST | `/api/auth/refresh` | Token erneuern |
| **Einsatz** | GET | `/api/einsatz/status` | Einsatz-Status |
| **Einsatz** | GET | `/api/einsatz/teams` | Alle Teams |
| **Einsatz** | GET | `/api/einsatz/teams/{id}` | Einzelnes Team |
| **Einsatz** | POST | `/api/einsatz/teams/{id}/start` | Timer starten |
| **Einsatz** | POST | `/api/einsatz/teams/{id}/stop` | Timer stoppen |
| **Einsatz** | POST | `/api/einsatz/teams/{id}/reset` | Timer zurücksetzen |
| **Einsatz** | GET | `/api/einsatz/searchAreas` | Suchgebiete |
| **Threads** | GET | `/api/threads` | Alle Notizen |
| **Threads** | GET | `/api/threads?teamId={id}` | Gefilterte Notizen |
| **Threads** | GET | `/api/threads/{id}` | Notiz mit Antworten |
| **Threads** | POST | `/api/threads` | Neue Notiz |
| **Threads** | POST | `/api/threads/{id}/replies` | Antwort hinzufügen |
| **Threads** | PUT | `/api/threads/{id}` | Notiz bearbeiten |
| **Threads** | PUT | `/api/threads/replies/{id}` | Antwort bearbeiten |
| **Threads** | DELETE | `/api/threads/replies/{id}` | Antwort löschen |

## ?? UI-Features

### Status-Farben
- ?? **Grün** - Team aktiv, keine Warnung
- ?? **Gelb** - Erste Warnung
- ?? **Rot** - Zweite Warnung (Kritisch)
- ? **Grau** - Bereit (nicht gestartet)

### Animationen
- Puls-Animation bei kritischen Teams
- Status-Dot Pulse
- Timer-Blink bei Kritisch
- Touch-Scale-Feedback

### Dark Mode
- ? Vollständiger Dark Mode Support
- ? Automatische Theme-Synchronisation
- ? Optimierte Farben für mobile Geräte

## ?? Performance

### Optimierungen
- SignalR mit Automatic Reconnect
- Timer-Updates: 1 Sekunde Client-seitig
- REST API: Stateless, skalierbar
- In-Memory Domain-Services (Singleton)

### Limitierungen
- In-Memory Storage (keine Persistenz)
- Keine Offline-Unterstützung
- Keine Datei-Uploads (noch)

## ?? Fehlerbehebung

### Problem: Mobile kann nicht verbinden
**Lösung:**
1. Firewall-Regeln prüfen
2. Server auf `0.0.0.0` binden
3. Gleiche WLAN-Verbindung prüfen

### Problem: 401 Unauthorized
**Lösung:**
1. Neues Token abrufen (Login)
2. Token im `Authorization: Bearer` Header
3. Token nicht abgelaufen?

### Problem: SignalR bricht ab
**Lösung:**
1. Mobile Daten deaktivieren
2. Browser-Tab im Vordergrund
3. Auto-Lock verlängern

## ?? Weitere Dokumentation

- `MOBILE_IMPLEMENTATION.md` - Vollständige technische Dokumentation
- `MOBILE_QUICK_START.md` - Schnellstart-Anleitung für Endnutzer
- `/swagger` - Live API-Dokumentation

## ?? Roadmap

### Phase 1: Lokales Netzwerk ? FERTIG
- REST API
- SignalR Hub
- Mobile Blazor Page
- JWT Auth
- Swagger Docs

### Phase 2: Externe Zugriffe ?? TODO
- User-Datenbank
- RBAC
- VPN-Integration
- Cloud-Deployment
- Mobile App (Native)

### Phase 3: Erweiterte Features ?? GEPLANT
- Push-Benachrichtigungen
- Offline-Modus
- GPS-Tracking
- Foto-Uploads
- Voice-Messages

## ?? Beitragen

Für Verbesserungen oder Feature-Requests:
1. Issue erstellen
2. Pull Request einreichen
3. Dokumentation aktualisieren

## ?? Support

- GitHub Issues
- Dokumentation lesen
- API-Tests mit Swagger

---

**Implementiert von GitHub Copilot** ??  
**Status: Phase 1 Komplett ?**  
**Viel Erfolg beim Einsatz! ????**
