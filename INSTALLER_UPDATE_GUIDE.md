# 📦 Vereinfachter Start & Installation mit Auto-Update

## 🚀 Neue Funktionalität

Einsatzüberwachung bietet jetzt einen **One-Click Installer** und automatische Updates von GitHub!

## ✨ Features

### 1️⃣ **One-Click Installer EXE**
- Automatische .NET 8 Prüfung
- Download der Anwendung von GitHub
- Desktop-Verknüpfung erstellen
- Direkt nach Installation starten

### 2️⃣ **Automatische GitHub Updates**
- Prüft stündlich auf neue Releases
- Zeigt Benachrichtigung an (oben rechts)
- Installer wird heruntergeladen und ausgeführt
- Keine Benutzerinteraktion nötig

### 3️⃣ **Einstellungen**
- Auto-Update aktivieren/deaktivieren
- Manuelle Update-Prüfung möglich

---

## 📋 Installation

### Option A: Mit Installer EXE (Empfohlen!)

1. **Installer herunterladen**
   ```
   EinsatzueberwachungSetup.exe
   ```

2. **Doppelklick auf die EXE**

3. Der Installer prüft:
   - ✓ .NET 8 SDK Installation
   - ✓ GitHub Verbindung
   - ✓ Speicherplatz

4. **Installation abschließen**
   - Installationsort wählen (oder Standard verwenden)
   - Desktop-Verknüpfung erstellen (empfohlen)
   - Nach Installation automatisch starten

### Option B: Manuell (wie bisher)

1. Repository klonen/downloaden
2. PowerShell oder Batch-Datei ausführen
3. Browser öffnet sich automatisch

---

## 🔄 Automatische Updates

### Wie es funktioniert

Die Anwendung prüft **stündlich** auf neue Releases:

1. **Service prüft GitHub**
   ```csharp
   https://api.github.com/repos/Elemirus1996/Einsatzueberwachung.Web/releases/latest
   ```

2. **Version wird verglichen**
   - Aktuelle Version: `3.0.0`
   - GitHub Version: `3.0.1`?
   - Wenn Unterschied: Benachrichtigung zeigen

3. **Update-Benachrichtigung**
   - Oben rechts im Browser
   - "Update verfügbar: 3.0.0 → 3.0.1"
   - Knöpfe: "Später" oder "Update installieren"

4. **Automatische Installation**
   - Installer wird heruntergeladen
   - Wird automatisch gestartet
   - Benutzer muss nur bestätigen
   - App wird danach neu gestartet

### Update-Einstellungen

Im Menü → **Einstellungen** → **System**:

```
☑ Automatisch nach Updates suchen
  ↳ Standardmäßig aktiviert
  
Update-URL: https://api.github.com/repos/Elemirus1996/Einsatzueberwachung.Web
```

### Manuelle Update-Prüfung

Über UI-Komponente (wird noch implementiert):
```
Menü → Einstellungen → "Jetzt nach Updates suchen"
```

---

## 🔧 Technische Details

### Services und Komponenten

#### `GitHubUpdateService` (Domain)
```csharp
- CheckForUpdatesAsync() → UpdateCheckResult
- DownloadInstallerAsync(url) → byte[]
- Vergleicht Versionsnummern
- Handhabt API-Fehler
```

#### `UpdateCheckService` (Web)
```csharp
- BackgroundService (läuft im Hintergrund)
- Prüft stündlich auf Updates
- Fired UpdateAvailable Event
- Startet Installation via ProcessStartInfo
```

#### `UpdateNotificationComponent` (Razor)
```csharp
- Zeigt Benachrichtigung oben rechts
- "Update verfügbar" Button
- Release Notes anzeigen
- Responsive Design
```

### Integration in Program.cs

```csharp
// Update Services registrieren
builder.Services.AddHttpClient<GitHubUpdateService>();
builder.Services.AddSingleton<GitHubUpdateService>();
builder.Services.AddHostedService<UpdateCheckService>();
```

### Installer Projekt

Separates .NET 8 WinForms Projekt:
- **Namespace**: `Einsatzueberwachung.Installer`
- **Assembly**: `EinsatzueberwachungSetup.exe`
- **Größe**: ~50-70 MB (selbstenthalten)

---

## 📂 Dateien

### Neue Dateien
- `Einsatzueberwachung.Domain/Services/GitHubUpdateService.cs`
- `Einsatzueberwachung.Web/Services/UpdateCheckService.cs`
- `Einsatzueberwachung.Web/Components/UpdateNotificationComponent.razor`
- `Einsatzueberwachung.Installer/` (ganzes Projekt)
  - `InstallerForm.cs`
  - `SystemChecker.cs`
  - `Einsatzueberwachung.Installer.csproj`

### Geänderte Dateien
- `Program.cs` - Update Services registriert
- `App.razor` - UpdateNotificationComponent hinzugefügt

---

## 🛠️ Entwicklung

### Installer bauen

```powershell
cd Einsatzueberwachung.Installer
dotnet publish -c Release -o ./output
```

Ausgabe: `output/EinsatzueberwachungSetup.exe`

### Für GitHub Release

1. Neue Version in `GitHubUpdateService` setzen:
   ```csharp
   public string CurrentVersion { get; set; } = "3.1.0";
   ```

2. Release auf GitHub erstellen
3. Installer-EXE als Asset hochladen
4. Version-Tag setzen: `v3.1.0`

---

## ✅ Checkliste für neuen Release

- [ ] Version in `GitHubUpdateService.cs` aktualisieren
- [ ] Changelog aktualisieren
- [ ] Web-App testen
- [ ] Installer bauen und testen
- [ ] GitHub Release erstellen
- [ ] Installer als Asset hochladen
- [ ] Version-Tag setzen (v3.x.x)
- [ ] Release Notes schreiben

---

## 🐛 Troubleshooting

### "Kein Installer gefunden"
- Prüfen Sie, dass in GitHub Release ein `.exe` Asset hochgeladen ist
- Oder: `.exe` muss im Dateiname "Installer" enthalten

### Update wird nicht angeboten
- Prüfen Sie Internet-Verbindung
- Logs prüfen: `Einsatzueberwachung.Web/bin/logs/`
- Manuell prüfen: `appsettings.json` → `AutoCheckUpdates: true`

### Installer startet nicht
- .NET 8 SDK muss installiert sein
- Administrator-Rechte evtl. erforderlich
- Antivirus könnte die Datei blockieren

### Service Worker & Updates
- Browser Cache löschen (STRG+F5)
- Service Worker in DevTools prüfen (F12)
- Reload nach Update erzwingen

---

## 📞 Support

Bei Problemen:
1. Browser Console prüfen (F12)
2. Installer-Logs anschauen
3. .NET Version prüfen: `dotnet --version`
4. GitHub Issue erstellen

---

**Version**: 3.0.0  
**Letzte Aktualisierung**: Januar 2026
