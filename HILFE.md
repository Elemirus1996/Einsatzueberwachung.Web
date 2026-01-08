# 📘 Einsatzüberwachung - Ausführliche Hilfe

Diese Datei enthält detaillierte Anleitungen zur Bedienung der Einsatzüberwachung.

---

## 📑 Inhaltsverzeichnis

1. [Installation & Start](#installation--start)
2. [Benutzeroberfläche](#benutzeroberfläche)
3. [Team-Management](#team-management)
4. [Karten & Gebiete](#karten--gebiete)
5. [Notizen-System](#notizen-system)
6. [Einstellungen](#einstellungen)
7. [Mobile Nutzung](#mobile-nutzung)
8. [Dark Mode](#dark-mode)
9. [Häufige Probleme](#häufige-probleme)
10. [Tastenkombinationen](#tastenkombinationen)

---

## Installation & Start

### Erstinstallation

#### Schritt 1: .NET 8 SDK installieren
1. Laden Sie .NET 8 SDK herunter: [https://dotnet.microsoft.com/download/dotnet/8.0](https://dotnet.microsoft.com/download/dotnet/8.0)
2. Führen Sie den Installer aus
3. Folgen Sie den Anweisungen
4. Starten Sie den Computer neu (empfohlen)

#### Schritt 2: Anwendung starten
1. Navigieren Sie zum Projektordner
2. Doppelklick auf `Einsatzueberwachung-Starten.ps1`
3. Falls Windows SmartScreen erscheint:
   - Klicken Sie auf "Weitere Informationen"
   - Klicken Sie auf "Trotzdem ausführen"

#### Schritt 3: Modus auswählen

**Lokaler Modus (`[1]`)**
- Nur auf diesem Computer verfügbar
- Schnellster Start
- Keine Firewall-Konfiguration nötig
- Ideal für Tests oder Einzelarbeitsplatz

**Netzwerk-Modus (`[2]`)**
- Zugriff von allen Geräten im Netzwerk
- Benötigt Administrator-Rechte beim ersten Start
- Konfiguriert automatisch Windows Firewall
- Ideal für Team-Einsätze mit mehreren Geräten

**Desktop-Verknüpfung erstellen (`[3]`)**
- Erstellt zwei Verknüpfungen auf dem Desktop
- Eine für lokalen Modus, eine für Netzwerk-Modus
- Danach einfacher Start per Doppelklick

### Täglicher Start

1. Doppelklick auf Desktop-Verknüpfung
2. Warten Sie, bis PowerShell-Fenster erscheint
3. Browser öffnet sich automatisch
4. Anwendung ist bereit!

### Anwendung beenden

**Methode 1: Tastenkombination**
- Drücken Sie `STRG+C` im PowerShell-Fenster
- Bestätigen Sie mit `J` (für Ja)

**Methode 2: Fenster schließen**
- Schließen Sie das PowerShell-Fenster mit dem X
- Anwendung wird automatisch beendet

---

## Benutzeroberfläche

### Navigation (oben)

```
╔═══════════════════════════════════════════════════════════╗
║  🏠 Home  |  👥 Teams  |  🗺️ Karten  |  ⚙️ Einstellungen  ║
╚═══════════════════════════════════════════════════════════╝
```

**Theme-Umschalter (rechts oben)**
- ☀️ = Aktuell Light Mode → Klick wechselt zu Dark Mode
- 🌙 = Aktuell Dark Mode → Klick wechselt zu Light Mode

### Home-Seite

**Oberer Bereich:**
- Einsatz-Informationen
- Statistiken (Anzahl Teams, aktive Teams, etc.)
- Aktuelle Zeit

**Unterer Bereich:**
- Globale Notizen
- Letzte Aktivitäten
- Schnellzugriff auf Funktionen

---

## Team-Management

### Neues Team anlegen

1. Navigieren Sie zu **👥 Teams**
2. Klicken Sie auf **"Neues Team"**
3. Füllen Sie das Formular aus:
   - **Name**: z.B. "Team Alpha" (Pflichtfeld)
   - **Führername**: z.B. "Max Mustermann" (optional)
   - **Hundename**: z.B. "Rex" (optional)
   - **Funkrufname**: z.B. "Alpha-1" (optional)
4. Klicken Sie auf **"Speichern"**

### Team starten

1. Finden Sie das Team in der Liste
2. Klicken Sie auf **"Start"**-Button
3. Startzeit wird automatisch erfasst
4. Team-Status wechselt zu "Aktiv" (grün)

### Team beenden

1. Finden Sie das aktive Team
2. Klicken Sie auf **"Stop"**-Button
3. Endzeit wird automatisch erfasst
4. Einsatzzeit wird berechnet und angezeigt

### Team bearbeiten

1. Klicken Sie auf das **Stift-Symbol** ✏️ beim Team
2. Ändern Sie die gewünschten Felder
3. Klicken Sie auf **"Speichern"**

### Team löschen

1. Klicken Sie auf das **Papierkorb-Symbol** 🗑️ beim Team
2. Bestätigen Sie die Sicherheitsabfrage
3. Team wird gelöscht

⚠️ **Achtung**: Gelöschte Teams können nicht wiederhergestellt werden!

### Team-Notizen

1. Klicken Sie auf das Team
2. Scrollen Sie zum Notizen-Bereich
3. Geben Sie Ihre Notiz ein
4. Klicken Sie auf **"Notiz hinzufügen"**

---

## Karten & Gebiete

### Karte öffnen

1. Navigieren Sie zu **🗺️ Karten**
2. Karte lädt automatisch
3. Standard-Ansicht: OpenStreetMap

### Suchgebiet zeichnen

#### Methode 1: Polygon
1. Klicken Sie auf das **Polygon-Werkzeug** (links auf der Karte)
2. Klicken Sie auf die Karte, um Eckpunkte zu setzen
3. Klicken Sie erneut auf den ersten Punkt zum Schließen
4. Gebiet-Dialog öffnet sich automatisch

#### Methode 2: Rechteck
1. Klicken Sie auf das **Rechteck-Werkzeug**
2. Ziehen Sie ein Rechteck auf der Karte
3. Gebiet-Dialog öffnet sich automatisch

### Gebiet konfigurieren

**Im Gebiet-Dialog:**

1. **Name**: z.B. "Waldgebiet Nord"
2. **Beschreibung**: Zusätzliche Infos
3. **Farbe**: Klicken Sie auf Farbauswahl
4. **Team zuweisen**: Wählen Sie ein Team aus Dropdown
5. Klicken Sie auf **"Speichern"**

### Marker setzen

1. Klicken Sie auf das **Marker-Werkzeug**
2. Klicken Sie auf die gewünschte Position
3. Geben Sie eine Beschriftung ein
4. Klicken Sie auf **"OK"**

### Gebiet bearbeiten

1. Klicken Sie auf das Gebiet
2. Popup mit Details erscheint
3. Klicken Sie auf **"Bearbeiten"**
4. Ändern Sie die gewünschten Felder
5. Klicken Sie auf **"Speichern"**

### Gebiet löschen

1. Klicken Sie auf das Gebiet
2. Klicken Sie im Popup auf **"Löschen"**
3. Bestätigen Sie die Sicherheitsabfrage

### Karte drucken

1. Klicken Sie auf **"Karte drucken"**-Button
2. Druck-Vorschau öffnet sich
3. Legende mit allen Gebieten wird automatisch erstellt
4. Klicken Sie auf **"Drucken"** im Browser

### Kartenansicht ändern

**Zoom:**
- Mausrad: Rein/Raus zoomen
- Plus/Minus-Buttons: Zoomen
- Doppelklick: Hineinzoomen

**Verschieben:**
- Maus gedrückt halten und ziehen
- Touch: Finger bewegen

**Vollbild:**
- Klicken Sie auf Vollbild-Symbol
- ESC zum Verlassen

---

## Notizen-System

### Globale Notizen

**Sichtbar für alle Benutzer**

#### Neue Notiz erstellen
1. Navigieren Sie zu **🏠 Home**
2. Scrollen Sie zum Notizen-Bereich
3. Geben Sie Text in das Eingabefeld ein
4. Klicken Sie auf **"Notiz hinzufügen"**

#### Auf Notiz antworten
1. Finden Sie die Notiz
2. Klicken Sie auf **"Antworten"**
3. Geben Sie Ihre Antwort ein
4. Klicken Sie auf **"Antwort senden"**

### Team-Notizen

**Nur für das jeweilige Team**

1. Navigieren Sie zu **👥 Teams**
2. Wählen Sie ein Team
3. Scrollen Sie zum Notizen-Bereich
4. Gleiche Funktionen wie globale Notizen

### Notiz-Historie

- Alle Notizen werden mit Zeitstempel gespeichert
- Sortierung: Neueste zuerst
- Antworten werden als Thread dargestellt

### Notiz-Typen

- **👤 Manuell**: Von Benutzer erstellt
- **🤖 System**: Automatisch erstellt (z.B. Team gestartet)
- **⚠️ Warnung**: Wichtige Hinweise

---

## Einstellungen

### Zugriff auf Einstellungen

1. Navigieren Sie zu **⚙️ Einstellungen**
2. Verschiedene Konfigurationsbereiche verfügbar

### QR-Code für Mobile

1. Im Einstellungen-Bereich
2. Klicken Sie auf **"QR-Code anzeigen"**
3. QR-Code wird generiert
4. Scannen Sie mit Smartphone/Tablet
5. Direkter Zugriff auf die Anwendung

### Theme-Einstellungen

- **Auto**: Folgt System-Einstellung
- **Hell**: Immer heller Modus
- **Dunkel**: Immer dunkler Modus

### Einsatz-Konfiguration

- **Einsatz-Name**: Name des aktuellen Einsatzes
- **Einsatz-Datum**: Start-Datum
- **Einsatz-Ort**: Standort

### Datenbank-Verwaltung

**Backup erstellen:**
1. Klicken Sie auf **"Backup erstellen"**
2. Datei wird heruntergeladen
3. Speichern Sie die Datei sicher

**Backup wiederherstellen:**
1. Stoppen Sie die Anwendung
2. Ersetzen Sie die Datei `einsatzueberwachung.db`
3. Starten Sie die Anwendung neu

**Datenbank zurücksetzen:**
1. Klicken Sie auf **"Datenbank zurücksetzen"**
2. Bestätigen Sie die Sicherheitsabfrage
3. Alle Daten werden gelöscht!

⚠️ **Achtung**: Erstellen Sie vorher ein Backup!

---

## Mobile Nutzung

### Verbindung herstellen

#### Methode 1: QR-Code (empfohlen)
1. Server muss im **Netzwerk-Modus** laufen
2. Öffnen Sie Einstellungen auf dem Server-PC
3. Klicken Sie auf **"QR-Code anzeigen"**
4. Scannen Sie den QR-Code mit Smartphone
5. Browser öffnet sich automatisch

#### Methode 2: Manuelle Eingabe
1. Server muss im **Netzwerk-Modus** laufen
2. Notieren Sie die IP-Adresse (wird beim Start angezeigt)
3. Öffnen Sie Browser auf Mobile-Gerät
4. Geben Sie ein: `https://<IP-Adresse>:7059`
5. Akzeptieren Sie Zertifikat-Warnung

### Mobile Bedienung

- **Touch-optimiert**: Große Buttons, einfache Bedienung
- **Responsive**: Passt sich an Bildschirmgröße an
- **Alle Funktionen**: Keine Einschränkungen

### Zertifikat-Warnung auf Mobile

**Android:**
1. "Erweitert" antippen
2. "Trotzdem fortfahren" wählen

**iOS:**
1. "Details anzeigen" antippen
2. "Diese Website besuchen" antippen
3. Passcode eingeben (falls gefordert)

---

## Dark Mode

### Theme wechseln

**Methode 1: Navigation**
- Klicken Sie auf ☀️/🌙 Icon (rechts oben)
- Theme wechselt sofort

**Methode 2: Einstellungen**
- Navigieren Sie zu **⚙️ Einstellungen**
- Wählen Sie gewünschten Modus
- Klicken Sie auf **"Speichern"**

### Theme-Modi

- **Hell (Light)**: Heller Hintergrund, dunkler Text
- **Dunkel (Dark)**: Dunkler Hintergrund, heller Text
- **Auto**: Folgt System-Einstellung (Windows Dark Mode)

### Theme-Synchronisation

- Theme wird automatisch gespeichert
- In LocalStorage des Browsers
- Bleibt auch nach Neustart erhalten
- Synchronisiert über alle offenen Browser-Tabs

### Dark Mode auf Karten

- Automatische Anpassung der Kartendarstellung
- Dunkle Tiles bei Dark Mode
- Optimierte Farben für bessere Lesbarkeit

---

## Häufige Probleme

### Problem: Script startet nicht

**Lösung 1: PowerShell Execution Policy**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Lösung 2: Rechtsklick → "Mit PowerShell ausführen"**

### Problem: Port bereits belegt

**Fehlermeldung**: "Address already in use"

**Lösung:**
1. Finden Sie den Prozess:
   ```powershell
   netstat -ano | findstr :7059
   ```
2. Beenden Sie den Prozess:
   ```powershell
   taskkill /PID <ProzessID> /F
   ```

### Problem: Keine Verbindung von anderen Geräten

**Checkliste:**
- ✓ Netzwerk-Modus aktiv?
- ✓ Firewall-Regel erstellt? (beim ersten Start)
- ✓ Gleiche Netzwerk (WLAN)?
- ✓ Richtige IP-Adresse?
- ✓ Kein VPN aktiv?

**Firewall manuell prüfen:**
1. Windows-Taste + R
2. `wf.msc` eingeben
3. "Eingehende Regeln" prüfen
4. "Einsatzueberwachung-Web" sollte existieren

### Problem: Dark Mode wird nicht gespeichert

**Lösungen:**
1. Browser-Cache leeren
2. Cookies aktivieren
3. LocalStorage darf nicht blockiert sein
4. Inkognito-Modus vermeiden

### Problem: Karte lädt nicht

**Lösungen:**
1. Internet-Verbindung prüfen (für Tile-Server)
2. Browser-Cache leeren (STRG+F5)
3. JavaScript aktiviert?
4. Browser-Konsole prüfen (F12)

### Problem: Echtzeit-Updates funktionieren nicht

**SignalR-Verbindung prüfen:**
1. F12 drücken (Developer Tools)
2. "Console" Tab öffnen
3. Nach SignalR-Fehlern suchen

**Lösungen:**
- Browser aktualisieren
- Seite neu laden (F5)
- WebSockets aktiviert?

---

## Tastenkombinationen

### Global

| Tastenkombination | Aktion |
|------------------|--------|
| `F5` | Seite neu laden |
| `STRG+F5` | Hard Refresh (Cache leeren) |
| `F11` | Vollbild |
| `F12` | Developer Tools |

### Server (PowerShell)

| Tastenkombination | Aktion |
|------------------|--------|
| `STRG+C` | Server beenden |

### Karten

| Aktion | Maus | Touch |
|--------|------|-------|
| Zoomen | Mausrad | Pinch |
| Verschieben | Ziehen | Wischen |
| Zoom In | Doppelklick | Doppel-Tap |

---

## Tipps & Tricks

### Performance

- **Browser-Cache**: Regelmäßig leeren für beste Performance
- **Tabs**: Schließen Sie nicht benötigte Tabs
- **Neustart**: Bei langem Betrieb mal neu starten

### Workflow

- **Desktop-Verknüpfungen**: Erstellen Sie beide für schnellen Zugriff
- **Backup**: Erstellen Sie regelmäßig Backups der Datenbank
- **Mobile**: QR-Code ist der schnellste Weg

### Sicherheit

- **Zertifikate**: Bei HTTPS erscheinen Warnungen (normal)
- **Firewall**: Nur vertrauenswürdige Netzwerke
- **Backups**: Vor größeren Änderungen

---

## Support & Kontakt

### Selbsthilfe

1. Diese Hilfe-Datei lesen
2. [README.md](README.md) konsultieren
3. Browser-Konsole prüfen (F12)
4. PowerShell-Ausgabe prüfen

### Weitere Ressourcen

- **[README.md](README.md)** - Übersicht und Schnellstart
- **[CHANGELOG.md](CHANGELOG.md)** - Versionshistorie
- **[DEVELOPER_SETUP.md](DEVELOPER_SETUP.md)** - Entwickler-Dokumentation

---

**Stand**: Version 3.0 (Januar 2026)

**Viel Erfolg bei Ihren Einsätzen! 🐕‍🦺**
