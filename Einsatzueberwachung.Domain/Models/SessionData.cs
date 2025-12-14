// Quelle: WPF-Projekt Models/SessionData.cs
// Session-/Stammdaten für die Anwendung (Personal, Hunde, Einstellungen)

using System.Collections.Generic;

namespace Einsatzueberwachung.Domain.Models
{
    public class SessionData
    {
        public List<PersonalEntry> PersonalList { get; set; }
        public List<DogEntry> DogList { get; set; }
        public List<DroneEntry> DroneList { get; set; }
        public StaffelSettings StaffelSettings { get; set; }
        public AppSettings AppSettings { get; set; }

        public SessionData()
        {
            PersonalList = new List<PersonalEntry>();
            DogList = new List<DogEntry>();
            DroneList = new List<DroneEntry>();
            StaffelSettings = new StaffelSettings();
            AppSettings = new AppSettings();
        }
    }

    public class StaffelSettings
    {
        public string StaffelName { get; set; }
        public string StaffelAdresse { get; set; }
        public string StaffelTelefon { get; set; }
        public string StaffelEmail { get; set; }
        public string StaffelLogoPfad { get; set; }

        public StaffelSettings()
        {
            StaffelName = string.Empty;
            StaffelAdresse = string.Empty;
            StaffelTelefon = string.Empty;
            StaffelEmail = string.Empty;
            StaffelLogoPfad = string.Empty;
        }
    }

    public class AppSettings
    {
        public string Theme { get; set; }
        public bool IsDarkMode { get; set; }
        public int DefaultFirstWarningMinutes { get; set; }
        public int DefaultSecondWarningMinutes { get; set; }
        public string UpdateUrl { get; set; }
        public bool AutoCheckUpdates { get; set; }

        public AppSettings()
        {
            Theme = "Light";
            IsDarkMode = false;
            DefaultFirstWarningMinutes = 45;
            DefaultSecondWarningMinutes = 60;
            UpdateUrl = string.Empty;
            AutoCheckUpdates = true;
        }
    }
}
