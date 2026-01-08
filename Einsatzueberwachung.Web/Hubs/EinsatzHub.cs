// SignalR Hub für Echtzeit-Kommunikation mit mobilen Clients
// Ermöglicht Push-Updates für Team-Status, Timer und Thread-Nachrichten

using Microsoft.AspNetCore.SignalR;
using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Models;

namespace Einsatzueberwachung.Web.Hubs
{
    public class EinsatzHub : Hub
    {
        private readonly IEinsatzService _einsatzService;
        private readonly ILogger<EinsatzHub> _logger;

        public EinsatzHub(IEinsatzService einsatzService, ILogger<EinsatzHub> logger)
        {
            _einsatzService = einsatzService;
            _logger = logger;
        }

        public override async Task OnConnectedAsync()
        {
            _logger.LogInformation("Mobile Client verbunden: {ConnectionId}", Context.ConnectionId);
            
            // Sende aktuellen Einsatz-Status an neuen Client
            await Clients.Caller.SendAsync("EinsatzStatus", new
            {
                Einsatz = _einsatzService.CurrentEinsatz,
                Teams = _einsatzService.Teams,
                GlobalNotes = _einsatzService.GlobalNotes
            });
            
            await base.OnConnectedAsync();
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            _logger.LogInformation("Mobile Client getrennt: {ConnectionId}", Context.ConnectionId);
            await base.OnDisconnectedAsync(exception);
        }

        // Client kann sich für bestimmte Team-Updates registrieren
        public async Task JoinTeamGroup(string teamId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"Team_{teamId}");
            _logger.LogInformation("Client {ConnectionId} beigetreten zu Team_{TeamId}", Context.ConnectionId, teamId);
        }

        public async Task LeaveTeamGroup(string teamId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"Team_{teamId}");
        }

        // Client sendet neue Thread-Nachricht
        public async Task SendThreadMessage(string noteId, string text, string sourceTeamId, string sourceTeamName)
        {
            try
            {
                var reply = await _einsatzService.AddReplyToNoteAsync(
                    noteId, 
                    text, 
                    sourceTeamId, 
                    sourceTeamName, 
                    "Einsatzleiter Mobile"
                );

                // Broadcast an alle verbundenen Clients
                await Clients.All.SendAsync("NewThreadReply", new
                {
                    NoteId = noteId,
                    Reply = reply
                });

                _logger.LogInformation("Thread-Antwort hinzugefügt: NoteId={NoteId}, ReplyId={ReplyId}", noteId, reply.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Hinzufügen der Thread-Antwort");
                await Clients.Caller.SendAsync("Error", new { Message = "Fehler beim Senden der Nachricht" });
            }
        }

        // Client erstellt neue Notiz
        public async Task CreateNote(string text, string sourceTeamId, string sourceTeamName, string sourceType)
        {
            try
            {
                var note = await _einsatzService.AddGlobalNoteWithSourceAsync(
                    text, 
                    sourceTeamId, 
                    sourceTeamName, 
                    sourceType,
                    Domain.Models.Enums.GlobalNotesEntryType.Manual,
                    "Einsatzleiter Mobile"
                );

                // Broadcast an alle Clients
                await Clients.All.SendAsync("NewNote", note);

                _logger.LogInformation("Neue Notiz erstellt: NoteId={NoteId}", note.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Erstellen der Notiz");
                await Clients.Caller.SendAsync("Error", new { Message = "Fehler beim Erstellen der Notiz" });
            }
        }

        // Ping für Connection-Health-Check
        public Task Ping()
        {
            return Task.CompletedTask;
        }
    }
}
