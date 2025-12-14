# Einsatzüberwachung - Quick Start Guide

## ?? Schnellstart für Windows

### Voraussetzungen
- **.NET 8 SDK** muss installiert sein
- Download: [https://dotnet.microsoft.com/download/dotnet/8.0](https://dotnet.microsoft.com/download/dotnet/8.0)

### Installation & Start

1. **Repository klonen oder herunterladen**
```bash
git clone https://github.com/Elemirus1996/Einsatzueberwachung.Web.git
```
   
Oder als ZIP herunterladen und entpacken

2. **Anwendung starten**
   
   Es gibt mehrere Möglichkeiten:

   #### Option 1: Desktop-Shortcut (Empfohlen für tägliche Nutzung)
   
   1. Rechtsklick auf `START_EINSATZUEBERWACHUNG.bat`
   2. "Verknüpfung erstellen" wählen
   3. Die Verknüpfung auf den Desktop ziehen
   4. Optional: Rechtsklick auf Verknüpfung ? Eigenschaften ? "Symbol ändern" für ein eigenes Icon
   5. **Doppelklick auf Desktop-Shortcut** ? Anwendung startet automatisch!

   #### Option 2: Batch-Datei direkt ausführen
   
   **Doppelklick auf eine der folgenden Dateien:**
   
   - `START_EINSATZUEBERWACHUNG.bat` - Startet mit HTTPS (Standard, empfohlen)
   - `START_HTTP.bat` - Startet mit HTTP (falls HTTPS-Zertifikat Probleme macht)

   #### Option 3: PowerShell-Script
   
   Rechtsklick auf `Start-Einsatzueberwachung.ps1` ? "Mit PowerShell ausführen"

   #### Option 4: Manuell über Kommandozeile
   
   ```bash
   cd Einsatzueberwachung.Web
   dotnet run
   ```

3. **Browser öffnet sich automatisch**
   
   - HTTPS: `https://localhost:7059`
   - HTTP: `http://localhost:5222`

4. **Beenden**
   
   Drücken Sie `STRG+C` im Konsolenfenster oder schließen Sie das Fenster

## ?? Erstmalige Einrichtung

### .NET 8 SDK Installation prüfen

Öffnen Sie eine Kommandozeile und führen Sie aus:
```bash
dotnet --version
```

Wenn Version 8.x.x angezeigt wird, ist alles bereit!

### Optionale Konfiguration

Die Anwendung speichert alle Daten lokal im Browser (LocalStorage/IndexedDB).
Keine weitere Konfiguration erforderlich!

## ?? Projektstruktur

```
Einsatzueberwachung/
??? START_EINSATZUEBERWACHUNG.bat   ? Hauptstarter (HTTPS)
??? START_HTTP.bat                   ? HTTP-Starter
??? Start-Einsatzueberwachung.ps1   ? PowerShell-Starter
??? QUICK_START.md                   ? Diese Anleitung
??? Einsatzueberwachung.Web/        ? Hauptprojekt
??? Einsatzueberwachung.Domain/     ? Business Logic
??? Einsatzueberwachung.Web.Client/ ? WebAssembly Client
```

## ?? Desktop-Shortcut mit eigenem Icon (Optional)

### Schritt 1: Icon erstellen/besorgen
- Erstellen Sie ein `.ico` File oder laden Sie eins herunter
- Speichern Sie es z.B. als `einsatz-icon.ico` im Hauptverzeichnis

### Schritt 2: Shortcut anpassen
1. Rechtsklick auf die Desktop-Verknüpfung ? Eigenschaften
2. Klick auf "Symbol ändern..."
3. Durchsuchen und Ihr Icon auswählen
4. OK ? Anwenden

## ?? HTTPS-Zertifikat einrichten (Beim ersten Start)

Falls beim ersten Start eine Warnung wegen des HTTPS-Zertifikats erscheint:

```bash
dotnet dev-certs https --trust
```

Bestätigen Sie die Sicherheitsabfrage mit "Ja".

## ?? Problembehandlung

### Problem: "dotnet" wird nicht erkannt
**Lösung:** .NET 8 SDK ist nicht installiert oder nicht im PATH
- Installieren Sie .NET 8 SDK neu
- Starten Sie den Computer neu

### Problem: Port bereits belegt
**Lösung:** Ändern Sie den Port in `launchSettings.json` oder verwenden Sie `START_HTTP.bat`

### Problem: Browser öffnet sich nicht automatisch
**Lösung:** Öffnen Sie manuell:
- HTTPS: `https://localhost:7059`
- HTTP: `http://localhost:5222`

### Problem: HTTPS-Zertifikat-Warnung
**Lösung:** Führen Sie aus:
```bash
dotnet dev-certs https --trust
```

## ?? Support

Bei Fragen oder Problemen öffnen Sie ein Issue auf GitHub.

## ?? Lizenz

[Ihre Lizenz hier einfügen]

---

**Viel Erfolg bei Ihren Einsätzen! ???????**
