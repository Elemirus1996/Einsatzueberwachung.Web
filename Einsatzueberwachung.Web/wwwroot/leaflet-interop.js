// Leaflet Map Interop für Einsatzueberwachung
// Ermöglicht das Zeichnen und Verwalten von Suchgebieten auf einer interaktiven Karte

window.LeafletMap = {
maps: {},
    
// Initialisiert eine neue Karte
initialize: function(mapId, centerLat, centerLng, zoom, dotNetReference) {
    try {
        // Karte erstellen
        const map = L.map(mapId).setView([centerLat, centerLng], zoom);
            
        // Layer definieren
        const osmLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors',
            maxZoom: 19
        });
        
        // Esri Satellite Layer
        const satelliteLayer = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
            attribution: 'Tiles © Esri',
            maxZoom: 18
        });
        
        // Google Satellite als Fallback (falls Esri nicht lädt)
        const googleSatellite = L.tileLayer('https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
            attribution: 'Map data © Google',
            maxZoom: 20
        });
        
        // Hybrid: Satellit mit Straßennamen
        const hybridLayer = L.tileLayer('https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}', {
            attribution: 'Map data © Google',
            maxZoom: 20
        });
        
        console.log('Layer erstellt');
        
        // Standard-Layer hinzufügen
        osmLayer.addTo(map);
        
        // Layer Control mit besserer Konfiguration
        const baseMaps = {
            "Straßenkarte": osmLayer,
            "Satellit (Esri)": satelliteLayer,
            "Satellit (Google)": googleSatellite,
            "Hybrid (Google)": hybridLayer
        };
        
        console.log('Layer Control wird hinzugefügt');
        const layerControl = L.control.layers(baseMaps, null, {
            position: 'topright',
            collapsed: false  // Immer ausgeklappt für bessere Sichtbarkeit
        });
        layerControl.addTo(map);
        console.log('Layer Control hinzugefügt:', layerControl);
            
        // FeatureGroup für gezeichnete Items
        const drawnItems = new L.FeatureGroup();
        map.addLayer(drawnItems);
            
        // Draw Control hinzufügen
        const drawControl = new L.Control.Draw({
            edit: {
                featureGroup: drawnItems,
                edit: true,
                remove: true
            },
            draw: {
                polygon: {
                    allowIntersection: false,
                    showArea: true,
                    drawError: {
                        color: '#e74c3c',
                        message: '<strong>Fehler!</strong> Polygone dürfen sich nicht überschneiden.'
                    },
                    shapeOptions: {
                        color: '#3388ff',
                        weight: 3
                    }
                },
                polyline: false,
                rectangle: true,
                circle: false,
                circlemarker: false,
                marker: true
            }
        });
        map.addControl(drawControl);
            
        // Event-Listener für gezeichnete Shapes
        map.on(L.Draw.Event.CREATED, function(e) {
            const layer = e.layer;
            drawnItems.addLayer(layer);
                
            // Callback an Blazor
            const geoJSON = layer.toGeoJSON();
            if (dotNetReference) {
                dotNetReference.invokeMethodAsync('OnShapeCreated', JSON.stringify(geoJSON));
            }
        });
            
        // Event-Listener für bearbeitete Shapes
        map.on(L.Draw.Event.EDITED, function(e) {
            const layers = e.layers;
            layers.eachLayer(function(layer) {
                const geoJSON = layer.toGeoJSON();
                if (dotNetReference) {
                    dotNetReference.invokeMethodAsync('OnShapeEdited', JSON.stringify(geoJSON));
                }
            });
        });
            
        // Event-Listener für gelöschte Shapes
        map.on(L.Draw.Event.DELETED, function(e) {
            const layers = e.layers;
            layers.eachLayer(function(layer) {
                const geoJSON = layer.toGeoJSON();
                if (dotNetReference) {
                    dotNetReference.invokeMethodAsync('OnShapeDeleted', JSON.stringify(geoJSON));
                }
            });
        });
            
        // Karte speichern
        this.maps[mapId] = {
            map: map,
            drawnItems: drawnItems,
            markers: {},
            dotNetReference: dotNetReference,
            layers: {
                streets: osmLayer,
                satellite: satelliteLayer,
                satelliteGoogle: googleSatellite,
                hybrid: hybridLayer
            },
            currentLayer: osmLayer
        };
            
        return true;
    } catch (error) {
        console.error('Fehler beim Initialisieren der Karte:', error);
        return false;
    }
},
    
    // Fügt ein Suchgebiet (Polygon) zur Karte hinzu
    addSearchArea: function(mapId, areaId, geoJSON, color, name) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData) return false;
            
            const layer = L.geoJSON(JSON.parse(geoJSON), {
                style: {
                    color: color,
                    weight: 3,
                    opacity: 0.8,
                    fillOpacity: 0.3
                }
            });
            
            layer.bindPopup(`<strong>${name}</strong>`);
            layer.addTo(mapData.drawnItems);
            
            // Layer-ID speichern
            mapData.markers[areaId] = layer;
            
            return true;
        } catch (error) {
            console.error('Fehler beim Hinzufügen des Suchgebiets:', error);
            return false;
        }
    },
    
    // Entfernt ein Suchgebiet von der Karte
    removeSearchArea: function(mapId, areaId) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData || !mapData.markers[areaId]) return false;
            
            mapData.drawnItems.removeLayer(mapData.markers[areaId]);
            delete mapData.markers[areaId];
            
            return true;
        } catch (error) {
            console.error('Fehler beim Entfernen des Suchgebiets:', error);
            return false;
        }
    },
    
    // Setzt einen Marker auf der Karte
    setMarker: function(mapId, markerId, lat, lng, title, iconColor) {
        console.log('setMarker aufgerufen:', { mapId, markerId, lat, lng, title });
        
        try {
            const mapData = this.maps[mapId];
            if (!mapData) {
                console.error('Karte nicht gefunden:', mapId);
                return false;
            }
            
            console.log('Karten-Daten gefunden:', mapData);
            
            // WICHTIG: Alten Marker IMMER entfernen (damit ELW-Position aktualisiert werden kann)
            if (mapData.markers[markerId]) {
                console.log('Entferne alten Marker:', markerId);
                mapData.map.removeLayer(mapData.markers[markerId]);
                delete mapData.markers[markerId];  // Aus der Liste entfernen
            }
            
            // Icon für ELW (spezielle rote Darstellung)
            let markerIcon = null;
            
            if (markerId === 'elw') {
                console.log('Erstelle ROTES ELW-Icon');
                // Erstelle einen roten Marker für ELW
                const svgIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="32" height="45" viewBox="0 0 32 45">
                    <path fill="#DC143C" stroke="#8B0000" stroke-width="2" d="M16 0 C7 0 0 7 0 16 C0 28 16 45 16 45 C16 45 32 28 32 16 C32 7 25 0 16 0 Z"/>
                    <circle cx="16" cy="16" r="8" fill="white"/>
                    <text x="16" y="22" font-size="14" font-weight="bold" text-anchor="middle" fill="#DC143C" font-family="Arial">E</text>
                </svg>`;
                
                markerIcon = L.divIcon({
                    html: svgIcon,
                    iconSize: [32, 45],
                    iconAnchor: [16, 45],
                    popupAnchor: [0, -45],
                    className: 'elw-marker-icon'
                });
            } else if (markerId === 'einsatzort') {
                console.log('Erstelle Standard Einsatzort-Icon');
                markerIcon = L.icon({
                    iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
                    shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
                    iconSize: [25, 41],
                    iconAnchor: [12, 41],
                    popupAnchor: [1, -34],
                    shadowSize: [41, 41]
                });
            } else {
                console.log('Erstelle Standard-Icon');
                markerIcon = L.icon({
                    iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
                    shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
                    iconSize: [25, 41],
                    iconAnchor: [12, 41],
                    popupAnchor: [1, -34],
                    shadowSize: [41, 41]
                });
            }
            
            console.log('Erstelle Marker an Position:', lat, lng);
            
            // Neuen Marker erstellen
            const marker = L.marker([lat, lng], {
                icon: markerIcon,
                title: title,
                draggable: markerId === 'elw'  // ELW-Marker kann verschoben werden
            }).addTo(mapData.map);
            
            // Popup
            marker.bindPopup(`<strong>${title}</strong><br><small>Lat: ${lat.toFixed(5)}, Lng: ${lng.toFixed(5)}</small>`);
            
            // Bei Verschiebung von ELW: Update Position
            if (markerId === 'elw') {
                marker.on('dragend', function(e) {
                    const newPos = e.target.getLatLng();
                    console.log('ELW verschoben zu:', newPos);
                    marker.setPopupContent(`<strong>${title}</strong><br><small>Lat: ${newPos.lat.toFixed(5)}, Lng: ${newPos.lng.toFixed(5)}</small>`);
                    
                    // Informiere Blazor über neue Position
                    if (mapData.dotNetReference) {
                        mapData.dotNetReference.invokeMethodAsync('OnElwMarkerMoved', newPos.lat, newPos.lng);
                    }
                });
            }
            
            // Marker speichern
            mapData.markers[markerId] = marker;
            
            console.log('Marker erfolgreich erstellt:', markerId);
            
            return true;
        } catch (error) {
            console.error('Fehler beim Setzen des Markers:', error);
            return false;
        }
    },
    
    // Entfernt einen Marker
    removeMarker: function(mapId, markerId) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData || !mapData.markers[markerId]) return false;
            
            mapData.map.removeLayer(mapData.markers[markerId]);
            delete mapData.markers[markerId];
            
            return true;
        } catch (error) {
            console.error('Fehler beim Entfernen des Markers:', error);
            return false;
        }
    },
    
    // Zentriert die Karte auf eine Position
    centerMap: function(mapId, lat, lng, zoom) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData) return false;
            
            mapData.map.setView([lat, lng], zoom || mapData.map.getZoom());
            return true;
        } catch (error) {
            console.error('Fehler beim Zentrieren der Karte:', error);
            return false;
        }
    },
    
    // Gibt die aktuelle Kartenmitte zurück
    getMapCenter: function(mapId) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData) return { lat: 0, lng: 0 };
            
            const center = mapData.map.getCenter();
            return {
                lat: center.lat,
                lng: center.lng
            };
        } catch (error) {
            console.error('Fehler beim Abrufen der Kartenmitte:', error);
            return { lat: 0, lng: 0 };
        }
    },
    
    // Wechselt die Basis-Layer-Ansicht
    changeBaseLayer: function(mapId, layerType) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData) {
                console.error('Karte nicht gefunden:', mapId);
                return false;
            }
            
            // Entferne aktuellen Layer
            if (mapData.currentLayer) {
                mapData.map.removeLayer(mapData.currentLayer);
            }
            
            // Füge neuen Layer hinzu
            let newLayer = null;
            switch(layerType) {
                case 'streets':
                    newLayer = mapData.layers.streets;
                    break;
                case 'satellite':
                    newLayer = mapData.layers.satellite;
                    break;
                case 'hybrid':
                    newLayer = mapData.layers.hybrid;
                    break;
                default:
                    newLayer = mapData.layers.streets;
            }
            
            if (newLayer) {
                newLayer.addTo(mapData.map);
                mapData.currentLayer = newLayer;
                console.log('Layer gewechselt zu:', layerType);
            }
            
            return true;
        } catch (error) {
            console.error('Fehler beim Wechseln des Layers:', error);
            return false;
        }
    },
    
    // Passt den Kartenausschnitt an alle Marker an
    fitBounds: function(mapId) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData) return false;
            
            const group = new L.featureGroup(Object.values(mapData.markers));
            mapData.map.fitBounds(group.getBounds().pad(0.1));
            
            return true;
        } catch (error) {
            console.error('Fehler beim Anpassen der Bounds:', error);
            return false;
        }
    },
    
    // Geocoding: Adresse zu Koordinaten
    geocodeAddress: async function(address) {
        try {
            const response = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}&limit=1`);
            const data = await response.json();
            
            if (data && data.length > 0) {
                return {
                    success: true,
                    lat: parseFloat(data[0].lat),
                    lng: parseFloat(data[0].lon),
                    displayName: data[0].display_name
                };
            }
            
            return { success: false, message: 'Adresse nicht gefunden' };
        } catch (error) {
            console.error('Fehler beim Geocoding:', error);
            return { success: false, message: error.message };
        }
    },
    
    // Druckt die Karte
    printMap: function(mapId) {
        console.log('printMap aufgerufen für:', mapId);
        try {
            const mapData = this.maps[mapId];
            if (!mapData) {
                console.error('Karte nicht gefunden:', mapId);
                return false;
            }
            
            console.log('Starte Druck-Dialog');
            // Trigger Browser-Druck-Dialog
            window.print();
            return true;
        } catch (error) {
            console.error('Fehler beim Drucken der Karte:', error);
            return false;
        }
    },
    
    // Exportiert die Karte als Bild (PNG)
    exportMapImage: function(mapId) {
        try {
            const mapData = this.maps[mapId];
            if (!mapData) return false;
            
            // Hinweis für Benutzer
            alert('Tipp: Nutzen Sie "Karte drucken" und speichern Sie als PDF, oder machen Sie einen Screenshot (Windows: Win+Shift+S, Mac: Cmd+Shift+4)');
            return true;
        } catch (error) {
            console.error('Fehler beim Exportieren:', error);
            return false;
        }
    },
    
    // Karte aufräumen
    dispose: function(mapId) {
        try {
            const mapData = this.maps[mapId];
            if (mapData && mapData.map) {
                mapData.map.remove();
                delete this.maps[mapId];
            }
            return true;
        } catch (error) {
            console.error('Fehler beim Dispose der Karte:', error);
            return false;
        }
    }
};



