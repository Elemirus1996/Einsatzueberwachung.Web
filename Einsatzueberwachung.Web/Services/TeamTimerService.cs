// Zentraler Timer-Service für alle Teams.
// Ersetzt die pro-Team System.Threading.Timer Instanzen durch einen einzigen
// HostedService-Timer, der jede Sekunde alle laufenden Teams aktualisiert.
// Vorher: N Teams = N Timer-Threads. Nachher: immer genau 1 Timer.

using System;
using System.Threading;
using System.Threading.Tasks;
using Einsatzueberwachung.Domain.Interfaces;
using Microsoft.Extensions.Hosting;

namespace Einsatzueberwachung.Web.Services
{
    public class TeamTimerService : IHostedService, IDisposable
    {
        private readonly IEinsatzService _einsatzService;
        private Timer? _timer;

        public TeamTimerService(IEinsatzService einsatzService)
        {
            _einsatzService = einsatzService;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _timer = new Timer(Tick, null, TimeSpan.FromSeconds(1), TimeSpan.FromSeconds(1));
            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _timer?.Change(Timeout.Infinite, 0);
            return Task.CompletedTask;
        }

        private void Tick(object? state)
        {
            var now = DateTime.Now;
            foreach (var team in _einsatzService.Teams)
            {
                team.Tick(now);
            }
        }

        public void Dispose()
        {
            _timer?.Dispose();
        }
    }
}
