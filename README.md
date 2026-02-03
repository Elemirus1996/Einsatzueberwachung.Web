# Einsatzüberwachung Web

**Version 3.8** - Moderne, touch-optimierte Web-Anwendung für die Koordination und Überwachung von Rettungshunde-Einsätzen mit Dark Mode Support.

---

## 🚀 Schnellstart

### Erstmalige Installation

1. **Voraussetzungen prüfen**
   - Windows 10/11
   - [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) installieren

2. **Anwendung starten**
   - Doppelklick auf `Einsatzueberwachung-Starten.ps1`
   - Wählen Sie den gewünschten Modus:
     - **Lokaler Modus**: Nur auf diesem Computer verfügbar
     - **Netzwerk-Modus**: Zugriff von anderen Geräten im Netzwerk
   - Option 3 erstellt Desktop-Verknüpfungen für beide Modi

3. **Desktop-Verknüpfungen (empfohlen)**
   - Beim ersten Start Option `[3]` wählen
   - Erstellt zwei Verknüpfungen:
     - `Einsatzüberwachung (Lokal).lnk` - Für lokalen Betrieb
     - `Einsatzüberwachung (Netzwerk).lnk` - Für Netzwerkbetrieb
   - Danach einfach per Doppelklick starten!

### Täglicher Betrieb

**Einfacher Start:**
- Doppelklick auf Desktop-Verknüpfung
- Anwendung startet automatisch
- Browser öffnet sich automatisch

**Beenden:**
- Drücken Sie `STRG+C` im PowerShell-Fenster
- Oder schließen Sie das PowerShell-Fenster

---

## 📱 Zugriff

### Lokaler Modus
- **URL**: `https://localhost:7059`
- **Verwendung**: Nur auf dem Computer, auf dem die Anwendung läuft

### Netzwerk-Modus
- **URL**: `https://<IP-Adresse>:7059`
- **Verwendung**: Von allen Geräten im gleichen Netzwerk
- **Mobile Geräte**: QR-Code in den Einstellungen scannen
- **Firewall**: Wird automatisch konfiguriert (benötigt Admin-Rechte)

---

## ✨ Hauptfunktionen

### 🌓 Dark Mode System
- Vollständiger Dark Mode für alle Komponenten
- Theme-Umschalter in der Navigation (☀️/🌙 Icon)
- Persistente Einstellungen (bleibt nach Neustart erhalten)
- Cross-Tab Synchronisation - Theme wird in allen offenen Browser-Tabs synchronisiert

### 🗺️ Interaktive Karten (Leaflet.js)
- Suchgebiete als Polygone zeichnen
- Marker setzen und beschriften
- Farben und Beschreibungen für Gebiete
- Teams zu Gebieten zuweisen
- Druck-Funktion mit Legende
- Dark Mode Support

### 👥 Team-Management
- Teams anlegen, bearbeiten, löschen
- Einsatzzeiten erfassen (Start/Ende)
- Team-Status überwachen
- Notizen pro Team

### 📝 Notizen-System
- Globale Notizen für alle sichtbar
- Team-spezifische Notizen
- Notiz-Historie mit Zeitstempel
- Antworten-System (Threads)
- Verschiedene Notiz-Typen (Manuell, System, Warnungen)

### ⚙️ Einstellungen
- QR-Code für mobilen Zugriff generieren
- Theme-Einstellungen (Hell/Dunkel)
- Einsatz-Konfiguration
- Datenbank-Verwaltung

### 📊 Echtzeit-Synchronisation
- SignalR für Live-Updates
- Alle Clients werden automatisch aktualisiert
- Keine manuelle Aktualisierung nötig

---

## 🏗️ Technische Details

### Architektur
- **Frontend**: Blazor WebAssembly (.NET 8)
- **Backend**: ASP.NET Core (.NET 8)
- **Datenbank**: Entity Framework Core mit SQLite
- **Echtzeit**: SignalR
- **Karten**: Leaflet.js
- **UI**: Bootstrap 5.3+

### Projekt-Struktur
```
Einsatzueberwachung.Web.Repo/
├── Einsatzueberwachung-Starten.ps1  ← HAUPTSCRIPT
├── Einsatzueberwachung.Web/         ← Server-Projekt
├── Einsatzueberwachung.Web.Client/  ← Client-Projekt (Blazor)
├── Einsatzueberwachung.Domain/      ← Domain-Logik
├── Einsatzueberwachung.Tests/       ← Unit-Tests
├── README.md                        ← Diese Datei
├── HILFE.md                         ← Detaillierte Hilfe
├── CHANGELOG.md                     ← Versionshistorie
└── Alte Dateien/                    ← Archivierte Dateien
```

### Ports
- **HTTPS**: 7059 (empfohlen)
- **HTTP**: 5059 (optional)

---

## 🔧 Problemlösung

### Die Anwendung startet nicht
1. Prüfen Sie, ob .NET 8 SDK installiert ist: `dotnet --version`
2. Stellen Sie sicher, dass Port 7059 nicht bereits verwendet wird
3. Prüfen Sie die Firewall-Einstellungen

### Kein Zugriff von anderen Geräten
1. Verwenden Sie den Netzwerk-Modus
2. Stellen Sie sicher, dass Firewall-Regel aktiv ist
3. Prüfen Sie, ob beide Geräte im gleichen Netzwerk sind
4. Verwenden Sie die IP-Adresse, nicht "localhost"

### Zertifikat-Warnung im Browser
- Bei HTTPS zeigt der Browser eine Warnung
- Dies ist normal bei selbst-signierten Zertifikaten
- Klicken Sie auf "Erweitert" → "Trotzdem fortfahren"
- Alternative: HTTP verwenden (Port 5059)

### Dark Mode wird nicht gespeichert
- Browser-Cache leeren
- Cookies für localhost aktivieren
- LocalStorage darf nicht blockiert sein

---

## 📚 Weitere Dokumentation

- **[HILFE.md](HILFE.md)** - Ausführliche Bedienungsanleitung
- **[CHANGELOG.md](CHANGELOG.md)** - Versionshistorie und Änderungen
- **[DEVELOPER_SETUP.md](DEVELOPER_SETUP.md)** - Entwickler-Setup

---

## 🆘 Support

Bei Problemen oder Fragen:
1. Lesen Sie die [HILFE.md](HILFE.md)
2. Prüfen Sie die Fehlermeldungen im PowerShell-Fenster
3. Kontaktieren Sie den Administrator

---

## 📝 Lizenz & Version

- **Version**: 3.0 (Januar 2026)
- **Framework**: .NET 8.0
- **Entwickelt für**: Rettungshunde-Einsatz-Koordination

---

## 🔄 Updates & Wartung

### Anwendung aktualisieren
1. Code aus Repository aktualisieren
2. Anwendung neu starten
3. Browser-Cache leeren (STRG+F5)

### Datenbank-Backup
- Datenbank liegt in: `Einsatzueberwachung.Web/einsatzueberwachung.db`
- Einfach Datei kopieren für Backup
- Zum Wiederherstellen: Datei zurückkopieren

---

**Viel Erfolg bei Ihren Einsätzen! 🐕‍🦺**
