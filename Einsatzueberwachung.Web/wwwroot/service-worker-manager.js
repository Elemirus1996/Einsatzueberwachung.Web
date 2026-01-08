// Service Worker Registration und Management
// Handhabt Installation, Updates und Offline-Status

const DEBUG = false;

class ServiceWorkerManager {
    constructor() {
        this.registration = null;
        this.isOnline = navigator.onLine;
        this.updateAvailable = false;
        
        this.init();
    }

    async init() {
        // Prüfe Browser-Support
        if (!('serviceWorker' in navigator)) {
            console.warn('Service Worker wird nicht unterstützt');
            return;
        }

        try {
            // Registriere Service Worker
            this.registration = await navigator.serviceWorker.register('/service-worker.js', {
                scope: '/'
            });

            if (DEBUG) console.log('Service Worker registriert:', this.registration.scope);

            // Prüfe auf Updates
            this.registration.addEventListener('updatefound', () => {
                this.handleUpdate();
            });

            // Online/Offline Status
            window.addEventListener('online', () => this.handleOnline());
            window.addEventListener('offline', () => this.handleOffline());

            // Zeige aktuellen Status
            this.updateOnlineStatus();

        } catch (error) {
            console.error('Service Worker Registrierung fehlgeschlagen:', error);
        }
    }

    handleUpdate() {
        const installingWorker = this.registration.installing;

        if (!installingWorker) return;

        installingWorker.addEventListener('statechange', () => {
            if (installingWorker.state === 'installed') {
                if (navigator.serviceWorker.controller) {
                    // Update verfügbar
                    this.updateAvailable = true;
                    this.showUpdateNotification();
                } else {
                    // Erste Installation
                    if (DEBUG) console.log('Service Worker installiert (erste Installation)');
                }
            }
        });
    }

    showUpdateNotification() {
        // Zeige Benachrichtigung über verfügbares Update
        const message = 'Neue Version verfügbar! Seite neu laden?';
        
        if (confirm(message)) {
            this.applyUpdate();
        } else {
            // Zeige Button zum späteren Update
            this.showUpdateButton();
        }
    }

    showUpdateButton() {
        let updateBtn = document.getElementById('sw-update-btn');
        
        if (!updateBtn) {
            updateBtn = document.createElement('button');
            updateBtn.id = 'sw-update-btn';
            updateBtn.className = 'btn btn-warning position-fixed';
            updateBtn.style.cssText = 'bottom: 20px; right: 20px; z-index: 9999;';
            updateBtn.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Update verfügbar';
            updateBtn.onclick = () => this.applyUpdate();
            document.body.appendChild(updateBtn);
        }
    }

    async applyUpdate() {
        if (!this.registration || !this.registration.waiting) return;

        // Aktiviere neuen Service Worker
        this.registration.waiting.postMessage({ type: 'SKIP_WAITING' });

        // Reload nach Aktivierung
        navigator.serviceWorker.addEventListener('controllerchange', () => {
            window.location.reload();
        });
    }

    handleOnline() {
        this.isOnline = true;
        this.updateOnlineStatus();
        
        if (DEBUG) console.log('Online-Modus');

        // Versuche Sync
        if (this.registration && 'sync' in this.registration) {
            this.registration.sync.register('sync-notes').catch(err => {
                console.error('Background Sync fehlgeschlagen:', err);
            });
        }
    }

    handleOffline() {
        this.isOnline = false;
        this.updateOnlineStatus();
        
        if (DEBUG) console.log('Offline-Modus');
    }

    updateOnlineStatus() {
        // Zeige Offline-Indicator
        let indicator = document.getElementById('offline-indicator');

        if (!this.isOnline) {
            if (!indicator) {
                indicator = document.createElement('div');
                indicator.id = 'offline-indicator';
                indicator.className = 'alert alert-warning position-fixed';
                indicator.style.cssText = 'top: 20px; right: 20px; z-index: 9999; margin: 0;';
                indicator.innerHTML = `
                    <i class="bi bi-wifi-off"></i> Offline-Modus
                    <small class="d-block">Änderungen werden später synchronisiert</small>
                `;
                document.body.appendChild(indicator);
            }
        } else {
            if (indicator) {
                indicator.remove();
            }
        }
    }

    // Cache-Verwaltung
    async clearCache() {
        if (!('caches' in window)) return;

        try {
            const cacheNames = await caches.keys();
            await Promise.all(cacheNames.map(name => caches.delete(name)));
            
            if (DEBUG) console.log('Cache geleert');
        } catch (error) {
            console.error('Cache löschen fehlgeschlagen:', error);
        }
    }

    async getCacheSize() {
        if (!('caches' in window)) return 0;

        try {
            const cacheNames = await caches.keys();
            let totalSize = 0;

            for (const name of cacheNames) {
                const cache = await caches.open(name);
                const requests = await cache.keys();

                for (const request of requests) {
                    const response = await cache.match(request);
                    if (response) {
                        const blob = await response.blob();
                        totalSize += blob.size;
                    }
                }
            }

            return totalSize;
        } catch (error) {
            console.error('Cache-Größe ermitteln fehlgeschlagen:', error);
            return 0;
        }
    }

    async unregister() {
        if (!this.registration) return;

        try {
            await this.registration.unregister();
            await this.clearCache();
            
            if (DEBUG) console.log('Service Worker deregistriert');
        } catch (error) {
            console.error('Service Worker deregistrierung fehlgeschlagen:', error);
        }
    }
}

// Initialisiere Service Worker Manager
const swManager = new ServiceWorkerManager();

// Exportiere für globalen Zugriff
window.swManager = swManager;

// Blazor Interop
window.getServiceWorkerStatus = function() {
    return {
        isRegistered: !!swManager.registration,
        isOnline: swManager.isOnline,
        updateAvailable: swManager.updateAvailable
    };
};

window.updateServiceWorker = function() {
    swManager.applyUpdate();
};

window.clearServiceWorkerCache = async function() {
    await swManager.clearCache();
    return true;
};

window.getServiceWorkerCacheSize = async function() {
    const bytes = await swManager.getCacheSize();
    const mb = (bytes / (1024 * 1024)).toFixed(2);
    return `${mb} MB`;
};
