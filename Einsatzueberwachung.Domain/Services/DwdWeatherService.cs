// DWD Weather Service - Wetterdaten vom Deutschen Wetterdienst
// Verwendet die BrightSky API (Open Source Proxy fuer DWD Open Data)
// https://brightsky.dev/

using System;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using Einsatzueberwachung.Domain.Interfaces;

namespace Einsatzueberwachung.Domain.Services
{
    public class DwdWeatherService : IWeatherService
    {
        private readonly HttpClient _httpClient;
        private const string BrightSkyBaseUrl = "https://api.brightsky.dev";
        
        // Cache fuer Wetterdaten (5 Minuten)
        private WeatherData? _cachedWeather;
        private DateTime _cacheTime = DateTime.MinValue;
        private (double lat, double lon) _cachedPosition;
        private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(5);

        public DwdWeatherService(HttpClient httpClient)
        {
            _httpClient = httpClient;
            _httpClient.Timeout = TimeSpan.FromSeconds(10);
        }

        public async Task<WeatherData?> GetCurrentWeatherAsync(double latitude, double longitude)
        {
            // Cache pruefen
            if (_cachedWeather != null && 
                DateTime.Now - _cacheTime < CacheDuration &&
                Math.Abs(_cachedPosition.lat - latitude) < 0.01 &&
                Math.Abs(_cachedPosition.lon - longitude) < 0.01)
            {
                return _cachedWeather;
            }

            try
            {
                // BrightSky API fuer aktuelles Wetter
                var now = DateTime.UtcNow;
                var url = $"{BrightSkyBaseUrl}/current_weather?lat={latitude.ToString(System.Globalization.CultureInfo.InvariantCulture)}&lon={longitude.ToString(System.Globalization.CultureInfo.InvariantCulture)}";
                
                var response = await _httpClient.GetAsync(url);
                
                if (!response.IsSuccessStatusCode)
                    return null;

                var json = await response.Content.ReadAsStringAsync();
                var weatherResponse = JsonSerializer.Deserialize<BrightSkyCurrentWeatherResponse>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

                if (weatherResponse?.Weather == null)
                    return null;

                var weather = MapToWeatherData(weatherResponse.Weather);
                
                // Cache aktualisieren
                _cachedWeather = weather;
                _cacheTime = DateTime.Now;
                _cachedPosition = (latitude, longitude);

                return weather;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public async Task<WeatherData?> GetCurrentWeatherByAddressAsync(string address)
        {
            // Fuer Adress-basierte Abfragen muessten wir einen Geocoding-Service nutzen
            // Erstmal Fallback auf manuelle Koordinaten-Eingabe
            // TODO: Nominatim oder Google Geocoding API integrieren
            return null;
        }

        public async Task<WeatherForecast?> GetForecastAsync(double latitude, double longitude)
        {
            try
            {
                var now = DateTime.UtcNow;
                var url = $"{BrightSkyBaseUrl}/weather?lat={latitude.ToString(System.Globalization.CultureInfo.InvariantCulture)}&lon={longitude.ToString(System.Globalization.CultureInfo.InvariantCulture)}&date={now:yyyy-MM-dd}";
                
                var response = await _httpClient.GetAsync(url);
                
                if (!response.IsSuccessStatusCode)
                    return null;

                var json = await response.Content.ReadAsStringAsync();
                var weatherResponse = JsonSerializer.Deserialize<BrightSkyWeatherResponse>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

                if (weatherResponse?.Weather == null || weatherResponse.Weather.Length == 0)
                    return null;

                var forecast = new WeatherForecast
                {
                    LetzteAktualisierung = DateTime.Now,
                    StundenVorhersage = new WeatherData[Math.Min(24, weatherResponse.Weather.Length)]
                };

                for (int i = 0; i < forecast.StundenVorhersage.Length && i < weatherResponse.Weather.Length; i++)
                {
                    forecast.StundenVorhersage[i] = MapToWeatherData(weatherResponse.Weather[i]);
                }

                return forecast;
            }
            catch (Exception)
            {
                return null;
            }
        }

        private WeatherData MapToWeatherData(BrightSkyWeatherData data)
        {
            var weather = new WeatherData
            {
                Zeitpunkt = data.Timestamp ?? DateTime.Now,
                Temperatur = data.Temperature ?? 0,
                Luftfeuchtigkeit = (int)(data.RelativeHumidity ?? 0),
                Windgeschwindigkeit = data.WindSpeed ?? 0,
                Windrichtung = (int)(data.WindDirection ?? 0),
                WindrichtungText = GetWindrichtungText((int)(data.WindDirection ?? 0)),
                Niederschlag = data.Precipitation ?? 0,
                Bewoelkung = (int)(data.CloudCover ?? 0),
                Sichtweite = (data.Visibility ?? 10000) / 1000.0, // m zu km
                Luftdruck = data.Pressure ?? 1013,
                Wetterlage = MapConditionToGerman(data.Condition),
                IstTag = data.Timestamp?.Hour >= 6 && data.Timestamp?.Hour < 20
            };

            // Gefuehlte Temperatur berechnen (vereinfacht)
            weather.GefuehlteTemperatur = CalculateFeelsLike(
                weather.Temperatur, 
                weather.Windgeschwindigkeit, 
                weather.Luftfeuchtigkeit);

            return weather;
        }

        private string GetWindrichtungText(int degrees)
        {
            if (degrees < 0) return "";
            
            var directions = new[] { "N", "NNO", "NO", "ONO", "O", "OSO", "SO", "SSO", 
                                     "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW" };
            var index = (int)Math.Round(degrees / 22.5) % 16;
            return directions[index];
        }

        private string MapConditionToGerman(string? condition)
        {
            if (string.IsNullOrEmpty(condition))
                return "Unbekannt";

            return condition.ToLowerInvariant() switch
            {
                "dry" => "Trocken",
                "fog" => "Nebel",
                "rain" => "Regen",
                "sleet" => "Schneeregen",
                "snow" => "Schnee",
                "hail" => "Hagel",
                "thunderstorm" => "Gewitter",
                "clear-day" => "Sonnig",
                "clear-night" => "Klar",
                "partly-cloudy-day" => "Teilweise bewoelkt",
                "partly-cloudy-night" => "Teilweise bewoelkt",
                "cloudy" => "Bewoelkt",
                "wind" => "Windig",
                _ => condition
            };
        }

        private double CalculateFeelsLike(double temp, double windSpeed, int humidity)
        {
            // Wind Chill fuer kalte Temperaturen
            if (temp <= 10 && windSpeed > 4.8)
            {
                var windChill = 13.12 + 0.6215 * temp - 11.37 * Math.Pow(windSpeed, 0.16) + 0.3965 * temp * Math.Pow(windSpeed, 0.16);
                return Math.Round(windChill, 1);
            }
            
            // Heat Index fuer warme Temperaturen
            if (temp >= 27 && humidity >= 40)
            {
                var hi = -8.784695 + 1.61139411 * temp + 2.338549 * humidity 
                         - 0.14611605 * temp * humidity - 0.012308094 * temp * temp 
                         - 0.016424828 * humidity * humidity;
                return Math.Round(hi, 1);
            }

            return temp;
        }

        #region BrightSky API Response Classes

        private class BrightSkyCurrentWeatherResponse
        {
            public BrightSkyWeatherData? Weather { get; set; }
            public BrightSkySource[]? Sources { get; set; }
        }

        private class BrightSkyWeatherResponse
        {
            public BrightSkyWeatherData[]? Weather { get; set; }
            public BrightSkySource[]? Sources { get; set; }
        }

        private class BrightSkyWeatherData
        {
            public DateTime? Timestamp { get; set; }
            public double? Temperature { get; set; }
            public double? RelativeHumidity { get; set; }
            public double? WindSpeed { get; set; }
            public double? WindDirection { get; set; }
            public double? Precipitation { get; set; }
            public double? CloudCover { get; set; }
            public double? Visibility { get; set; }
            public double? Pressure { get; set; }
            public string? Condition { get; set; }
            public string? Icon { get; set; }
        }

        private class BrightSkySource
        {
            public string? Id { get; set; }
            public string? StationName { get; set; }
        }

        #endregion
    }
}
