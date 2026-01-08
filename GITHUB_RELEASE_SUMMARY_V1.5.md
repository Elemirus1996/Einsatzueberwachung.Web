# ?? Version 1.5.0 - Mobile Dashboard

## Was ist neu?

Die neue Version bringt ein **vollständig mobiles Dashboard** für Einsatzkräfte im Feld! 

### ?? Hauptfeatures

?? **Mobile Dashboard** 
- Echtzeit-Übersicht aller Teams auf dem Smartphone
- Live-Timer mit Warnungen
- Chronologische Notizen und Funksprüche
- Touch-optimiertes Design

?? **QR-Code Verbindung**
- Schnelle Verbindung via QR-Code scannen
- Automatische Netzwerk-Erkennung
- PIN-geschützter Zugang

?? **SignalR Echtzeit-Updates**
- Alle Änderungen werden sofort synchronisiert
- Keine manuelle Aktualisierung nötig
- Stabile Verbindung mit Auto-Reconnect

## ?? Schnellstart

### Desktop-Version starten:
```bash
dotnet run
```

### Mit Mobile Dashboard (Netzwerk):
```batch
START_NETWORK_SERVER.bat
```

Dann auf `/mobile/connect` navigieren und QR-Code scannen!

## ?? Dokumentation

Vollständige Dokumentation:
- [MOBILE_README.md](MOBILE_README.md) - Hauptdokumentation
- [MOBILE_QUICK_START.md](MOBILE_QUICK_START.md) - Schnellstart-Anleitung
- [RELEASE_V1.5.md](RELEASE_V1.5.md) - Release Notes

## ?? Wichtige Hinweise

- **Standard-PIN:** `1234` (bitte in `appsettings.json` ändern!)
- **Firewall:** Wird automatisch konfiguriert via Script
- **Port:** 5000 (HTTP)

## ?? Download

**Source Code:**
- [ZIP herunterladen](../../archive/refs/tags/v1.5.0.zip)
- [TAR.GZ herunterladen](../../archive/refs/tags/v1.5.0.tar.gz)

**Git Clone:**
```bash
git clone https://github.com/Elemirus1996/Einsatzueberwachung.Web.git
cd Einsatzueberwachung.Web
git checkout v1.5.0
```

## ?? Für wen ist das?

- **Einsatzleiter:** Nutzen die Desktop-Version für volle Kontrolle
- **Einsatzkräfte:** Nutzen das Mobile Dashboard für schnellen Überblick
- **Gruppenführer:** Können beide Versionen parallel nutzen

## ?? Technische Details

### Neue Abhängigkeiten:
- Microsoft.AspNetCore.SignalR.Client (8.0.0)
- Microsoft.AspNetCore.Authentication.JwtBearer (8.0.0)
- QRCoder (1.4.3)
- Swashbuckle.AspNetCore (6.5.0)

### Neue API-Endpunkte:
- `POST /api/auth/login` - PIN-Authentifizierung
- `GET /api/einsatz/current` - Aktuelle Einsatzdaten
- `GET /api/einsatz/teams` - Alle Teams
- `GET /api/einsatz/notes` - Alle Notizen
- `GET /api/network/info` - Netzwerk-Informationen

## ?? Bug Reports

Bitte Issues auf GitHub erstellen:
https://github.com/Elemirus1996/Einsatzueberwachung.Web/issues

## ?? Feedback

Feedback ist willkommen! Bitte nutze:
- GitHub Issues für Bug Reports
- GitHub Discussions für Feature-Requests
- Pull Requests für Contributions

## ? Unterstützung

Wenn dir dieses Projekt hilft, gib bitte einen Stern auf GitHub!

---

**Entwickelt mit ?? für Rettungshundestaffeln**

