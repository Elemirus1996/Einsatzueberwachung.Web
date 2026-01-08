# ? Pre-Release Checkliste - Version 1.5.0

## ?? Vor dem Release

### Code & Tests
- [ ] Alle Dateien gespeichert
- [ ] Build erfolgreich: `dotnet build`
- [ ] Keine Compiler-Fehler oder Warnungen
- [ ] Alle neuen Features getestet:
  - [ ] Mobile Dashboard funktioniert
  - [ ] QR-Code wird generiert
  - [ ] SignalR-Verbindung stabil
  - [ ] PIN-Authentifizierung funktioniert
  - [ ] Netzwerk-Zugriff funktioniert
  - [ ] Auto-Reconnect funktioniert
  - [ ] Timer-Updates werden synchronisiert

### Dokumentation
- [x] CHANGELOG.md aktualisiert
- [x] README.md aktualisiert
- [x] RELEASE_V1.5.md erstellt
- [x] Alle Mobile-Dokumentationen vorhanden:
  - [x] MOBILE_README.md
  - [x] MOBILE_QUICK_START.md
  - [x] MOBILE_DEPLOYMENT_CHECKLIST.md
  - [x] MOBILE_VISUAL_GUIDE.md
  - [x] MOBILE_SUMMARY.md
  - [x] MOBILE_IMPLEMENTATION.md
  - [x] MOBILE_NETWORK_ACCESS.md
  - [x] MOBILE_QR_VISUAL_GUIDE.md

### Versionierung
- [x] Version in .csproj auf 1.5.0
- [x] AssemblyVersion auf 1.5.0.0
- [x] FileVersion auf 1.5.0.0

### Git & Repository
- [ ] Alle Änderungen committed
- [ ] Branch ist aktuell
- [ ] Keine unerwünschten Dateien im Commit
- [ ] .gitignore korrekt

---

## ?? Release durchführen

### 1. Lokaler Build-Test
```bash
cd Einsatzueberwachung.Web
dotnet clean
dotnet restore
dotnet build
```

**Ergebnis:**
- [ ] Build erfolgreich
- [ ] Keine Fehler
- [ ] Keine Warnungen

### 2. Funktionstest Lokal
```bash
dotnet run
```

**Testen:**
- [ ] Anwendung startet
- [ ] http://localhost:5000 erreichbar
- [ ] Navigation funktioniert
- [ ] Einsatz kann gestartet werden
- [ ] Teams können erstellt werden

### 3. Funktionstest Netzwerk
```batch
START_NETWORK_SERVER.bat
```

**Testen:**
- [ ] Server startet auf 0.0.0.0:5000
- [ ] Firewall-Regel existiert
- [ ] /mobile/connect erreichbar
- [ ] QR-Code wird angezeigt
- [ ] IP-Adresse korrekt
- [ ] Mobile URL funktioniert
- [ ] PIN-Login funktioniert
- [ ] Mobile Dashboard zeigt Daten

### 4. SignalR-Test
**Setup:**
- Desktop: EinsatzMonitor offen
- Mobile: MobileDashboard offen

**Testen:**
- [ ] Team erstellen ? erscheint auf Mobile
- [ ] Team bearbeiten ? Update auf Mobile
- [ ] Timer starten ? läuft auf Mobile
- [ ] Notiz erstellen ? erscheint auf Mobile
- [ ] Funkspruch ? erscheint auf Mobile

### 5. Multi-Device-Test
**3 Geräte gleichzeitig:**
- [ ] Desktop + 2x Mobile gleichzeitig verbunden
- [ ] Alle empfangen Updates
- [ ] Keine Verzögerungen
- [ ] Keine Verbindungsabbrüche

---

## ?? Git Release

### 1. Status prüfen
```bash
git status
```
- [ ] Alle Änderungen angezeigt
- [ ] Keine unerwünschten Dateien

### 2. Commit & Push
```batch
RELEASE_TO_GITHUB_V1.5.bat
```

**Oder manuell:**
```bash
git add .
git commit -m "Release v1.5.0 - Mobile Dashboard mit SignalR und QR-Code Verbindung"
git tag -a v1.5.0 -m "Version 1.5.0 - Mobile Dashboard"
git push origin main
git push origin v1.5.0
```

**Ergebnis:**
- [ ] Commit erfolgreich
- [ ] Tag erstellt
- [ ] Push erfolgreich
- [ ] Auf GitHub sichtbar

---

## ?? GitHub Release erstellen

### 1. Zu GitHub navigieren
- URL: https://github.com/Elemirus1996/Einsatzueberwachung.Web
- [ ] Repository geöffnet

### 2. Release erstellen
1. [ ] Klick auf "Releases"
2. [ ] Klick "Draft a new release"
3. [ ] Tag wählen: `v1.5.0`
4. [ ] Release Titel: **Version 1.5.0 - Mobile Dashboard**
5. [ ] Beschreibung aus `RELEASE_V1.5.md` kopieren
6. [ ] Als "Latest release" markieren
7. [ ] Klick "Publish release"

### 3. Release überprüfen
- [ ] Release ist veröffentlicht
- [ ] Tag ist sichtbar
- [ ] Beschreibung korrekt formatiert
- [ ] Download-Links funktionieren

---

## ?? Nach dem Release

### GitHub README
- [ ] README.md wird korrekt angezeigt
- [ ] Badges aktualisiert (falls vorhanden)
- [ ] Mobile Dashboard im Feature-Set erwähnt

### Dokumentation
- [ ] Wiki aktualisiert (falls vorhanden)
- [ ] Issues geschlossen, die mit v1.5 gelöst wurden
- [ ] Roadmap aktualisiert

### Optional: Promotion
- [ ] Social Media Post
- [ ] Community informieren
- [ ] Feedback-Kanäle öffnen

---

## ?? Rollback-Plan

Falls Probleme auftreten:

### Tag löschen
```bash
git tag -d v1.5.0
git push origin :refs/tags/v1.5.0
```

### Commit rückgängig
```bash
git revert HEAD
git push origin main
```

### Release auf GitHub löschen
1. Zu Release navigieren
2. "Delete" klicken
3. Tag separat löschen

---

## ?? Erfolgsmetriken

Nach 1 Woche prüfen:
- [ ] Anzahl Downloads
- [ ] GitHub Stars
- [ ] Issues geöffnet
- [ ] Feedback erhalten
- [ ] Bug Reports

---

## ? Finale Checkliste

**Alles bereit für v1.5.0?**

- [ ] Code getestet ?
- [ ] Dokumentation komplett ?
- [ ] Build erfolgreich ?
- [ ] Git committed ?
- [ ] GitHub Release erstellt ?
- [ ] Community informiert ??

---

**?? Release v1.5.0 "Mobile Dashboard" abgeschlossen!**

Datum: ______________
Durchgeführt von: ______________
Dauer: ______________
Probleme: ______________

