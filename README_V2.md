# ?? Einsatzüberwachung Web - Version 2.0

Moderne, touch-optimierte Web-Anwendung für die Koordination und Überwachung von Rettungshunde-Einsätzen mit komplett überarbeitetem Design!

## ? Neuigkeiten in Version 2.0

### ?? **Völlig neues Design**
- **Moderneres UI** mit Gradients, Shadows und Animationen
- **Glassmorphism-Effekte** für einen Premium-Look
- **Verbesserte Farbpalette** mit besseren Kontrasten
- **Smooth Animations** für alle Interaktionen

### ?? **Vereinfachter Workflow**
- **Team-Verwaltung direkt im Monitor** - Keine separate Team-Seite mehr nötig
- **Schnellerer Zugriff** auf alle Funktionen
- **Intuitivere Navigation** 
- **One-Click Team-Erstellung** mit modernem Modal-Dialog

### ?? **Optimierte Monitor-Ansicht**
- **Einsatzinfo-Header** mit Badge-System (Einsatz/Übung)
- **Grid-Layout** für bessere Übersicht
- **Team-Cards** mit Hover-Effekten und Farbcodierung
- **Live-Timer** mit kritischen Warnungen (Blinken bei Überschreitung)
- **Chip-Design** für Team-Mitglieder
- **Inline-Bearbeitung** mit Icon-Buttons

---

## ?? Features

### ? Vollständig implementiert

#### **Einsatz-Management**
- ? Einsatz starten mit allen Basisdaten
- ?? Live-Monitor mit integrierter Team-Verwaltung
- ?? Team-Timer mit automatischen Warnungen
- ?? Funkspruch- und Notizen-Log
- ??? Suchgebiete definieren und zuweisen
- ?? Einsatzbericht exportieren (TXT)

#### **Team-Management** (NEU!)
- ? Teams direkt im Monitor erstellen
- ?? Inline-Editing mit Icon-Buttons
- ?? Hunde-Teams mit Spezialisierung
- ?? Drohnen-Teams
- ??? Support-Teams
- ?? Farbcodierung nach Hundeausbildung

#### **Stammdaten**
- ?? Personal mit Qualifikationen
- ?? Hunde mit Ausbildungen
- ? Aktiv/Inaktiv-Status

#### **Einstellungen**
- ?? Staffel-Informationen
- ?? Hell-/Dunkelmodus
- ?? Konfigurierbare Timer-Warnungen

---

## ?? Design-Highlights

### **Home-Seite**
- Hero-Section mit Gradient-Background
- Große Action-Cards mit Hover-Effekten
- Touch-optimierte Buttons (min. 48px)
- Feature-Übersicht

### **Monitor-Seite**
```
???????????????????????????????????????????????
?  ?? EINSATZ | Waldgebiet Römerberg          ?
?  ?? 27.01.2024 | ?? Müller | ?? Schmidt    ?
?  [??? Karte] [?? Bericht]                    ?
???????????????????????????????????????????????

????????????????????????????????????????????????
? ?? Teams (3)      ? ?? Funksprüche & Notizen ?
? [? Team]          ? [Neuer Eintrag...]       ?
????????????????????? ???????????????????????? ?
? Team 1  [??][???]  ? ? 14:23 ?? Team Start ? ?
? ?? Rex (FL)       ? ? Team 1 gestartet    ? ?
? ?? Müller         ? ???????????????????????? ?
? ?? Schmidt        ?                          ?
? ?? Sektor Alpha   ?                          ?
?                   ?                          ?
?   ? 00:45:32 ??   ?                          ?
?   [?? Stop][??]   ?                          ?
????????????????????????????????????????????????
```

### **Moderne Modal-Dialoge**
- Glassmorphism-Background
- Gradient-Header
- Smooth Slide-Up Animation
- Touch-optimierte Formulare
- Button-Group für Team-Typen

---

## ?? Workflow

1. **Home** ? Einsatz starten
2. **Einsatz Start** ? Grunddaten erfassen
3. **Monitor** ? 
   - ? Teams erstellen (direkt im Monitor!)
   - ?? Timer starten
   - ?? Notizen dokumentieren
   - ?? Teams bearbeiten
4. **Karte** ? Suchgebiete definieren
5. **Bericht** ? Export als TXT

---

## ??? Technologie

- **.NET 8** - Framework
- **Blazor Server** - Interactive Components
- **Bootstrap 5** - CSS-Framework
- **Custom CSS** - Modernes Design-System
- **JSON** - Datenpersistenz

---

## ?? Projekt-Struktur

```
Einsatzueberwachung.Web/
??? Einsatzueberwachung.Domain/
?   ??? Models/                    # Domain-Modelle
?   ??? Services/                  # Business-Logik
?   ??? Interfaces/                # Service-Contracts
?
??? Einsatzueberwachung.Web/
?   ??? Components/
?   ?   ??? Pages/
?   ?   ?   ??? Home.razor         # Dashboard
?   ?   ?   ??? EinsatzStart.razor # Einsatz initialisieren
?   ?   ?   ??? EinsatzMonitor.razor # Live-Monitor (NEU!)
?   ?   ?   ??? EinsatzKarte.razor # Kartenansicht
?   ?   ?   ??? EinsatzBericht.razor # Export
?   ?   ?   ??? Stammdaten.razor   # Personal & Hunde
?   ?   ?   ??? Einstellungen.razor # Konfiguration
?   ?   ??? Layout/
?   ?       ??? MainLayout.razor
?   ?       ??? NavMenu.razor
?   ??? wwwroot/
?       ??? app.css                # Modernes CSS (2000+ Zeilen!)
?
??? Einsatzueberwachung.Web.Client/ # WebAssembly (optional)
```

---

## ?? Installation & Start

### Voraussetzungen
- .NET 8 SDK
- Visual Studio 2022 / VS Code / Rider

### Starten

```bash
cd Einsatzueberwachung.Web
dotnet run
```

Öffne Browser: **https://localhost:5001**

---

## ?? Design-System

### Farben
```css
--primary-color: #2196F3   /* Blau */
--success-color: #4CAF50   /* Grün */
--warning-color: #FF9800   /* Orange */
--danger-color: #f44336    /* Rot */
--info-color: #00BCD4      /* Cyan */
```

### Hundeausbildungen (Farbcodierung)
- ?? **Fläche** - #2196F3
- ?? **Trümmer** - #FF9800
- ?? **Mantrailer** - #4CAF50
- ?? **Wasser** - #00BCD4
- ?? **Lawine** - #9C27B0
- ?? **Gelände** - #8BC34A
- ?? **Leiche** - #795548
- ?? **Ausbildung** - #FFC107

### Touch-Optimierung
- **Min. Button-Höhe**: 48px
- **Large Buttons**: 56px
- **Form-Controls**: 48px
- **Tap-Targets**: Min. 44x44px
- **Spacing**: Großzügige Abstände für Finger

---

## ?? Responsive Design

- **Desktop** (>1200px): Grid-Layout mit Sidebar
- **Tablet** (768-1200px): Stack-Layout optimiert
- **Mobile** (<768px): Single-Column mit größeren Buttons

---

## ?? Was ist neu (vs. Version 1.0)

| Feature | v1.0 | v2.0 |
|---------|------|------|
| Team-Verwaltung | Separate Seite | ? Direkt im Monitor |
| Design | Standard Bootstrap | ?? Custom Modern Design |
| Modals | Bootstrap-Modals | ? Moderne Glassmorphism |
| Animations | Keine | ? Smooth Transitions |
| Timer | Einfache Anzeige | ?? Blinken bei Kritisch |
| Team-Cards | Basis-Design | ? Gradients & Shadows |
| Button-Größe | Standard | ?? Touch-optimiert (48px+) |
| Navigation | 8 Links | ? 6 Links (vereinfacht) |

---

## ?? Roadmap

### Phase 1 (Q2 2024)
- ??? **Leaflet.js Integration** - Echte Kartenansicht
- ?? **QuestPDF** - Professionelle PDF-Berichte mit Logo

### Phase 2 (Q3 2024)
- ?? **Entity Framework Core** - SQLite-Datenbank
- ?? **Statistiken** - Auswertungen vergangener Einsätze
- ?? **Benachrichtigungen** - Push bei kritischen Timern

### Phase 3 (Q4 2024)
- ?? **Multi-User** - Mehrere Nutzer gleichzeitig
- ?? **SignalR** - Echtzeit-Synchronisation
- ?? **PWA** - Als App installierbar

---

## ?? Lizenz

(Lizenz hier einfügen)

---

## ?? Autor

**Elemirus1996**

Basierend auf: [Einsatzueberwachung WPF](https://github.com/Elemirus1996/Einsatzueberwachung)

---

## ?? Support

Bei Fragen oder Problemen:
- GitHub Issues erstellen
- Dokumentation lesen
- Code-Kommentare beachten

---

*Entwickelt mit ?? für Rettungshundestaffeln*

**Version 2.0** - Januar 2024
