// Audio-Warnungs-System für Timer-Alerts
// Spielt akustische Warnungen bei kritischen Team-Timern ab
// V3.10 - Jetzt mit konfigurierbaren Einstellungen

window.AudioAlerts = {
    audioContext: null,
    isEnabled: true,
    volume: 0.7, // 0-1
    repeatInterval: null,
    settings: {
        soundAlertsEnabled: true,
        soundVolume: 70,
        firstWarningSound: 'beep',
        secondWarningSound: 'alarm',
        firstWarningFrequency: 800,
        secondWarningFrequency: 1200,
        repeatSecondWarning: true,
        repeatWarningIntervalSeconds: 30
    },
    
    // Initialisiert das Audio-System
    initialize: function() {
        try {
            // AudioContext nur bei Bedarf erstellen (wegen Browser-Policies)
            if (!this.audioContext) {
                const AudioContext = window.AudioContext || window.webkitAudioContext;
                this.audioContext = new AudioContext();
            }
            return true;
        } catch (error) {
            console.error('Fehler beim Initialisieren des Audio-Systems:', error);
            return false;
        }
    },
    
    // Aktualisiert die Einstellungen
    updateSettings: function(settings) {
        if (settings) {
            this.settings = { ...this.settings, ...settings };
            this.isEnabled = settings.soundAlertsEnabled !== false;
            this.volume = (settings.soundVolume || 70) / 100;
            console.log('Audio-Einstellungen aktualisiert:', this.settings);
        }
        return true;
    },
    
    // Aktiviert/Deaktiviert Sounds
    setEnabled: function(enabled) {
        this.isEnabled = enabled;
        if (!enabled) {
            this.stopRepeat();
        }
        console.log('Sound-Alerts:', enabled ? 'aktiviert' : 'deaktiviert');
        return true;
    },
    
    // Setzt die Lautstärke (0-100)
    setVolume: function(volumePercent) {
        this.volume = Math.max(0, Math.min(100, volumePercent)) / 100;
        console.log('Lautstärke gesetzt auf:', this.volume * 100, '%');
        return true;
    },
    
    // Spielt einen Warn-Ton ab (Frequenz-basiert, keine Datei nötig)
    playWarningBeep: function(duration = 300, frequency = 800, type = 'sine') {
        if (!this.isEnabled) return false;
        
        try {
            if (!this.audioContext) {
                this.initialize();
            }
            
            if (this.audioContext.state === 'suspended') {
                this.audioContext.resume();
            }
            
            const oscillator = this.audioContext.createOscillator();
            const gainNode = this.audioContext.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(this.audioContext.destination);
            
            oscillator.frequency.value = frequency;
            oscillator.type = type; // sine, square, sawtooth, triangle
            
            // Lautstärke mit Fade-out
            gainNode.gain.setValueAtTime(this.volume * 0.5, this.audioContext.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + duration / 1000);
            
            oscillator.start(this.audioContext.currentTime);
            oscillator.stop(this.audioContext.currentTime + duration / 1000);
            
            return true;
        } catch (error) {
            console.error('Fehler beim Abspielen des Warn-Tons:', error);
            return false;
        }
    },
    
    // Spielt einen Glocken-Sound ab
    playBell: function(frequency = 800) {
        if (!this.isEnabled) return false;
        
        try {
            if (!this.audioContext) this.initialize();
            if (this.audioContext.state === 'suspended') this.audioContext.resume();
            
            const oscillator = this.audioContext.createOscillator();
            const gainNode = this.audioContext.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(this.audioContext.destination);
            
            oscillator.frequency.value = frequency;
            oscillator.type = 'sine';
            
            // Bell-ähnlicher Klang mit schnellem Attack und langem Decay
            const now = this.audioContext.currentTime;
            gainNode.gain.setValueAtTime(0, now);
            gainNode.gain.linearRampToValueAtTime(this.volume * 0.4, now + 0.01);
            gainNode.gain.exponentialRampToValueAtTime(0.01, now + 1.5);
            
            oscillator.start(now);
            oscillator.stop(now + 1.5);
            
            return true;
        } catch (error) {
            console.error('Fehler beim Abspielen des Glocken-Sounds:', error);
            return false;
        }
    },
    
    // Spielt einen Alarm-Sound ab (mehrere Töne in schneller Folge)
    playAlarm: function(frequency = 1200) {
        if (!this.isEnabled) return false;
        
        const playOne = (delay, freq) => {
            setTimeout(() => this.playWarningBeep(150, freq, 'square'), delay);
        };
        
        // Wechselnde Frequenzen für Sirenen-Effekt
        playOne(0, frequency);
        playOne(200, frequency * 0.8);
        playOne(400, frequency);
        playOne(600, frequency * 0.8);
        
        return true;
    },
    
    // Spielt den konfigurierten Sound ab
    playSound: function(soundType, frequency = 800) {
        switch (soundType) {
            case 'bell':
                return this.playBell(frequency);
            case 'alarm':
                return this.playAlarm(frequency);
            case 'beep':
            default:
                return this.playWarningBeep(400, frequency);
        }
    },
    
    // Spielt eine erste Warnung ab (einzelner Ton)
    playFirstWarning: function() {
        if (!this.isEnabled) return false;
        
        const { firstWarningSound, firstWarningFrequency } = this.settings;
        this.playSound(firstWarningSound, firstWarningFrequency);
        
        // Visuelles Feedback
        this.showVisualAlert('⚠️ Erste Warnung', 'warning');
        
        return true;
    },
    
    // Spielt eine kritische Warnung ab (drei kurze Töne)
    playSecondWarning: function() {
        if (!this.isEnabled) return false;
        
        const { secondWarningSound, secondWarningFrequency, repeatSecondWarning, repeatWarningIntervalSeconds } = this.settings;
        
        // Initial-Sound
        this.playSound(secondWarningSound, secondWarningFrequency);
        
        // Visuelles Feedback
        this.showVisualAlert('🚨 KRITISCHE WARNUNG!', 'danger');
        
        // Wiederholung aktivieren falls konfiguriert
        if (repeatSecondWarning && !this.repeatInterval) {
            this.repeatInterval = setInterval(() => {
                if (this.isEnabled) {
                    this.playSound(secondWarningSound, secondWarningFrequency);
                    this.showVisualAlert('🚨 KRITISCHE WARNUNG!', 'danger');
                }
            }, repeatWarningIntervalSeconds * 1000);
        }
        
        return true;
    },
    
    // Stoppt wiederholende Warnungen
    stopRepeat: function() {
        if (this.repeatInterval) {
            clearInterval(this.repeatInterval);
            this.repeatInterval = null;
            console.log('Wiederholung der Warnung gestoppt');
        }
        return true;
    },
    
    // Zeigt visuelles Alert
    showVisualAlert: function(message, type = 'warning') {
        // Entferne existierendes Alert
        document.getElementById('audio-visual-alert')?.remove();
        
        const alert = document.createElement('div');
        alert.id = 'audio-visual-alert';
        alert.className = `alert alert-${type} audio-visual-alert`;
        alert.innerHTML = `
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <span style="font-weight: bold; font-size: 1.2rem;">${message}</span>
                <button type="button" class="btn-close" onclick="this.parentElement.parentElement.remove(); AudioAlerts.stopRepeat();"></button>
            </div>
        `;
        alert.style.cssText = `
            position: fixed;
            top: 70px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            animation: slideInRight 0.3s ease-out, pulse 1s ease-in-out infinite;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        `;
        
        document.body.appendChild(alert);
        
        // Auto-Entfernen nach 10 Sekunden (wenn nicht kritisch)
        if (type !== 'danger') {
            setTimeout(() => alert.remove(), 10000);
        }
    },
    
    // Test-Funktion für Debug-Zwecke
    test: function(soundType = 'beep') {
        console.log('Test: Spiele', soundType, 'Sound ab');
        this.playSound(soundType, 880);
        return true;
    },
    
    // Test alle Sound-Typen
    testAll: function() {
        console.log('Teste alle Sound-Typen...');
        this.test('beep');
        setTimeout(() => this.test('bell'), 1000);
        setTimeout(() => this.test('alarm'), 2500);
        return true;
    }
};

// CSS für Animationen hinzufügen
const audioAlertStyles = document.createElement('style');
audioAlertStyles.textContent = `
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.02); }
    }
    
    .audio-visual-alert {
        border-left: 5px solid;
    }
    
    .audio-visual-alert.alert-warning {
        border-left-color: #ffc107;
    }
    
    .audio-visual-alert.alert-danger {
        border-left-color: #dc3545;
    }
`;
document.head.appendChild(audioAlertStyles);

// Auto-Initialisierung bei User-Interaktion (Browser-Policy)
document.addEventListener('click', function initOnFirstClick() {
    window.AudioAlerts.initialize();
    document.removeEventListener('click', initOnFirstClick);
}, { once: true });
