// Tastenkürzel-System für Einsatzüberwachung
// Ermöglicht schnellen Zugriff auf häufig genutzte Funktionen

window.KeyboardShortcuts = {
    isEnabled: true,
    dotNetHelper: null,
    shortcuts: {},
    helpDialogVisible: false,
    
    // Initialisiert das Tastenkürzel-System mit Blazor-Referenz
    initialize: function(dotNetHelper) {
        this.dotNetHelper = dotNetHelper;
        this.isEnabled = true;
        
        // Registriere Event-Listener
        document.addEventListener('keydown', this.handleKeyDown.bind(this));
        
        // Standard-Shortcuts definieren
        this.shortcuts = {
            // F-Tasten
            'F1': { action: 'showHelp', description: 'Hilfe anzeigen', enabled: true },
            'F2': { action: 'addTeam', description: 'Neues Team hinzufügen', enabled: true },
            'F5': { action: 'refresh', description: 'Seite aktualisieren', enabled: true },
            
            // Navigation mit Ctrl
            'Ctrl+H': { action: 'navigateHome', description: 'Zur Startseite', enabled: true },
            'Ctrl+M': { action: 'navigateMap', description: 'Zur Karte', enabled: true },
            'Ctrl+B': { action: 'navigateReport', description: 'Zum Bericht', enabled: true },
            'Ctrl+E': { action: 'navigateMonitor', description: 'Zum Einsatzmonitor', enabled: true },
            'Ctrl+Shift+S': { action: 'navigateStammdaten', description: 'Zu Stammdaten', enabled: true },
            
            // Aktionen
            'Ctrl+N': { action: 'newNote', description: 'Neue Notiz/Funkspruch', enabled: true },
            'Ctrl+T': { action: 'addTeam', description: 'Neues Team', enabled: true },
            'Ctrl+P': { action: 'printPage', description: 'Seite drucken', enabled: true },
            
            // Escape für Dialoge
            'Escape': { action: 'closeDialog', description: 'Dialog schließen', enabled: true },
            
            // Theme Toggle
            'Ctrl+D': { action: 'toggleDarkMode', description: 'Dark Mode umschalten', enabled: true },
            
            // Quick-Hilfe
            'Ctrl+/': { action: 'showShortcuts', description: 'Tastenkürzel anzeigen', enabled: true },
            '?': { action: 'showShortcuts', description: 'Tastenkürzel anzeigen', enabled: true, requiresNoInput: true }
        };
        
        console.log('Tastenkürzel-System initialisiert');
        return true;
    },
    
    // Behandelt Tastendruck-Events
    handleKeyDown: function(event) {
        if (!this.isEnabled) return;
        
        // Ignoriere Eingaben in Textfeldern (außer Escape und bestimmte Kombinationen)
        const isInputField = ['INPUT', 'TEXTAREA', 'SELECT'].includes(event.target.tagName) ||
                           event.target.isContentEditable;
        
        // Erstelle Shortcut-Key
        let key = '';
        if (event.ctrlKey) key += 'Ctrl+';
        if (event.shiftKey) key += 'Shift+';
        if (event.altKey) key += 'Alt+';
        key += event.key === ' ' ? 'Space' : event.key;
        
        // Normalisiere Key (F-Tasten und Sonderzeichen)
        key = key.replace('Control+', 'Ctrl+');
        
        // Suche nach passendem Shortcut
        const shortcut = this.shortcuts[key];
        
        if (!shortcut || !shortcut.enabled) {
            return; // Kein passender Shortcut
        }
        
        // Prüfe ob requiresNoInput-Shortcut in Eingabefeld ausgelöst wurde
        if (shortcut.requiresNoInput && isInputField) {
            return;
        }
        
        // Sonderfall: Escape immer erlauben
        if (key !== 'Escape' && isInputField && !event.ctrlKey) {
            return;
        }
        
        // Verhindere Standard-Aktion für die meisten Shortcuts
        if (key !== 'F5') { // F5 für Browser-Refresh beibehalten
            event.preventDefault();
        }
        
        // Führe Aktion aus
        this.executeAction(shortcut.action);
    },
    
    // Führt eine Shortcut-Aktion aus
    executeAction: function(action) {
        console.log('Shortcut-Aktion:', action);
        
        // Zeige visuelles Feedback
        this.showActionFeedback(action);
        
        // Rufe Blazor auf falls verfügbar
        if (this.dotNetHelper) {
            this.dotNetHelper.invokeMethodAsync('HandleShortcut', action)
                .catch(err => console.warn('Shortcut-Handler nicht verfügbar:', err));
        }
        
        // Client-seitige Aktionen
        switch (action) {
            case 'showHelp':
            case 'showShortcuts':
                this.showShortcutsDialog();
                break;
            case 'refresh':
                location.reload();
                break;
            case 'printPage':
                window.print();
                break;
            case 'closeDialog':
                this.closeAllDialogs();
                break;
        }
    },
    
    // Zeigt visuelles Feedback für Shortcuts
    showActionFeedback: function(action) {
        const feedback = document.createElement('div');
        feedback.className = 'shortcut-feedback';
        feedback.textContent = this.getActionName(action);
        feedback.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px 20px;
            background: var(--bs-primary, #0d6efd);
            color: white;
            border-radius: 8px;
            font-weight: bold;
            z-index: 9999;
            animation: fadeInOut 1.5s ease-in-out forwards;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `;
        
        document.body.appendChild(feedback);
        setTimeout(() => feedback.remove(), 1500);
    },
    
    // Gibt lesbaren Aktionsnamen zurück
    getActionName: function(action) {
        const names = {
            'showHelp': '❓ Hilfe',
            'showShortcuts': '⌨️ Tastenkürzel',
            'addTeam': '👥 Neues Team',
            'refresh': '🔄 Aktualisieren',
            'navigateHome': '🏠 Startseite',
            'navigateMap': '🗺️ Karte',
            'navigateReport': '📄 Bericht',
            'navigateMonitor': '📊 Monitor',
            'navigateStammdaten': '📋 Stammdaten',
            'newNote': '📝 Neue Notiz',
            'printPage': '🖨️ Drucken',
            'closeDialog': '✖️ Dialog schließen',
            'toggleDarkMode': '🌓 Theme wechseln'
        };
        return names[action] || action;
    },
    
    // Zeigt Dialog mit allen Tastenkürzel
    showShortcutsDialog: function() {
        // Entferne existierenden Dialog
        const existing = document.getElementById('shortcuts-dialog');
        if (existing) {
            existing.remove();
            this.helpDialogVisible = false;
            return;
        }
        
        this.helpDialogVisible = true;
        
        // Erstelle Dialog
        const dialog = document.createElement('div');
        dialog.id = 'shortcuts-dialog';
        dialog.style.cssText = `
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: var(--bs-body-bg, white);
            color: var(--bs-body-color, black);
            border: 1px solid var(--bs-border-color, #dee2e6);
            border-radius: 12px;
            padding: 24px;
            z-index: 10000;
            max-width: 600px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        `;
        
        let html = `
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h4 style="margin: 0;"><i class="bi bi-keyboard"></i> Tastenkürzel</h4>
                <button onclick="document.getElementById('shortcuts-dialog').remove()" 
                        style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: inherit;">
                    ×
                </button>
            </div>
            <div style="display: grid; gap: 8px;">
        `;
        
        // Gruppiere Shortcuts
        const groups = {
            'Navigation': ['Ctrl+H', 'Ctrl+M', 'Ctrl+B', 'Ctrl+E', 'Ctrl+Shift+S'],
            'Aktionen': ['F2', 'Ctrl+T', 'Ctrl+N', 'Ctrl+P'],
            'Allgemein': ['F1', 'Ctrl+/', '?', 'F5', 'Ctrl+D', 'Escape']
        };
        
        for (const [group, keys] of Object.entries(groups)) {
            html += `<h6 style="margin: 15px 0 8px; color: var(--bs-primary, #0d6efd);">${group}</h6>`;
            for (const key of keys) {
                const shortcut = this.shortcuts[key];
                if (shortcut) {
                    html += `
                        <div style="display: flex; justify-content: space-between; padding: 8px; 
                                    background: var(--bs-tertiary-bg, #f8f9fa); border-radius: 6px;">
                            <kbd style="background: var(--bs-secondary-bg, #e9ecef); padding: 4px 8px; 
                                       border-radius: 4px; font-family: monospace;">${key}</kbd>
                            <span>${shortcut.description}</span>
                        </div>
                    `;
                }
            }
        }
        
        html += `
            </div>
            <div style="margin-top: 20px; text-align: center; color: var(--bs-secondary-color, #6c757d); font-size: 0.85rem;">
                Drücken Sie <kbd>Escape</kbd> oder klicken Sie außerhalb um zu schließen
            </div>
        `;
        
        dialog.innerHTML = html;
        
        // Overlay
        const overlay = document.createElement('div');
        overlay.id = 'shortcuts-overlay';
        overlay.style.cssText = `
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
        `;
        overlay.onclick = () => {
            document.getElementById('shortcuts-dialog')?.remove();
            overlay.remove();
            this.helpDialogVisible = false;
        };
        
        document.body.appendChild(overlay);
        document.body.appendChild(dialog);
    },
    
    // Schließt alle offenen Dialoge
    closeAllDialogs: function() {
        // Schließe Shortcuts-Dialog
        document.getElementById('shortcuts-dialog')?.remove();
        document.getElementById('shortcuts-overlay')?.remove();
        this.helpDialogVisible = false;
        
        // Schließe Bootstrap Modals
        const modals = document.querySelectorAll('.modal.show');
        modals.forEach(modal => {
            const bsModal = bootstrap.Modal.getInstance(modal);
            if (bsModal) bsModal.hide();
        });
        
        // Klicke auf Modal-Close-Buttons
        document.querySelectorAll('[data-bs-dismiss="modal"]').forEach(btn => {
            btn.click();
        });
    },
    
    // Aktiviert/Deaktiviert das System
    setEnabled: function(enabled) {
        this.isEnabled = enabled;
        console.log('Tastenkürzel:', enabled ? 'aktiviert' : 'deaktiviert');
    },
    
    // Entfernt Event-Listener
    dispose: function() {
        document.removeEventListener('keydown', this.handleKeyDown);
        document.getElementById('shortcuts-dialog')?.remove();
        document.getElementById('shortcuts-overlay')?.remove();
        this.dotNetHelper = null;
    }
};

// CSS für Animation hinzufügen
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeInOut {
        0% { opacity: 0; transform: translateY(20px); }
        20% { opacity: 1; transform: translateY(0); }
        80% { opacity: 1; transform: translateY(0); }
        100% { opacity: 0; transform: translateY(-20px); }
    }
    
    kbd {
        background: var(--bs-secondary-bg, #e9ecef);
        padding: 2px 6px;
        border-radius: 4px;
        font-family: 'Consolas', 'Monaco', monospace;
        font-size: 0.85em;
        border: 1px solid var(--bs-border-color, #dee2e6);
    }
    
    .shortcut-feedback {
        pointer-events: none;
    }
`;
document.head.appendChild(style);
