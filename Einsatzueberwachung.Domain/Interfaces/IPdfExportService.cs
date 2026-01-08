// Service-Interface für PDF-Export von Einsatzberichten
// Quelle: Abgeleitet von WPF Services/PdfExportService.cs und ViewModels/PdfExportViewModel.cs

using System.Collections.Generic;
using System.Threading.Tasks;
using Einsatzueberwachung.Domain.Models;

namespace Einsatzueberwachung.Domain.Interfaces
{
    public interface IPdfExportService
    {
        Task<PdfExportResult> ExportEinsatzToPdfAsync(EinsatzData einsatzData, List<Team> teams, List<GlobalNotesEntry> notes);
    }

    public class PdfExportResult
    {
        public bool Success { get; set; }
        public string FilePath { get; set; } = string.Empty;
        public string ErrorMessage { get; set; } = string.Empty;
    }
}
