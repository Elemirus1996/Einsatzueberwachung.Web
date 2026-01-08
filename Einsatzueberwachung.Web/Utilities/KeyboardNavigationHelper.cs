using Microsoft.JSInterop;

namespace Einsatzueberwachung.Web.Utilities;

/// <summary>
/// Hilfsfunktionen für Keyboard-Navigation und Accessibility
/// </summary>
public class KeyboardNavigationHelper
{
    private readonly IJSRuntime _jsRuntime;

    public KeyboardNavigationHelper(IJSRuntime jsRuntime)
    {
        _jsRuntime = jsRuntime;
    }

    /// <summary>
    /// Aktiviert Focus Trap für Dialoge (Tab bleibt innerhalb des Dialogs)
    /// </summary>
    public async Task EnableFocusTrap(string dialogSelector)
    {
        await _jsRuntime.InvokeVoidAsync("eval", $@"
            (function() {{
                const dialog = document.querySelector('{dialogSelector}');
                if (!dialog) return;
                
                const focusableElements = dialog.querySelectorAll(
                    'button, [href], input, select, textarea, [tabindex]:not([tabindex=""-1])'
                );
                
                if (focusableElements.length === 0) return;
                
                const firstElement = focusableElements[0];
                const lastElement = focusableElements[focusableElements.length - 1];
                
                dialog.addEventListener('keydown', function(e) {{
                    if (e.key !== 'Tab') return;
                    
                    if (e.shiftKey) {{
                        if (document.activeElement === firstElement) {{
                            lastElement.focus();
                            e.preventDefault();
                        }}
                    }} else {{
                        if (document.activeElement === lastElement) {{
                            firstElement.focus();
                            e.preventDefault();
                        }}
                    }}
                }});
                
                // Fokus auf erstes Element setzen
                firstElement.focus();
            }})();
        ");
    }

    /// <summary>
    /// Aktiviert ESC-Taste für Dialog schließen
    /// </summary>
    public async Task EnableEscapeKey(string dialogSelector, Func<Task> onEscape)
    {
        var dotNetRef = DotNetObjectReference.Create(new EscapeKeyHandler(onEscape));
        
        await _jsRuntime.InvokeVoidAsync("eval", $@"
            (function() {{
                const dialog = document.querySelector('{dialogSelector}');
                if (!dialog) return;
                
                dialog.addEventListener('keydown', function(e) {{
                    if (e.key === 'Escape') {{
                        {dotNetRef}.invokeMethodAsync('OnEscape');
                    }}
                }});
            }})();
        ");
    }

    /// <summary>
    /// Setzt den Fokus zurück auf das vorherige Element nach Dialog-Schließen
    /// </summary>
    public async Task RestoreFocus()
    {
        await _jsRuntime.InvokeVoidAsync("eval", @"
            if (window.previousFocusedElement) {
                window.previousFocusedElement.focus();
                window.previousFocusedElement = null;
            }
        ");
    }

    /// <summary>
    /// Speichert das aktuell fokussierte Element vor Dialog-Öffnen
    /// </summary>
    public async Task SaveCurrentFocus()
    {
        await _jsRuntime.InvokeVoidAsync("eval", @"
            window.previousFocusedElement = document.activeElement;
        ");
    }

    private class EscapeKeyHandler
    {
        private readonly Func<Task> _onEscape;

        public EscapeKeyHandler(Func<Task> onEscape)
        {
            _onEscape = onEscape;
        }

        [JSInvokable]
        public Task OnEscape() => _onEscape();
    }
}
