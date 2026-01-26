using System;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using Einsatzueberwachung.Domain.Services;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Einsatzueberwachung.Web.Services
{
    /// <summary>
    /// Hosted Service der im Hintergrund regelmäßig auf Updates prüft
    /// </summary>
    public class UpdateCheckService : BackgroundService
    {
        private readonly GitHubUpdateService _updateService;
        private readonly ILogger<UpdateCheckService> _logger;
        
        // Standard: Jede Stunde prüfen (in Millisekunden)
        private const int CHECK_INTERVAL_HOURS = 1;
        private const int CHECK_INTERVAL_MS = CHECK_INTERVAL_HOURS * 60 * 60 * 1000;

        // Event für Update-Benachrichtigungen
        public event Action<UpdateCheckResult>? UpdateAvailable;

        public UpdateCheckService(GitHubUpdateService updateService, ILogger<UpdateCheckService> logger)
        {
            _updateService = updateService;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Update Check Service gestartet");

            // Initial nach 30 Sekunden prüfen (lässt App hochfahren)
            await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    var result = await _updateService.CheckForUpdatesAsync();
                    
                    if (result.UpdateAvailable)
                    {
                        _logger.LogInformation("Update verfügbar: {Version}", result.LatestVersion);
                        UpdateAvailable?.Invoke(result);
                    }

                    // Nächste Prüfung nach CHECK_INTERVAL_HOURS
                    await Task.Delay(CHECK_INTERVAL_MS, stoppingToken);
                }
                catch (OperationCanceledException)
                {
                    _logger.LogInformation("Update Check Service wird beendet");
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Fehler im Update Check Service");
                    // Bei Fehler 5 Minuten warten vor nächstem Versuch
                    await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
                }
            }
        }

        /// <summary>
        /// Startet manuell eine Update-Installation
        /// </summary>
        public async Task<bool> StartUpdateAsync(UpdateCheckResult updateInfo)
        {
            try
            {
                if (string.IsNullOrEmpty(updateInfo.InstallerUrl))
                {
                    _logger.LogWarning("Kein Installer URL verfügbar");
                    return false;
                }

                // Installer herunterladen
                var installerData = await _updateService.DownloadInstallerAsync(updateInfo.InstallerUrl);
                if (installerData == null || installerData.Length == 0)
                {
                    _logger.LogError("Installer Download fehlgeschlagen");
                    return false;
                }

                // Installer in Temp speichern und ausführen
                var tempPath = Path.Combine(Path.GetTempPath(), "EinsatzueberwachungSetup.exe");
                await File.WriteAllBytesAsync(tempPath, installerData);

                // Installer starten
                var process = new ProcessStartInfo
                {
                    FileName = tempPath,
                    UseShellExecute = true,
                    Verb = "runas" // Administrator-Rechte anfordern
                };

                Process.Start(process);
                _logger.LogInformation("Update-Installer gestartet");
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Starten des Updates");
                return false;
            }
        }
    }
}
