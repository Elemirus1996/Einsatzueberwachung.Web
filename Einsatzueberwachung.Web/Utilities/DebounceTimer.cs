// Debouncing-Utility für verzögerte Ausführung
// Verhindert zu häufige Updates bei schneller User-Eingabe

namespace Einsatzueberwachung.Web.Utilities;

public class DebounceTimer : IDisposable
{
    private Timer? _timer;
    private readonly int _delayMilliseconds;
    private bool _disposed = false;

    public DebounceTimer(int delayMilliseconds = 300)
    {
        _delayMilliseconds = delayMilliseconds;
    }

    public void Debounce(Action action)
    {
        // Cancel vorheriger Timer
        _timer?.Dispose();

        // Neuer Timer für verzögerte Ausführung
        _timer = new Timer(
            _ =>
            {
                action();
                _timer?.Dispose();
            },
            null,
            _delayMilliseconds,
            Timeout.Infinite);
    }

    public void Dispose()
    {
        if (!_disposed)
        {
            _timer?.Dispose();
            _disposed = true;
        }
    }
}
