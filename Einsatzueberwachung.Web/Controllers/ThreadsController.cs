// REST API Controller für Thread-System (Global Notes)
// Ermöglicht mobilen Zugriff auf Funksprüche, Notizen und Thread-Kommunikation

using Microsoft.AspNetCore.Mvc;
using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Models;
using Einsatzueberwachung.Domain.Models.Enums;

namespace Einsatzueberwachung.Web.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class ThreadsController : ControllerBase
    {
        private readonly IEinsatzService _einsatzService;
        private readonly ILogger<ThreadsController> _logger;

        public ThreadsController(IEinsatzService einsatzService, ILogger<ThreadsController> logger)
        {
            _einsatzService = einsatzService;
            _logger = logger;
        }

        /// <summary>
        /// Gibt alle Global Notes (Threads) zurück
        /// </summary>
        [HttpGet]
        public IActionResult GetAllNotes([FromQuery] string? teamId = null)
        {
            try
            {
                var notes = string.IsNullOrEmpty(teamId)
                    ? _einsatzService.GlobalNotes.OrderByDescending(n => n.Timestamp).ToList()
                    : _einsatzService.GlobalNotes
                        .Where(n => string.IsNullOrEmpty(n.SourceTeamId) || n.SourceTeamId == teamId)
                        .OrderByDescending(n => n.Timestamp)
                        .ToList();

                var response = notes.Select(n => new
                {
                    n.Id,
                    n.Timestamp,
                    n.Text,
                    n.Type,
                    n.SourceTeamId,
                    n.SourceTeamName,
                    n.SourceType,
                    n.CreatedBy,
                    n.IsEdited,
                    n.UpdatedAt,
                    n.UpdatedBy,
                    n.ReplyCount,
                    FormattedTime = n.FormattedTimestamp,
                    FormattedDate = n.FormattedDate,
                    FormattedDateTime = n.FormattedDateTime,
                    TypeIcon = n.TypeIcon,
                    TypeColor = n.TypeColor,
                    HasReplies = n.ReplyCount > 0
                });

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen der Notes");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Gibt eine einzelne Note mit allen Antworten zurück
        /// </summary>
        [HttpGet("{noteId}")]
        public async Task<IActionResult> GetNote(string noteId)
        {
            try
            {
                var note = await _einsatzService.GetGlobalNoteByIdAsync(noteId);
                
                if (note == null)
                {
                    return NotFound(new { Error = "Notiz nicht gefunden" });
                }

                var response = new
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
                    FormattedTime = note.FormattedTimestamp,
                    FormattedDate = note.FormattedDate,
                    FormattedDateTime = note.FormattedDateTime,
                    TypeIcon = note.TypeIcon,
                    TypeColor = note.TypeColor,
                    Replies = note.Replies.OrderBy(r => r.Timestamp).Select(r => new
                    {
                        r.Id,
                        r.Text,
                        r.Timestamp,
                        r.SourceTeamId,
                        r.SourceTeamName,
                        r.CreatedBy,
                        r.IsEdited,
                        r.UpdatedAt,
                        r.UpdatedBy,
                        FormattedTime = r.FormattedTimestamp,
                        FormattedDateTime = r.FormattedDateTime
                    })
                };

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen der Note {NoteId}", noteId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Erstellt eine neue Note (Thread)
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateNote([FromBody] CreateNoteRequest request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.Text))
                {
                    return BadRequest(new { Error = "Text darf nicht leer sein" });
                }

                var note = await _einsatzService.AddGlobalNoteWithSourceAsync(
                    request.Text,
                    request.SourceTeamId ?? "mobile",
                    request.SourceTeamName ?? "Einsatzleiter Mobile",
                    request.SourceType ?? "Einsatzleitung",
                    request.Type,
                    request.CreatedBy ?? "Einsatzleiter Mobile"
                );

                _logger.LogInformation("Neue Note erstellt via API: {NoteId}", note.Id);

                return CreatedAtAction(nameof(GetNote), new { noteId = note.Id }, new
                {
                    note.Id,
                    note.Timestamp,
                    note.Text,
                    note.Type,
                    note.SourceTeamId,
                    note.SourceTeamName,
                    note.SourceType,
                    note.CreatedBy
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Erstellen der Note");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Fügt eine Antwort zu einer Note hinzu
        /// </summary>
        [HttpPost("{noteId}/replies")]
        public async Task<IActionResult> AddReply(string noteId, [FromBody] AddReplyRequest request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.Text))
                {
                    return BadRequest(new { Error = "Text darf nicht leer sein" });
                }

                var reply = await _einsatzService.AddReplyToNoteAsync(
                    noteId,
                    request.Text,
                    request.SourceTeamId ?? "mobile",
                    request.SourceTeamName ?? "Einsatzleiter Mobile",
                    request.CreatedBy ?? "Einsatzleiter Mobile"
                );

                _logger.LogInformation("Neue Antwort hinzugefügt via API: NoteId={NoteId}, ReplyId={ReplyId}", noteId, reply.Id);

                return Ok(new
                {
                    reply.Id,
                    reply.Text,
                    reply.Timestamp,
                    reply.SourceTeamId,
                    reply.SourceTeamName,
                    reply.CreatedBy,
                    FormattedTime = reply.FormattedTimestamp
                });
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "Note nicht gefunden: {NoteId}", noteId);
                return NotFound(new { Error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Hinzufügen der Antwort");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Gibt alle Antworten einer Note zurück
        /// </summary>
        [HttpGet("{noteId}/replies")]
        public async Task<IActionResult> GetReplies(string noteId)
        {
            try
            {
                var replies = await _einsatzService.GetRepliesForNoteAsync(noteId);

                var response = replies.Select(r => new
                {
                    r.Id,
                    r.Text,
                    r.Timestamp,
                    r.SourceTeamId,
                    r.SourceTeamName,
                    r.CreatedBy,
                    r.IsEdited,
                    r.UpdatedAt,
                    r.UpdatedBy,
                    FormattedTime = r.FormattedTimestamp,
                    FormattedDateTime = r.FormattedDateTime
                });

                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen der Antworten für Note {NoteId}", noteId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Aktualisiert eine Note
        /// </summary>
        [HttpPut("{noteId}")]
        public async Task<IActionResult> UpdateNote(string noteId, [FromBody] UpdateNoteRequest request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.Text))
                {
                    return BadRequest(new { Error = "Text darf nicht leer sein" });
                }

                var note = await _einsatzService.UpdateGlobalNoteAsync(
                    noteId,
                    request.Text,
                    request.UpdatedBy ?? "Einsatzleiter Mobile"
                );

                _logger.LogInformation("Note aktualisiert via API: {NoteId}", noteId);

                return Ok(new
                {
                    note.Id,
                    note.Text,
                    note.UpdatedAt,
                    note.UpdatedBy,
                    note.IsEdited
                });
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "Note nicht gefunden: {NoteId}", noteId);
                return NotFound(new { Error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Aktualisieren der Note {NoteId}", noteId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Aktualisiert eine Antwort
        /// </summary>
        [HttpPut("replies/{replyId}")]
        public async Task<IActionResult> UpdateReply(string replyId, [FromBody] UpdateReplyRequest request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.Text))
                {
                    return BadRequest(new { Error = "Text darf nicht leer sein" });
                }

                var reply = await _einsatzService.UpdateReplyAsync(
                    replyId,
                    request.Text,
                    request.UpdatedBy ?? "Einsatzleiter Mobile"
                );

                _logger.LogInformation("Antwort aktualisiert via API: {ReplyId}", replyId);

                return Ok(new
                {
                    reply.Id,
                    reply.Text,
                    reply.UpdatedAt,
                    reply.UpdatedBy,
                    reply.IsEdited
                });
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "Antwort nicht gefunden: {ReplyId}", replyId);
                return NotFound(new { Error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Aktualisieren der Antwort {ReplyId}", replyId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Löscht eine Antwort
        /// </summary>
        [HttpDelete("replies/{replyId}")]
        public async Task<IActionResult> DeleteReply(string replyId)
        {
            try
            {
                await _einsatzService.DeleteReplyAsync(replyId);
                _logger.LogInformation("Antwort gelöscht via API: {ReplyId}", replyId);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Löschen der Antwort {ReplyId}", replyId);
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }
    }

    // DTOs für Request Bodies
    public class CreateNoteRequest
    {
        public required string Text { get; set; }
        public string? SourceTeamId { get; set; }
        public string? SourceTeamName { get; set; }
        public string? SourceType { get; set; }
        public GlobalNotesEntryType Type { get; set; } = GlobalNotesEntryType.Manual;
        public string? CreatedBy { get; set; }
    }

    public class AddReplyRequest
    {
        public required string Text { get; set; }
        public string? SourceTeamId { get; set; }
        public string? SourceTeamName { get; set; }
        public string? CreatedBy { get; set; }
    }

    public class UpdateNoteRequest
    {
        public required string Text { get; set; }
        public string? UpdatedBy { get; set; }
    }

    public class UpdateReplyRequest
    {
        public required string Text { get; set; }
        public string? UpdatedBy { get; set; }
    }
}
