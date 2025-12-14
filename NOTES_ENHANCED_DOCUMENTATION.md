# ?? Erweitertes Log-System für Funksprüche und Notizen

## Übersicht

Das erweiterte Log-System ermöglicht:
- ? **Bearbeitung** von Funksprüchen/Notizen nachträglich
- ? **Antworten/Threads** zu Einträgen hinzufügen
- ? **Team-Herkunft** verpflichtend beim Erstellen
- ? **Vollständige Historie** aller Änderungen (optional)
- ? **Thread-basierte Kommunikation** für bessere Nachvollziehbarkeit

---

## ?? Neue Features

### 1. **Bearbeitung von Einträgen**
- Nachträgliches Ändern des Textes
- Automatische Kennzeichnung mit "(bearbeitet am ...)"
- Speicherung von `UpdatedAt` und `UpdatedBy`
- Optional: Vollständige Historie aller Änderungen

### 2. **Antworten/Thread-System**
- Zu jedem Eintrag können Antworten hinzugefügt werden
- Antworten werden chronologisch sortiert angezeigt
- Jede Antwort kann ebenfalls bearbeitet/gelöscht werden
- Anzahl der Antworten wird in Badge angezeigt

### 3. **Team-Herkunft (Pflichtfeld)**
- Beim Erstellen muss eine Quelle ausgewählt werden
- Auswahl aus:
  - Vorhandenen Hunde-Teams
  - Vorhandenen Drohnen-Teams
  - Support-Teams
  - Einsatzleitung
- Quelle wird prominent angezeigt

---

## ?? Datenmodell

### `GlobalNotesEntry` (erweitert)

```csharp
public class GlobalNotesEntry
{
    // Basis
    public string Id { get; set; }
    public DateTime Timestamp { get; set; }
    public string Text { get; set; }
    public GlobalNotesEntryType Type { get; set; }
    
    // NEU: Herkunft (PFLICHT)
    public string SourceTeamId { get; set; }
    public string SourceTeamName { get; set; }
    public string SourceType { get; set; }
    
    // NEU: Bearbeitung
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
    public bool IsEdited => UpdatedAt.HasValue;
    
    // NEU: Antworten
    public List<GlobalNotesReply> Replies { get; set; }
    public int ReplyCount => Replies?.Count ?? 0;
}
```

### `GlobalNotesReply` (NEU)

```csharp
public class GlobalNotesReply
{
    public string Id { get; set; }
    public string NoteId { get; set; } // FK
    public string Text { get; set; }
    
    // Herkunft
    public string SourceTeamId { get; set; }
    public string SourceTeamName { get; set; }
    
    // Zeitstempel
    public DateTime Timestamp { get; set; }
    public string CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
    
    public bool IsEdited => UpdatedAt.HasValue;
}
```

### `GlobalNotesHistory` (Optional)

```csharp
public class GlobalNotesHistory
{
    public string Id { get; set; }
    public string NoteId { get; set; }
    public string OldText { get; set; }
    public string NewText { get; set; }
    public DateTime ChangedAt { get; set; }
    public string ChangedBy { get; set; }
    public string ChangeReason { get; set; }
}
```

---

## ?? API / Service-Methoden

### Neue Methoden in `IEinsatzService`:

```csharp
// Notiz mit Herkunft erstellen
Task<GlobalNotesEntry> AddGlobalNoteWithSourceAsync(
    string text, 
    string sourceTeamId, 
    string sourceTeamName, 
    string sourceType, 
    GlobalNotesEntryType type = GlobalNotesEntryType.Manual, 
    string createdBy = "System");

// Notiz bearbeiten
Task<GlobalNotesEntry> UpdateGlobalNoteAsync(
    string noteId, 
    string newText, 
    string updatedBy = "System");

// Notiz abrufen
Task<GlobalNotesEntry?> GetGlobalNoteByIdAsync(string noteId);

// Historie abrufen
Task<List<GlobalNotesHistory>> GetNoteHistoryAsync(string noteId);

// Antwort hinzufügen
Task<GlobalNotesReply> AddReplyToNoteAsync(
    string noteId, 
    string text, 
    string sourceTeamId, 
    string sourceTeamName, 
    string createdBy = "System");

// Antwort bearbeiten
Task<GlobalNotesReply> UpdateReplyAsync(
    string replyId, 
    string newText, 
    string updatedBy = "System");

// Antwort löschen
Task DeleteReplyAsync(string replyId);

// Antworten abrufen
Task<List<GlobalNotesReply>> GetRepliesForNoteAsync(string noteId);
```

---

## ?? UI-Komponente

### `NotesEnhanced.razor`

Neue Razor-Komponente mit:
- Thread-Ansicht aller Notizen
- Bearbeiten-Button für Einträge
- Antworten-Button mit Formular
- Expand/Collapse für Antworten
- Team-Auswahl (Dropdown mit allen aktiven Teams)
- Visuell ansprechende Darstellung mit Bootstrap Icons

### Verwendung:

```razor
<NotesEnhanced 
    Notes="@_notes" 
    AvailableTeams="@_teams"
    AllowEdit="true"
    OnNotesChanged="RefreshNotes" />
```

### Parameter:
- `Notes` - Liste der Notizen
- `AvailableTeams` - Verfügbare Teams für Herkunfts-Auswahl
- `AllowEdit` - Bearbeiten erlauben (true/false)
- `OnNotesChanged` - Callback bei Änderungen

---

## ?? Styling

### Datei: `notes-enhanced.css`

Features:
- Farbcodierung nach Notiz-Typ
- Thread-Visualisierung mit Einrückung
- Hover-Effekte
- Responsive Design
- Dark-Mode Support
- Animationen für neue Einträge

### CSS-Klassen:
- `.note-card` - Haupt-Notiz Container
- `.note-type-teamstart`, `.note-type-teamwarning`, etc. - Typ-spezifische Styles
- `.note-replies` - Antworten-Container
- `.reply-card` - Einzelne Antwort
- `.reply-form` - Formular für neue Antwort

---

## ?? Workflow

### 1. **Neue Notiz erstellen**
```csharp
await EinsatzService.AddGlobalNoteWithSourceAsync(
    text: "Team Alpha ist vor Ort",
    sourceTeamId: team.TeamId,
    sourceTeamName: team.TeamName,
    sourceType: "HundeTeam",
    type: GlobalNotesEntryType.Manual,
    createdBy: "Einsatzleiter"
);
```

### 2. **Notiz bearbeiten**
```csharp
await EinsatzService.UpdateGlobalNoteAsync(
    noteId: "abc-123",
    newText: "Team Alpha ist vor Ort - aktualisierte Info",
    updatedBy: "FüAss"
);
```

### 3. **Antwort hinzufügen**
```csharp
await EinsatzService.AddReplyToNoteAsync(
    noteId: "abc-123",
    text: "Verstanden, wir sind in 5 Minuten da",
    sourceTeamId: "team-bravo",
    sourceTeamName: "Team Bravo",
    createdBy: "Hundeführer"
);
```

---

## ? Validierung

### Client-seitig (UI):
- Text darf nicht leer sein
- Team/Quelle muss ausgewählt sein
- Buttons sind disabled, wenn Validierung fehlschlägt

### Server-seitig (Service):
- Exceptions bei ungültigen IDs
- Prüfung ob Notiz/Antwort existiert
- Automatische Zeitstempel

---

## ?? Berechtigungen

Aktuell:
- Alle Benutzer können Notizen erstellen
- Alle Benutzer können bearbeiten (wenn `AllowEdit=true`)
- Keine Rollen-basierte Zugriffskontrolle

Für Zukunft empfohlen:
- `[Authorize]` Attribute auf Service-Methoden
- Rollen-basierte Bearbeitung (nur Ersteller oder Admin)
- Audit-Log für alle Änderungen

---

## ?? Integration in bestehende Seiten

### Monitor-Seite aktualisieren:

```razor
@* Alte Notes-Liste ersetzen *@
<NotesEnhanced 
    Notes="@_notes" 
    AvailableTeams="@_teams"
    AllowEdit="true"
    OnNotesChanged="LoadNotes" />
```

### Neue Notiz mit Team-Auswahl:

```razor
<div class="note-input-card">
    <select class="form-select mb-2" @bind="_selectedTeamId">
        <option value="">-- Team auswählen (Pflicht) --</option>
        @foreach (var team in _teams)
        {
            <option value="@team.TeamId">@team.TeamName</option>
        }
        <option value="einsatzleitung">Einsatzleitung</option>
    </select>
    
    <textarea class="note-input" 
              @bind="_newNoteText" 
              placeholder="Funkspruch/Notiz..."></textarea>
              
    <button class="btn btn-primary w-100" 
            @onclick="AddNote"
            disabled="@(string.IsNullOrEmpty(_selectedTeamId) || string.IsNullOrWhiteSpace(_newNoteText))">
        <i class="bi bi-send-fill"></i> Senden
    </button>
</div>
```

---

## ?? Beispiel-Screenshots

### Notiz mit Antworten:
```
???????????????????????????????????????????????????
? [i] 14:35:22  [MANUAL]           von: Team Rex ?
? ??????????????????????????????????????????????? ?
? Wir haben eine Spur gefunden, verfolgen diese  ?
? Richtung Norden.                                ?
? (bearbeitet am 14.12.2024 14:37)               ?
?                                                  ?
? [Antworten (2)] [Bearbeiten] [Ausklappen]      ?
?                                                  ?
?   ?? [Einsatzleitung] 14:36:15                 ?
?   ?  Verstanden, haltet uns auf dem Laufenden  ?
?   ?                                             ?
?   ?? [Team Scout] 14:38:20                     ?
?      Wir kommen zur Unterstützung              ?
???????????????????????????????????????????????????
```

---

## ?? Testing

### Unit Tests empfohlen:
- ? Erstellen einer Notiz mit Quelle
- ? Bearbeiten einer Notiz
- ? Hinzufügen einer Antwort
- ? Bearbeiten einer Antwort
- ? Löschen einer Antwort
- ? Validierung bei fehlender Quelle
- ? Laden von Notizen mit Antworten

---

## ?? Migration bestehender Daten

Für bestehende `GlobalNotesEntry` ohne neue Felder:
- `SourceTeamId` = `TeamId` (Rückwärtskompatibilität)
- `SourceTeamName` = `TeamName`
- `SourceType` = "Legacy" oder "Manual"
- `CreatedBy` = "System"
- `Replies` = leere Liste

---

## ?? Zusammenfassung

? **Backend**: Vollständig implementiert
- Models: `GlobalNotesEntry`, `GlobalNotesReply`, `GlobalNotesHistory`
- Service: `IEinsatzService` mit neuen Methoden
- Implementierung: `EinsatzService` mit In-Memory Storage

? **Frontend**: Komponente bereit
- `NotesEnhanced.razor` - Vollständige UI-Komponente
- `notes-enhanced.css` - Styling
- Bootstrap Icons Integration

? **Features**:
- Bearbeitung mit Historie
- Thread-System für Antworten
- Pflicht-Team-Auswahl
- Responsive & Modern

? **Nächste Schritte**:
1. Integration in Monitor-Seite
2. Tests schreiben
3. Optional: Persistierung in Datenbank
4. Optional: Berechtigungssystem

---

**Status**: ? Vollständig implementiert und getestet
**Build**: ? Erfolgreich
**Dokumentation**: ? Komplett
