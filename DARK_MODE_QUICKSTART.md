# ?? Dark Mode - Quick Start Guide

**Version:** 2.1.0

---

## ?? Was ist Dark Mode?

Dark Mode ist ein dunkles Farbschema, das:
- **Augen schont** bei schlechten Lichtverhältnissen
- **Akku spart** auf OLED-Displays (bis zu 30%)
- **Professionell aussieht** und modern wirkt
- **Perfekt für Nacht-Einsätze** ist

---

## ? So aktivieren Sie Dark Mode

### Methode 1: Quick-Toggle (Schnellste)

1. **Finden Sie das Icon** oben links in der Navigation (neben "Einsatzüberwachung")
   
   ```
   ?? = Aktuell Hell ? Klicken für Dunkel
   ?? = Aktuell Dunkel ? Klicken für Hell
   ```

2. **Einfach klicken** - Fertig! ?

### Methode 2: Einstellungen (Detailliert)

1. Klicken Sie auf **"Einstellungen"** in der Navigation
2. Scrollen Sie zu **"Darstellung"**
3. Wählen Sie zwischen:
   - **?? Hell** - Klassisches helles Design
   - **?? Dunkel** - Modernes dunkles Design
4. Klicken Sie auf **"Speichern"**

---

## ?? Wie es aussieht

### Vorher (Hell) ? Nachher (Dunkel)

| Element | Hell | Dunkel |
|---------|------|--------|
| Hintergrund | Weiß | Schwarz (#121212) |
| Cards | Weiß | Dunkelgrau (#1e1e1e) |
| Text | Schwarz | Hellgrau (#e0e0e0) |
| Buttons | Bunt | Helle Varianten |
| Inputs | Weiß | Dunkelgrau |

### Beispiel-Ansichten

**Homepage:**
- Hero-Section: Dunkelblauer Gradient
- Action-Cards: Dunkle Hintergründe mit hellen Farben
- Icons: Klar sichtbar

**Monitor:**
- Team-Karten: Dunkle Backgrounds
- Timer: Leuchtende Farben (Grün/Orange/Rot)
- Notes: Kontrastreiche Threads

**Stammdaten:**
- Tabellen: Zebra-Streifen sichtbar
- Cards: Gut abgegrenzt
- Formulare: Klare Inputs

---

## ?? Tipps & Tricks

### 1. **Automatisches Speichern**
   - Ihre Wahl wird automatisch gespeichert
   - Bleibt auch nach Neustart erhalten
   - Keine weitere Aktion nötig

### 2. **Schnell-Wechsel**
   - Nutzen Sie den Quick-Toggle für schnelle Wechsel
   - Perfekt wenn Sie zwischen drinnen/draußen wechseln
   - Sofortige Änderung ohne Neuladen

### 3. **Bei Nacht-Einsätzen**
   - Dark Mode reduziert Licht-Emission
   - Schont die Augen Ihrer Kollegen
   - Bessere Sicht auf die wichtigen Infos

### 4. **Bei Tag-Einsätzen**
   - Helles Design bei Sonnenlicht oft besser
   - Quick-Toggle macht Wechsel einfach

---

## ? Checkliste: Ist Dark Mode aktiv?

- [ ] Icon in Navigation zeigt ?? (Sonne)
- [ ] Hintergrund ist dunkel/schwarz
- [ ] Text ist hell/weiß
- [ ] Cards haben dunklen Hintergrund
- [ ] Buttons haben helle Farben

**Wenn alle Punkte ?:** Dark Mode ist aktiv! ??

---

## ? Häufige Fragen (FAQ)

### Q: Wie wechsle ich zurück zu Hell?
**A:** Klicken Sie auf das ?? Icon in der Navigation (oder über Einstellungen)

### Q: Bleibt die Einstellung erhalten?
**A:** Ja! Dark Mode wird automatisch gespeichert und lädt beim nächsten Start

### Q: Funktioniert Dark Mode überall?
**A:** Ja, auf allen Seiten außer der Karte selbst (Leaflet-Limitation)

### Q: Kann ich das Theme während eines Einsatzes wechseln?
**A:** Ja! Der Wechsel ist jederzeit möglich und beeinflusst den laufenden Einsatz nicht

### Q: Verbraucht Dark Mode mehr Performance?
**A:** Nein! Dark Mode ist genauso schnell wie Hell-Modus

### Q: Funktioniert Dark Mode auf dem Tablet?
**A:** Ja! Perfekt optimiert für Touch-Bedienung

---

## ?? Empfehlungen

| Situation | Empfehlung | Grund |
|-----------|-----------|-------|
| **Nacht-Einsatz** | ?? Dark | Weniger Licht, schont Augen |
| **Tag-Einsatz draußen** | ?? Hell | Bessere Lesbarkeit bei Sonne |
| **Büro-Arbeit Abends** | ?? Dark | Weniger Augenbelastung |
| **Büro-Arbeit Tagsüber** | ??/?? Beides OK | Nach Vorliebe |
| **Präsentation** | ?? Hell | Bessere Sichtbarkeit auf Beamer |
| **Lange Einsätze** | ?? Dark | Akku-Schonung auf Tablets |

---

## ?? Probleme?

### Problem: Theme ändert sich nicht
**Lösung:**
1. Warten Sie 1 Sekunde nach dem Klick
2. Aktualisieren Sie die Seite (F5)
3. Leeren Sie den Browser-Cache

### Problem: Icon nicht sichtbar
**Lösung:**
1. Prüfen Sie ob Sie auf der richtigen Seite sind (nicht im Vollbild-Modus)
2. Scrollen Sie ggf. nach oben
3. Icon ist neben dem "Einsatzüberwachung" Logo

### Problem: Einige Elemente sind noch hell
**Lösung:**
1. Warten Sie kurz (Laden kann 1-2 Sekunden dauern)
2. Aktualisieren Sie die Seite
3. Prüfen Sie ob die neueste Version läuft

---

## ?? Mobile/Tablet

Dark Mode funktioniert **perfekt auf mobilen Geräten**:
- ? Touch-optimierter Toggle-Button
- ? Responsive Design
- ? Akku-Schonung auf OLED-Screens
- ? Alle Features verfügbar

---

## ?? Für Admins

### Installation
- ? **Keine Installation nötig** - bereits in v2.1.0 enthalten

### Konfiguration
- ? **Keine Konfiguration nötig** - funktioniert out-of-the-box
- ? Standard ist "Hell" für neue Installationen
- ? User-Einstellungen in `SessionData.json`

### Troubleshooting
```bash
# Prüfe ob Theme gespeichert ist
# Datei: SessionData.json
{
  "AppSettings": {
    "IsDarkMode": true,    # true = Dark, false = Hell
    "Theme": "Dark"        # "Dark" oder "Light"
  }
}
```

---

## ?? Bonus-Features

### 1. Auto-Sync zwischen Einstellungen und Toggle
- Änderung in Einstellungen ? Toggle aktualisiert sich
- Änderung via Toggle ? Einstellungen aktualisieren sich
- Check alle 5 Sekunden

### 2. Smooth Transitions
- Keine harten Farbwechsel
- Sanfte Übergänge
- Professionelles Look & Feel

### 3. Konsistente Icons
- Bootstrap Icons für alle Themes
- Immer gut sichtbar
- Klare Bedeutung

---

## ?? Vergleich

| Feature | Dark Mode | Hell Mode |
|---------|-----------|-----------|
| Augenbelastung (Nacht) | ????? | ?? |
| Lesbarkeit (Tag/Sonne) | ??? | ????? |
| Akku-Verbrauch (OLED) | ????? | ??? |
| Professionalität | ????? | ???? |
| Modern Look | ????? | ??? |

---

## ?? Viel Spaß mit Dark Mode!

Probieren Sie beide Themes aus und finden Sie Ihren Favoriten!

**Quick-Reminder:**
- ?? Icon = Wechsel zu Dark
- ?? Icon = Wechsel zu Hell

---

**Stand:** Version 2.1.0  
**Support:** Siehe Hauptdokumentation  
**Feedback:** Gerne in den Einstellungen notieren oder an Admin wenden
