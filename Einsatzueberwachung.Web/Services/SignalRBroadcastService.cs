// Service zur Weiterleitung von Einsatz-Events an SignalR Hub
// Verknüpft Domain-Events mit SignalR für Echtzeit-Updates an mobile Clients

using Microsoft.AspNetCore.SignalR;
using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Models;
using Einsatzueberwachung.Web.Hubs;

namespace Einsatzueberwachung.Web.Services
{
    public class SignalRBroadcastService : IHostedService
    {
        private readonly IEinsatzService _einsatzService;
        private readonly IHubContext<EinsatzHub> _hubContext;
        private readonly ILogger<SignalRBroadcastService> _logger;

        public SignalRBroadcastService(
            IEinsatzService einsatzService,
            IHubContext<EinsatzHub> hubContext,
            ILogger<SignalRBroadcastService> logger)
        {
            _einsatzService = einsatzService;
            _hubContext = hubContext;
            _logger = logger;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("SignalR Broadcast Service gestartet");

            // Abonniere Einsatz-Events
            _einsatzService.EinsatzChanged += OnEinsatzChanged;
            _einsatzService.TeamAdded += OnTeamAdded;
            _einsatzService.TeamRemoved += OnTeamRemoved;
            _einsatzService.TeamUpdated += OnTeamUpdated;
            _einsatzService.NoteAdded += OnNoteAdded;
            _einsatzService.TeamWarningTriggered += OnTeamWarningTriggered;

            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("SignalR Broadcast Service gestoppt");

            // Deabonniere Events
            _einsatzService.EinsatzChanged -= OnEinsatzChanged;
            _einsatzService.TeamAdded -= OnTeamAdded;
            _einsatzService.TeamRemoved -= OnTeamRemoved;
            _einsatzService.TeamUpdated -= OnTeamUpdated;
            _einsatzService.NoteAdded -= OnNoteAdded;
            _einsatzService.TeamWarningTriggered -= OnTeamWarningTriggered;

            return Task.CompletedTask;
        }

        private async void OnEinsatzChanged()
        {
            try
            {
                await _hubContext.Clients.All.SendAsync("EinsatzChanged", new
                {
                    Einsatz = _einsatzService.CurrentEinsatz
                });
                _logger.LogDebug("EinsatzChanged Event gesendet");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Senden von EinsatzChanged");
            }
        }

        private async void OnTeamAdded(Team team)
        {
            try
            {
                var teamDto = CreateTeamDto(team);
                await _hubContext.Clients.All.SendAsync("TeamAdded", teamDto);
                _logger.LogInformation("TeamAdded Event gesendet: {TeamId}", team.TeamId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Senden von TeamAdded");
            }
        }

        private async void OnTeamRemoved(Team team)
        {
            try
            {
                await _hubContext.Clients.All.SendAsync("TeamRemoved", new { TeamId = team.TeamId });
                _logger.LogInformation("TeamRemoved Event gesendet: {TeamId}", team.TeamId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Senden von TeamRemoved");
            }
        }

        private async void OnTeamUpdated(Team team)
        {
            try
            {
                var teamDto = CreateTeamDto(team);
                
                // Broadcast an alle Clients
                await _hubContext.Clients.All.SendAsync("TeamUpdated", teamDto);
                
                // Spezielle Benachrichtigung an Clients, die dieses Team abonniert haben
                await _hubContext.Clients.Group($"Team_{team.TeamId}").SendAsync("TeamStatusUpdate", teamDto);
                
                _logger.LogDebug("TeamUpdated Event gesendet: {TeamId}", team.TeamId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Senden von TeamUpdated");
            }
        }

        private async void OnNoteAdded(GlobalNotesEntry note)
        {
            try
            {
                var noteDto = CreateNoteDto(note);
                await _hubContext.Clients.All.SendAsync("NewNote", noteDto);
                _logger.LogDebug("NewNote Event gesendet: {NoteId}", note.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Senden von NewNote");
            }
        }

        private async void OnTeamWarningTriggered(Team team, bool isSecondWarning)
        {
            try
            {
                var warningDto = new
                {
                    TeamId = team.TeamId,
                    TeamName = team.TeamName,
                    IsSecondWarning = isSecondWarning,
                    ElapsedMinutes = (int)team.ElapsedTime.TotalMinutes,
                    Timestamp = DateTime.Now
                };

                await _hubContext.Clients.All.SendAsync("TeamWarning", warningDto);
                _logger.LogInformation("TeamWarning Event gesendet: {TeamId}, Second={IsSecond}", team.TeamId, isSecondWarning);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Senden von TeamWarning");
            }
        }

        private object CreateTeamDto(Team team)
        {
            return new
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
                team.CreatedAt,
                ElapsedMinutes = (int)team.ElapsedTime.TotalMinutes,
                ElapsedFormatted = $"{team.ElapsedTime:hh\\:mm\\:ss}",
                Status = GetTeamStatus(team)
            };
        }

        private object CreateNoteDto(GlobalNotesEntry note)
        {
            return new
            {
                note.Id,
                note.Timestamp,
                note.Text,
                note.Type,
                note.SourceTeamId,
                note.SourceTeamName,
                note.SourceType,
                note.CreatedBy,
                note.IsEdited,
                note.UpdatedAt,
                note.UpdatedBy,
                note.ReplyCount,
                FormattedTime = note.FormattedTimestamp,
                FormattedDate = note.FormattedDate,
                FormattedDateTime = note.FormattedDateTime,
                TypeIcon = note.TypeIcon,
                TypeColor = note.TypeColor,
                HasReplies = note.ReplyCount > 0
            };
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
