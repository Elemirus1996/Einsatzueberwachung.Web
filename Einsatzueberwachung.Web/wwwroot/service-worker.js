// Service Worker für Offline-Support
// Cacht wichtige Ressourcen und ermöglicht Offline-Funktionalität

const CACHE_NAME = 'einsatzueberwachung-v1.0.1';
const STATIC_CACHE = 'static-v1.0.1';
const DYNAMIC_CACHE = 'dynamic-v1.0.1';

// Zu cachende Ressourcen
const STATIC_ASSETS = [
    '/',
    '/app.css',
    '/dark-mode-base.css',
    '/notes-enhanced.css',
    '/mobile-dashboard.css',
    '/print-map.css',
    '/bootstrap/bootstrap.min.css',
    '/bootstrap/bootstrap.min.css.map',
    '/_framework/blazor.web.js',
    '/manifest.json',
    '/icon-192.png',
    '/icon-512.png',
    '/favicon.png'
];

// Installation - Cache erstellen
self.addEventListener('install', event => {
    console.log('Service Worker: Installing...');
    
    event.waitUntil(
        caches.open(STATIC_CACHE)
            .then(cache => {
                console.log('Service Worker: Caching static assets');
                return cache.addAll(STATIC_ASSETS);
            })
            .catch(err => {
                console.error('Service Worker: Cache failed', err);
            })
    );
    
    // Aktiviere Worker sofort
    self.skipWaiting();
});

// Aktivierung - Alte Caches löschen
self.addEventListener('activate', event => {
    console.log('Service Worker: Activating...');
    
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames
                    .filter(name => name !== STATIC_CACHE && name !== DYNAMIC_CACHE)
                    .map(name => {
                        console.log('Service Worker: Deleting old cache', name);
                        return caches.delete(name);
                    })
            );
        })
    );
    
    // Übernimmt Kontrolle über alle Clients
    return self.clients.claim();
});

// Fetch - Network First mit Cache Fallback
self.addEventListener('fetch', event => {
    const { request } = event;
    const url = new URL(request.url);
    
    // Ignoriere Chrome Extensions und nicht-HTTP(S)
    if (!url.protocol.startsWith('http')) {
        return;
    }
    
    // API-Calls: Network First
    if (url.pathname.startsWith('/api/')) {
        event.respondWith(networkFirst(request));
        return;
    }
    
    // Blazor Framework: Cache First
    if (url.pathname.includes('/_framework/')) {
        event.respondWith(cacheFirst(request));
        return;
    }
    
    // Static Assets: Cache First
    if (isStaticAsset(url.pathname)) {
        event.respondWith(cacheFirst(request));
        return;
    }
    
    // Alles andere: Network First mit Cache Fallback
    event.respondWith(networkFirst(request));
});

// Cache First Strategy
async function cacheFirst(request) {
    const cache = await caches.open(STATIC_CACHE);
    const cached = await cache.match(request);
    
    if (cached) {
        return cached;
    }
    
    try {
        const response = await fetch(request);
        
        if (response.ok) {
            cache.put(request, response.clone());
        }
        
        return response;
    } catch (error) {
        console.error('Cache First failed:', error);
        return new Response('Offline - Ressource nicht verfügbar', {
            status: 503,
            statusText: 'Service Unavailable'
        });
    }
}

// Network First Strategy
async function networkFirst(request) {
    const cache = await caches.open(DYNAMIC_CACHE);
    
    try {
        const response = await fetch(request);
        
        // Nur GET-Requests können gecacht werden
        if (response.ok && request.method === 'GET') {
            cache.put(request, response.clone());
        }
        
        return response;
    } catch (error) {
        console.log('Network First: Falling back to cache', request.url);
        
        const cached = await cache.match(request);
        
        if (cached) {
            return cached;
        }
        
        // Offline-Fallback
        if (request.destination === 'document') {
            const fallback = await cache.match('/');
            if (fallback) return fallback;
        }
        
        return new Response('Offline - Keine Verbindung', {
            status: 503,
            statusText: 'Service Unavailable',
            headers: { 'Content-Type': 'text/plain' }
        });
    }
}

// Prüfe ob Ressource statisch ist
function isStaticAsset(pathname) {
    const staticExtensions = ['.css', '.js', '.png', '.jpg', '.svg', '.woff', '.woff2', '.ttf'];
    return staticExtensions.some(ext => pathname.endsWith(ext));
}

// Background Sync für Offline-Daten (optional)
self.addEventListener('sync', event => {
    if (event.tag === 'sync-notes') {
        event.waitUntil(syncNotes());
    }
});

async function syncNotes() {
    // Hier können offline gespeicherte Notizen synchronisiert werden
    console.log('Service Worker: Syncing offline data...');
}

// Push Notifications (optional für zukünftige Features)
self.addEventListener('push', event => {
    const options = {
        body: event.data ? event.data.text() : 'Neue Benachrichtigung',
        icon: '/icon-192.png',
        badge: '/icon-192.png',
        vibrate: [200, 100, 200]
    };
    
    event.waitUntil(
        self.registration.showNotification('Einsatzüberwachung', options)
    );
});

// Notification Click
self.addEventListener('notificationclick', event => {
    event.notification.close();
    
    event.waitUntil(
        clients.openWindow('/')
    );
});
