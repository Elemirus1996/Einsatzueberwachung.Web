# Mobile Einsatzüberwachung - Implementierung

## Übersicht

Die mobile Einsatzüberwachung ermöglicht dem Einsatzleiter den Zugriff auf kritische Einsatzdaten über mobile Geräte (Smartphones/Tablets) im lokalen Netzwerk (Phase 1) mit Vorbereitung für externen Zugriff (Phase 2).

## ?? Implementierte Features

### Phase 1: Lokales Netzwerk (? ABGESCHLOSSEN)

#### 1. REST API Endpunkte

**Einsatz-Controller** (`/api/einsatz`)
- `GET /api/einsatz/status` - Aktueller Einsatz-Status
- `GET /api/einsatz/teams` - Alle Teams mit Status
- `GET /api/einsatz/teams/{teamId}` - Einzelnes Team
- `POST /api/einsatz/teams/{teamId}/start` - Timer starten
- `POST /api/einsatz/teams/{teamId}/stop` - Timer stoppen
- `POST /api/einsatz/teams/{teamId}/reset` - Timer zurücksetzen
- `GET /api/einsatz/searchAreas` - Suchgebiete mit GeoJSON

**Thread-Controller** (`/api/threads`)
- `GET /api/threads` - Alle Notes/Threads (optional: ?teamId=xyz)
- `GET /api/threads/{noteId}` - Einzelne Note mit Antworten
- `POST /api/threads` - Neue Note erstellen
- `POST /api/threads/{noteId}/replies` - Antwort hinzufügen
- `GET /api/threads/{noteId}/replies` - Alle Antworten
- `PUT /api/threads/{noteId}` - Note bearbeiten
- `PUT /api/threads/replies/{replyId}` - Antwort bearbeiten
- `DELETE /api/threads/replies/{replyId}` - Antwort löschen

**Auth-Controller** (`/api/auth`)
- `POST /api/auth/login` - Login mit JWT Token
- `POST /api/auth/refresh` - Token erneuern

#### 2. SignalR Echtzeit-Kommunikation

**Hub**: `/hubs/einsatz`

**Server ? Client Events:**
- `EinsatzStatus` - Initial Status bei Verbindung
- `EinsatzChanged` - Einsatz-Daten geändert
- `TeamAdded` - Neues Team hinzugefügt
- `TeamRemoved` - Team entfernt
- `TeamUpdated` - Team-Status aktualisiert
- `TeamStatusUpdate` - Update für abonniertes Team
- `TeamWarning` - Warnung ausgelöst
- `NewNote` - Neue Notiz/Thread
- `NewThreadReply` - Neue Antwort in Thread

**Client ? Server Methods:**
- `JoinTeamGroup(teamId)` - Team-Updates abonnieren
- `LeaveTeamGroup(teamId)` - Team-Updates deabonnieren
- `SendThreadMessage(noteId, text, sourceTeamId, sourceTeamName)` - Thread-Antwort senden
- `CreateNote(text, sourceTeamId, sourceTeamName, sourceType)` - Neue Notiz erstellen
- `Ping()` - Connection Health-Check

#### 3. Mobile-Optimierte Blazor Seite

**Route**: `/mobile`

**Features:**
- Touch-optimierte Bedienung
- Responsive Design für alle Bildschirmgrößen
- Echtzeit-Timer-Updates (1 Sekunde Refresh)
- Farbcodierte Status-Indikatoren
- Quick Stats Dashboard
- Team-Listen mit Statusanzeige
- Aktuelle Meldungen/Threads
- Quick Actions (Karte, Timer-Steuerung)

#### 4. Authentifizierung & Sicherheit

**JWT Token-basiert:**
- Issuer: "Einsatzueberwachung"
- Audience: "EinsatzueberwachungMobile"
- Token-Lebensdauer: 1 Stunde
- Token-Refresh möglich

**Konfigurierbare Credentials:**
```json
"Auth": {
  "Username": "einsatzleiter",
  "Password": "einsatz2024"
}
```

**HINWEIS:** Für Production sollte eine User-Datenbank mit gehashten Passwörtern implementiert werden!

#### 5. CORS-Konfiguration

Aktuell: `AllowAnyOrigin()` für Entwicklung
Für Production: Einschränken auf spezifische IP-Ranges

```json
"Mobile": {
  "EnableExternalAccess": false,
  "AllowedIpRanges": [
    "192.168.0.0/16",
    "10.0.0.0/8"
  ]
}
```

## ?? Nutzung

### Mobile Web-Oberfläche

1. **Zugriff über Browser:**
   ```
   http://[SERVER-IP]:5000/mobile
   https://[SERVER-IP]:5001/mobile
   ```

2. **Features:**
   - Dashboard mit Team-Übersicht
   - Echtzeit-Timer
   - Status-Indikatoren (Bereit, Aktiv, Warnung, Kritisch)
   - Aktuelle Meldungen
   - Timer-Steuerung (Start/Stop)
   - Navigation zu Karte und Monitor

### API-Zugriff (für Mobile Apps)

#### 1. Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "username": "einsatzleiter",
  "password": "einsatz2024"
}

# Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "einsatzleiter",
  "role": "Einsatzleiter",
  "expiresIn": 3600
}
```

#### 2. Teams abrufen
```bash
GET /api/einsatz/teams
Authorization: Bearer [TOKEN]

# Response:
[
  {
    "teamId": "...",
    "teamName": "HT-1 Max",
    "dogName": "Max",
    "elapsedTime": "00:15:30",
    "isRunning": true,
    "status": "Im Einsatz"
  }
]
```

#### 3. Thread-Nachricht senden
```bash
POST /api/threads/{noteId}/replies
Authorization: Bearer [TOKEN]
Content-Type: application/json

{
  "text": "Team im Suchgebiet angekommen",
  "sourceTeamId": "mobile",
  "sourceTeamName": "Einsatzleiter Mobile"
}
```

### SignalR Verbindung (JavaScript Beispiel)

```javascript
const connection = new signalR.HubConnectionBuilder()
    .withUrl("/hubs/einsatz", {
        accessTokenFactory: () => TOKEN
    })
    .withAutomaticReconnect()
    .build();

// Events empfangen
connection.on("TeamUpdated", (team) => {
    console.log("Team Update:", team);
    updateUI(team);
});

connection.on("NewNote", (note) => {
    console.log("Neue Notiz:", note);
    addNoteToList(note);
});

// Starten
await connection.start();

// Team abonnieren
await connection.invoke("JoinTeamGroup", "team-123");

// Nachricht senden
await connection.invoke("SendThreadMessage", 
    "note-456", 
    "Nachricht von Mobile",
    "mobile",
    "Einsatzleiter Mobile"
);
```

## ??? Architektur

### Komponenten

```
Einsatzueberwachung.Web/
??? Controllers/
?   ??? EinsatzController.cs       # Einsatz-Daten API
?   ??? ThreadsController.cs       # Thread-System API
?   ??? AuthController.cs          # Authentifizierung
??? Hubs/
?   ??? EinsatzHub.cs              # SignalR Hub
??? Services/
?   ??? SignalRBroadcastService.cs # Event ? SignalR Bridge
??? Components/Pages/
?   ??? MobileDashboard.razor      # Mobile UI
??? wwwroot/
    ??? mobile-dashboard.css       # Mobile Styles
```

### Event-Flow

```
Domain Event (z.B. TeamUpdated)
    ?
SignalRBroadcastService (IHostedService)
    ?
EinsatzHub (SignalR)
    ?
Alle verbundenen Clients (Mobile, Web)
```

### Datenfluss

```
Mobile Client
    ? HTTP/REST
API Controller ? IEinsatzService
    ? Domain Events
SignalRBroadcastService
    ? SignalR
Alle Clients (Real-time Update)
```

## ?? Sicherheit

### Aktuelle Implementierung (Phase 1)

- ? JWT Token-basierte Authentifizierung
- ? HTTPS-Unterstützung vorbereitet
- ? CORS für lokales Netzwerk
- ? Token-Refresh-Mechanismus
- ?? Einfache Username/Password-Validierung

### Für Production (Phase 2)

- [ ] User-Datenbank mit gehashten Passwörtern
- [ ] Role-based Access Control (RBAC)
- [ ] IP-Whitelist für externe Zugriffe
- [ ] VPN-Tunnel oder Cloud-Deployment
- [ ] Rate Limiting
- [ ] Audit-Logging
- [ ] Two-Factor Authentication (2FA)

## ?? Netzwerk-Konfiguration

### Phase 1: Lokales Netzwerk

**Server-Konfiguration:**
```bash
# Server auf allen Netzwerk-Interfaces
dotnet run --urls "http://0.0.0.0:5000;https://0.0.0.0:5001"
```

**Firewall (Windows):**
```powershell
New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTP" `
    -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS" `
    -Direction Inbound -LocalPort 5001 -Protocol TCP -Action Allow
```

**Zugriff von mobilen Geräten:**
```
http://[SERVER-IP]:5000/mobile
```

### Phase 2: Externe Zugriffe (Vorbereitet)

**Option A: VPN-Tunnel**
- OpenVPN oder WireGuard
- Sichere Verbindung zum lokalen Netzwerk
- Keine Port-Freigaben nötig

**Option B: Cloud-Deployment**
- Azure App Service
- Docker Container
- Reverse Proxy (nginx/Apache)

**Option C: Hybrid (empfohlen)**
- Lokaler Server für primäre Nutzung
- Cloud-Backup für Notfallzugriff
- Datensynchronisation

## ?? Swagger API Dokumentation

Im Development-Modus verfügbar:
```
http://localhost:5000/swagger
```

## ?? Testing

### API-Tests (PowerShell)

```powershell
# Login
$response = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" `
    -Method POST `
    -ContentType "application/json" `
    -Body '{"username":"einsatzleiter","password":"einsatz2024"}'

$token = $response.token

# Teams abrufen
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:5000/api/einsatz/teams" `
    -Headers $headers
```

### SignalR-Test (Browser Console)

```javascript
const connection = new signalR.HubConnectionBuilder()
    .withUrl("/hubs/einsatz")
    .build();

connection.on("TeamUpdated", console.log);
await connection.start();
console.log("Verbunden!");
```

## ?? Entwicklungs-Roadmap

### ? Phase 1: Lokales Netzwerk (FERTIG)
- REST API
- SignalR Hub
- Mobile Blazor Page
- JWT Authentifizierung
- CORS für LAN

### ?? Phase 2: Externe Zugriffe (TODO)
- [ ] User-Datenbank
- [ ] RBAC Implementation
- [ ] VPN-Integration
- [ ] Cloud-Deployment Scripts
- [ ] Mobile App (React Native/Flutter)

### ?? Phase 3: Erweiterungen (GEPLANT)
- [ ] Push-Benachrichtigungen (FCM/APNS)
- [ ] Offline-Fähigkeit (Service Worker)
- [ ] GPS-Tracking Integration
- [ ] Foto-Upload für Threads
- [ ] Voice-Messages
- [ ] Team-to-Team Chat

## ?? Bekannte Einschränkungen

1. **Authentifizierung**: Aktuell einfache Username/Password-Validierung ohne Datenbank
2. **CORS**: Im Development-Modus sehr permissiv (`AllowAnyOrigin`)
3. **Offline**: Keine Offline-Unterstützung (erfordert Service Worker)
4. **Attachments**: Noch keine Datei-Uploads in Threads
5. **Timer-Sync**: Timer-Updates jede Sekunde (könnte optimiert werden)

## ?? Support & Kontakt

Bei Fragen zur Mobile-Implementierung:
- Repository Issues erstellen
- Dokumentation lesen
- API-Tests durchführen

## ?? Lizenz

Teil des Einsatzueberwachung-Projekts
