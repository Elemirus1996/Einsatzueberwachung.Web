# ?? Einsatzüberwachung

**Professionelle Einsatzüberwachung für Rettungsdienste und Feuerwehr**

Eine moderne, browserbasierte Anwendung zur Verwaltung und Überwachung von Einsätzen mit Echtzeit-Kartendarstellung, Teamverwaltung und umfangreicher Dokumentation.

![.NET 8](https://img.shields.io/badge/.NET-8.0-blue)
![Blazor](https://img.shields.io/badge/Blazor-WebAssembly-purple)
![License](https://img.shields.io/badge/license-MIT-green)

## ? Features

### ??? Kartenfunktionen
- **Interaktive Karte** mit Leaflet.js
- **Suchgebiete** zeichnen und verwalten
- **Team-Tracking** mit Echtzeit-Positionen
- **Markierungen** für wichtige Punkte
- **PDF-Export** der Karte für Dokumentation
- **Dark Mode** für Nachtbetrieb

### ?? Teamverwaltung
- Unbegrenzte Teams erstellen und verwalten
- Team-Status in Echtzeit
- Personal- und Ressourcenverwaltung
- Hunde- und Drohnenteams
- Fähigkeiten und Spezialisierungen

### ?? Notizen & Dokumentation
- **Enhanced Notes System** mit Threading
- Wichtige Meldungen hervorheben
- Antworten und Diskussionen
- Automatische Zeitstempel
- Filterung nach Teams und Typ

### ?? Einsatzberichte
- Automatische PDF-Generierung
- Zeitstrahl aller Ereignisse
- Team-Übersichten
- Kartendarstellung
- Export-Funktion

### ?? Datenspeicherung
- Komplett offline-fähig
- Daten im Browser gespeichert (LocalStorage)
- Keine Server-Anbindung notwendig
- Datenschutzkonform (DSGVO)

## ?? Quick Start

### Voraussetzungen
- **Windows 10/11**
- **.NET 8 SDK** ([Download](https://dotnet.microsoft.com/download/dotnet/8.0))

### Installation in 3 Schritten

1. **Repository herunterladen**
   ```bash
   git clone https://github.com/Elemirus1996/Einsatzueberwachung.Web.git
   ```
   Oder als ZIP herunterladen und entpacken

2. **Desktop-Shortcut erstellen**
   - Rechtsklick auf `START_EINSATZUEBERWACHUNG.bat`
   - "Verknüpfung erstellen"
   - Verknüpfung auf Desktop ziehen

3. **Starten!**
   - Doppelklick auf Desktop-Shortcut
   - Browser öffnet sich automatisch
   - Fertig! ?

### Alternative Startmethoden

- **Einfacher Start:** Doppelklick auf `START_EINSATZUEBERWACHUNG.bat`
- **HTTP-Modus:** Doppelklick auf `START_HTTP.bat`
- **Menü mit Optionen:** Doppelklick auf `STARTER_MENU.bat`
- **PowerShell:** Rechtsklick auf `Start-Einsatzueberwachung.ps1` ? "Mit PowerShell ausführen"

Detaillierte Anleitung: [QUICK_START.md](QUICK_START.md)

## ?? Dokumentation

- **[QUICK_START.md](QUICK_START.md)** - Schnellstartanleitung für Endanwender
- **[DEVELOPER_SETUP.md](DEVELOPER_SETUP.md)** - Setup für Entwickler
- **[NOTES_ENHANCED_DOCUMENTATION.md](NOTES_ENHANCED_DOCUMENTATION.md)** - Notizensystem
- **[KARTEN_FUNKTIONALITAET.md](KARTEN_FUNKTIONALITAET.md)** - Kartenfunktionen
- **[DARK_MODE_IMPLEMENTATION.md](DARK_MODE_IMPLEMENTATION.md)** - Dark Mode Details

## ??? Technologien

- **.NET 8** - Framework
- **Blazor WebAssembly** - Frontend
- **Bootstrap 5** - UI Framework
- **Leaflet.js** - Kartendarstellung
- **QuestPDF** - PDF-Generierung
- **Font Awesome** - Icons
- **LocalStorage/IndexedDB** - Datenspeicherung

## ?? Screenshots

### Einsatzmonitor
![Einsatzmonitor](docs/screenshots/monitor.png)

### Interaktive Karte
![Karte](docs/screenshots/map.png)

### Dark Mode
![Dark Mode](docs/screenshots/dark-mode.png)

## ?? Verwendung

### Neuen Einsatz starten
1. Klick auf "Neuer Einsatz"
2. Einsatzdetails eingeben
3. Karte anpassen
4. Teams hinzufügen
5. Einsatz überwachen

### Teams verwalten
1. Menü ? Stammdaten
2. Teams/Personal hinzufügen
3. Im Einsatz verfügbar

### Notizen erstellen
1. Im Einsatzmonitor Notiz hinzufügen
2. Typ wählen (Info/Wichtig/Warnung)
3. Optional Team zuordnen
4. Speichern

### Bericht erstellen
1. Im Einsatz auf "Bericht" klicken
2. PDF wird automatisch generiert
3. Enthält alle Ereignisse und Karte

## ?? Konfiguration

Einstellungen über Menü ? Einstellungen:
- Organisation anpassen
- Einsatz-Nummer Präfix
- Dark Mode aktivieren
- Audio-Benachrichtigungen
- Auto-Speichern Intervall

## ?? Problembehandlung

### Problem: ".NET wird nicht erkannt"
**Lösung:** Installieren Sie .NET 8 SDK und starten Sie den Computer neu

### Problem: "Port bereits belegt"
**Lösung:** Verwenden Sie `START_HTTP.bat` oder ändern Sie den Port

### Problem: "HTTPS-Zertifikat-Warnung"
**Lösung:** 
```bash
dotnet dev-certs https --trust
```

Mehr Hilfe: [QUICK_START.md](QUICK_START.md#-problembehandlung)

## ?? Beitragen

Contributions sind willkommen! 

1. Fork das Repository
2. Feature Branch erstellen (`git checkout -b feature/AmazingFeature`)
3. Changes committen (`git commit -m 'Add AmazingFeature'`)
4. Branch pushen (`git push origin feature/AmazingFeature`)
5. Pull Request öffnen

## ?? Changelog

Alle Änderungen werden dokumentiert:
- [CHANGELOG_V2.1.0_DARK_MODE.md](CHANGELOG_V2.1.0_DARK_MODE.md)
- [CHANGELOG_V2.0.1.md](CHANGELOG_V2.0.1.md)
- [CHANGELOG.md](CHANGELOG.md)

## ?? Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe [LICENSE](LICENSE) für Details.

## ?? Autoren

- **Ihr Name** - *Initial work*

## ?? Danksagungen

- Leaflet.js für die Kartenfunktionalität
- QuestPDF für PDF-Generierung
- Bootstrap Team für das UI Framework
- Alle Contributors

## ?? Support

- **Issues:** [GitHub Issues](https://github.com/Elemirus1996/Einsatzueberwachung.Web/issues)
- **Dokumentation:** Siehe `docs/` Ordner
- **Fragen:** Öffnen Sie eine Discussion

## ?? Datenschutz

- Alle Daten werden **lokal im Browser** gespeichert
- **Keine Datenübertragung** an externe Server
- **DSGVO-konform**
- Vollständige Kontrolle über Ihre Daten

## ?? Roadmap

- [ ] Export/Import von Einsätzen
- [ ] Multi-User Support mit Server
- [ ] Mobile App (iOS/Android)
- [ ] GPS-Integration
- [ ] Funk-Integration
- [ ] Statistiken und Auswertungen

---

**? Entwickelt für Einsatzkräfte, von Einsatzkräften**

*Made with ?? using .NET and Blazor*
