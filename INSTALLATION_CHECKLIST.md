# ?? Installations-Checkliste

## Vor dem Upload auf GitHub

### ? Dateien prüfen
- [ ] Alle persönlichen Daten entfernt
- [ ] Keine Passwörter oder API-Keys in Dateien
- [ ] `.gitignore` erstellt
- [ ] `publish/` Ordner nicht hochgeladen (wird von .gitignore ignoriert)

### ? README anpassen
- [ ] `README_GITHUB.md` in `README.md` umbenennen (oder Inhalt kopieren)
- [ ] Ihr GitHub-Username in URLs einfügen
- [ ] Screenshots erstellen und in `docs/screenshots/` speichern
- [ ] Lizenz auswählen und `LICENSE` Datei erstellen

### ? Starter-Dateien testen
- [ ] `START_EINSATZUEBERWACHUNG.bat` getestet
- [ ] `START_HTTP.bat` getestet
- [ ] `STARTER_MENU.bat` getestet
- [ ] `Start-Einsatzueberwachung.ps1` getestet

## GitHub Repository erstellen

### Schritt 1: Auf GitHub
1. Auf [github.com](https://github.com) einloggen
2. Klick auf "New Repository" (grüner Button)
3. Repository-Name: `Einsatzueberwachung.Web`
4. Beschreibung: "Professionelle Einsatzüberwachung für Rettungsdienste"
5. Public oder Private wählen
6. **NICHT** "Initialize with README" aktivieren (haben wir schon)
7. "Create Repository" klicken

### Schritt 2: Lokal vorbereiten
Öffnen Sie eine Kommandozeile im Projektordner:

```bash
# Git initialisieren (falls noch nicht geschehen)
git init

# .gitignore prüfen
git add .gitignore

# Alle Dateien hinzufügen
git add .

# Ersten Commit erstellen
git commit -m "Initial commit - Einsatzüberwachung v2.1.0"

# Branch umbenennen (optional, aber empfohlen)
git branch -M main

# GitHub Repository verknüpfen
git remote add origin https://github.com/Elemirus1996/Einsatzueberwachung.Web.git

# Hochladen
git push -u origin main
```

### Schritt 3: Repository-Einstellungen (optional)

1. **About Section:**
   - Repository ? Settings ? (scroll down) ? "Edit repository details"
   - Website: Ihre Website (optional)
   - Topics: `blazor`, `dotnet`, `emergency-management`, `wasm`, `rescue-service`

2. **README anpassen:**
   - Screenshots hinzufügen (siehe unten)
   - Ihre Kontaktdaten ergänzen

3. **Releases erstellen:**
   - Releases ? "Create a new release"
   - Tag: `v2.1.0`
   - Title: "Version 2.1.0 - Initial Release"
   - Beschreibung aus `CHANGELOG.md` kopieren

## Screenshots erstellen

### Empfohlene Screenshots:
1. **Einsatzmonitor** - Hauptansicht mit Teams und Notizen
2. **Karte** - Interaktive Karte mit Suchgebieten
3. **Dark Mode** - Nachtansicht
4. **Einsatzstart** - Neue Einsatz erstellen Dialog
5. **Bericht** - Generierter PDF-Bericht

### Speicherort:
Erstellen Sie Ordner `docs/screenshots/` und speichern Sie die Bilder als:
- `monitor.png`
- `map.png`
- `dark-mode.png`
- `einsatz-start.png`
- `bericht.png`

## Lizenz hinzufügen

### MIT-Lizenz (empfohlen für Open Source):
Erstellen Sie eine `LICENSE` Datei:

```
MIT License

Copyright (c) 2024 [Ihr Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Nach dem Upload

### ? Testen
- [ ] Repository klonen (anderer Ordner zum Test)
- [ ] Starter-Dateien ausführen
- [ ] Funktioniert alles?

### ? Dokumentation
- [ ] README auf GitHub prüfen
- [ ] Links funktionieren?
- [ ] Screenshots werden angezeigt?

### ? Community
- [ ] Issues aktivieren (Settings ? Features ? Issues)
- [ ] Discussions aktivieren (optional)
- [ ] CONTRIBUTING.md erstellen (optional)

## Wichtige Git-Befehle

```bash
# Status prüfen
git status

# Änderungen hinzufügen
git add .

# Commit erstellen
git commit -m "Beschreibung der Änderungen"

# Hochladen
git push

# Herunterladen
git pull

# Branch erstellen
git checkout -b feature-name

# Branch wechseln
git checkout main
```

## Häufige Probleme

### Problem: "Large files detected"
**Lösung:** 
- `publish/` Ordner nicht hochladen
- Bereits hochgeladen? Aus Git-Historie entfernen:
  ```bash
  git rm -r --cached publish/
  git commit -m "Remove publish folder"
  git push
  ```

### Problem: "Permission denied"
**Lösung:**
- SSH-Key einrichten oder HTTPS mit Token verwenden
- Siehe: [GitHub Docs - Authentication](https://docs.github.com/en/authentication)

### Problem: Falscher Branch
**Lösung:**
```bash
git branch -M main
git push -u origin main
```

## Nächste Schritte

Nach erfolgreichem Upload:

1. **Teilen:** Link zum Repository verbreiten
2. **Updates:** Regelmäßig neue Versionen hochladen
3. **Issues:** Auf Feedback reagieren
4. **Contributions:** Pull Requests annehmen
5. **Releases:** Bei Updates neue Releases erstellen

## Kontakt & Support

- **GitHub Issues:** Für Bug-Reports und Feature-Requests
- **Discussions:** Für Fragen und Diskussionen
- **Email:** [Ihre Email]

---

**Viel Erfolg mit Ihrem Open-Source-Projekt! ??**
