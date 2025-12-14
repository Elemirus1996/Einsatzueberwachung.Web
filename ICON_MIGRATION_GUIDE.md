# ?? Icon-System Migration Guide

## Problem
Emojis werden als `??` angezeigt wegen UTF-8 Encoding-Problemen in Razor-Dateien.

## Lösung
**Bootstrap Icons** (bereits im Projekt vorhanden) verwenden statt Emojis.

## Icon-Mapping Tabelle

| Emoji | Bootstrap Icon CSS | HTML Code | Verwendung |
|-------|-------------------|-----------|------------|
| ?? | `bi bi-alarm-fill` | - | Einsatz/Alarm |
| ?? | `bi bi-bar-chart-fill` | - | Monitor/Statistik |
| ?? | `bi bi-clipboard-data` | - | Stammdaten/Listen |
| ?? | `bi bi-gear-fill` | - | Einstellungen |
| ?? | `bi bi-clock-history` | - | Timer/Zeiterfassung |
| ??? | `bi bi-map-fill` | - | Karte |
| ?? | `bi bi-file-pdf-fill` | - | PDF/Dokumente |
| ?? | `bi bi-people-fill` | - | Personal/Personen |
| ?? | `bi bi-heart-fill` | `&#x1F415;` | Hunde (Herz als Symbol) |
| ?? | `bi bi-triangle-fill` | `&#x1F681;` | Drohne (Dreieck) |
| ??? | `bi bi-tools` | - | Support/Werkzeuge |
| ? | `bi bi-plus-circle-fill` | - | Hinzufügen |
| ?? | `bi bi-pencil-fill` | - | Bearbeiten |
| ??? | `bi bi-trash-fill` | - | Löschen |
| ? | `bi bi-check-circle-fill` | - | Aktiv/Bestätigt |
| ?? | `bi bi-save-fill` | - | Speichern |
| ?? | `bi bi-geo-alt-fill` | - | Standort/Gebiet |
| ?? | `bi bi-sun-fill` | - | Hell-Modus |
| ?? | `bi bi-moon-fill` | - | Dunkel-Modus |
| ?? | `bi bi-building` | - | Gebäude/Staffel |
| ?? | `bi bi-info-circle-fill` | - | Information |
| ?? | `bi bi-palette-fill` | - | Darstellung/Design |
| ?? | `bi bi-arrow-repeat` | - | Updates/Wiederholen |

## Verwendung

### Methode 1: Direkt im HTML
```razor
<h1><i class="bi bi-alarm-fill"></i> Einsatzüberwachung</h1>
```

### Methode 2: Mit Action-Icons
```razor
<div class="action-icon"><i class="bi bi-alarm-fill"></i></div>
```

### Methode 3: Mit eigener Icon-Komponente
```razor
<Icon IconName="alarm" Size="1.5em" />
```

## Dateien die aktualisiert werden müssen

### ? Bereits aktualisiert:
- [x] `Home.razor` - Komplett aktualisiert
- [x] `Einstellungen.razor` - Komplett aktualisiert
- [x] `Icon.razor` - Helper-Komponente erstellt

### ? Noch zu aktualisieren:
- [ ] `EinsatzTeams.razor` - Enthält viele `??`
- [ ] `EinsatzKarte.razor` - Enthält `??` und `???`
- [ ] `NavMenu.razor` - Wahrscheinlich Icons in Navigation
- [ ] `EinsatzMonitor.razor` - Sollte überprüft werden
- [ ] `EinsatzBericht.razor` - Sollte überprüft werden
- [ ] `EinsatzStart.razor` - Sollte überprüft werden

## Schnell-Referenz für häufige Ersetzungen

```razor
<!-- Alt -->
<h1>?? Einsatzüberwachung</h1>

<!-- Neu -->
<h1><i class="bi bi-alarm-fill text-danger"></i> Einsatzüberwachung</h1>

<!-- Alt -->
<button>? Hinzufügen</button>

<!-- Neu -->
<button><i class="bi bi-plus-circle-fill"></i> Hinzufügen</button>

<!-- Alt -->
<span>?? Personal</span>

<!-- Neu -->
<span><i class="bi bi-people-fill"></i> Personal</span>
```

## CSS-Anpassungen

Die Icons können mit Bootstrap-Utilities gestyled werden:
```html
<!-- Größe -->
<i class="bi bi-alarm-fill fs-1"></i>  <!-- Sehr groß -->
<i class="bi bi-alarm-fill fs-4"></i>  <!-- Normal -->

<!-- Farbe -->
<i class="bi bi-alarm-fill text-danger"></i>   <!-- Rot -->
<i class="bi bi-alarm-fill text-primary"></i>  <!-- Blau -->
<i class="bi bi-alarm-fill text-success"></i>  <!-- Grün -->

<!-- Custom Style -->
<i class="bi bi-alarm-fill" style="font-size: 2.5rem; color: #ff6b6b;"></i>
```

## Vorteile dieser Lösung

1. ? **Keine Encoding-Probleme** - Bootstrap Icons sind Schriftarten
2. ? **Konsistentes Design** - Alle Icons im gleichen Stil
3. ? **Einfach anzupassen** - CSS für Größe/Farbe
4. ? **Performance** - Keine Bild-Dateien, nur Fonts
5. ? **Accessibility** - Screen-Reader kompatibel
6. ? **Responsive** - Skalieren mit Text

## Bootstrap Icons Dokumentation

Vollständige Liste aller verfügbaren Icons:
https://icons.getbootstrap.com/

Bereits im Projekt vorhanden (kein zusätzliches Package nötig).

---

**Status:** 2 von 8+ Dateien migriert
**Nächste Schritte:** Systematisch alle verbleibenden Dateien durchgehen
