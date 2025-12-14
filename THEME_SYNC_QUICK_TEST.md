# ?? Theme Sync - Quick Test Guide

## ? So testen Sie das neue Feature

### Test 1: Zwei Browser-Tabs (Einfachster Test)

**Schritt 1:** App starten
```bash
dotnet run --project Einsatzueberwachung.Web
```

**Schritt 2:** Ersten Tab öffnen
```
https://localhost:5001
```

**Schritt 3:** Zweiten Tab öffnen
- Drücken Sie `Ctrl + T` (Neuer Tab)
- Geben Sie gleiche URL ein: `https://localhost:5001`
- Oder: Rechtsklick auf Tab ? "Duplizieren"

**Schritt 4:** Theme ändern in Tab 1
- Klicken Sie auf das ?? Icon oben links
- Theme wechselt zu Dark

**Schritt 5:** Prüfen Sie Tab 2
- ? **Erwartung:** Theme wechselt **SOFORT** zu Dark
- ? **Erwartung:** Notification erscheint: "?? Dark Mode aktiviert"
- ? **Erwartung:** Notification verschwindet nach 2 Sekunden

**Resultat:**
```
? Theme-Sync funktioniert!
   Keine manuelle Aktualisierung nötig!
```

---

### Test 2: Tab und Popup-Fenster

**Schritt 1:** App öffnen
```
https://localhost:5001
```

**Schritt 2:** Neues Fenster öffnen
- Rechtsklick auf einen Link (z.B. "Monitor")
- Wählen Sie: "Link in neuem Fenster öffnen"
- Oder: `Shift + Klick` auf Link

**Schritt 3:** Theme ändern
- In einem der Fenster: Klick auf ?? Icon

**Schritt 4:** Prüfen
- ? **Erwartung:** Anderes Fenster wechselt **SOFORT**
- ? **Erwartung:** Notification erscheint im anderen Fenster

---

### Test 3: Via Einstellungen

**Schritt 1:** Zwei Tabs offen
```
Tab 1: https://localhost:5001
Tab 2: https://localhost:5001/einstellungen
```

**Schritt 2:** In Tab 2 (Einstellungen)
- Gehen Sie zu "Darstellung"
- Klicken Sie auf "?? Dunkel" Button

**Schritt 3:** Prüfen Tab 1
- ? **Erwartung:** Theme wechselt **SOFORT** zu Dark
- ? **Erwartung:** Notification erscheint

**Schritt 4:** Speichern in Tab 2
- Klicken Sie "Speichern"

**Schritt 5:** Prüfen Persistenz
- Schließen Sie beide Tabs
- Öffnen Sie App neu
- ? **Erwartung:** Dark Mode bleibt aktiv

---

### Test 4: Viele Tabs (Stress Test)

**Schritt 1:** Öffnen Sie 5 Tabs
```
Tab 1: Home
Tab 2: Monitor
Tab 3: Stammdaten
Tab 4: Einstellungen
Tab 5: Karte
```

**Schritt 2:** Theme ändern in Tab 1
- Klick auf ?? Icon

**Schritt 3:** Prüfen Sie ALLE Tabs
- ? Tab 2: Wechselt zu Dark + Notification
- ? Tab 3: Wechselt zu Dark + Notification
- ? Tab 4: Wechselt zu Dark + Notification
- ? Tab 5: Wechselt zu Dark + Notification

**Resultat:**
```
? Alle Tabs synchron!
   Performance OK!
```

---

### Test 5: Browser Console (Developer Test)

**Schritt 1:** Öffnen Sie zwei Tabs mit Developer Tools
- Drücken Sie `F12` in beiden Tabs
- Wechseln Sie zum "Console" Tab

**Schritt 2:** Theme ändern in Tab 1
- Klick auf ?? Icon

**Schritt 3:** Prüfen Sie Console in Tab 1
```
Broadcasting Theme-Änderung: dark
Theme-Update via BroadcastChannel gesendet
Wende Theme an: dark
```

**Schritt 4:** Prüfen Sie Console in Tab 2
```
Theme-Update via BroadcastChannel empfangen: dark
Wende Theme an: dark
```

**Wenn Sie sehen:**
```
? "BroadcastChannel" ? Moderner Browser, volle Features
?? Nur "storage event" ? Älterer Browser, Fallback aktiv
? Gar keine Messages ? Problem! (Siehe Troubleshooting unten)
```

---

### Test 6: Notification Animation

**Schritt 1:** Zwei Tabs offen

**Schritt 2:** Tab 2 im Fokus
- Aktivieren Sie Tab 2 (klicken Sie darauf)

**Schritt 3:** Theme ändern in Tab 1
- Wechseln Sie zu Tab 1
- Klick auf ?? Icon

**Schritt 4:** Schnell zu Tab 2 wechseln
- Wechseln Sie zurück zu Tab 2

**Schritt 5:** Prüfen Sie Animation
- ? Notification slide-in von rechts
- ? Bleibt 2 Sekunden
- ? Notification slide-out nach rechts
- ? Verschwindet

**Notification aussehen:**
```
???????????????????????????????
? ?? Dark Mode aktiviert      ?  ? Theme-abhängiges Design
???????????????????????????????
```

---

## ?? Troubleshooting

### Problem: Tabs synchronisieren sich nicht

**Lösung 1: Cache leeren**
```
Ctrl + Shift + Delete
? Clear Cache
? Hard Reload (Ctrl + Shift + R)
```

**Lösung 2: Prüfe Console auf Fehler**
```
F12 ? Console Tab
Suche nach roten Fehlern
```

**Lösung 3: Prüfe ob theme-sync.js geladen ist**
```javascript
// In Browser Console
typeof broadcastThemeChange === 'function'
// Sollte: true
```

**Lösung 4: Manueller Test**
```javascript
// In Browser Console von Tab 1
broadcastThemeChange('dark');

// In Tab 2 sollte Theme wechseln
```

---

### Problem: Notification erscheint nicht

**Prüfe:**
```javascript
// In Browser Console
document.getElementById('theme-change-notification')
// Sollte: null (wenn keine Notification)
// Oder: HTMLDivElement (wenn Notification aktiv)
```

**Manueller Test:**
```javascript
// In Browser Console
window.dispatchEvent(new CustomEvent('theme-changed', {
    detail: { theme: 'dark' }
}));
// Notification sollte erscheinen
```

---

### Problem: BroadcastChannel nicht verfügbar

**Prüfe Browser-Support:**
```javascript
// In Browser Console
'BroadcastChannel' in window
// true = Unterstützt
// false = Nicht unterstützt (verwendet LocalStorage Fallback)
```

**Browser-Versions:**
- ? Chrome 54+ ? Unterstützt
- ? Firefox 38+ ? Unterstützt
- ? Edge 79+ ? Unterstützt
- ? Safari 15.4+ ? Unterstützt
- ? IE11 ? Nicht unterstützt (Timer-Fallback in NavMenu)

**Wenn nicht unterstützt:**
- LocalStorage Events funktionieren trotzdem
- Sync funktioniert zwischen verschiedenen Tabs
- Nur etwas langsamer (~50ms statt <10ms)

---

## ? Erfolgs-Checkliste

Nach allen Tests sollten Sie sehen:

### Visuell
- [x] ? Theme wechselt in allen Tabs **ohne Reload**
- [x] ? Notification erscheint in allen Tabs (außer dem aktiven)
- [x] ? Notification hat korrekte Animation
- [x] ? Notification verschwindet nach 2 Sekunden
- [x] ? Icon im aktiven Tab wechselt (?? ? ??)

### Browser Console
- [x] ? "Broadcasting Theme-Änderung" in Tab der ändert
- [x] ? "Theme-Update empfangen" in allen anderen Tabs
- [x] ? "Wende Theme an" in allen Tabs
- [x] ? Keine roten Fehler

### Funktional
- [x] ? Funktioniert mit Toggle-Button
- [x] ? Funktioniert über Einstellungen-Seite
- [x] ? Funktioniert in beiden Richtungen (Hell ? Dunkel, Dunkel ? Hell)
- [x] ? Persistiert über App-Neustarts
- [x] ? Funktioniert mit vielen Tabs

---

## ?? Performance-Test

### Timing Test
```javascript
// In Browser Console von Tab 1
console.time('theme-sync');
broadcastThemeChange('dark');
console.timeEnd('theme-sync');

// Sollte: < 10ms (BroadcastChannel)
// Oder: < 50ms (LocalStorage)
```

### Memory Test
```javascript
// Vor Theme-Änderungen
console.memory.usedJSHeapSize / 1024 / 1024; // MB

// Nach 100 Theme-Änderungen
for(let i=0; i<100; i++) {
    broadcastThemeChange(i % 2 === 0 ? 'dark' : 'light');
}
console.memory.usedJSHeapSize / 1024 / 1024; // MB

// Sollte: < 1 MB Unterschied (kein Memory Leak)
```

---

## ?? Erfolg!

Wenn alle Tests ? sind:
```
?????????????????????????????????????????????
?                                           ?
?   ? THEME SYNC FUNKTIONIERT!            ?
?                                           ?
?   • Keine manuellen Reloads nötig        ?
?   • Instant Synchronisation              ?
?   • Alle Tabs/Fenster synchron           ?
?   • Visuelle Notifications               ?
?   • Browser-übergreifend                 ?
?                                           ?
?   ?? BEREIT FÜR PRODUKTION               ?
?                                           ?
?????????????????????????????????????????????
```

---

## ?? Support

**Wenn ein Test fehlschlägt:**

1. **Prüfe Build:**
   ```bash
   dotnet build
   ```

2. **Prüfe theme-sync.js:**
   ```bash
   Test-Path "Einsatzueberwachung.Web/wwwroot/theme-sync.js"
   # Sollte: True
   ```

3. **Prüfe App.razor:**
   ```bash
   Get-Content "Einsatzueberwachung.Web/Components/App.razor" | Select-String "theme-sync.js"
   # Sollte: Zeile mit <script src="theme-sync.js">
   ```

4. **Browser neu starten:**
   - Alle Tabs schließen
   - Browser komplett beenden
   - Browser neu starten

5. **Inkognito-Modus testen:**
   - `Ctrl + Shift + N`
   - Öffne zwei Inkognito-Tabs
   - Teste erneut

---

**Version:** 2.1.1  
**Feature:** Theme Sync System  
**Status:** ? Ready for Testing
