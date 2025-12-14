# Karten-Druckfunktion - Update V2.1

## ??? Verbesserte Druckfunktionalität

### Neue Features

Die Druckfunktion wurde erheblich erweitert und zeigt nun automatisch alle relevanten Informationen in einer professionellen Legende an.

---

## ?? Legende-Details

### Aufbau der Legende

Die Legende wird automatisch beim Drucken rechts unten auf der Karte angezeigt und enthält:

#### 1. **ELW-Position** (falls gesetzt)
```
???????????????????????????????????????
? ?? ELW - Einsatzleitwagen           ?
?    Position: 49.31880, 8.43120      ?
???????????????????????????????????????
```
- **Hervorgehoben** mit gelbem Hintergrund und rotem Rahmen
- **Koordinaten** werden angezeigt
- Nur sichtbar, wenn ELW-Position gesetzt ist

#### 2. **Suchgebiete-Liste**
```
Suchgebiete (3)

???????????????????????????????????????
? ? Sektor Alpha                      ?
?   ?? Team 1                          ?
?   ?? 2.5 ha                          ?
?   ? Abgeschlossen                    ?
?   ?? Waldgebiet nördlich            ?
???????????????????????????????????????
? ? Sektor Bravo                      ?
?   ?? Team 2                          ?
?   ?? 1.8 ha                          ?
?   ? In Bearbeitung                  ?
???????????????????????????????????????
? ? Sektor Charlie                    ?
?   ?? 3.2 ha                          ?
?   ? In Bearbeitung                  ?
???????????????????????????????????????
```

Für jedes Suchgebiet wird angezeigt:
- **Farbcodierung**: Farbiger Kasten mit der definierten Farbe
- **Name**: Bezeichnung des Suchgebiets
- **Team** (falls zugewiesen): Blauer Badge mit Team-Namen
- **Fläche**: Graues Badge mit berechneter Fläche
- **Status**: 
  - ? Grüner Badge für "Abgeschlossen"
  - ? Gelber Badge für "In Bearbeitung"
- **Notizen** (falls vorhanden): Kursiv und grau

#### 3. **Statistik-Sektion**
```
?????????????????????????????????????
Statistik:
  ? Gebiete gesamt: 3
  ? Abgeschlossen: 1
  ? In Bearbeitung: 2
  ? Gesamtfläche: 7.5 ha
```

Automatisch berechnet:
- Anzahl aller Suchgebiete
- Anzahl abgeschlossene Gebiete
- Anzahl in Bearbeitung befindliche Gebiete
- Gesamtfläche aller Suchgebiete (summiert)

---

## ?? Visuelle Gestaltung

### Farbcodierung

**Team-Badge:**
- Hintergrund: Blau (#0d6efd)
- Text: Weiß
- Icon: ??

**Flächen-Badge:**
- Hintergrund: Grau (#6c757d)
- Text: Weiß
- Icon: ??

**Status-Badge "Abgeschlossen":**
- Hintergrund: Grün (#198754)
- Text: Weiß
- Icon: ?

**Status-Badge "In Bearbeitung":**
- Hintergrund: Gelb (#ffc107)
- Text: Schwarz
- Icon: ?

### Layout

```
???????????????????????????????????????????????????
?  KOPFZEILE                                      ?
?  Einsatznummer - Einsatzort                     ?
?  Datum und Uhrzeit                              ?
???????????????????????????????????????????????????
?                                                 ?
?                                         ??????? ?
?                                         ?     ? ?
?           KARTE                         ? L   ? ?
?                                         ? E   ? ?
?                                         ? G   ? ?
?                                         ? E   ? ?
?                                         ? N   ? ?
?                                         ? D   ? ?
?                                         ? E   ? ?
?                                         ??????? ?
???????????????????????????????????????????????????
```

- **Kopfzeile**: Oben zentriert
- **Karte**: 80vh Höhe, volle Breite
- **Legende**: Rechts unten, max. 350px breit
- **Rahmen**: 3px schwarzer Rand
- **Schatten**: 4px für 3D-Effekt

---

## ?? Technische Details

### CSS-Klassen

**Legende-Container:**
```css
.print-legend {
    position: absolute;
    bottom: 20px;
    right: 20px;
    max-width: 350px;
    background: white;
    border: 3px solid #333;
    box-shadow: 0 4px 10px rgba(0,0,0,0.3);
    border-radius: 5px;
}
```

**Legende-Items:**
```css
.legend-item {
    display: flex;
    align-items: flex-start;
    margin: 8px 0;
    padding: 5px;
    border-bottom: 1px solid #eee;
}
```

**Badges:**
```css
.team-badge {
    background: #0d6efd;
    color: white;
    padding: 2px 6px;
    border-radius: 3px;
}

.area-badge {
    background: #6c757d;
    color: white;
    padding: 2px 6px;
    border-radius: 3px;
}

.status-badge.completed {
    background: #198754;
    color: white;
}

.status-badge.in-progress {
    background: #ffc107;
    color: #000;
}
```

### Razor-Code

**Legende-Generierung:**
```csharp
<!-- Legende sortiert nach Team -->
@foreach (var area in _searchAreas.OrderBy(a => a.AssignedTeamName ?? "zzz"))
{
    <div class="legend-item">
        <span class="legend-color" style="background-color: @area.Color"></span>
        <div class="legend-details">
            <strong>@area.Name</strong>
            
            @if (!string.IsNullOrEmpty(area.AssignedTeamName))
            {
                <span class="team-badge">?? @area.AssignedTeamName</span>
            }
            
            @if (area.AreaInSquareMeters > 0)
            {
                <span class="area-badge">?? @area.FormattedArea</span>
            }
            
            <span class="status-badge @(area.IsCompleted ? "completed" : "in-progress")">
                @(area.IsCompleted ? "? Abgeschlossen" : "? In Bearbeitung")
            </span>
            
            @if (!string.IsNullOrEmpty(area.Notes))
            {
                <small class="notes">?? @area.Notes</small>
            }
        </div>
    </div>
}
```

**Statistik-Berechnung:**
```csharp
private string GetTotalArea()
{
    if (!_searchAreas.Any()) return "0 m²";
    
    var totalSquareMeters = _searchAreas.Sum(a => a.AreaInSquareMeters);
    
    if (totalSquareMeters < 1)
        return "< 1 m²";
    else if (totalSquareMeters < 50000)
        return $"{totalSquareMeters:N0} m²";
    else if (totalSquareMeters < 1000000)
        return $"{(totalSquareMeters / 10000.0):N2} ha";
    else
        return $"{(totalSquareMeters / 1000000.0):N2} km²";
}
```

---

## ?? Sortierung

Die Suchgebiete werden automatisch sortiert:

1. **Primär**: Nach Team-Namen (alphabetisch)
2. **Sekundär**: Gebiete ohne Team-Zuweisung am Ende

```csharp
_searchAreas.OrderBy(a => a.AssignedTeamName ?? "zzz")
```

Dies stellt sicher, dass:
- Gebiete desselben Teams zusammen stehen
- Die Übersicht strukturiert ist
- Nicht zugewiesene Gebiete am Ende erscheinen

---

## ?? Anwendungsbeispiel

### Szenario: Einsatz mit 3 Teams

**Einsatzdaten:**
- Einsatznummer: E-2024-0042
- Einsatzort: Pfälzerwald, Nähe Johanniskreuz
- Datum: 15.03.2024 14:30

**Suchgebiete:**
1. **Sektor Nord** (Team Alpha, 2.5 ha, Abgeschlossen)
2. **Sektor Süd** (Team Alpha, 1.8 ha, In Bearbeitung)
3. **Sektor Ost** (Team Bravo, 3.2 ha, In Bearbeitung)
4. **Sektor West** (Team Charlie, 2.1 ha, In Bearbeitung)
5. **Parkplatz** (Nicht zugewiesen, 0.3 ha, In Bearbeitung)

**Gedruckte Legende:**
```
??????????????????????????????????????????
? ?? ELW - Einsatzleitwagen             ?
?    Position: 49.12345, 8.67890         ?
??????????????????????????????????????????

Suchgebiete (5)

? Sektor Nord
  ?? Team Alpha    ?? 2.5 ha
  ? Abgeschlossen

? Sektor Süd
  ?? Team Alpha    ?? 1.8 ha
  ? In Bearbeitung

? Sektor Ost
  ?? Team Bravo    ?? 3.2 ha
  ? In Bearbeitung

? Sektor West
  ?? Team Charlie  ?? 2.1 ha
  ? In Bearbeitung

? Parkplatz
  ?? 0.3 ha
  ? In Bearbeitung

????????????????????????????????????????
Statistik:
  ? Gebiete gesamt: 5
  ? Abgeschlossen: 1
  ? In Bearbeitung: 4
  ? Gesamtfläche: 9.9 ha
```

---

## ?? Vorteile

### Für Einsatzleiter:
- ? **Auf einen Blick**: Alle Informationen kompakt
- ? **Team-Übersicht**: Welches Team wo sucht
- ? **Fortschritt**: Status jedes Gebiets erkennbar
- ? **Flächenangaben**: Größe jedes Suchgebiets
- ? **Statistik**: Gesamtübersicht

### Für Teams:
- ? **Zuordnung**: Eigenes Gebiet schnell finden
- ? **Orientierung**: Farbe auf Karte und Legende
- ? **Größe**: Einschätzung des Suchaufwands
- ? **Notizen**: Wichtige Hinweise direkt sichtbar

### Für Dokumentation:
- ? **Professionell**: Sauberes Layout
- ? **Vollständig**: Alle Informationen enthalten
- ? **Archivierbar**: PDF-Export möglich
- ? **Nachvollziehbar**: Status und Zeiten dokumentiert

---

## ?? Details zu einzelnen Elementen

### ELW-Position Box

**Wann sichtbar:**
- Nur wenn `EinsatzService.CurrentEinsatz.ElwPosition.HasValue == true`

**Darstellung:**
```html
<div class="legend-item elw-item">
    <span class="legend-marker elw-marker">??</span>
    <div class="legend-details">
        <strong>ELW</strong> - Einsatzleitwagen
        <br/><small>Position: 49.31880, 8.43120</small>
    </div>
</div>
```

**Styling:**
- Gelber Hintergrund (#fff3cd)
- Roter Rahmen (2px)
- Extra Padding (8px)
- Abgerundete Ecken

### Farbkästchen

**Größe:** 20x20 Pixel  
**Form:** Abgerundete Ecken (3px)  
**Rahmen:** 2px (20% dunkler als Füllfarbe)  
**Position:** Links neben dem Text

### Status-Badges

**Abgeschlossen:**
- Grün (#198754)
- ? Häkchen-Symbol
- Weißer Text

**In Bearbeitung:**
- Gelb (#ffc107)
- ? Sanduhr-Symbol
- Schwarzer Text

### Notizen

**Darstellung:**
- Kursiv
- Grau (#666)
- Kleinere Schrift (8pt)
- Icon: ??

**Wann sichtbar:**
- Nur wenn `area.Notes` nicht leer

---

## ?? Flächenformatierung

Die Fläche wird automatisch in der passenden Einheit angezeigt:

| Bereich | Einheit | Beispiel |
|---------|---------|----------|
| < 1 m² | m² | "< 1 m²" |
| 1 - 50.000 m² | m² | "12.345 m²" |
| 50.000 - 1.000.000 m² | Hektar | "7.5 ha" |
| > 1.000.000 m² | km² | "2.5 km²" |

**Formatierung:**
- Tausendertrennzeichen bei m² (12.345 m²)
- 2 Dezimalstellen bei ha und km² (7.50 ha)

---

## ??? Druckoptimierungen

### Versteckte Elemente
```css
@media print {
    .btn, .btn-group, .badge:not(.print-legend .badge) {
        display: none !important;
    }
}
```

### Sichtbare Elemente
- Karte (80vh)
- Kopfzeile
- Legende
- Alle Marker und Suchgebiete

### Seiteneinstellungen
```css
@page {
    size: landscape;
    margin: 1cm;
}
```

---

## ?? Tipps für beste Druckergebnisse

1. **PDF-Export**: 
   - Im Druckdialog "Als PDF speichern" wählen
   - Beste Qualität für Archivierung

2. **Farbe**:
   - Farbdruck empfohlen für Farbcodierung
   - Schwarz-Weiß: Legende bleibt lesbar

3. **Papierformat**:
   - A4 Querformat optimal
   - Ränder: 1cm (Standard)

4. **Vorschau**:
   - Druckvorschau prüfen vor dem Druck
   - Legende sollte vollständig sichtbar sein

5. **Kartenausschnitt**:
   - Vor dem Drucken Zoom anpassen
   - Alle Suchgebiete sollten sichtbar sein

---

## ?? Zukünftige Erweiterungen

**Potenzielle Features:**
- Export als PNG-Bild
- Anpassbare Legende (Position/Größe)
- Mehrsprachigkeit
- Team-Farben in Legende
- QR-Code mit Einsatz-Details
- Zeitstempel für jedes Gebiet
- Suchfortschritt in Prozent

---

## ?? Verwendung

**Drucken aktivieren:**
```csharp
private async Task PrintMap()
{
    var result = await JSRuntime.InvokeAsync<bool>("confirm", 
        "Karte drucken?\n\nTipp: Im Druckdialog können Sie 'Als PDF speichern' wählen.");
    
    if (result)
    {
        await JSRuntime.InvokeVoidAsync("LeafletMap.printMap", "einsatzMap");
    }
}
```

**JavaScript:**
```javascript
printMap: function(mapId) {
    window.print();
    return true;
}
```

---

**Version**: 2.1  
**Letzte Aktualisierung**: 2024  
**Changelog**: Detaillierte Legende mit Team-Zuweisungen und Statistiken
