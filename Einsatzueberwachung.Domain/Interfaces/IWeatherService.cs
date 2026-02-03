// Service-Interface fuer Wetter-Abfragen vom Deutschen Wetterdienst (DWD)

using System;
using System.Threading.Tasks;

namespace Einsatzueberwachung.Domain.Interfaces
{
    public interface IWeatherService
    {
        /// <summary>
        /// Holt aktuelle Wetterdaten fuer eine Position
        /// </summary>
        Task<WeatherData?> GetCurrentWeatherAsync(double latitude, double longitude);

        /// <summary>
        /// Holt aktuelle Wetterdaten fuer eine Adresse/Ort
        /// </summary>
        Task<WeatherData?> GetCurrentWeatherByAddressAsync(string address);

        /// <summary>
        /// Holt Wettervorhersage fuer die naechsten Stunden
        /// </summary>
        Task<WeatherForecast?> GetForecastAsync(double latitude, double longitude);
    }

    /// <summary>
    /// Aktuelle Wetterdaten
    /// </summary>
    public class WeatherData
    {
        public DateTime Zeitpunkt { get; set; } = DateTime.Now;
        public double Temperatur { get; set; } // in Celsius
        public double GefuehlteTemperatur { get; set; } // Wind Chill / Heat Index
        public int Luftfeuchtigkeit { get; set; } // in Prozent
        public double Windgeschwindigkeit { get; set; } // in km/h
        public int Windrichtung { get; set; } // in Grad (0-360)
        public string WindrichtungText { get; set; } = string.Empty; // N, NE, E, etc.
        public double Niederschlag { get; set; } // mm in letzter Stunde
        public int Bewoelkung { get; set; } // in Prozent
        public double Sichtweite { get; set; } // in km
        public double Luftdruck { get; set; } // in hPa
        public string Wetterlage { get; set; } = string.Empty; // Beschreibung
        public string WetterIcon { get; set; } = string.Empty; // Icon-Code
        public bool IstTag { get; set; } = true;
        
        // DWD-spezifische Warnungen
        public bool HatWarnung { get; set; }
        public string Warnung { get; set; } = string.Empty;
        public WarnungsStufe WarnungsStufe { get; set; } = WarnungsStufe.Keine;

        // Berechnete Eigenschaften
        public string TemperaturFormatiert => $"{Temperatur:0.0}°C";
        public string WindFormatiert => $"{Windgeschwindigkeit:0} km/h {WindrichtungText}";
        public string LuftfeuchtigkeitFormatiert => $"{Luftfeuchtigkeit}%";
        
        public string GetBootstrapIcon()
        {
            // Mapping von Wetterlage zu Bootstrap Icons
            var wetter = Wetterlage.ToLowerInvariant();
            
            if (wetter.Contains("gewitter")) return "bi-cloud-lightning-rain";
            if (wetter.Contains("regen") || wetter.Contains("schauer")) return "bi-cloud-rain";
            if (wetter.Contains("schnee")) return "bi-cloud-snow";
            if (wetter.Contains("nebel")) return "bi-cloud-fog";
            if (wetter.Contains("bewoelkt") || wetter.Contains("wolkig")) return "bi-cloud";
            if (wetter.Contains("sonnig") || wetter.Contains("klar"))
            {
                return IstTag ? "bi-sun" : "bi-moon-stars";
            }
            if (Bewoelkung > 70) return "bi-clouds";
            if (Bewoelkung > 30) return "bi-cloud-sun";
            
            return IstTag ? "bi-sun" : "bi-moon";
        }

        public string GetWarnungBadgeClass()
        {
            return WarnungsStufe switch
            {
                WarnungsStufe.Vorabwarnung => "bg-info",
                WarnungsStufe.Markant => "bg-warning text-dark",
                WarnungsStufe.Unwetter => "bg-danger",
                WarnungsStufe.ExtremesUnwetter => "bg-danger",
                _ => "bg-secondary"
            };
        }
    }

    /// <summary>
    /// Wettervorhersage fuer mehrere Stunden
    /// </summary>
    public class WeatherForecast
    {
        public WeatherData[] StundenVorhersage { get; set; } = Array.Empty<WeatherData>();
        public DateTime LetzteAktualisierung { get; set; } = DateTime.Now;
    }

    /// <summary>
    /// DWD Warnungsstufen
    /// </summary>
    public enum WarnungsStufe
    {
        Keine = 0,
        Vorabwarnung = 1,   // Gelb
        Markant = 2,        // Orange
        Unwetter = 3,       // Rot
        ExtremesUnwetter = 4 // Dunkelrot/Violett
    }
}
