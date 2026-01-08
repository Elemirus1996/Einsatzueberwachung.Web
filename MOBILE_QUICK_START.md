# ?? Mobile Einsatzüberwachung - Quick Start Guide

## Schnellstart für Einsatzleiter

### 1. Server starten

```powershell
# Im Projektverzeichnis
cd Einsatzueberwachung.Web
dotnet run
```

Server läuft auf:
- HTTP: `http://localhost:5000`
- HTTPS: `https://localhost:5001`

### 2. Mobile Zugriff im lokalen Netzwerk

#### Server-IP ermitteln (Windows)
```powershell
ipconfig
# Notiere die IPv4-Adresse, z.B.: 192.168.1.100
```

#### Von mobilem Gerät (Smartphone/Tablet)

**Schritt 1: Gleiche WLAN-Verbindung**
- Stelle sicher, dass dein mobiles Gerät im gleichen WLAN wie der Server ist

**Schritt 2: Browser öffnen**
- Chrome, Safari, oder Firefox auf dem mobilen Gerät

**Schritt 3: Mobile Dashboard aufrufen**
```
http://[SERVER-IP]:5000/mobile

Beispiel: http://192.168.1.100:5000/mobile
```

### 3. Mobile Dashboard Features

#### Dashboard-Übersicht
- ? Team-Anzahl (Gesamt, Aktiv, Warnung, Kritisch)
- ? Live-Timer für alle Teams
- ? Status-Indikatoren
- ? Aktuelle Meldungen/Threads
- ? Timer-Steuerung (Start/Stop)

#### Status-Farben
- ?? **Grün** = Team aktiv, keine Warnung
- ?? **Gelb** = Erste Warnung erreicht
- ?? **Rot** = Zweite Warnung (Kritisch)
- ? **Grau** = Team bereit (nicht gestartet)

#### Touch-Bedienung
- **Tippen auf Team-Karte** = Details anzeigen
- **Start/Stop-Button** = Timer steuern
- **Nach oben scrollen** = Updates laden
- **Wischen** = Durch Meldungen navigieren

### 4. API-Zugriff (für Entwickler)

#### Login und Token abrufen
```bash
curl -X POST http://192.168.1.100:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"einsatzleiter","password":"einsatz2024"}'

# Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "einsatzleiter",
  "role": "Einsatzleiter",
  "expiresIn": 3600
}
```

#### Teams abrufen
```bash
curl http://192.168.1.100:5000/api/einsatz/teams \
  -H "Authorization: Bearer [TOKEN]"
```

#### Thread-Nachricht senden
```bash
curl -X POST http://192.168.1.100:5000/api/threads \
  -H "Authorization: Bearer [TOKEN]" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Update vom Einsatzleiter",
    "sourceTeamName": "Einsatzleitung",
    "sourceType": "Einsatzleitung"
  }'
```

### 5. Swagger API-Dokumentation

Nur im Development-Modus:
```
http://localhost:5000/swagger
```

Vollständige API-Dokumentation mit interaktiven Tests.

### 6. Fehlerbehebung

#### Problem: Mobile Gerät kann nicht verbinden

**Lösung 1: Firewall-Regel prüfen**
```powershell
# Windows Firewall öffnen
New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTP" `
    -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

**Lösung 2: Server auf allen Interfaces starten**
```powershell
dotnet run --urls "http://0.0.0.0:5000"
```

**Lösung 3: Netzwerk-Verbindung prüfen**
```powershell
# Auf mobilem Gerät (Browser)
http://[SERVER-IP]:5000/api/einsatz/status

# Sollte JSON zurückgeben
```

#### Problem: "401 Unauthorized" bei API-Aufrufen

**Lösung:**
- Token abgelaufen? Neues Token mit `/api/auth/login` abrufen
- Token korrekt im `Authorization: Bearer [TOKEN]` Header?
- Username/Password korrekt?

#### Problem: SignalR-Verbindung bricht ab

**Lösung:**
- Mobile Daten aus, nur WLAN verwenden
- Browser-Tab im Vordergrund lassen
- Auto-Lock des Geräts verlängern

### 7. Netzwerk-Konfiguration

#### Server für LAN freigeben
```powershell
# appsettings.json anpassen (optional)
{
  "Urls": "http://0.0.0.0:5000;https://0.0.0.0:5001"
}
```

#### Router-Einstellungen (für externe Zugriffe)
?? **NICHT EMPFOHLEN für Phase 1**
- Port-Forwarding: 5000 ? Server-IP
- Dynamisches DNS (DDNS) einrichten
- **Besser:** VPN-Tunnel verwenden

### 8. Tipps für den Einsatz

#### Optimale Nutzung
1. **Tablet** als mobile Kommandozentrale
2. **Smartphone** für schnelle Status-Checks
3. **Browser-Tab offen lassen** für Live-Updates
4. **Bildschirm-Timeout erhöhen** (Geräte-Einstellungen)

#### Akku-Schonend
- Dark Mode aktivieren (falls verfügbar)
- Bildschirm-Helligkeit reduzieren
- Nicht benötigte Apps schließen
- Powerbank bereithalten

#### Netzwerk-Stabilität
- Router in Einsatznähe platzieren
- Mobilen Hotspot als Backup
- Signalstärke regelmäßig prüfen

### 9. Cheat Sheet

| Aktion | URL/Befehl |
|--------|------------|
| Mobile Dashboard | `http://[IP]:5000/mobile` |
| Login API | `POST /api/auth/login` |
| Teams abrufen | `GET /api/einsatz/teams` |
| Team-Timer starten | `POST /api/einsatz/teams/{id}/start` |
| Threads abrufen | `GET /api/threads` |
| Neue Notiz | `POST /api/threads` |
| Swagger UI | `http://localhost:5000/swagger` |

### 10. Standard-Credentials

**?? WICHTIG: Für Produktionsumgebung ändern!**

```
Username: einsatzleiter
Password: einsatz2024
```

Konfiguration in `appsettings.json`:
```json
"Auth": {
  "Username": "einsatzleiter",
  "Password": "einsatz2024"
}
```

### 11. Weitere Seiten

| Seite | URL | Beschreibung |
|-------|-----|--------------|
| Home | `/` | Startseite |
| Einsatz Start | `/einsatz/start` | Neuen Einsatz starten |
| Monitor | `/einsatz/monitor` | Haupt-Monitor |
| Karte | `/einsatz/karte` | Interaktive Karte |
| Mobile Dashboard | `/mobile` | Mobile Ansicht |

### 12. Support

Bei Problemen:
1. Logs prüfen: Console-Output des Servers
2. Browser-Console öffnen (F12)
3. Netzwerk-Tab prüfen (failed requests?)
4. Documentation lesen: `MOBILE_IMPLEMENTATION.md`

## ?? Nächste Schritte

Nach dem Quick Start:
1. ? Mobile Dashboard testen
2. ? API-Endpunkte ausprobieren
3. ? SignalR Live-Updates verifizieren
4. ?? Vollständige Dokumentation lesen
5. ?? Sicherheitseinstellungen für Production anpassen

---

**Viel Erfolg beim Einsatz! ????**
