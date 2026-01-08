using Microsoft.JSInterop;

namespace Einsatzueberwachung.Web.Utilities;

/// <summary>
/// C# Wrapper für Swipe-Gesten auf Touch-Geräten
/// </summary>
public class SwipeHandlerInterop : IAsyncDisposable
{
    private readonly IJSRuntime _jsRuntime;
    private readonly DotNetObjectReference<SwipeHandlerInterop> _dotNetRef;
    private IJSObjectReference? _swipeModule;
    private IJSObjectReference? _handlerInstance;
    
    public event Func<string, Task>? OnSwipe;

    public SwipeHandlerInterop(IJSRuntime jsRuntime)
    {
        _jsRuntime = jsRuntime;
        _dotNetRef = DotNetObjectReference.Create(this);
    }

    /// <summary>
    /// Initialisiert Swipe-Handler für ein HTML-Element
    /// </summary>
    /// <param name="elementId">ID des HTML-Elements</param>
    public async Task InitializeAsync(string elementId)
    {
        _swipeModule = await _jsRuntime.InvokeAsync<IJSObjectReference>(
            "import", "./swipe-handler.js");

        _handlerInstance = await _swipeModule.InvokeAsync<IJSObjectReference>(
            "initSwipeHandler", elementId, _dotNetRef, nameof(HandleSwipe));
    }

    /// <summary>
    /// Wird von JavaScript aufgerufen wenn Swipe erkannt wurde
    /// </summary>
    [JSInvokable]
    public async Task HandleSwipe(string direction)
    {
        if (OnSwipe != null)
        {
            await OnSwipe.Invoke(direction);
        }
    }

    public async ValueTask DisposeAsync()
    {
        if (_handlerInstance != null)
        {
            await _handlerInstance.InvokeVoidAsync("dispose");
            await _handlerInstance.DisposeAsync();
        }

        if (_swipeModule != null)
        {
            await _swipeModule.DisposeAsync();
        }

        _dotNetRef.Dispose();
    }
}
