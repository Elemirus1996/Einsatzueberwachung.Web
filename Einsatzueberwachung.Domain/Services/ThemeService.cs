// Einsatzüberwachung - Globaler Theme Service
// Stellt sicher, dass Theme über alle Seiten/Komponenten synchron ist

using Einsatzueberwachung.Domain.Interfaces;

namespace Einsatzueberwachung.Domain.Services
{
    public class ThemeService
    {
        private readonly IMasterDataService _masterDataService;
        private bool _isDarkMode;
        private bool _isInitialized = false;

        public event Action? OnThemeChanged;

        public ThemeService(IMasterDataService masterDataService)
        {
            _masterDataService = masterDataService;
        }

        public async Task InitializeAsync()
        {
            if (!_isInitialized)
            {
                await LoadThemeAsync();
                _isInitialized = true;
            }
        }

        public bool IsDarkMode => _isDarkMode;

        public string CurrentTheme => _isDarkMode ? "dark" : "light";

        public async Task LoadThemeAsync()
        {
            try
            {
                var sessionData = await _masterDataService.LoadSessionDataAsync();
                _isDarkMode = sessionData?.AppSettings?.IsDarkMode ?? false;
                Console.WriteLine($"ThemeService: Theme geladen - {CurrentTheme}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"ThemeService: Fehler beim Laden - {ex.Message}");
                _isDarkMode = false;
            }
        }

        public async Task SetThemeAsync(bool isDark)
        {
            if (_isDarkMode != isDark)
            {
                _isDarkMode = isDark;

                // Speichere in Settings
                try
                {
                    var sessionData = await _masterDataService.LoadSessionDataAsync();
                    if (sessionData.AppSettings == null)
                        sessionData.AppSettings = new Models.AppSettings();

                    sessionData.AppSettings.IsDarkMode = isDark;
                    sessionData.AppSettings.Theme = isDark ? "Dark" : "Light";
                    await _masterDataService.SaveSessionDataAsync(sessionData);

                    Console.WriteLine($"ThemeService: Theme gespeichert - {CurrentTheme}");

                    // Notify subscribers
                    OnThemeChanged?.Invoke();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"ThemeService: Fehler beim Speichern - {ex.Message}");
                }
            }
        }

        public async Task ToggleThemeAsync()
        {
            await SetThemeAsync(!_isDarkMode);
        }
    }
}
