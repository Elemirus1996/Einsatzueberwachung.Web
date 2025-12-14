/* ========================================
   THEME SYNC SYSTEM
   Synchronisiert Theme-Änderungen über alle Tabs/Fenster
   ======================================== */

(function () {
    'use strict';

    console.log('Theme Sync System geladen');

    // Funktion zum Laden und Anwenden des Themes
    function loadAndApplyTheme() {
        try {
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme) {
                console.log('Theme aus localStorage geladen:', savedTheme);
                applyTheme(savedTheme);
            } else {
                // Versuche aus SessionData zu lesen (für Initial-Load)
                console.log('Kein Theme in localStorage, verwende light als Standard');
                applyTheme('light');
            }
        } catch (e) {
            console.error('Fehler beim Laden des Themes:', e);
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
                
                // Wenn Theme nicht mit gespeichertem übereinstimmt, korrigiere es
                if (savedTheme && currentTheme !== savedTheme) {
                    console.log('Theme-Drift erkannt, korrigiere:', savedTheme);
                    document.documentElement.setAttribute('data-bs-theme', savedTheme);
                }
            }
        });
    });

    // Beobachte das HTML-Element für Änderungen
    observer.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ['data-bs-theme']
    });

    // LocalStorage Event Listener für Theme-Änderungen
    // Wird ausgelöst wenn ANDERE Tabs den Theme ändern
    window.addEventListener('storage', function (e) {
        if (e.key === 'theme' && e.newValue !== null) {
            console.log('Theme-Änderung erkannt von anderem Tab:', e.newValue);
            applyTheme(e.newValue);
        }
    });

    // Broadcast Channel API für moderne Browser
    // Ermöglicht direkte Kommunikation zwischen Tabs
    let themeChannel = null;
    
    if ('BroadcastChannel' in window) {
        try {
            themeChannel = new BroadcastChannel('theme-updates');
            console.log('BroadcastChannel für Theme-Updates erstellt');

            themeChannel.onmessage = function (event) {
                if (event.data && event.data.type === 'theme-changed') {
                    console.log('Theme-Update via BroadcastChannel empfangen:', event.data.theme);
                    applyTheme(event.data.theme);
                }
            };
        } catch (e) {
            console.warn('BroadcastChannel konnte nicht erstellt werden:', e);
        }
    }

    // Funktion zum Anwenden des Themes
    function applyTheme(theme) {
        if (theme === 'dark' || theme === 'light') {
            const currentTheme = document.documentElement.getAttribute('data-bs-theme');
            
            if (currentTheme !== theme) {
                console.log('Wende Theme an:', theme);
                document.documentElement.setAttribute('data-bs-theme', theme);
                
                // Trigger custom event für Blazor-Komponenten
                window.dispatchEvent(new CustomEvent('theme-changed', {
                    detail: { theme: theme }
                }));
                
                // Visuelles Feedback
                showThemeChangeNotification(theme);
            }
        }
    }

    // Funktion zum Broadcasten von Theme-Änderungen
    window.broadcastThemeChange = function (theme) {
        console.log('Broadcasting Theme-Änderung:', theme);
        
        // Speichere in LocalStorage (triggert storage event in anderen Tabs)
        localStorage.setItem('theme', theme);
        
        // Broadcast via BroadcastChannel falls verfügbar
        if (themeChannel) {
            try {
                themeChannel.postMessage({
                    type: 'theme-changed',
                    theme: theme,
                    timestamp: Date.now()
                });
                console.log('Theme-Update via BroadcastChannel gesendet');
            } catch (e) {
                console.warn('Fehler beim BroadcastChannel-Versand:', e);
            }
        }
        
        // Wende Theme auch im aktuellen Tab an
        applyTheme(theme);
    };

    // Forciere Theme-Anwendung (für Blazor-Navigation)
    window.forceApplyTheme = function() {
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            console.log('Force-Apply Theme:', savedTheme);
            applyTheme(savedTheme);
        }
    };

    // Visuelles Feedback für Theme-Wechsel
    function showThemeChangeNotification(theme) {
        // Prüfe ob bereits eine Notification existiert
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

    // CSS Animationen hinzufügen
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

    // Cleanup beim Schließen des Tabs
    window.addEventListener('beforeunload', function () {
        if (themeChannel) {
            themeChannel.close();
        }
    });

    // Bei Blazor-Navigationen (Enhanced Navigation)
    if ('Blazor' in window) {
        window.addEventListener('enhancednavigation', function() {
            console.log('Blazor Enhanced Navigation erkannt, force-apply theme');
            window.forceApplyTheme();
        });
    }

    // Periodischer Check (Fallback)
    setInterval(function() {
        const currentTheme = document.documentElement.getAttribute('data-bs-theme');
        const savedTheme = localStorage.getItem('theme');
        
        if (savedTheme && currentTheme !== savedTheme) {
            console.log('Periodic check: Theme-Drift korrigiert', savedTheme);
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        }
    }, 1000); // Jede Sekunde prüfen

    console.log('Theme Sync System bereit');
})();
