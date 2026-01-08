# ?? Mobile Zugriff über Netzwerk - Schnellstart

## ?? In 3 Schritten zum mobilen Zugriff

### Schritt 1: Firewall konfigurieren (Einmalig)

**Als Administrator ausführen:**

**Option A: Automatisches PowerShell-Script**
```powershell
# Rechtsklick auf Datei ? "Als Administrator ausführen"
Scripts\Configure-Firewall.ps1
```

**Option B: Manuell**
```powershell
New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTP" `
    -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS" `
    -Direction Inbound -LocalPort 5001 -Protocol TCP -Action Allow
```

### Schritt 2: Server im Netzwerk-Modus starten

**Einfach starten:**
```cmd
START_NETWORK_SERVER.bat
```

Der Server startet auf allen Netzwerk-Interfaces:
- HTTP: `http://0.0.0.0:5000`
- HTTPS: `https://0.0.0.0:5001`

### Schritt 3: QR-Code scannen

1. **Am Desktop/Laptop:** Browser öffnen
   ```
   http://localhost:5000/mobile/connect
   ```

2. **QR-Code scannen** mit Smartphone/Tablet

3. **Fertig!** Mobile Dashboard öffnet sich automatisch

---

## ?? Detaillierte Anleitung

### Server-IP ermitteln

**Windows PowerShell:**
```powershell
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" }
```

**Windows CMD:**
```cmd
ipconfig | findstr "IPv4"
```

**Beispiel-Ausgabe:**
```
IPv4-Adresse: 192.168.1.100
```

### Manuelle Verbindung (ohne QR-Code)

Wenn QR-Code-Scanning nicht funktioniert, URL manuell eingeben:

```
http://[IHRE-IP]:5000/mobile

Beispiel: http://192.168.1.100:5000/mobile
```

### Verfügbare URLs

| Zweck | URL | Beschreibung |
|-------|-----|--------------|
| **Desktop-Ansicht** | `http://localhost:5000` | Normale Ansicht am Server |
| **QR-Code-Seite** | `http://localhost:5000/mobile/connect` | QR-Codes für alle Netzwerk-IPs |
| **Mobile Dashboard** | `http://[IP]:5000/mobile` | Touch-optimierte Ansicht |
| **API-Docs** | `http://localhost:5000/swagger` | Swagger API-Dokumentation |

---

## ?? Problembehandlung

### Problem 1: "Keine Verbindung möglich"

**Checkliste:**
1. ? Firewall-Regel erstellt?
2. ? Server läuft?
3. ? Smartphone im gleichen WLAN?
4. ? Richtige IP-Adresse?

**Lösung:**
```powershell
# 1. Firewall prüfen
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*Einsatzueberwachung*" }

# 2. Server-Status prüfen
Test-NetConnection -ComputerName localhost -Port 5000

# 3. IP prüfen (am Server)
ipconfig

# 4. Verbindung testen (vom Smartphone)
# Browser öffnen: http://[SERVER-IP]:5000/api/network/info
```

### Problem 2: "QR-Code wird nicht generiert"

**Ursache:** Keine Netzwerk-IP gefunden

**Lösung:**
1. Netzwerkverbindung prüfen (WLAN/LAN aktiv?)
2. Server neu starten
3. Browser-Cache leeren (Strg+F5)

### Problem 3: "Mobile Dashboard lädt nicht"

**Lösung:**
```
1. URL direkt eingeben: http://[IP]:5000/mobile
2. Browser-Konsole öffnen (F12) ? Fehler prüfen
3. Server-Logs prüfen
```

---

## ?? Netzwerk-Konfiguration

### Lokales Netzwerk (Standard)

```
???????????????
?   Router    ?
? 192.168.1.1 ?
???????????????
       ?
       ???? Server (Desktop)
       ?    192.168.1.100:5000
       ?
       ???? Tablet
       ?    192.168.1.101
       ?
       ???? Smartphone
            192.168.1.102
```

**Alle Geräte müssen im gleichen Netzwerk sein!**

### Externe Zugriffe (Zukünftig)

Für Zugriffe von außerhalb des lokalen Netzwerks:

**Option A: VPN (empfohlen)**
- WireGuard oder OpenVPN
- Sicherer Tunnel ins lokale Netz

**Option B: Port-Forwarding (nicht empfohlen für Phase 1)**
- Router-Konfiguration erforderlich
- Sicherheitsrisiko ohne HTTPS

**Option C: Cloud-Deployment**
- Azure App Service
- Docker Container
- Automatisches SSL

---

## ?? Mobile Geräte einrichten

### iOS (iPhone/iPad)

1. **Kamera-App öffnen**
2. **QR-Code scannen**
3. **Benachrichtigung antippen** ("In Safari öffnen")
4. **Zum Homescreen hinzufügen** (optional):
   - Teilen-Button ? "Zum Home-Bildschirm"
   - App-Icon wird erstellt

### Android (Smartphone/Tablet)

1. **Kamera-App** oder **QR-Scanner** öffnen
2. **QR-Code scannen**
3. **Link antippen**
4. **Zum Startbildschirm hinzufügen** (optional):
   - Chrome-Menü ? "Zum Startbildschirm hinzufügen"

### Windows Tablet

1. **Browser öffnen** (Edge/Chrome)
2. **QR-Code scannen** (mit Kamera-App)
3. **Link öffnen**

---

## ?? Sicherheitshinweise

### Für lokales Netzwerk (Phase 1)

? **Sicher:**
- Zugriff nur im lokalen WLAN
- Keine Passwörter übertragen
- Firewall nur für lokales Netz

?? **Beachten:**
- Keine externen Ports freigeben
- WLAN-Passwort sicher
- Gäste-WLAN getrennt

### Für externen Zugriff (Phase 2)

?? **Erforderlich:**
- HTTPS mit gültigem Zertifikat
- JWT-Authentifizierung aktiv
- Starke Passwörter
- Rate Limiting
- VPN oder Cloud-Deployment

---

## ?? API-Endpunkte für Netzwerk-Info

### Netzwerk-Informationen abrufen

```bash
GET /api/network/info

Response:
{
  "serverIPs": ["192.168.1.100", "10.0.0.5"],
  "port": 5000,
  "httpsPort": 5001,
  "hostName": "DESKTOP-ABC123",
  "accessUrls": [
    {
      "ip": "192.168.1.100",
      "httpUrl": "http://192.168.1.100:5000",
      "mobileUrl": "http://192.168.1.100:5000/mobile"
    }
  ]
}
```

### QR-Code generieren

```bash
# Für alle verfügbaren IPs
GET /api/network/qrcodes

# Für spezifische URL
GET /api/network/qrcode?url=http://192.168.1.100:5000/mobile

Response: PNG-Bild (QR-Code)
```

---

## ?? Best Practices

### Für den Einsatz

1. **Vor dem Einsatz:**
   - Server starten
   - QR-Codes ausdrucken (optional)
   - Mobile Geräte testen

2. **Während des Einsatzes:**
   - Server am Netzstrom
   - Router in Nähe des Einsatzortes
   - Backup-Smartphone bereithalten

3. **Nach dem Einsatz:**
   - Daten sichern
   - Server herunterfahren

### Netzwerk-Setup

```
Empfohlenes Setup:

????????????????
? Mobiler WLAN ?  ? Tragbarer Router
?    Router    ?     (z.B. TP-Link M7350)
????????????????
       ?
       ???? Laptop (Server)
       ?    Stromversorgung: Akku/Netzteil
       ?
       ???? Tablets (Einsatzleiter)
       ?
       ???? Smartphones (Team-Führer)
```

---

## ?? Support

### Häufige Fragen

**Q: Kann ich mehrere mobile Geräte gleichzeitig verbinden?**  
A: Ja, unbegrenzt viele Geräte können gleichzeitig zugreifen.

**Q: Funktioniert es ohne Internet?**  
A: Ja, nur lokales WLAN erforderlich (kein Internet nötig).

**Q: Wie schnell sind die Updates?**  
A: Echtzeit via SignalR (< 1 Sekunde).

**Q: Kann ich offline arbeiten?**  
A: Nein, Netzwerkverbindung erforderlich (für Phase 2 geplant).

**Q: Funktioniert es mit mobilen Daten?**  
A: Nur mit VPN oder externem Zugriff (Phase 2).

---

## ?? Nächste Schritte

Nach erfolgreichem Setup:

1. ? Mobile Dashboard testen
2. ? Team-Timer auf Tablet steuern
3. ? Thread-Nachrichten senden
4. ? Mehrere Geräte gleichzeitig testen
5. ?? Dokumentation für Team erstellen

---

**Viel Erfolg beim mobilen Einsatz! ????**
