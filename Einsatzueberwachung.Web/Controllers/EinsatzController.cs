// REST API Controller für mobilen Zugriff auf Einsatz-Daten
// Bereitstellung von Team-Status, Zeiten und Einsatzinformationen

using Microsoft.AspNetCore.Mvc;
using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Models;

namespace Einsatzueberwachung.Web.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class EinsatzController : ControllerBase
    {
        private readonly IEinsatzService _einsatzService;
        private readonly ILogger<EinsatzController> _logger;

        public EinsatzController(IEinsatzService einsatzService, ILogger<EinsatzController> logger)
        {
            _einsatzService = einsatzService;
            _logger = logger;
        }

        /// <summary>
        /// Gibt den aktuellen Einsatz-Status zurück
        /// </summary>
        [HttpGet("status")]
        public IActionResult GetEinsatzStatus()
        {
            try
            {
                var response = new
                {
                    Einsatz = _einsatzService.CurrentEinsatz,
                    IsActive = _einsatzService.Teams.Any(),
                    TeamCount = _einsatzService.Teams.Count,
                    ActiveTeams = _einsatzService.Teams.Count(t => t.IsRunning)
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen des Einsatz-Status");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Gibt alle Teams mit deren Status zurück
        /// </summary>
        [HttpGet("teams")]
        public IActionResult GetAllTeams()
        {
            try
            {
                var teams = _einsatzService.Teams.Select(t => new
                {
                    t.TeamId,
                    t.TeamName,
                    t.DogName,
                    t.DogSpecialization,
                    t.HundefuehrerName,
                    t.HelferName,
                    t.SearchAreaName,
                    t.ElapsedTime,
                    t.IsRunning,
                    t.IsFirstWarning,
                    t.IsSecondWarning,
                    t.IsDroneTeam,
                    t.DroneType,
                    t.IsSupportTeam,
                    t.CreatedAt,
                    ElapsedMinutes = (int)t.ElapsedTime.TotalMinutes,
                    ElapsedFormatted = $"{t.ElapsedTime:hh\\:mm\\:ss}",
                    Status = GetTeamStatus(t)
                });

                return Ok(teams);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen der Teams");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Gibt ein einzelnes Team zurück
        /// </summary>
        [HttpGet("teams/{teamId}")]
        public async Task<IActionResult> GetTeam(string teamId)
        {
            try
            {
                var team = await _einsatzService.GetTeamByIdAsync(teamId);
                
                if (team == null)
                {
                    return NotFound(new { Error = "Team nicht gefunden" });
                }

                var response = new
                {
                    team.TeamId,
                    team.TeamName,
                    team.DogName,
                    team.DogSpecialization,
                    team.HundefuehrerName,
                    team.HelferName,
                    team.SearchAreaName,
                    team.ElapsedTime,
                    team.IsRunning,
                    team.IsFirstWarning,
                    team.IsSecondWarning,
                    team.IsDroneTeam,
                    team.DroneType,
                    team.IsSupportTeam,
                    team.Notes,
                    team.CreatedAt,
                    ElapsedMinutes = (int)team.ElapsedTime.TotalMinutes,
                    ElapsedFormatted = $"{team.ElapsedTime:hh\\:mm\\:ss}",
                    Status = GetTeamStatus(team)
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen des Teams {TeamId}", teamId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Startet den Timer eines Teams
        /// </summary>
        [HttpPost("teams/{teamId}/start")]
        public async Task<IActionResult> StartTeamTimer(string teamId)
        {
            try
            {
                await _einsatzService.StartTeamTimerAsync(teamId);
                _logger.LogInformation("Timer gestartet für Team {TeamId} via API", teamId);
                return Ok(new { Message = "Timer gestartet" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Starten des Timers für Team {TeamId}", teamId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Stoppt den Timer eines Teams
        /// </summary>
        [HttpPost("teams/{teamId}/stop")]
        public async Task<IActionResult> StopTeamTimer(string teamId)
        {
            try
            {
                await _einsatzService.StopTeamTimerAsync(teamId);
                _logger.LogInformation("Timer gestoppt für Team {TeamId} via API", teamId);
                return Ok(new { Message = "Timer gestoppt" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Stoppen des Timers für Team {TeamId}", teamId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Setzt den Timer eines Teams zurück
        /// </summary>
        [HttpPost("teams/{teamId}/reset")]
        public async Task<IActionResult> ResetTeamTimer(string teamId)
        {
            try
            {
                await _einsatzService.ResetTeamTimerAsync(teamId);
                _logger.LogInformation("Timer zurückgesetzt für Team {TeamId} via API", teamId);
                return Ok(new { Message = "Timer zurückgesetzt" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Zurücksetzen des Timers für Team {TeamId}", teamId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Gibt Suchgebiete zurück
        /// </summary>
        [HttpGet("searchAreas")]
        public IActionResult GetSearchAreas()
        {
            try
            {
                var areas = _einsatzService.CurrentEinsatz.SearchAreas.Select(a => new
                {
                    a.Id,
                    a.Name,
                    a.Color,
                    a.GeoJsonData,
                    a.AssignedTeamId,
                    a.AssignedTeamName,
                    a.IsCompleted,
                    a.Notes,
                    a.CreatedAt
                });

                return Ok(areas);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen der Suchgebiete");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        private string GetTeamStatus(Team team)
        {
            if (!team.IsRunning)
                return "Bereit";
            
            if (team.IsSecondWarning)
                return "Kritisch";
            
            if (team.IsFirstWarning)
                return "Warnung";
            
            return "Im Einsatz";
        }
    }
}
