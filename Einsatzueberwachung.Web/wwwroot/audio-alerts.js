// Audio-Warnungs-System für Timer-Alerts
// Spielt akustische Warnungen bei kritischen Team-Timern ab

window.AudioAlerts = {
    audioContext: null,
    
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
    
    // Spielt einen Warn-Ton ab (Frequenz-basiert, keine Datei nötig)
    playWarningBeep: function(duration = 300, frequency = 800) {
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
            oscillator.type = 'sine';
            
            gainNode.gain.setValueAtTime(0.3, this.audioContext.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + duration / 1000);
            
            oscillator.start(this.audioContext.currentTime);
            oscillator.stop(this.audioContext.currentTime + duration / 1000);
            
            return true;
        } catch (error) {
            console.error('Fehler beim Abspielen des Warn-Tons:', error);
            return false;
        }
    },
    
    // Spielt eine erste Warnung ab (einzelner Ton)
    playFirstWarning: function() {
        this.playWarningBeep(400, 1000);
        return true;
    },
    
    // Spielt eine kritische Warnung ab (drei kurze Töne)
    playSecondWarning: function() {
        this.playWarningBeep(200, 1200);
        setTimeout(() => this.playWarningBeep(200, 1200), 300);
        setTimeout(() => this.playWarningBeep(200, 1200), 600);
        return true;
    },
    
    // Test-Funktion für Debug-Zwecke
    test: function() {
        console.log('Test: Spiele Warn-Ton ab');
        this.playWarningBeep(500, 880);
    }
};

// Auto-Initialisierung bei User-Interaktion (Browser-Policy)
document.addEventListener('click', function initOnFirstClick() {
    window.AudioAlerts.initialize();
    document.removeEventListener('click', initOnFirstClick);
}, { once: true });
