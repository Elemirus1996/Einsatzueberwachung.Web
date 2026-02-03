// Swipe-Gesten Utility für Touch-Interaktionen
// Unterstützt Links/Rechts-Swipe für Aktionen

class SwipeHandler {
    constructor(element, options = {}) {
        this.element = element;
        this.options = {
            threshold: options.threshold || 50, // Minimale Swipe-Distanz in px
            allowedTime: options.allowedTime || 300, // Maximale Zeit für Swipe in ms
            restraint: options.restraint || 100, // Maximale vertikale Abweichung
            onSwipeLeft: options.onSwipeLeft || null,
            onSwipeRight: options.onSwipeRight || null,
            onSwipeUp: options.onSwipeUp || null,
            onSwipeDown: options.onSwipeDown || null
        };

        this.touchStartX = 0;
        this.touchStartY = 0;
        this.touchStartTime = 0;
        this.touchEndX = 0;
        this.touchEndY = 0;

        this.init();
    }

    init() {
        this.element.addEventListener('touchstart', (e) => this.handleTouchStart(e), { passive: true });
        this.element.addEventListener('touchend', (e) => this.handleTouchEnd(e), { passive: false });
    }

    handleTouchStart(e) {
        const touch = e.changedTouches[0];
        this.touchStartX = touch.pageX;
        this.touchStartY = touch.pageY;
        this.touchStartTime = Date.now();
    }

    handleTouchEnd(e) {
        const touch = e.changedTouches[0];
        this.touchEndX = touch.pageX;
        this.touchEndY = touch.pageY;
        
        this.handleSwipe();
    }

    handleSwipe() {
        const elapsedTime = Date.now() - this.touchStartTime;
        
        // Prüfe ob Swipe innerhalb erlaubter Zeit
        if (elapsedTime > this.options.allowedTime) {
            return;
        }

        const distX = this.touchEndX - this.touchStartX;
        const distY = this.touchEndY - this.touchStartY;
        const absDistX = Math.abs(distX);
        const absDistY = Math.abs(distY);

        // Horizontale Swipes
        if (absDistX >= this.options.threshold && absDistY <= this.options.restraint) {
            if (distX < 0) {
                // Swipe Left
                if (this.options.onSwipeLeft) {
                    this.options.onSwipeLeft(this.element);
                }
            } else {
                // Swipe Right
                if (this.options.onSwipeRight) {
                    this.options.onSwipeRight(this.element);
                }
            }
        }
        
        // Vertikale Swipes
        else if (absDistY >= this.options.threshold && absDistX <= this.options.restraint) {
            if (distY < 0) {
                // Swipe Up
                if (this.options.onSwipeUp) {
                    this.options.onSwipeUp(this.element);
                }
            } else {
                // Swipe Down
                if (this.options.onSwipeDown) {
                    this.options.onSwipeDown(this.element);
                }
            }
        }
    }

    destroy() {
        this.element.removeEventListener('touchstart', this.handleTouchStart);
        this.element.removeEventListener('touchend', this.handleTouchEnd);
    }
}

// Blazor-Interop für Swipe-Gesten
window.initSwipeHandler = function(elementId, dotNetRef, methodName) {
    const element = document.getElementById(elementId);
    if (!element) {
        console.error('Element nicht gefunden:', elementId);
        return null;
    }

    const handler = new SwipeHandler(element, {
        threshold: 50,
        allowedTime: 300,
        onSwipeLeft: () => {
            dotNetRef.invokeMethodAsync(methodName, 'left');
        },
        onSwipeRight: () => {
            dotNetRef.invokeMethodAsync(methodName, 'right');
        }
    });

    return {
        dispose: () => handler.destroy()
    };
};

// CSS für Swipe-Feedback
const swipeStyles = `
.swipe-container {
    position: relative;
    overflow: hidden;
    touch-action: pan-y;
}

.swipe-item {
    position: relative;
    transition: transform 0.3s ease-out;
    will-change: transform;
}

.swipe-item.swiping {
    transition: none;
}

.swipe-actions {
    position: absolute;
    top: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    padding: 0 1rem;
}

.swipe-actions.left {
    right: 0;
    background: #dc3545;
    color: white;
}

.swipe-actions.right {
    left: 0;
    background: #28a745;
    color: white;
}

.swipe-icon {
    font-size: 1.5rem;
}
`;

// Styles einfügen
if (!document.getElementById('swipe-styles')) {
    const styleElement = document.createElement('style');
    styleElement.id = 'swipe-styles';
    styleElement.textContent = swipeStyles;
    document.head.appendChild(styleElement);
}
