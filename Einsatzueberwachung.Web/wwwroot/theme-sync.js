/* ========================================
   THEME SYNC SYSTEM
   Synchronisiert Theme-ï¿½nderungen ï¿½ber alle Tabs/Fenster
   ======================================== */

(function () {
    'use strict';

    // Debug-Flag - setze auf false fÃ¼r Production
    const DEBUG = false;
    const log = DEBUG ? console.log.bind(console) : () => {};
    const warn = DEBUG ? console.warn.bind(console) : () => {};
    const error = console.error.bind(console); // Errors immer loggen

    log('Theme Sync System geladen');

    // Funktion zum Laden und Anwenden des Themes
    function loadAndApplyTheme() {
        try {
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme) {
                log('Theme aus localStorage geladen:', savedTheme);
                applyTheme(savedTheme);
            } else {
                // Versuche aus SessionData zu lesen (fÃ¼r Initial-Load)
                log('Kein Theme in localStorage, verwende light als Standard');
                applyTheme('light');
            }
        } catch (e) {
            error('Fehler beim Laden des Themes:', e);
            applyTheme('light');
        }
    }

    // Theme SOFORT beim Laden anwenden
    loadAndApplyTheme();

    // MutationObserver um sicherzustellen, dass Theme bleibt
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'attributes' && mutation.attributeName === 'data-bs-theme') {
                const currentTheme = document.documentElement.getAttribute('data-bs-theme');
                const savedTheme = localStorage.getItem('theme');
                
                // Wenn Theme nicht mit gespeichertem ï¿½bereinstimmt, korrigiere es
                if (savedTheme && currentTheme !== savedTheme) {
                    log('Theme-Drift erkannt, korrigiere:', savedTheme);
                    document.documentElement.setAttribute('data-bs-theme', savedTheme);
                }
            }
        });
    });

    // Beobachte das HTML-Element fï¿½r ï¿½nderungen
    observer.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ['data-bs-theme']
    });

    // LocalStorage Event Listener fï¿½r Theme-ï¿½nderungen
    // Wird ausgelï¿½st wenn ANDERE Tabs den Theme ï¿½ndern
    window.addEventListener('storage', function (e) {
        if (e.key === 'theme' && e.newValue !== null) {
            log('Theme-Ã„nderung erkannt von anderem Tab:', e.newValue);
            applyTheme(e.newValue);
        }
    });

    // Broadcast Channel API fï¿½r moderne Browser
    // Ermï¿½glicht direkte Kommunikation zwischen Tabs
    let themeChannel = null;
    
    if ('BroadcastChannel' in window) {
        try {
            themeChannel = new BroadcastChannel('theme-updates');
            log('BroadcastChannel fÃ¼r Theme-Updates erstellt');

            themeChannel.onmessage = function (event) {
                if (event.data && event.data.type === 'theme-changed') {
                    log('Theme-Update via BroadcastChannel empfangen:', event.data.theme);
                    applyTheme(event.data.theme);
                }
            };
        } catch (e) {
            warn('BroadcastChannel konnte nicht erstellt werden:', e);
        }
    }

    // Funktion zum Anwenden des Themes
    function applyTheme(theme) {
        if (theme === 'dark' || theme === 'light') {
            const currentTheme = document.documentElement.getAttribute('data-bs-theme');
            
            if (currentTheme !== theme) {
                log('Wende Theme an:', theme);
                document.documentElement.setAttribute('data-bs-theme', theme);
                
                // Trigger custom event fï¿½r Blazor-Komponenten
                window.dispatchEvent(new CustomEvent('theme-changed', {
                    detail: { theme: theme }
                }));
                
                // Visuelles Feedback
                showThemeChangeNotification(theme);
            }
        }
    }

    // Funktion zum Broadcasten von Theme-ï¿½nderungen
    window.broadcastThemeChange = function (theme) {
        log('Broadcasting Theme-Ã„nderung:', theme);
        
        // Speichere in LocalStorage (triggert storage event in anderen Tabs)
        localStorage.setItem('theme', theme);
        
        // Broadcast via BroadcastChannel falls verfÃ¼gbar
        if (themeChannel) {
            try {
                themeChannel.postMessage({
                    type: 'theme-changed',
                    theme: theme,
                    timestamp: Date.now()
                });
                log('Theme-Update via BroadcastChannel gesendet');
            } catch (e) {
                warn('Fehler beim BroadcastChannel-Versand:', e);
            }
        }
        
        // Wende Theme auch im aktuellen Tab an
        applyTheme(theme);
    };

    // Forciere Theme-Anwendung (fï¿½r Blazor-Navigation)
    window.forceApplyTheme = function() {
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            log('Force-Apply Theme:', savedTheme);
            applyTheme(savedTheme);
        }
    };

    // Visuelles Feedback fï¿½r Theme-Wechsel
    function showThemeChangeNotification(theme) {
        // Prï¿½fe ob bereits eine Notification existiert
        const existingNotif = document.getElementById('theme-change-notification');
        if (existingNotif) {
            existingNotif.remove();
        }

        const notif = document.createElement('div');
        notif.id = 'theme-change-notification';
        notif.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${theme === 'dark' ? '#2d2d2d' : '#ffffff'};
            color: ${theme === 'dark' ? '#e0e0e0' : '#000000'};
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 10000;
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
            animation: slideInRight 0.3s ease;
            border: 2px solid ${theme === 'dark' ? '#404040' : '#e0e0e0'};
        `;

        const icon = theme === 'dark' ? '??' : '??';
        const text = theme === 'dark' ? 'Dark Mode aktiviert' : 'Light Mode aktiviert';
        
        notif.innerHTML = `
            <span style="font-size: 20px;">${icon}</span>
            <span>${text}</span>
        `;

        document.body.appendChild(notif);

        // Entferne Notification nach 2 Sekunden
        setTimeout(() => {
            notif.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => notif.remove(), 300);
        }, 2000);
    }

    // CSS Animationen hinzufï¿½gen
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideInRight {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        @keyframes slideOutRight {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);

    // Cleanup beim Schlieï¿½en des Tabs
    window.addEventListener('beforeunload', function () {
        if (themeChannel) {
            themeChannel.close();
        }
    });

    // Bei Blazor-Navigationen (Enhanced Navigation)
    if ('Blazor' in window) {
        window.addEventListener('enhancednavigation', function() {
            log('Blazor Enhanced Navigation erkannt, force-apply theme');
            window.forceApplyTheme();
        });
    }

    // Periodischer Check (Fallback)
    setInterval(function() {
        const currentTheme = document.documentElement.getAttribute('data-bs-theme');
        const savedTheme = localStorage.getItem('theme');
        
        if (savedTheme && currentTheme !== savedTheme) {
            log('Periodic check: Theme-Drift korrigiert', savedTheme);
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        }
    }, 1000); // Jede Sekunde prï¿½fen

    log('Theme Sync System bereit');
})();
