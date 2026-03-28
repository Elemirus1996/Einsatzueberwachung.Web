// Multi-Monitor Support System für Einsatzüberwachung
// Ermöglicht das Öffnen von Ansichten in separaten Fenstern für mehrere Bildschirme

window.MultiMonitor = {
    openWindows: {},
    windowFeatures: {
        teams: 'width=800,height=900,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes',
        map: 'width=1200,height=900,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes',
        notes: 'width=500,height=800,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes',
        fullscreen: 'menubar=no,toolbar=no,location=no,status=no,scrollbars=yes'
    },
    
    // Öffnet eine View in einem neuen Fenster
    openInNewWindow: function(viewType, url) {
        const features = this.windowFeatures[viewType] || this.windowFeatures.fullscreen;
        const windowName = `einsatz_${viewType}`;
        
        // Prüfe ob Fenster bereits offen ist
        if (this.openWindows[windowName] && !this.openWindows[windowName].closed) {
            // Fenster existiert - fokussiere es
            this.openWindows[windowName].focus();
            return { success: true, action: 'focused', windowName: windowName };
        }
        
        // Neues Fenster öffnen
        try {
            const newWindow = window.open(url, windowName, features);
            
            if (newWindow) {
                this.openWindows[windowName] = newWindow;
                
                // Event-Listener für Fenster-Schließung
                newWindow.addEventListener('beforeunload', () => {
                    delete this.openWindows[windowName];
                });
                
                // Sende Theme an neues Fenster
                newWindow.addEventListener('load', () => {
                    const currentTheme = document.documentElement.getAttribute('data-bs-theme');
                    if (newWindow.document && newWindow.document.documentElement) {
                        newWindow.document.documentElement.setAttribute('data-bs-theme', currentTheme);
                    }
                });
                
                this.showNotification(`${this.getViewName(viewType)} in neuem Fenster geöffnet`, 'success');
                return { success: true, action: 'opened', windowName: windowName };
            } else {
                this.showNotification('Popup wurde blockiert. Bitte erlauben Sie Popups für diese Seite.', 'warning');
                return { success: false, error: 'popup_blocked' };
            }
        } catch (error) {
            console.error('Fehler beim Öffnen des Fensters:', error);
            return { success: false, error: error.message };
        }
    },
    
    // Öffnet Vollbild-View
    openFullscreen: function(viewType, url) {
        const windowName = `einsatz_${viewType}_fullscreen`;
        
        try {
            const newWindow = window.open(url, windowName, 'fullscreen=yes');
            
            if (newWindow) {
                this.openWindows[windowName] = newWindow;
                
                // Versuche in Vollbild zu wechseln
                newWindow.addEventListener('load', () => {
                    if (newWindow.document.documentElement.requestFullscreen) {
                        newWindow.document.documentElement.requestFullscreen().catch(() => {});
                    }
                    
                    // Theme synchronisieren
                    const currentTheme = document.documentElement.getAttribute('data-bs-theme');
                    newWindow.document.documentElement.setAttribute('data-bs-theme', currentTheme);
                });
                
                return { success: true, action: 'opened_fullscreen' };
            }
            
            return { success: false, error: 'popup_blocked' };
        } catch (error) {
            return { success: false, error: error.message };
        }
    },
    
    // Schließt ein geöffnetes Fenster
    closeWindow: function(viewType) {
        const windowName = `einsatz_${viewType}`;
        
        if (this.openWindows[windowName] && !this.openWindows[windowName].closed) {
            this.openWindows[windowName].close();
            delete this.openWindows[windowName];
            return true;
        }
        
        return false;
    },
    
    // Schließt alle geöffneten Fenster
    closeAllWindows: function() {
        for (const [name, win] of Object.entries(this.openWindows)) {
            if (win && !win.closed) {
                win.close();
            }
        }
        this.openWindows = {};
        return true;
    },
    
    // Prüft ob ein Fenster offen ist
    isWindowOpen: function(viewType) {
        const windowName = `einsatz_${viewType}`;
        return this.openWindows[windowName] && !this.openWindows[windowName].closed;
    },
    
    // Gibt die Anzahl offener Fenster zurück
    getOpenWindowCount: function() {
        return Object.values(this.openWindows).filter(w => w && !w.closed).length;
    },
    
    // Sendet eine Nachricht an alle offenen Fenster
    broadcastToWindows: function(message) {
        for (const [name, win] of Object.entries(this.openWindows)) {
            if (win && !win.closed) {
                try {
                    win.postMessage(message, '*');
                } catch (e) {
                    console.warn(`Konnte nicht an ${name} senden:`, e);
                }
            }
        }
    },
    
    // Helper: View-Name für Anzeige
    getViewName: function(viewType) {
        const names = {
            'teams': 'Team-Übersicht',
            'map': 'Einsatzkarte',
            'notes': 'Funksprüche',
            'monitor': 'Einsatzmonitor',
            'dashboard': 'Dashboard'
        };
        return names[viewType] || viewType;
    },
    
    // Zeigt Benachrichtigung
    showNotification: function(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} multi-monitor-notification`;
        notification.innerHTML = `
            <i class="bi bi-${type === 'success' ? 'check-circle' : type === 'warning' ? 'exclamation-triangle' : 'info-circle'}-fill"></i>
            ${message}
        `;
        notification.style.cssText = `
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            animation: slideUp 0.3s ease-out;
        `;
        
        document.body.appendChild(notification);
        setTimeout(() => notification.remove(), 3000);
    },
    
    // Arrangiert Fenster auf mehreren Monitoren
    arrangeWindows: function(layout = 'side-by-side') {
        const width = window.screen.availWidth;
        const height = window.screen.availHeight;
        
        const windows = Object.values(this.openWindows).filter(w => w && !w.closed);
        
        if (layout === 'side-by-side' && windows.length > 0) {
            const windowWidth = Math.floor(width / windows.length);
            
            windows.forEach((win, index) => {
                win.moveTo(index * windowWidth, 0);
                win.resizeTo(windowWidth, height);
            });
        }
        
        return windows.length;
    }
};

// CSS für Animationen
const multiMonitorStyles = document.createElement('style');
multiMonitorStyles.textContent = `
    @keyframes slideUp {
        from { transform: translateX(-50%) translateY(100%); opacity: 0; }
        to { transform: translateX(-50%) translateY(0); opacity: 1; }
    }
    
    .multi-monitor-notification {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
    }
    
    .popout-btn {
        opacity: 0.7;
        transition: opacity 0.2s, transform 0.2s;
    }
    
    .popout-btn:hover {
        opacity: 1;
        transform: scale(1.1);
    }
`;
document.head.appendChild(multiMonitorStyles);

// Beim Beenden alle Fenster schließen
window.addEventListener('beforeunload', () => {
    MultiMonitor.closeAllWindows();
});
