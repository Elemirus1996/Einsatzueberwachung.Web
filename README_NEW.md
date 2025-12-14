# ?? Einsatzüberwachung

**Professionelle Einsatzüberwachung für Rettungsdienste und Feuerwehr**

Eine moderne, browserbasierte Anwendung zur Verwaltung und Überwachung von Einsätzen mit Echtzeit-Kartendarstellung, Teamverwaltung und umfangreicher Dokumentation.

![.NET 8](https://img.shields.io/badge/.NET-8.0-blue)
![Blazor](https://img.shields.io/badge/Blazor-WebAssembly-purple)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## ? Highlights

- ??? **Interaktive Karten** mit Leaflet.js
- ?? **Team-Management** in Echtzeit
- ?? **Enhanced Notes System** mit Threading
- ?? **PDF-Berichte** automatisch generiert
- ?? **Dark Mode** für Nachtbetrieb
- ?? **Offline-fähig** - keine Server-Anbindung nötig
- ?? **Ein-Klick-Start** vom Desktop
- ?? **DSGVO-konform** - alle Daten lokal

## ?? Quick Start - In 3 Schritten zur laufenden Anwendung

### Voraussetzungen
- **Windows 10/11**
- **.NET 8 SDK** ([Download](https://dotnet.microsoft.com/download/dotnet/8.0))

### Installation

**Option A: Mit Git**
```bash
git clone https://github.com/Elemirus1996/Einsatzueberwachung.Web.git
cd Einsatzueberwachung.Web
powershell -ExecutionPolicy Bypass -File Create-Desktop-Shortcut.ps1
```

**Option B: ZIP Download**
1. [ZIP herunterladen](https://github.com/Elemirus1996/Einsatzueberwachung.Web/archive/refs/heads/main.zip)
2. Entpacken
3. Rechtsklick auf `START_EINSATZUEBERWACHUNG.bat` ? "Verknüpfung erstellen"
4. Verknüpfung auf Desktop ziehen

**Starten:**
- Doppelklick auf Desktop-Shortcut
- Browser öffnet automatisch
- **Fertig!** ?

## ?? Dokumentation

- **[QUICK_START.md](QUICK_START.md)** - Detaillierte Schnellstartanleitung
- **[VISUAL_GUIDE.md](VISUAL_GUIDE.md)** - Bildliche Schritt-für-Schritt Anleitung
- **[DEVELOPER_SETUP.md](DEVELOPER_SETUP.md)** - Setup für Entwickler

## ? Features im Detail

### ??? Kartenfunktionen
- Interaktive Karte mit Leaflet.js
- Suchgebiete zeichnen und verwalten
- Team-Tracking mit Positionen
- Markierungen für wichtige Punkte
- PDF-Export der Karte
- Dark Mode für Nachtbetrieb

### ?? Teamverwaltung
- Unbegrenzte Teams
- Personal- und Ressourcenverwaltung
- Hunde- und Drohnenteams
- Echtzeit-Status
- Fähigkeiten und Spezialisierungen

### ?? Notizen & Dokumentation
- Enhanced Notes mit Threading
- Antworten und Diskussionen
- Wichtige Meldungen hervorheben
- Automatische Zeitstempel
- Filterung nach Teams

### ?? Einsatzberichte
- Automatische PDF-Generierung
- Zeitstrahl aller Ereignisse
- Team-Übersichten
- Kartendarstellung
- Export-Funktion

## ??? Technologien

- **.NET 8** - Framework
- **Blazor WebAssembly** - Frontend
- **Bootstrap 5** - UI
- **Leaflet.js** - Karten
- **QuestPDF** - PDF-Export
- **LocalStorage** - Datenspeicherung

## ?? Starter-Dateien

| Datei | Zweck |
|-------|-------|
| `START_EINSATZUEBERWACHUNG.bat` | Hauptstarter (HTTPS) - **Empfohlen** ? |
| `START_HTTP.bat` | HTTP-Version (bei SSL-Problemen) |
| `STARTER_MENU.bat` | Interaktives Menü mit Optionen |
| `Start-Einsatzueberwachung.ps1` | PowerShell-Version |
| `Create-Desktop-Shortcut.ps1` | Automatischer Shortcut-Creator |

## ?? Problembehandlung

### ".NET nicht gefunden"
```bash
# .NET 8 SDK installieren
https://dotnet.microsoft.com/download/dotnet/8.0
```

### "Port bereits belegt"
```bash
# HTTP-Version verwenden
.\START_HTTP.bat
```

### "HTTPS-Zertifikat-Warnung"
```bash
# Zertifikat installieren
dotnet dev-certs https --trust
```

Mehr Hilfe: [QUICK_START.md](QUICK_START.md)

## ?? Beitragen

Contributions sind willkommen!

1. Fork das Repository
2. Feature Branch: `git checkout -b feature/NeuesFeature`
3. Commit: `git commit -m 'Add NeuesFeature'`
4. Push: `git push origin feature/NeuesFeature`
5. Pull Request öffnen

## ?? Changelog

- **v2.1.0** - Desktop-Shortcuts, Dark Mode, Enhanced Documentation
- **v2.0.1** - Karten-Updates, PDF-Export-Verbesserungen
- **v2.0.0** - Enhanced Notes System, Refactoring

Details: [CHANGELOG_V2.1.0_DARK_MODE.md](CHANGELOG_V2.1.0_DARK_MODE.md)

## ?? Datenschutz

- ? Alle Daten lokal im Browser
- ? Keine Server-Anbindung
- ? Keine Datenübertragung
- ? DSGVO-konform
- ? Vollständige Datenkontrolle

## ?? Support

- **Issues:** [GitHub Issues](https://github.com/Elemirus1996/Einsatzueberwachung.Web/issues)
- **Dokumentation:** Siehe Markdown-Dateien im Repository

## ?? Lizenz

MIT License - siehe [LICENSE](LICENSE) für Details

## ?? Credits

- **Leaflet.js** - Kartendarstellung
- **QuestPDF** - PDF-Generierung
- **Bootstrap** - UI Framework

---

**? Entwickelt für Einsatzkräfte, von Einsatzkräften**

*Made with ?? using .NET 8 and Blazor WebAssembly*

**Repository:** https://github.com/Elemirus1996/Einsatzueberwachung.Web
