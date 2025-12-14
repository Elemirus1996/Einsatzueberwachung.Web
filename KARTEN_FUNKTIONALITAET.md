# Karten-Funktionalität - Vollständige Dokumentation

## Übersicht
Die Karten-Seite bietet umfassende Funktionen zur Verwaltung von Suchgebieten, ELW-Positionierung und Kartenansichten für die Einsatzüberwachung.

---

## ? Implementierte Features

### 1. ??? Kartenansichten (Hybrid, Satellit, Streets)

**Beschreibung:**  
Drei verschiedene Kartenansichten stehen zur Verfügung und können mit einem Klick umgeschaltet werden.

**Verfügbare Ansichten:**
- **Straßenkarte**: OpenStreetMap-Karte mit detaillierten Straßeninformationen
- **Satellit**: Esri World Imagery - Satellitenbilder in hoher Auflösung
- **Hybrid**: Google Hybrid - Kombination aus Satellitenbild und Straßenbeschriftungen

**Bedienung:**
- Verwenden Sie die Button-Gruppe oberhalb der Karte
- Die aktuelle Ansicht wird mit einem blauen Rahmen hervorgehoben
- Die Auswahl bleibt während der Sitzung erhalten

**Technische Details:**
- Implementiert in: `leaflet-interop.js` ? `changeBaseLayer()`
- Layer werden dynamisch gewechselt ohne Neuladung der Karte
- Alle gezeichneten Suchgebiete und Marker bleiben erhalten

---

### 2. ?? Suchgebiete einzeichnen

**Beschreibung:**  
Benutzer können verschiedene Arten von Suchgebieten auf der Karte erstellen.

**Verfügbare Werkzeuge:**
- **Polygon**: Beliebige Formen zeichnen (Klick für jeden Punkt, Doppelklick zum Beenden)
- **Rechteck**: Rechteckige Bereiche durch Ziehen erstellen
- **Marker**: Einzelne Marker setzen

**Workflow:**
1. Werkzeug auf der linken Seite der Karte auswählen
2. Suchgebiet auf der Karte einzeichnen
3. Automatischer Dialog öffnet sich zur Eingabe von Details:
   - **Name**: Bezeichnung des Suchgebiets (z.B. "Sektor Alpha")
   - **Farbe**: Visuelle Kennzeichnung auf der Karte
   - **Team-Zuweisung**: Optional ein Team dem Gebiet zuweisen
   - **Notizen**: Zusätzliche Informationen
   - **Status**: Markierung als "Abgeschlossen"

**Features:**
- Automatische Flächenberechnung (m², ha, km²)
- Koordinaten werden gespeichert
- GeoJSON-Format für präzise Speicherung
- Suchgebiete können bearbeitet und gelöscht werden

**Technische Details:**
- Verwendet Leaflet.draw Plugin
- Callback-Funktion: `OnShapeCreated(string geoJson)`
- Flächenberechnung mit Shoelace-Formel für Polygone

---

### 3. ?? ELW-Marker (Einsatzleitwagen)

**Beschreibung:**  
Der rote ELW-Marker zeigt die Position des Einsatzleitwagens auf der Karte an.

**Features:**
- **Roter, deutlich sichtbarer Marker** mit "E"-Symbol
- **Draggable**: Marker kann mit der Maus verschoben werden
- **Positionsspeicherung**: Position wird dauerhaft im Einsatz gespeichert
- **Automatische Wiederherstellung**: Bei erneutem Laden der Seite wird die Position wiederhergestellt

**Bedienung:**
1. **Karte positionieren**: Zoomen/Verschieben Sie die Karte zur gewünschten Position
2. **ELW setzen**: Klicken Sie auf "ELW-Position setzen"
3. **Bestätigung**: Dialog zeigt die exakten Koordinaten an
4. **Verschieben**: ELW-Marker kann jederzeit mit der Maus verschoben werden
5. **Badge-Anzeige**: Ein grünes Badge zeigt an, dass ELW gesetzt ist

**Position ändern:**
- Ziehen Sie den roten Marker an eine neue Position
- Die Position wird automatisch aktualisiert und gespeichert
- Alternativ: Button "ELW verschieben" nutzen (setzt Marker auf neue Kartenmitte)

**Technische Details:**
- Speicherort: `EinsatzData.ElwPosition` (Tupel mit Lat/Lng)
- Callback bei Verschiebung: `OnElwMarkerMoved(double lat, double lng)`
- Icon: Custom SVG mit roter Farbe und "E"-Kennzeichnung
- JavaScript-Funktion: `LeafletMap.setMarker()`

---

### 4. ??? Druckfunktionalität

**Beschreibung:**  
Die Karte kann gedruckt oder als PDF exportiert werden.

**Features:**
- **Optimierter Druck**: Alle UI-Elemente werden ausgeblendet
- **Landscape-Modus**: Automatisch im Querformat
- **Kopfzeile**: Einsatznummer, Einsatzort und Datum
- **Legende**: Automatisch generierte Legende mit allen Suchgebieten
- **ELW-Position**: Wird auf dem Ausdruck angezeigt
- **PDF-Export**: Über Browser-Funktion "Als PDF speichern"

**Bedienung:**
1. Klicken Sie auf "Karte drucken"
2. Bestätigungsdialog mit Hinweis zu PDF-Export
3. Druckdialog des Browsers öffnet sich
4. Wählen Sie:
   - **Drucker** oder **Als PDF speichern**
   - **Ausrichtung**: Querformat (automatisch)
   - **Ränder**: 1cm (empfohlen)

**Druckansicht beinhaltet:**
- Vollständige Karte mit allen Suchgebieten
- ELW-Marker (falls gesetzt)
- Kopfzeile mit Einsatzinformationen
- Legende unten links mit:
  - Farbkodierung aller Suchgebiete
  - Namen der Suchgebiete
  - Zugewiesene Teams

**Technische Details:**
- CSS-Datei: `print-map.css`
- Media Query: `@media print`
- Seitengröße: `@page { size: landscape; margin: 1cm; }`
- JavaScript-Funktion: `LeafletMap.printMap()`

---

## ?? Zusätzliche Features

### Adresssuche
- Geocoding über Nominatim (OpenStreetMap)
- Adresse eingeben ? automatische Positionierung auf der Karte
- Einsatzort-Marker wird gesetzt
- Adresse wird im Einsatz gespeichert

### Suchgebiete-Verwaltung
- **Übersichtstabelle** unterhalb der Karte
- **Zoom-Funktion** zu einzelnen Gebieten
- **Bearbeiten** von Namen, Farbe, Team-Zuweisung, Status
- **Löschen** mit Bestätigung
- **Status-Tracking**: "In Bearbeitung" vs. "Abgeschlossen"

### Hilfe-Dialog
- Button "Hilfe" zeigt alle Funktionen
- Schritt-für-Schritt-Anleitungen
- Tipps zur Bedienung

---

## ?? Technische Architektur

### Frontend (Blazor)
- **Datei**: `EinsatzKarte.razor`
- **RenderMode**: `InteractiveServer`
- **Dependencies**: 
  - `IEinsatzService` für Datenverwaltung
  - `IJSRuntime` für JavaScript-Interop

### JavaScript-Interop
- **Datei**: `leaflet-interop.js`
- **Bibliotheken**:
  - Leaflet 1.9.4 (Karten-Engine)
  - Leaflet.draw 1.0.4 (Zeichenwerkzeuge)

### Datenmodell
```csharp
// SearchArea.cs
public class SearchArea
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Color { get; set; }
    public List<(double Latitude, double Longitude)> Coordinates { get; set; }
    public string GeoJsonData { get; set; }
    public string AssignedTeamId { get; set; }
    public bool IsCompleted { get; set; }
    // + Flächenberechnung
}

// EinsatzData.cs
public class EinsatzData
{
    public (double Latitude, double Longitude)? ElwPosition { get; set; }
    public List<SearchArea> SearchAreas { get; set; }
    // ...
}
```

### Callback-Mechanismus
```csharp
// Blazor ? JavaScript
await JSRuntime.InvokeVoidAsync("LeafletMap.setMarker", params...);

// JavaScript ? Blazor
[JSInvokable]
public async Task OnShapeCreated(string geoJson) { ... }

[JSInvokable]
public async Task OnElwMarkerMoved(double lat, double lng) { ... }
```

---

## ?? Datenfluss

### ELW-Position setzen:
```
1. Benutzer klickt "ELW-Position setzen"
   ?
2. Blazor ruft getMapCenter() auf
   ?
3. JavaScript gibt aktuelle Koordinaten zurück
   ?
4. Blazor zeigt Bestätigungsdialog
   ?
5. Bei Bestätigung: setMarker() wird aufgerufen
   ?
6. Position wird in EinsatzData.ElwPosition gespeichert
   ?
7. Marker wird auf Karte gezeichnet (draggable)
   ?
8. Bei Verschiebung: OnElwMarkerMoved-Callback
   ?
9. Position wird automatisch aktualisiert
```

### Suchgebiet erstellen:
```
1. Benutzer zeichnet Polygon/Rechteck
   ?
2. Leaflet.draw feuert CREATED-Event
   ?
3. GeoJSON wird generiert
   ?
4. OnShapeCreated-Callback (JavaScript ? Blazor)
   ?
5. Dialog öffnet sich automatisch
   ?
6. Benutzer gibt Details ein
   ?
7. SaveArea() speichert im EinsatzService
   ?
8. addSearchArea() zeichnet auf Karte
```

---

## ?? Styling

### Kartenelemente
- **Suchgebiete**: 
  - Füllfarbe: Benutzerdefiniert (mit 30% Transparenz)
  - Randfarbe: Gleich wie Füllfarbe (100% opacity)
  - Strichstärke: 3px

- **ELW-Marker**:
  - Farbe: #DC143C (Crimson Red)
  - Größe: 32x45 Pixel
  - Icon: Custom SVG mit "E"

- **Einsatzort-Marker**:
  - Standard Leaflet-Icon
  - Blau

### Buttons
- Button-Gruppe für Kartenansichten
- Aktive Ansicht mit `active`-Klasse
- Bootstrap-Styling

---

## ?? Verwendungsbeispiel

### Typischer Workflow im Einsatz:

1. **Einsatz starten** auf "Einsatz Start"-Seite
2. **Zur Karte navigieren**
3. **Einsatzort suchen**: Adresse eingeben ? Karte zoomt zur Position
4. **ELW-Position setzen**: Kartenmitte anpassen ? "ELW-Position setzen"
5. **Kartenansicht wählen**: Hybrid oder Satellit für bessere Orientierung
6. **Suchgebiete einzeichnen**:
   - Polygon für Team Alpha zeichnen
   - Team zuweisen im Dialog
   - Weitere Suchgebiete für andere Teams
7. **Während des Einsatzes**:
   - ELW-Position bei Bedarf anpassen (Marker verschieben)
   - Suchgebiete als "Abgeschlossen" markieren
8. **Karte drucken** für Einsatzleiter/Dokumentation

---

## ?? Flächenberechnung

Die Fläche von Suchgebieten wird automatisch berechnet:

- **Algorithmus**: Shoelace-Formel für sphärische Polygone
- **Einheiten**:
  - < 50.000 m²: Quadratmeter (m²)
  - 50.000 - 1.000.000 m²: Hektar (ha)
  - \> 1.000.000 m²: Quadratkilometer (km²)

**Beispiele:**
- 500 m² ? "500 m²"
- 75.000 m² ? "7,5 ha"
- 2.500.000 m² ? "2,5 km²"

---

## ?? Konfiguration

### Leaflet-Layer-URLs

**OpenStreetMap:**
```javascript
https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png
```

**Esri Satellite:**
```javascript
https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}
```

**Google Hybrid:**
```javascript
https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}
```

### Standard-Position
- **Latitude**: 49.3188 (Speyer, Deutschland)
- **Longitude**: 8.4312
- **Zoom-Level**: 13

Diese kann angepasst werden in `EinsatzKarte.razor`:
```csharp
private double _mapCenterLat = 49.3188;
private double _mapCenterLng = 8.4312;
private int _mapZoom = 13;
```

---

## ?? Bekannte Einschränkungen

1. **Offline-Nutzung**: Kartenkacheln erfordern Internetverbindung
2. **Geocoding**: Abhängig von Nominatim-API (Rate-Limiting möglich)
3. **Google-Layer**: Keine offizielle API, könnte sich ändern
4. **Druck**: PDF-Qualität abhängig vom Browser

---

## ?? Zukünftige Erweiterungen (Optional)

- **GPS-Integration**: Automatische ELW-Position via Geolocation API
- **Offline-Karten**: Cached Tiles für Offline-Nutzung
- **Team-Tracking**: Live-Tracking von Team-Positionen
- **Heatmap**: Suchintensität visualisieren
- **Export**: KML/GPX-Export für GPS-Geräte
- **Koordinaten-Formate**: UTM, MGRS zusätzlich zu Lat/Lng

---

## ?? Support

Bei Fragen oder Problemen:
- Hilfe-Button auf der Karten-Seite nutzen
- Dokumentation in diesem Dokument konsultieren
- Entwickler-Konsole für technische Fehler prüfen

---

**Version**: 2.0.1  
**Letzte Aktualisierung**: 2024  
**Autor**: Einsatzüberwachung Development Team
