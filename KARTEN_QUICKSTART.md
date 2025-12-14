# ??? Karten-Funktionalität - Quick Start Guide

## ? Neue Features in Version 2.0.1

### ?? Auf einen Blick

| Feature | Status | Beschreibung |
|---------|--------|--------------|
| ??? **Kartenansichten** | ? Fertig | Straßenkarte, Satellit, Hybrid |
| ?? **Suchgebiete** | ? Fertig | Zeichnen, Bearbeiten, Löschen |
| ?? **ELW-Marker** | ? Fertig | Rot, draggable, persistent |
| ??? **Drucken/PDF** | ? Fertig | Optimiert mit Legende |
| ?? **Hilfe** | ? Fertig | Integrierter Hilfe-Dialog |

---

## ?? Schnellstart

### 1?? Kartenansicht wählen
```
Straßenkarte ? Detaillierte Straßenkarte
Satellit     ? Hochauflösende Luftbilder
Hybrid       ? Satellit + Straßennamen
```

### 2?? ELW-Position setzen
```
1. Karte zur gewünschten Position bewegen
2. "ELW-Position setzen" klicken
3. Bestätigen ? Roter Marker erscheint
4. Optional: Marker mit Maus verschieben
```

### 3?? Suchgebiet zeichnen
```
1. Werkzeug auswählen (Polygon/Rechteck/Marker)
2. Auf Karte zeichnen
3. Details eingeben (Name, Team, Farbe)
4. Speichern ? Gebiet erscheint auf Karte
```

### 4?? Karte drucken
```
1. "Karte drucken" klicken
2. Im Dialog "Als PDF speichern" wählen
3. PDF enthält Karte + Legende + ELW
```

---

## ?? Dateien

### Dokumentation
- ?? **KARTEN_FUNKTIONALITAET.md** - Vollständige Dokumentation
- ?? **KARTEN_IMPLEMENTIERUNG.md** - Technische Details
- ?? **CHANGELOG_KARTEN_V2.0.1.md** - Änderungsprotokoll
- ?? **KARTEN_QUICKSTART.md** - Diese Datei

### Code
- `EinsatzKarte.razor` - Hauptkomponente
- `leaflet-interop.js` - JavaScript-Interop
- `print-map.css` - Druckstyles
- `EinsatzData.cs` - Datenmodell (ElwPosition)
- `SearchArea.cs` - Suchgebiet-Modell

---

## ?? Tipps

### ELW-Marker
- ? Marker bleibt gespeichert (auch nach Reload)
- ? Einfach mit Maus verschieben
- ? Grünes Badge zeigt Status

### Kartenansichten
- ?? Hybrid-Ansicht ideal für Einsatzplanung
- ?? Satellit zeigt Gelände und Vegetation
- ?? Straßenkarte für Navigation

### Suchgebiete
- ?? Farben für verschiedene Teams nutzen
- ?? Fläche wird automatisch berechnet
- ?? Teams können zugewiesen werden
- ?? Status-Tracking (In Bearbeitung/Fertig)

### Drucken
- ?? PDF-Export über "Als PDF speichern"
- ?? Legende wird automatisch eingefügt
- ?? Querformat für beste Darstellung

---

## ?? Tastenkombinationen

### Suchgebiete zeichnen
- **Escape** - Zeichnen abbrechen
- **Doppelklick** - Polygon beenden
- **Backspace** - Letzten Punkt löschen

### Karte navigieren
- **+/-** - Zoom
- **Mausrad** - Zoom
- **Ziehen** - Karte verschieben
- **Doppelklick** - Zoom zur Position

---

## ?? Hilfe

### Auf der Seite
Klicken Sie auf den **"Hilfe"**-Button für eine interaktive Anleitung.

### Dokumentation
Siehe **KARTEN_FUNKTIONALITAET.md** für detaillierte Informationen.

### Probleme?
1. Browser-Konsole prüfen (F12)
2. Internetverbindung prüfen (für Kartenkacheln)
3. Seite neu laden (Strg+F5)

---

## ?? Typischer Workflow

```
?? Einsatz starten
   ?
??? Zur Karte navigieren
   ?
?? Einsatzort suchen (Adresse eingeben)
   ?
?? ELW-Position setzen
   ?
?? Kartenansicht wählen (Hybrid empfohlen)
   ?
?? Suchgebiete einzeichnen
   ?
?? Teams zuweisen
   ?
??? Karte drucken/PDF exportieren
```

---

## ?? Technische Details

### Unterstützte Browser
- ? Chrome/Edge (empfohlen)
- ? Firefox
- ?? Safari (eingeschränkt)

### Anforderungen
- Internetverbindung (für Kartenkacheln)
- Moderne Browser (ES6+)
- JavaScript aktiviert

### Kartendienste
- OpenStreetMap (Straßenkarte)
- Esri World Imagery (Satellit)
- Google Maps (Hybrid)

---

## ?? Features im Detail

### Kartenansichten
```
Streets   ? OpenStreetMap Tiles
Satellite ? Esri World Imagery (18x Zoom)
Hybrid    ? Google Satellite + Labels (20x Zoom)
```

### ELW-Marker
```
Icon:      Custom SVG (32x45 px)
Farbe:     #DC143C (Crimson Red)
Draggable: ? Ja
Persistent: ? Ja (in EinsatzData.ElwPosition)
```

### Suchgebiete
```
Typen:     Polygon, Rechteck, Marker
Fläche:    Automatisch berechnet (m², ha, km²)
Teams:     Zuweisbar
Status:    In Bearbeitung / Abgeschlossen
```

### Druckfunktion
```
Format:    Landscape (Querformat)
Größe:     A4 mit 1cm Rand
Inhalt:    Karte + Legende + Kopfzeile
Export:    PDF via Browser
```

---

## ?? UI-Elemente

### Buttons
```
?? Straßenkarte  ?  OpenStreetMap
?? Satellit      ?  Esri Imagery
?? Hybrid        ?  Google Hybrid
?? ELW setzen    ?  Position markieren
?? Drucken       ?  PDF exportieren
?? Hilfe          ?  Anleitung öffnen
```

### Status-Anzeigen
```
?? ELW-Position gesetzt  ?  Badge grün
?? Suchgebiet aktiv      ?  In Bearbeitung (gelb)
?? Suchgebiet fertig     ?  Abgeschlossen (grün)
```

---

## ?? Verbesserungen

### Gegenüber v2.0.0

| Feature | v2.0.0 | v2.0.1 |
|---------|--------|--------|
| Kartenansichten | Standard | ? Button-Gruppe |
| ELW-Position | Temporär | ? Persistent |
| ELW verschieben | ? Nein | ? Drag & Drop |
| Druckqualität | Basis | ? Professionell |
| Hilfe | ? Keine | ? Integriert |

---

## ?? Tutorials

### Tutorial 1: Erste Schritte
```
1. Öffne "Karte & Suchgebiete"
2. Gib eine Adresse ein ? Suchen
3. Klicke "ELW-Position setzen"
4. Wähle eine Kartenansicht
5. Fertig! ??
```

### Tutorial 2: Suchgebiet erstellen
```
1. Wähle Polygon-Werkzeug (links auf Karte)
2. Klicke Punkte auf der Karte
3. Doppelklick zum Beenden
4. Dialog öffnet sich automatisch
5. Name eingeben, Team zuweisen
6. Speichern ? Fertig! ??
```

### Tutorial 3: Karte exportieren
```
1. Alle Suchgebiete einzeichnen
2. ELW-Position setzen
3. Klicke "Karte drucken"
4. Bestätige den Dialog
5. Wähle "Als PDF speichern"
6. PDF wird heruntergeladen ??
```

---

## ?? Support

**Fragen?**
- ?? Hilfe-Button auf der Seite
- ?? KARTEN_FUNKTIONALITAET.md
- ?? KARTEN_IMPLEMENTIERUNG.md

**Technische Probleme?**
- ?? Browser-Konsole (F12)
- ?? Internetverbindung prüfen
- ?? Seite neu laden (Strg+F5)

---

## ? Checkliste

### Vor dem Einsatz
- [ ] Internetverbindung prüfen
- [ ] Einsatz gestartet
- [ ] Zur Karte navigiert
- [ ] Kartenansicht gewählt

### Während des Einsatzes
- [ ] ELW-Position gesetzt
- [ ] Suchgebiete eingezeichnet
- [ ] Teams zugewiesen
- [ ] Status aktualisiert

### Nach dem Einsatz
- [ ] Karte gedruckt/PDF exportiert
- [ ] Alle Gebiete als fertig markiert
- [ ] Dokumentation abgeschlossen

---

**Version**: 2.0.1  
**Status**: ? Production Ready  
**Letzte Aktualisierung**: 2024

---

## ?? Los geht's!

1. Starte einen Einsatz
2. Öffne "Karte & Suchgebiete"
3. Folge den Tipps oben
4. Bei Fragen: Hilfe-Button klicken

**Viel Erfolg! ??**
