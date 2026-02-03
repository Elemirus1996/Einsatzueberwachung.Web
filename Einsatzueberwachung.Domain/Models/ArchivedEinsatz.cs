// Archivierter Einsatz - Speichert abgeschlossene Einsaetze fuer Historien-Ansicht

using System;
using System.Collections.Generic;

namespace Einsatzueberwachung.Domain.Models
{
    /// <summary>
    /// Repraesentiert einen archivierten (abgeschlossenen) Einsatz
    /// </summary>
    public class ArchivedEinsatz
    {
        /// <summary>
        /// Eindeutige ID des archivierten Einsatzes
        /// </summary>
        public string Id { get; set; } = Guid.NewGuid().ToString();

        /// <summary>
        /// Zeitpunkt der Archivierung
        /// </summary>
        public DateTime ArchivedAt { get; set; } = DateTime.Now;

        // === Einsatz-Grunddaten ===
        public string Einsatzleiter { get; set; } = string.Empty;
        public string Fuehrungsassistent { get; set; } = string.Empty;
        public string Alarmiert { get; set; } = string.Empty;
        public string Einsatzort { get; set; } = string.Empty;
        public string MapAddress { get; set; } = string.Empty;
        public bool IstEinsatz { get; set; } = true;
        public DateTime EinsatzDatum { get; set; }
        public string EinsatzNummer { get; set; } = string.Empty;
        public string StaffelName { get; set; } = string.Empty;
        public DateTime? AlarmierungsZeit { get; set; }

        // === Einsatz-Ende ===
        public DateTime? EinsatzEnde { get; set; }
        public string Ergebnis { get; set; } = string.Empty; // z.B. "Person gefunden", "Erfolglos", "Abgebrochen"
        public string Bemerkungen { get; set; } = string.Empty;

        // === Teams und Statistiken ===
        public int AnzahlTeams { get; set; }
        public int AnzahlPersonal { get; set; }
        public int AnzahlHunde { get; set; }
        public int AnzahlDrohnen { get; set; }
        public List<ArchivedTeam> Teams { get; set; } = new();

        // === Notizen und Bereiche ===
        public List<GlobalNotesEntry> GlobalNotesEntries { get; set; } = new();
        public List<SearchArea> SearchAreas { get; set; } = new();

        // === Kartendaten ===
        public (double Latitude, double Longitude)? ElwPosition { get; set; }

        // === Berechnete Eigenschaften ===
        public string EinsatzTyp => IstEinsatz ? "Einsatz" : "Uebung";
        
        public TimeSpan? Dauer => EinsatzEnde.HasValue && AlarmierungsZeit.HasValue 
            ? EinsatzEnde.Value - AlarmierungsZeit.Value 
            : null;

        public string DauerFormatiert => Dauer.HasValue 
            ? $"{(int)Dauer.Value.TotalHours}h {Dauer.Value.Minutes}min" 
            : "Unbekannt";

        /// <summary>
        /// Erstellt ein ArchivedEinsatz aus aktuellen EinsatzData
        /// </summary>
        public static ArchivedEinsatz FromEinsatzData(EinsatzData data, string ergebnis = "", string bemerkungen = "")
        {
            var archived = new ArchivedEinsatz
            {
                Einsatzleiter = data.Einsatzleiter,
                Fuehrungsassistent = data.Fuehrungsassistent,
                Alarmiert = data.Alarmiert,
                Einsatzort = data.Einsatzort,
                MapAddress = data.MapAddress,
                IstEinsatz = data.IstEinsatz,
                EinsatzDatum = data.EinsatzDatum,
                EinsatzNummer = data.EinsatzNummer,
                StaffelName = data.StaffelName,
                AlarmierungsZeit = data.AlarmierungsZeit,
                EinsatzEnde = DateTime.Now,
                Ergebnis = ergebnis,
                Bemerkungen = bemerkungen,
                AnzahlTeams = data.Teams?.Count ?? 0,
                GlobalNotesEntries = data.GlobalNotesEntries ?? new List<GlobalNotesEntry>(),
                SearchAreas = data.SearchAreas ?? new List<SearchArea>(),
                ElwPosition = data.ElwPosition
            };

            // Teams archivieren
            if (data.Teams != null)
            {
                foreach (var team in data.Teams)
                {
                    archived.Teams.Add(ArchivedTeam.FromTeam(team));
                    // Zähle Personal
                    if (!string.IsNullOrEmpty(team.HundefuehrerName)) archived.AnzahlPersonal++;
                    if (!string.IsNullOrEmpty(team.HelferName)) archived.AnzahlPersonal++;
                    // Zähle Hunde
                    if (!string.IsNullOrEmpty(team.DogName)) archived.AnzahlHunde++;
                    // Zähle Drohnen
                    if (team.IsDroneTeam) archived.AnzahlDrohnen++;
                }
            }

            return archived;
        }
    }

    /// <summary>
    /// Archiviertes Team mit minimalen Informationen
    /// </summary>
    public class ArchivedTeam
    {
        public string TeamName { get; set; } = string.Empty;
        public string Funkrufname { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public List<string> MemberNames { get; set; } = new();
        public string DogName { get; set; } = string.Empty;
        public string DroneName { get; set; } = string.Empty;
        public DateTime? AusrueckZeit { get; set; }
        public DateTime? EinrueckZeit { get; set; }

        public static ArchivedTeam FromTeam(Team team)
        {
            var archived = new ArchivedTeam
            {
                TeamName = team.TeamName,
                Funkrufname = team.TeamName, // TeamName wird als Funkrufname verwendet
                Status = team.IsRunning ? "Im Einsatz" : "Beendet",
                DogName = team.DogName ?? string.Empty,
                DroneName = team.IsDroneTeam ? team.DroneType ?? string.Empty : string.Empty
            };

            // Personal hinzufuegen
            if (!string.IsNullOrEmpty(team.HundefuehrerName))
            {
                archived.MemberNames.Add(team.HundefuehrerName);
            }
            if (!string.IsNullOrEmpty(team.HelferName))
            {
                archived.MemberNames.Add(team.HelferName);
            }

            return archived;
        }
    }
}
