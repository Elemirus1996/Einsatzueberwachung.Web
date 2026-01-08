# ? Mobile Einsatzüberwachung - Production Deployment Checklist

## ?? Pre-Deployment Checkliste

### ?? Sicherheit (KRITISCH)

- [ ] **JWT Secret Key ändern**
  ```json
  "Jwt": {
    "Key": "MINDESTENS-32-ZEICHEN-SICHERER-RANDOM-STRING-HIER"
  }
  ```
  - Mindestens 32 Zeichen
  - Zufällig generiert
  - Geheim halten!

- [ ] **Credentials ändern**
  ```json
  "Auth": {
    "Username": "neuer-username",
    "Password": "sicheres-passwort-min-12-zeichen"
  }
  ```
  - Nicht die Standard-Credentials verwenden!
  - Starkes Passwort (min. 12 Zeichen)

- [ ] **HTTPS aktivieren**
  - [ ] SSL-Zertifikat installiert
  - [ ] HTTP ? HTTPS Redirect aktiv
  - [ ] HSTS-Header konfiguriert

- [ ] **CORS einschränken**
  ```csharp
  // Statt AllowAnyOrigin():
  policy.WithOrigins(
      "https://trusted-domain.com",
      "https://mobile.einsatz.local"
  )
  ```

- [ ] **Rate Limiting implementieren** (optional, empfohlen)
  - Login-Endpunkt: Max 5 Versuche/Minute
  - API-Endpunkte: Max 100 Requests/Minute

### ?? Netzwerk-Konfiguration

- [ ] **Firewall-Regeln eingerichtet**
  ```powershell
  # Windows
  New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS" `
      -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow
  ```

- [ ] **Port-Konfiguration**
  - [ ] Production Port festgelegt (Standard: 443 für HTTPS)
  - [ ] In `appsettings.Production.json` konfiguriert

- [ ] **DNS/IP-Adresse**
  - [ ] Statische IP für Server konfiguriert
  - [ ] DNS-Name registriert (optional)
  - [ ] Dokumentiert für Endnutzer

- [ ] **Netzwerk-Zugriff getestet**
  - [ ] Von mobilem Gerät erreichbar
  - [ ] SignalR-Verbindung funktioniert
  - [ ] API-Endpunkte antworten

### ??? Datenbank & Persistenz

- [ ] **Session Data Backup**
  - [ ] Regelmäßige Backups eingerichtet
  - [ ] Backup-Speicherort definiert
  - [ ] Restore-Prozedur dokumentiert

- [ ] **User-Datenbank** (für Phase 2)
  - [ ] Datenbank-System gewählt (SQL Server, PostgreSQL, etc.)
  - [ ] Migrations-Scripts erstellt
  - [ ] Passwort-Hashing implementiert (BCrypt/PBKDF2)
  - [ ] Connection String in Secrets gespeichert

### ?? Logging & Monitoring

- [ ] **Logging konfiguriert**
  ```json
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Einsatzueberwachung": "Information"
    }
  }
  ```

- [ ] **Log-Speicherort**
  - [ ] Log-Dateien-Pfad definiert
  - [ ] Log-Rotation konfiguriert (täglich/wöchentlich)
  - [ ] Disk-Space überwacht

- [ ] **Error-Tracking**
  - [ ] Exception-Handler überprüft
  - [ ] Critical-Errors werden geloggt
  - [ ] Admin-Benachrichtigung bei Kritisch (optional)

- [ ] **Performance-Monitoring**
  - [ ] Response-Times überwachen
  - [ ] SignalR-Connection-Count tracken
  - [ ] Memory-Usage überwachen

### ?? Testing

- [ ] **Funktions-Tests**
  - [ ] Login funktioniert
  - [ ] Team-Timer starten/stoppen
  - [ ] Notizen erstellen/lesen
  - [ ] SignalR-Updates werden empfangen
  - [ ] Mobile Dashboard lädt korrekt

- [ ] **Load-Tests**
  - [ ] 10+ gleichzeitige Clients getestet
  - [ ] SignalR unter Last stabil
  - [ ] API-Response-Times akzeptabel (<500ms)

- [ ] **Browser-Tests**
  - [ ] Chrome (Android)
  - [ ] Safari (iOS)
  - [ ] Firefox (Android)
  - [ ] Edge (Windows Phone, falls relevant)

- [ ] **Geräte-Tests**
  - [ ] Smartphone (Portrait)
  - [ ] Smartphone (Landscape)
  - [ ] Tablet (10")
  - [ ] Tablet (7")

### ?? Mobile-Optimierung

- [ ] **Performance**
  - [ ] Bilder komprimiert
  - [ ] CSS minified
  - [ ] JavaScript minified
  - [ ] Gzip-Compression aktiviert

- [ ] **PWA-Features** (optional)
  - [ ] Service Worker erstellt
  - [ ] Manifest.json konfiguriert
  - [ ] Offline-Fallback implementiert
  - [ ] Add to Homescreen unterstützt

### ?? Dokumentation

- [ ] **Benutzer-Dokumentation**
  - [ ] Zugriffs-URL dokumentiert
  - [ ] Login-Credentials kommuniziert
  - [ ] Nutzungs-Anleitung erstellt
  - [ ] FAQ vorbereitet

- [ ] **Admin-Dokumentation**
  - [ ] Server-Konfiguration dokumentiert
  - [ ] Backup-Prozedur beschrieben
  - [ ] Troubleshooting-Guide erstellt
  - [ ] Update-Prozedur dokumentiert

- [ ] **API-Dokumentation**
  - [ ] Swagger-UI für Admin zugänglich
  - [ ] API-Beispiele dokumentiert
  - [ ] Integration-Guide für Dritt-Apps

### ?? Update-Strategie

- [ ] **Version-Kontrolle**
  - [ ] Version-Nummer definiert (z.B. v2.1.0)
  - [ ] Changelog aktualisiert
  - [ ] Git-Tag erstellt

- [ ] **Deployment-Prozess**
  - [ ] Deployment-Script erstellt
  - [ ] Rollback-Plan definiert
  - [ ] Downtime-Fenster kommuniziert

- [ ] **Post-Deployment**
  - [ ] Smoke-Tests durchgeführt
  - [ ] Logs auf Errors geprüft
  - [ ] Mobile-Zugriff verifiziert

## ?? Deployment-Schritte

### Schritt 1: Server vorbereiten

```bash
# .NET 8 Runtime installieren
winget install Microsoft.DotNet.Runtime.8

# Publish erstellen
dotnet publish -c Release -o ./publish

# Auf Server kopieren
# Option A: Manuell per FTP/SCP
# Option B: Git Pull auf Server
# Option C: CI/CD Pipeline
```

### Schritt 2: Konfiguration anpassen

```bash
# appsettings.Production.json erstellen
cp appsettings.json appsettings.Production.json

# WICHTIG: Secrets ändern!
nano appsettings.Production.json
```

### Schritt 3: Service installieren (Windows)

```powershell
# Als Windows Service
New-Service -Name "Einsatzueberwachung" `
    -BinaryPathName "C:\Apps\Einsatzueberwachung\Einsatzueberwachung.Web.exe" `
    -StartupType Automatic

Start-Service -Name "Einsatzueberwachung"
```

### Schritt 4: IIS konfigurieren (Alternative)

```powershell
# IIS Application Pool erstellen
New-WebAppPool -Name "Einsatzueberwachung"

# Website erstellen
New-Website -Name "Einsatzueberwachung" `
    -PhysicalPath "C:\Apps\Einsatzueberwachung" `
    -ApplicationPool "Einsatzueberwachung" `
    -Port 443 `
    -Ssl
```

### Schritt 5: SSL-Zertifikat

```powershell
# Self-Signed für Development
New-SelfSignedCertificate -DnsName "einsatz.local" `
    -CertStoreLocation "cert:\LocalMachine\My"

# Production: Let's Encrypt oder Kommerzielles Zertifikat
```

### Schritt 6: Firewall

```powershell
New-NetFirewallRule -DisplayName "Einsatzueberwachung HTTPS" `
    -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow
```

### Schritt 7: Testen

```bash
# Health-Check
curl https://[SERVER-IP]/api/einsatz/status

# Mobile Dashboard
# Browser öffnen: https://[SERVER-IP]/mobile
```

## ?? appsettings.Production.json Template

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft.AspNetCore": "Warning",
      "Einsatzueberwachung": "Information"
    },
    "File": {
      "Path": "C:\\Logs\\Einsatzueberwachung\\log-.txt",
      "RollingInterval": "Day"
    }
  },
  "AllowedHosts": "*.einsatz.local;192.168.*",
  "Jwt": {
    "Key": "PRODUCTION-SECRET-KEY-MINDESTENS-32-ZEICHEN-LANG",
    "Issuer": "Einsatzueberwachung",
    "Audience": "EinsatzueberwachungMobile"
  },
  "Auth": {
    "Username": "production-username",
    "Password": "production-password"
  },
  "Mobile": {
    "EnableExternalAccess": false,
    "AllowedIpRanges": [
      "192.168.1.0/24",
      "10.0.0.0/8"
    ]
  },
  "Kestrel": {
    "Endpoints": {
      "Https": {
        "Url": "https://*:443",
        "Certificate": {
          "Path": "cert.pfx",
          "Password": "cert-password"
        }
      }
    }
  }
}
```

## ?? Post-Deployment Monitoring

### Erste 24 Stunden

- [ ] **Stündlich prüfen:**
  - [ ] Server-Erreichbarkeit
  - [ ] Log-Dateien auf Errors
  - [ ] Memory-Usage
  - [ ] CPU-Usage

- [ ] **Bei jedem Einsatz:**
  - [ ] Mobile-Zugriff testen
  - [ ] SignalR-Updates verifizieren
  - [ ] Response-Times messen

### Erste Woche

- [ ] **Täglich prüfen:**
  - [ ] Log-Dateien reviewen
  - [ ] User-Feedback sammeln
  - [ ] Performance-Metriken analysieren

- [ ] **Optimierungen:**
  - [ ] Langsame API-Calls identifizieren
  - [ ] SignalR-Reconnects analysieren
  - [ ] UI-Verbesserungen basierend auf Feedback

## ?? Troubleshooting-Guide

### Problem: Mobile kann nicht verbinden

**Checks:**
1. Server läuft? `Get-Service Einsatzueberwachung`
2. Firewall? `Test-NetConnection -ComputerName [IP] -Port 443`
3. Gleiche Netzwerk? `ipconfig` auf beiden Geräten
4. HTTPS-Zertifikat vertrauenswürdig?

**Lösung:**
```powershell
# Firewall-Regel prüfen
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*Einsatzueberwachung*"}

# Service neu starten
Restart-Service -Name "Einsatzueberwachung"
```

### Problem: 401 Unauthorized

**Checks:**
1. Token abgelaufen? (Max 1 Stunde)
2. Credentials korrekt?
3. JWT Key in Production-Config?

**Lösung:**
- Neues Token abrufen: `POST /api/auth/login`
- Config prüfen: `type appsettings.Production.json`

### Problem: SignalR bricht ab

**Checks:**
1. Websockets unterstützt? (Server & Client)
2. Proxy/Load Balancer konfiguriert?
3. Timeout zu kurz?

**Lösung:**
```csharp
// Program.cs
builder.Services.AddSignalR(options =>
{
    options.ClientTimeoutInterval = TimeSpan.FromMinutes(5);
    options.KeepAliveInterval = TimeSpan.FromMinutes(2);
});
```

## ?? Support & Eskalation

### Level 1: Benutzer-Support
- Zugangsdaten vergessen ? Admin kontaktieren
- App lädt nicht ? Browser neu laden, Cache leeren
- Daten veraltet ? Seite neu laden

### Level 2: Admin-Support
- Server-Probleme ? Service neu starten
- Netzwerk-Probleme ? Firewall/Router prüfen
- Performance-Probleme ? Logs analysieren

### Level 3: Entwickler-Support
- Bug-Reports ? GitHub Issue erstellen
- Feature-Requests ? Dokumentieren und priorisieren
- Critical Issues ? Rollback auf letzte stabile Version

---

**Deployment-Status:** [ ] Bereit | [ ] In Arbeit | [ ] Live

**Go-Live Datum:** ________________

**Verantwortlich:** ________________

**Backup-Kontakt:** ________________

---

Viel Erfolg beim Deployment! ??
