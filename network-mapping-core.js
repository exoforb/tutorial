// Variables & Map Position Memory
var map;
var markersGroup = {
    routers: L.layerGroup(),
    odcs: L.layerGroup(),
    odps: L.layerGroup(),
    customers: L.layerGroup(),
    poles: L.layerGroup() // TAMBAHAN BARU
};
var connectionsGroup = L.layerGroup();
var cablesLayerGroup = L.layerGroup();
var cableRoutingMode = false;
var quickAddMode = false;
var quickAddType = '';
var routingFromPoint = null;
var routingToPoint = null;
var currentWaypoints = [];
var tempPolyline = null;
var waypointMarkers = [];
var cableRoutes = [];
var allMarkers = {}; // Store all markers for easy access
// ===== TAMBAHAN BARU: MAP POSITION MEMORY SYSTEM =====
var mapPositionMemory = {
    storageKey: 'ffth_map_position',
    defaultPosition: {
        lat: -7.250445,
        lng: 112.768845,
        zoom: 13
    },

    // Simpan posisi current map
    savePosition: function () {
        if (!map) return;

        var center = map.getCenter();
        var zoom = map.getZoom();

        var position = {
            lat: center.lat,
            lng: center.lng,
            zoom: zoom,
            timestamp: Date.now()
        };

        try {
            localStorage.setItem(this.storageKey, JSON.stringify(position));
            console.log('Map position saved:', position);
        } catch (e) {
            console.warn('Could not save map position:', e);
        }
    },

    // Load posisi yang tersimpan
    loadPosition: function () {
        try {
            var stored = localStorage.getItem(this.storageKey);
            if (stored) {
                var position = JSON.parse(stored);

                // Check if position is not too old (24 hours)
                var maxAge = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
                if (Date.now() - position.timestamp < maxAge) {
                    console.log('Loading saved map position:', position);
                    return position;
                }
            }
        } catch (e) {
            console.warn('Could not load map position:', e);
        }

        console.log('Using default map position');
        return this.defaultPosition;
    },

    // Clear saved position
    clearPosition: function () {
        try {
            localStorage.removeItem(this.storageKey);
            console.log('Map position cleared');
        } catch (e) {
            console.warn('Could not clear map position:', e);
        }
    }
};

function editOdcFromMap(id) {
    console.log('Edit ODC from map, ID:', id);
    showEditOdcModal(id);
}

function editOdpFromMap(id) {
    console.log('Edit ODP from map, ID:', id);
    showEditOdpModal(id);
}

//Get Location & Map Setup
function getLocation() {
    document.getElementById('loading').style.display = 'block';

    // Cek apakah ada posisi tersimpan
    var savedPosition = mapPositionMemory.loadPosition();

    if (window.location.protocol == "https:" && navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            function (position) {
                // Jika ada posisi tersimpan, gunakan yang tersimpan
                // Jika tidak, gunakan geolocation
                if (savedPosition && savedPosition !== mapPositionMemory.defaultPosition) {
                    console.log('Using saved position instead of geolocation');
                    setupMap(savedPosition.lat, savedPosition.lng, savedPosition.zoom);
                } else {
                    console.log('Using geolocation position');
                    setupMap(position.coords.latitude, position.coords.longitude, 15);
                }
            },
            function () {
                // Geolocation error - gunakan posisi tersimpan atau default
                setupMap(savedPosition.lat, savedPosition.lng, savedPosition.zoom);
            }
        );
    } else {
        // No geolocation - gunakan posisi tersimpan atau default
        setupMap(savedPosition.lat, savedPosition.lng, savedPosition.zoom);
    }
}

function showPosition(position) {
    // Fungsi ini tidak diperlukan lagi karena logic sudah dipindah ke getLocation
    // Tapi kita biarkan untuk backward compatibility
    setupMap(position.coords.latitude, position.coords.longitude);
}

function setupMap(lat, lon, zoom = 15) {
    map = L.map('map').setView([lat, lon], zoom);

    // ===== DEFINE ALL LAYERS =====

    // Street Map Layer (OpenStreetMap)
    var streetMapLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors'
    });

    // ESRI Satellite Layer (untuk zoom < 19)
    var esriSatelliteLayer = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
        maxZoom: 19,
        attribution:
            'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
    });

    // Google Satellite Layer (untuk zoom >= 19)
    var googleSatelliteLayer = L.tileLayer('https://mt{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
        maxZoom: 21,
        subdomains: ['0', '1', '2', '3'],
        attribution: '&copy; Google'
    });

    // ===== LAYER MANAGEMENT VARIABLES =====
    var currentMapMode = 'street'; // 'street' atau 'satellite'
    var currentSatelliteLayer = null;

    // ===== FUNCTION: SWITCH TO STREET MAP =====
    function switchToStreetMap() {
        // Remove satellite layers
        if (map.hasLayer(esriSatelliteLayer)) map.removeLayer(esriSatelliteLayer);
        if (map.hasLayer(googleSatelliteLayer)) map.removeLayer(googleSatelliteLayer);

        // Add street map
        if (!map.hasLayer(streetMapLayer)) {
            map.addLayer(streetMapLayer);
        }

        currentMapMode = 'street';
        console.log('Switched to Street Map mode');
        showLayerSwitchNotification('Street Map', 'Vector map style');
    }

    // ===== FUNCTION: SWITCH TO SATELLITE =====
    function switchToSatelliteMode() {
        // Remove street map
        if (map.hasLayer(streetMapLayer)) map.removeLayer(streetMapLayer);

        // Determine which satellite layer based on zoom
        var currentZoom = map.getZoom();
        if (currentZoom >= 19) {
            if (map.hasLayer(esriSatelliteLayer)) map.removeLayer(esriSatelliteLayer);
            if (!map.hasLayer(googleSatelliteLayer)) {
                map.addLayer(googleSatelliteLayer);
                currentSatelliteLayer = 'google';
            }
        } else {
            if (map.hasLayer(googleSatelliteLayer)) map.removeLayer(googleSatelliteLayer);
            if (!map.hasLayer(esriSatelliteLayer)) {
                map.addLayer(esriSatelliteLayer);
                currentSatelliteLayer = 'esri';
            }
        }

        currentMapMode = 'satellite';
        console.log('Switched to Satellite mode');
        showLayerSwitchNotification('Satellite Mode', currentSatelliteLayer === 'google' ? 'Google ultra detail' :
            'ESRI standard detail');
    }

    // ===== ZOOM EVENT: SATELLITE AUTO-SWITCHING =====
    map.on('zoomend', function () {
        // Only auto-switch satellite layers if we're in satellite mode
        if (currentMapMode === 'satellite') {
            var currentZoom = map.getZoom();
            console.log('Zoom changed to:', currentZoom, '(Satellite mode)');

            if (currentZoom >= 19 && currentSatelliteLayer !== 'google') {
                // Switch to Google Satellite
                if (map.hasLayer(esriSatelliteLayer)) map.removeLayer(esriSatelliteLayer);
                if (!map.hasLayer(googleSatelliteLayer)) {
                    map.addLayer(googleSatelliteLayer);
                    currentSatelliteLayer = 'google';
                    showLayerSwitchNotification('Google Satellite', 'Ultra high detail mode');
                }
            } else if (currentZoom < 19 && currentSatelliteLayer !== 'esri') {
                // Switch to ESRI Satellite
                if (map.hasLayer(googleSatelliteLayer)) map.removeLayer(googleSatelliteLayer);
                if (!map.hasLayer(esriSatelliteLayer)) {
                    map.addLayer(esriSatelliteLayer);
                    currentSatelliteLayer = 'esri';
                    showLayerSwitchNotification('ESRI Satellite', 'Standard satellite mode');
                }
            }
        }
    });

    // ===== LAYER CONTROL SETUP =====
    var baseLayers = {
        "🗺️ Street Map": {
            layer: streetMapLayer,
            action: switchToStreetMap
        },
        "🛰️ Satellite": {
            layer: null, // Controlled by functions
            action: switchToSatelliteMode
        }
    };

    // Create custom layer control
    var layerControl = L.control({ position: 'topright' });
    layerControl.onAdd = function (map) {
        var div = L.DomUtil.create('div', 'custom-layer-control');
        div.innerHTML = `
            <div class="layer-control-container" id="layerControlContainer">
                <div class="layer-control-toggle" id="layerControlToggle">
                    <i class="fa-solid fa-layer-group fa-lg layer-main-icon"></i>
                    <div class="layer-control-tooltip">Map Layers</div>
                </div>
                <div class="layer-control-options">
                    <div class="layer-option selected" data-layer="street">
                        <div class="layer-option-icon street">
                            <i class="fa-solid fa-map"></i>
                        </div>
                        <div class="layer-option-name">Street Map</div>
                        <div class="layer-option-checkmark">
                            <i class="fa fa-check"></i>
                        </div>
                    </div>
                    <div class="layer-option" data-layer="satellite">
                        <div class="layer-option-icon satellite">
                            <i class="fa fa-globe"></i>
                        </div>
                        <div class="layer-option-name">Satellite</div>
                        <div class="layer-option-checkmark">
                            <i class="fa fa-check"></i>
                        </div>
                    </div>
                </div>
            </div>
        `;

        // Prevent map interaction when clicking control
        L.DomEvent.disableClickPropagation(div);
        L.DomEvent.disableScrollPropagation(div);

        return div;
    };

    layerControl.addTo(map);

    // ===== LAYER CONTROL EVENT HANDLERS =====
    setTimeout(function () {
        var container = document.getElementById('layerControlContainer');
        var toggle = document.getElementById('layerControlToggle');
        var options = document.querySelectorAll('.layer-option');

        if (!container || !toggle) {
            console.error('Layer control elements not found');
            return;
        }

        // Toggle expand/collapse
        toggle.addEventListener('click', function (e) {
            e.stopPropagation();
            console.log('Layer control clicked');
            container.classList.toggle('expanded');
        });

        // Close when clicking outside
        document.addEventListener('click', function (e) {
            if (!e.target.closest('.custom-layer-control')) {
                container.classList.remove('expanded');
            }
        });

        // Handle option selection
        options.forEach(function (option) {
            option.addEventListener('click', function (e) {
                e.stopPropagation();
                console.log('Layer option clicked:', this.dataset.layer);

                // Remove selected class from all options
                options.forEach(opt => opt.classList.remove('selected'));

                // Add selected class to clicked option
                this.classList.add('selected');

                // Trigger layer change
                var layerType = this.dataset.layer;

                if (layerType === 'street') {
                    switchToStreetMap();
                } else if (layerType === 'satellite') {
                    switchToSatelliteMode();
                }

                // Close panel after selection
                setTimeout(() => {
                    container.classList.remove('expanded');
                }, 300);
            });
        });

        console.log('Layer control initialized successfully');
    }, 1000); // Increase timeout to 1 second

    // ===== INITIALIZE WITH STREET MAP =====
    streetMapLayer.addTo(map);
    currentMapMode = 'street';

    Object.values(markersGroup).forEach(group => group.addTo(map));
    connectionsGroup.addTo(map);
    cablesLayerGroup.addTo(map);

    // ===== TAMBAHAN BARU: AUTO-SAVE POSITION =====
    // Save position setiap kali map di-move atau zoom
    var saveTimeout;

    function debouncedSave() {
        clearTimeout(saveTimeout);
        saveTimeout = setTimeout(function () {
            mapPositionMemory.savePosition();
        }, 1000); // Save 1 detik setelah user berhenti move/zoom
    }

    map.on('moveend', debouncedSave);
    map.on('zoomend', debouncedSave);

    // Save position juga saat user interact dengan map
    map.on('click', function () {
        setTimeout(function () {
            mapPositionMemory.savePosition();
        }, 500);
    });

    loadNetworkData();
    initializeCableRouting();
    setupLayerControls();

    document.getElementById('loading').style.display = 'none';

    console.log('Map initialized at:', lat, lon, 'zoom:', zoom);
}

// ===== LAYER SWITCH NOTIFICATION FUNCTION =====
function showLayerSwitchNotification(layerName, description) {
    // Remove existing notification if any
    var existingNotif = document.getElementById('layer-switch-notification');
    if (existingNotif) {
        existingNotif.remove();
    }

    // Create notification element
    var notification = document.createElement('div');
    notification.id = 'layer-switch-notification';
    notification.innerHTML =
        '<i class="fa fa-globe"></i> ' + layerName +
        '<br><small>' + description + '</small>';

    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        background: rgba(0, 123, 255, 0.95);
        color: white;
        padding: 10px 15px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: bold;
        z-index: 9999;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        transition: all 0.3s ease;
        opacity: 0;
        transform: translateX(100px);
        max-width: 200px;
        text-align: center;
        line-height: 1.3;
    `;

    document.body.appendChild(notification);

    // Animate in
    setTimeout(function () {
        notification.style.opacity = '1';
        notification.style.transform = 'translateX(0)';
    }, 100);

    // Auto remove after 3 seconds
    setTimeout(function () {
        if (notification && notification.parentNode) {
            notification.style.opacity = '0';
            notification.style.transform = 'translateX(100px)';
            setTimeout(function () {
                if (notification && notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }
    }, 3000);
}

function loadNetworkData() {
    Object.values(markersGroup).forEach(group => group.clearLayers());
    connectionsGroup.clearLayers();

    var allCoordinates = [];

    // Add routers with IMPROVED ICONS AND Z-INDEX
    if (networkData.routers) {
        networkData.routers.forEach(function (router) {
            var coords = router.coordinates.split(',').map(parseFloat);
            allCoordinates.push(coords);

            var routerIcon = L.divIcon({
                className: 'custom-div-icon',
                html: '<div class="router-marker" data-type="router" data-id="' + router.id +
                    '" data-name="' + router.name + '" data-coords="' + router.coordinates +
                    '"><i class="fa fa-server"></i></div>',
                iconSize: [32, 32],
                iconAnchor: [16, 16],
                popupAnchor: [0, -16]
            });

            var marker = L.marker(coords, {
                icon: routerIcon,
                zIndexOffset: 10000
            }).addTo(markersGroup.routers);

            // Enhanced popup with routing button
            var popupContent = router.popup_content.replace(
                '<a href=\'javascript:void(0)\' onclick=\'showRouterDetail(' + router.id +
                ')\'>Detail</a>',
                '<a href=\'javascript:void(0)\' onclick=\'showRouterDetail(' + router.id +
                ')\'>Detail</a> | ' +
                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("router", ' + router
                    .id + ', "' + router.name + '", "' + router.coordinates +
                '")\' class="route-cable-link">Route Cable</a>'
            );

            marker.bindPopup(popupContent);
            marker.bindTooltip(router.name, { permanent: false, direction: 'top' });

            // Store marker reference
            allMarkers['router_' + router.id] = {
                marker: marker,
                data: router,
                type: 'router'
            };

            if (router.coverage > 0) {
                var circle = L.circle(coords, {
                    radius: router.coverage,
                    color: router.enabled == 1 ? 'blue' : 'red',
                    fillOpacity: 0.1,
                    weight: 2
                }).addTo(markersGroup.routers);
            }
        });
    }

    // Add ODCs with IMPROVED ICONS AND Z-INDEX
    if (networkData.odcs) {
        networkData.odcs.forEach(function (odc) {
            var coords = odc.coordinates.split(',').map(parseFloat);
            allCoordinates.push(coords);

            var odcIcon = L.divIcon({
                className: 'custom-div-icon',
                html: '<div class="odc-marker" data-type="odc" data-id="' + odc.id +
                    '" data-name="' + odc.name + '" data-coords="' + odc.coordinates +
                    '"><i class="fa-solid fa-tower-cell"></i></div>',
                iconSize: [28, 28],
                iconAnchor: [14, 14],
                popupAnchor: [0, -14]
            });

            var marker = L.marker(coords, {
                icon: odcIcon,
                zIndexOffset: 9000
            }).addTo(markersGroup.odcs);

            // Enhanced popup with routing button
            var popupContent = odc.popup_content.replace(
                '<a href=\'javascript:void(0)\' onclick=\'showOdcDetail(' + odc.id + ')\'>Detail</a>',
                '<a href=\'javascript:void(0)\' onclick=\'showOdcDetail(' + odc.id +
                ')\'>Detail</a> | ' +
                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("odc", ' + odc.id +
                ', "' + odc.name + '", "' + odc.coordinates +
                '")\' class="route-cable-link">Route Cable</a>'
            );

            marker.bindPopup(popupContent);
            marker.bindTooltip(odc.name + ' (' + odc.available_ports + ' ports)', {
                permanent: false,
                direction: 'top'
            });

            // Store marker reference
            allMarkers['odc_' + odc.id] = {
                marker: marker,
                data: odc,
                type: 'odc'
            };
        });
    }

    // Add ODPs with IMPROVED ICONS AND Z-INDEX
    if (networkData.odps) {
        networkData.odps.forEach(function (odp) {
            var coords = odp.coordinates.split(',').map(parseFloat);
            allCoordinates.push(coords);

            var odpIcon = L.divIcon({
                className: 'custom-div-icon',
                html: '<div class="odp-marker" data-type="odp" data-id="' + odp.id +
                    '" data-name="' + odp.name + '" data-coords="' + odp.coordinates +
                    '"><i class="fa-solid fa-circle-nodes"></i></div>',
                iconSize: [24, 24],
                iconAnchor: [12, 12],
                popupAnchor: [0, -12]
            });

            var marker = L.marker(coords, {
                icon: odpIcon,
                zIndexOffset: 8000
            }).addTo(markersGroup.odps);

            // Enhanced popup with routing button
            var popupContent = odp.popup_content.replace(
                '<a href=\'javascript:void(0)\' onclick=\'showOdpDetail(' + odp.id + ')\'>Detail</a>',
                '<a href=\'javascript:void(0)\' onclick=\'showOdpDetail(' + odp.id +
                ')\'>Detail</a> | ' +
                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("odp", ' + odp.id +
                ', "' + odp.name + '", "' + odp.coordinates +
                '")\' class="route-cable-link">Route Cable</a>'
            );

            marker.bindPopup(popupContent);
            marker.bindTooltip(odp.name + ' (' + odp.available_ports + ' ports)', {
                permanent: false,
                direction: 'top'
            });

            // Store marker reference
            allMarkers['odp_' + odp.id] = {
                marker: marker,
                data: odp,
                type: 'odp'
            };
        });
    }

    // Add customers with IMPROVED ICONS AND Z-INDEX
    if (networkData.customers) {
        networkData.customers.forEach(function (customer) {
            var coords = customer.coordinates.split(',').map(parseFloat);
            allCoordinates.push(coords);

            var customerIcon = L.divIcon({
                className: 'custom-div-icon',
                html: '<div class="customer-marker" data-type="customer" data-id="' + customer.id +
                    '" data-name="' + customer.name + '" data-coords="' + customer.coordinates +
                    '"><i class="fa fa-user"></i></div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10],
                popupAnchor: [0, -10]
            });

            var marker = L.marker(coords, {
                icon: customerIcon,
                zIndexOffset: 7000
            }).addTo(markersGroup.customers);

            // Enhanced popup with routing button
            var popupContent = customer.popup_content.replace(
                '<a href=\'' + baseUrl + 'customers/view/' + customer.id + '\'>Detail</a>',
                '<a href=\'' + baseUrl + 'customers/view/' + customer.id + '\'>Detail</a> | ' +
                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("customer", ' + customer
                    .id + ', "' + customer.name + '", "' + customer.coordinates +
                '")\' class="route-cable-link">Route Cable</a>'
            );

            marker.bindPopup(popupContent);
            marker.bindTooltip(customer.name, { permanent: false, direction: 'top' });

            // Store marker reference
            allMarkers['customer_' + customer.id] = {
                marker: marker,
                data: customer,
                type: 'customer'
            };
        });
    }

    // UBAH BAGIAN INI - hanya fitBounds jika tidak ada posisi tersimpan
    if (allCoordinates.length > 0) {
        var savedPosition = mapPositionMemory.loadPosition();

        // Hanya auto-fit jika menggunakan default position (belum pernah save)
        if (savedPosition === mapPositionMemory.defaultPosition) {
            console.log('Auto-fitting bounds for first time user');
            var group = new L.featureGroup(Object.values(markersGroup).map(g => g.getLayers()).flat());
            if (group.getBounds().isValid()) {
                map.fitBounds(group.getBounds(), { padding: [20, 20] });
                // Save position setelah auto-fit
                setTimeout(function () {
                    mapPositionMemory.savePosition();
                }, 1000);
            }
        } else {
            console.log('Using saved position, skipping auto-fit');
        }
    }

    // Add poles with IMPROVED ICONS AND Z-INDEX
    if (networkData.poles) {
        networkData.poles.forEach(function (pole) {
            var coords = pole.coordinates.split(',').map(parseFloat);
            allCoordinates.push(coords);

            var poleIcon = L.divIcon({
                className: 'custom-div-icon',
                html: '<div class="pole-marker" data-type="pole" data-id="' + pole.id +
                    '" data-name="' + pole.name + '" data-coords="' + pole.coordinates +
                    '"><i class="fa fa-map-pin"></i></div>',
                iconSize: [22, 22],
                iconAnchor: [11, 11],
                popupAnchor: [0, -11]
            });

            var marker = L.marker(coords, {
                icon: poleIcon,
                zIndexOffset: 6500
            }).addTo(markersGroup.poles);

            // Simple popup without routing button for poles
            marker.bindPopup(pole.popup_content);
            marker.bindTooltip(pole.name, { permanent: false, direction: 'top' });

            // Store marker reference
            allMarkers['pole_' + pole.id] = {
                marker: marker,
                data: pole,
                type: 'pole'
            };
        });
    }

    // Update popup contents with cable status after cables are loaded
    setTimeout(function () {
        updateAllPopupsWithCableStatus();
    }, 1000);
}

function initializeCableRouting() {
    loadExistingCables();
    setupCableRoutingEvents();
    setupMarkerClickHandlers();

    // Update popups after cables loaded
    setTimeout(function () {
        updateAllPopupsWithCableStatus();
    }, 500);
}

function loadExistingCables() {
    if (cablesData && cablesData.length > 0) {
        cableRoutes = cablesData;
        cablesLayerGroup.clearLayers();

        cablesData.forEach(cable => {
            // ✅ ENHANCED: Properly handle visible status for hidden bridges
            if (cable.visible === undefined || cable.visible === 1) {
                drawCableRoute(cable);
            } else {
                // ✅ NEW: Log hidden cables for debugging
                console.log('Cable route ' + cable.id + ' is hidden (visible = 0)');
            }
        });

        updateCableStatistics();
    } else {
        // Fetch from API if not provided
        // ✅ NEW: Add cache buster to API call
        var cacheParam = '&t=' + Date.now();
        fetch(baseUrl + 'plugin/network_mapping/api-cable-routes' + cacheParam)
            .then(response => response.json())
            .then(responseData => {
                cablesLayerGroup.clearLayers();

                // ✅ NEW: Handle enhanced API response format
                var data = responseData.routes || responseData; // Backward compatibility
                var meta = responseData.meta || {};

                cableRoutes = data;

                data.forEach(cable => {
                    // ✅ ENHANCED: Consistent visibility handling
                    if (cable.visible === undefined || cable.visible === 1) {
                        drawCableRoute(cable);
                    } else {
                        console.log('Cable route ' + cable.id + ' is hidden (visible = 0)');
                    }
                });

                updateCableStatistics();

                // ✅ NEW: Use API metadata if available, otherwise calculate
                if (meta.total_routes) {
                    console.log('API Cable Routes Loaded:');
                    console.log('- Total: ' + meta.total_routes);
                    console.log('- Visible: ' + meta.visible_routes);
                    console.log('- Hidden: ' + meta.hidden_routes);
                    console.log('- Timestamp: ' + meta.timestamp);
                } else {
                    // Fallback calculation
                    var visibleCables = data.filter(cable => cable.visible === undefined || cable.visible ===
                        1);
                    var hiddenCables = data.filter(cable => cable.visible === 0);

                    console.log('Loaded ' + data.length + ' total cables:');
                    console.log('- Visible: ' + visibleCables.length);
                    console.log('- Hidden: ' + hiddenCables.length);
                }
            })
            .catch(error => {
                console.error('Error loading cables:', error);
            });
    }
}

function drawCableRoute(cable) {
    if (!cable.waypoints || cable.waypoints.length < 2) return;

    var coordinates = cable.waypoints.map(wp => [wp.lat, wp.lng]);

    // Get enhanced styling based on connection type
    var cableColor = getCableColorByConnection(cable.from_type, cable.to_type, cable.cable_type);
    var cableWidth = getCableWidthByConnection(cable.from_type, cable.to_type);

    var polylineOptions = {
        color: cableColor,
        weight: cableWidth,
        opacity: 0.8,
        className: 'cable-line cable-' + cable.cable_type + ' cable-animated connection-' + cable.from_type +
            '-' + cable.to_type
    };

    var polyline = L.polyline(coordinates, polylineOptions).addTo(cablesLayerGroup);

    // Enhanced popup with connection type info
    var length = calculateCableLength(cable.waypoints);
    var connectionType = getConnectionTypeName(cable.from_type, cable.to_type);

    var popupContent =
        '<div class="text-center">' +
        '<h5><i class="fa fa-sitemap"></i> Cable Route #' + cable.id + '</h5>' +
        '<hr>' +
        '<p><strong>From:</strong> ' + cable.from_name + ' (' + cable.from_type + ')</p>' +
        '<p><strong>To:</strong> ' + cable.to_name + ' (' + cable.to_type + ')</p>' +
        '<p><strong>Connection Type:</strong> <span class="label label-info">' + connectionType + '</span></p>' +
        '<p><strong>Cable Type:</strong> ' + cable.cable_type + '</p>' +
        '<p><strong>Length:</strong> ' + length.toFixed(0) + 'm</p>' +
        '<p><strong>Waypoints:</strong> ' + cable.waypoints.length + '</p>' +
        '<div style="margin: 10px 0;">' +
        '<div style="width: 100%; height: 4px; background: ' + cableColor + '; border-radius: 2px;"></div>' +
        '<small>Cable Color Preview</small>' +
        '</div>' +
        '</div>';

    polyline.bindPopup(popupContent);

    // Enhanced tooltip with connection type and color
    var tooltipContent = cable.from_name + ' → ' + cable.to_name +
        '<br>' + connectionType +
        '<br>' + length.toFixed(0) + 'm';

    polyline.bindTooltip(tooltipContent, {
        permanent: false,
        direction: 'center'
    });

    // Store polyline reference with cableId
    polyline.cableId = cable.id;
}


// Cable statistics functions
function updateCableStatistics() {
    var stats = {
        backbone: { count: 0, length: 0 },
        primary: { count: 0, length: 0 },
        distribution: { count: 0, length: 0 },
        access: { count: 0, length: 0 }
    };

    var totalLength = 0;

    cableRoutes.forEach(function (cable) {
        var length = calculateCableLength(cable.waypoints);
        var connectionType = getConnectionCategory(cable.from_type, cable.to_type);

        if (stats[connectionType]) {
            stats[connectionType].count++;
            stats[connectionType].length += length;
        }

        totalLength += length;
    });

    // Update count displays
    if (document.getElementById('backbone-count')) {
        document.getElementById('backbone-count').textContent = stats.backbone.count;
        document.getElementById('primary-count').textContent = stats.primary.count;
        document.getElementById('distribution-count').textContent = stats.distribution.count;
        document.getElementById('access-count').textContent = stats.access.count;

        // Update length displays
        document.getElementById('backbone-length').textContent = Math.round(stats.backbone.length) + 'm';
        document.getElementById('primary-length').textContent = Math.round(stats.primary.length) + 'm';
        document.getElementById('distribution-length').textContent = Math.round(stats.distribution.length) + 'm';
        document.getElementById('access-length').textContent = Math.round(stats.access.length) + 'm';

        // Update progress bars
        if (totalLength > 0) {
            var backbonePercent = (stats.backbone.length / totalLength) * 100;
            var primaryPercent = (stats.primary.length / totalLength) * 100;
            var distributionPercent = (stats.distribution.length / totalLength) * 100;
            var accessPercent = (stats.access.length / totalLength) * 100;

            document.getElementById('backbone-progress').style.width = backbonePercent + '%';
            document.getElementById('primary-progress').style.width = primaryPercent + '%';
            document.getElementById('distribution-progress').style.width = distributionPercent + '%';
            document.getElementById('access-progress').style.width = accessPercent + '%';
        }
    }

    // Update main cable count and total length
    document.getElementById('cable-count').textContent = cableRoutes.length;
    document.getElementById('total-cable-length').textContent = Math.round(totalLength);
}

// Setup cable routing event handlers
function setupCableRoutingEvents() {
    // Toggle routing button (Start/Cancel)
    document.getElementById('toggle-routing').addEventListener('click', function () {
        if (cableRoutingMode) {
            cancelCableRouting();
        } else {
            startCableRouting();
        }
    });

    // Undo waypoint button
    document.getElementById('undo-waypoint').addEventListener('click', function () {
        undoLastWaypoint();
    });

    // View cables button
    document.getElementById('view-cables').addEventListener('click', function () {
        showAllCables();
    });
    // View poles button
    document.getElementById('view-poles').addEventListener('click', function () {
        showAllPoles();
    });
    // View customers button
    document.getElementById('view-customers').addEventListener('click', function () {
        showAllCustomers();
    });
    document.getElementById('view-odcs').addEventListener('click', function () {
        showAllOdcs();
    });
    document.getElementById('view-odps').addEventListener('click', function () {
        showAllOdps();
    });

    // Quick add button - TOGGLE BEHAVIOR
    document.getElementById('quick-add-mode').addEventListener('click', function () {
        if (quickAddMode) {
            // Jika sedang aktif, langsung cancel
            cancelQuickAddMode();
        } else {
            // Jika tidak aktif, tampilkan pilihan type
            showQuickAddTypeSelection();
        }
    });

    // Map click event for waypoints and quick add
    map.on('click', function (e) {
        if (cableRoutingMode) {
            handleMapClickForRouting(e);
        } else if (quickAddMode) {
            handleQuickAddClick(e);
        }
    });
}

function setupMarkerClickHandlers() {
    // Add click handlers to all marker divs
    setTimeout(() => {
        var markerDivs = document.querySelectorAll(
            '.router-marker, .odc-marker, .odp-marker, .customer-marker, .pole-marker');

        markerDivs.forEach(div => {
            div.addEventListener('click', function (e) {
                if (cableRoutingMode) {
                    e.stopPropagation();
                    var type = this.getAttribute('data-type');
                    var id = this.getAttribute('data-id');
                    var name = this.getAttribute('data-name');
                    var coords = this.getAttribute('data-coords');

                    handleMarkerClickForRouting(type, id, name, coords);
                }
            });
        });
    }, 2000);
}

// Start cable routing mode
function startCableRouting() {
    cableRoutingMode = true;
    routingFromPoint = null;
    routingToPoint = null;
    currentWaypoints = [];

    // Update toggle button to cancel state
    const toggleBtn = document.getElementById('toggle-routing');
    if (toggleBtn) {
        toggleBtn.className = 'nav-btn nav-btn-danger';
        toggleBtn.title = 'Cancel Cable Routing';
        toggleBtn.innerHTML = '<i class="fa fa-times"></i>'; // UBAH ICON KE X
        // Keep same icon, just change color
    }

    const undoBtn = document.getElementById('undo-waypoint');
    if (undoBtn) undoBtn.disabled = true; // Initially disabled until we have waypoints

    const cableSelector = document.getElementById('cable-type-selector');
    if (cableSelector) cableSelector.style.display = 'block';

    const indicator = document.getElementById('routing-mode-indicator');
    if (indicator) indicator.style.display = 'inline-block';

    // Add routing mode class to body - AMAN
    if (document.body && document.body.classList) {
        document.body.classList.add('routing-mode-active');
    }

    updateRoutingStatus('🔥 ROUTING MODE ACTIVE! Click on any Router, ODC, ODP, or Customer to start routing...');

    // Show instructions - AMAN
    const cableControls = document.getElementById('cableRoutingControls');
    if (cableControls && cableControls.classList) {
        cableControls.classList.add('in');
    }

    // Show routing connection info - AMAN
    const connectionInfo = document.getElementById('routing-connection-info');
    if (connectionInfo) {
        connectionInfo.style.display = 'block';
    }

    console.log('Cable routing started safely');
}

// Cancel cable routing
function cancelCableRouting() {
    cableRoutingMode = false;
    routingFromPoint = null;
    routingToPoint = null;

    clearWaypoints();

    // Reset toggle button to start state
    const toggleBtn = document.getElementById('toggle-routing');
    if (toggleBtn) {
        toggleBtn.className = 'nav-btn nav-btn-default';
        toggleBtn.title = 'Start Cable Routing';
        toggleBtn.innerHTML = '<i class="fa fa-sitemap"></i>'; // Kembali ke icon cable
        // Keep same icon, just change color back
    }

    const undoBtn = document.getElementById('undo-waypoint');
    if (undoBtn) undoBtn.disabled = true;

    const cableSelector = document.getElementById('cable-type-selector');
    if (cableSelector) cableSelector.style.display = 'none';

    const indicator = document.getElementById('routing-mode-indicator');
    if (indicator) indicator.style.display = 'none';

    // Remove routing mode class - AMAN
    if (document.body && document.body.classList) {
        document.body.classList.remove('routing-mode-active');
    }

    removeActiveClasses();
    updateRoutingStatus('Ready for new cable routing');
    hideRoutingStatus();
}

// Clear waypoints
function clearWaypoints() {
    currentWaypoints = [];

    // Remove waypoint markers
    waypointMarkers.forEach(marker => {
        map.removeLayer(marker);
    });
    waypointMarkers = [];

    // Remove temp polyline
    if (tempPolyline) {
        map.removeLayer(tempPolyline);
        tempPolyline = null;
    }
}
// Undo last waypoint (not including start/end points)
function undoLastWaypoint() {
    if (!cableRoutingMode || currentWaypoints.length <= 1) return;

    // Don't remove start point (first waypoint)
    if (currentWaypoints.length > 1) {
        // Remove last waypoint
        currentWaypoints.pop();

        // Remove corresponding marker
        if (waypointMarkers.length > 0) {
            var lastMarker = waypointMarkers.pop();
            map.removeLayer(lastMarker);
        }

        // Update temp polyline
        updateTempPolyline();

        // Update waypoint numbers
        updateWaypointNumbers();

        // Disable undo button if only start point remains
        if (currentWaypoints.length <= 1) {
            document.getElementById('undo-waypoint').disabled = true;
        }

        updateRoutingStatus('Undid last waypoint. Current waypoints: ' +
            (currentWaypoints.length - 1) + '. Continue adding waypoints or click destination.');
    }
}

// Handle map click for routing - DIPERBAIKI
function handleMapClickForRouting(e) {
    if (!cableRoutingMode || !routingFromPoint) return;

    // Add waypoint
    var waypoint = {
        lat: e.latlng.lat,
        lng: e.latlng.lng
    };

    currentWaypoints.push(waypoint);

    // Add waypoint marker - DIPERBAIKI
    var waypointIcon = L.divIcon({
        className: 'custom-div-icon',
        html: '<div class="waypoint-marker">' + (currentWaypoints.length - 1) + '</div>',
        iconSize: [20, 20],
        iconAnchor: [10, 10]
    });

    var marker = L.marker([waypoint.lat, waypoint.lng], {
        icon: waypointIcon,
        zIndexOffset: 6000
    }).addTo(map);

    // Add right-click to remove waypoint
    marker.on('contextmenu', function () {
        removeWaypoint(marker, waypoint);
    });

    waypointMarkers.push(marker);

    // Update temp polyline
    updateTempPolyline();

    // Enable undo button when we have waypoints to undo
    if (currentWaypoints.length > 1) {
        document.getElementById('undo-waypoint').disabled = false;
    }

    updateRoutingStatus('Added waypoint ' + (currentWaypoints.length - 1) +
        '. Continue adding waypoints or click destination to finish.');
}

// Remove waypoint
function removeWaypoint(marker, waypoint) {
    var index = currentWaypoints.indexOf(waypoint);
    if (index > 0 && index < currentWaypoints.length - 1) { // Don't remove start/end points
        currentWaypoints.splice(index, 1);
        map.removeLayer(marker);

        var markerIndex = waypointMarkers.indexOf(marker);
        if (markerIndex > -1) {
            waypointMarkers.splice(markerIndex, 1);
        }

        updateTempPolyline();
        updateWaypointNumbers();
    }
}

// Update waypoint numbers - DIPERBAIKI
function updateWaypointNumbers() {
    waypointMarkers.forEach(function (marker, index) {
        var icon = L.divIcon({
            className: 'custom-div-icon',
            html: '<div class="waypoint-marker">' + index + '</div>',
            iconSize: [20, 20],
            iconAnchor: [10, 10]
        });
        marker.setIcon(icon);
    });
}

// Enhanced cable color system based on connection type
function getCableColorByConnection(fromType, toType, cableType) {
    // TAMBAHAN BARU: Determine actual connection ignoring poles
    var actualConnection = determineActualConnection(fromType, toType);

    // Define connection hierarchy colors
    const connectionColors = {
        // Router connections (Backbone - Thick lines)
        'router-router': '#ff0000', // Red - Core network
        'router-odc': '#ff6600', // Orange - Primary distribution

        // ODC connections (Distribution - Medium lines)
        'odc-odc': '#ffaa00', // Orange-Yellow - Distribution ring
        'odc-odp': '#00aa00', // Green - Secondary distribution

        // ODP connections (Access - Thin lines)
        'odp-odp': '#00dd00', // Light Green - Access ring
        'odp-customer': '#0066ff', // Blue - Customer connection

        // Customer connections
        'customer-customer': '#6600ff', // Purple - Peer connections

        // Reverse connections (same colors)
        'odc-router': '#ff6600',
        'odp-odc': '#00aa00',
        'customer-odp': '#0066ff',

        // Pole connections (transparent/waypoint style)
        'pole-pole': '#cccccc', // Light gray for pole-to-pole
        'router-pole': '#ff6600', // Use destination type color
        'odc-pole': '#00aa00',
        'odp-pole': '#0066ff',
        'pole-router': '#ff6600',
        'pole-odc': '#00aa00',
        'pole-odp': '#0066ff',
        'pole-customer': '#0066ff',
        'customer-pole': '#0066ff',

        // Default fallback
        'default': '#888888' // Gray
    };

    return connectionColors[actualConnection] || connectionColors['default'];
}

// TAMBAHAN BARU: Determine actual connection type ignoring poles
function determineActualConnection(fromType, toType) {
    // If neither is pole, return as-is
    if (fromType !== 'pole' && toType !== 'pole') {
        return fromType + '-' + toType;
    }

    // If one is pole, use a neutral waypoint color logic
    // This ensures poles don't change the fundamental connection color
    if (fromType === 'pole' || toType === 'pole') {
        // For display purposes, treat as the non-pole type
        var nonPoleType = fromType === 'pole' ? toType : fromType;

        // Return a connection that maintains the original color scheme
        // but indicates it passes through a pole
        return fromType + '-' + toType; // This will use pole-specific colors
    }

    return fromType + '-' + toType;
}

// Get cable width based on connection type
function getCableWidthByConnection(fromType, toType) {
    const connectionWidths = {
        'router-router': 8, // Backbone - thickest
        'router-odc': 6, // Primary distribution
        'odc-router': 6,
        'odc-odc': 5, // Distribution ring
        'odc-odp': 4, // Secondary distribution
        'odp-odc': 4,
        'odp-odp': 3, // Access ring
        'odp-customer': 3, // Customer connection
        'customer-odp': 3,
        'customer-customer': 2, // Peer connections
        'default': 3
    };

    const connectionKey = fromType + '-' + toType;
    return connectionWidths[connectionKey] || connectionWidths['default'];
}

// Get human-readable connection type name
function getConnectionTypeName(fromType, toType) {
    const connectionNames = {
        'router-router': 'Backbone Connection',
        'router-odc': 'Primary Distribution',
        'odc-router': 'Primary Distribution',
        'odc-odc': 'Distribution Ring',
        'odc-odp': 'Secondary Distribution',
        'odp-odc': 'Secondary Distribution',
        'odp-odp': 'Access Ring',
        'odp-customer': 'Customer Access',
        'customer-odp': 'Customer Access',
        'customer-customer': 'Peer Connection',
        'default': 'Unknown Connection'
    };

    const connectionKey = fromType + '-' + toType;
    return connectionNames[connectionKey] || connectionNames['default'];
}

// Get connection category for statistics
function getConnectionCategory(fromType, toType) {
    var connectionKey = fromType + '-' + toType;

    var categories = {
        'router-router': 'backbone',
        'router-odc': 'primary',
        'odc-router': 'primary',
        'odc-odc': 'distribution',
        'odc-odp': 'distribution',
        'odp-odc': 'distribution',
        'odp-odp': 'access',
        'odp-customer': 'access',
        'customer-odp': 'access',
        'customer-customer': 'access'
    };

    return categories[connectionKey] || 'access';
}

function setupLayerControls() {
    var showRouters = document.getElementById('show-routers');
    var showOdcs = document.getElementById('show-odcs');
    var showOdps = document.getElementById('show-odps');
    var showCustomers = document.getElementById('show-customers');
    var showCables = document.getElementById('show-cables');
    var showCoverage = document.getElementById('show-coverage');

    if (showRouters) {
        showRouters.addEventListener('change', function () {
            if (this.checked) {
                map.addLayer(markersGroup.routers);
            } else {
                map.removeLayer(markersGroup.routers);
            }
        });
    }

    if (showOdcs) {
        showOdcs.addEventListener('change', function () {
            if (this.checked) {
                map.addLayer(markersGroup.odcs);
            } else {
                map.removeLayer(markersGroup.odcs);
            }
        });
    }

    if (showOdps) {
        showOdps.addEventListener('change', function () {
            if (this.checked) {
                map.addLayer(markersGroup.odps);
            } else {
                map.removeLayer(markersGroup.odps);
            }
        });
    }

    if (showCustomers) {
        showCustomers.addEventListener('change', function () {
            if (this.checked) {
                map.addLayer(markersGroup.customers);
            } else {
                map.removeLayer(markersGroup.customers);
            }
        });
    }

    if (showCables) {
        showCables.addEventListener('change', function () {
            if (this.checked) {
                map.addLayer(cablesLayerGroup);
                document.getElementById('toggle-cables').innerHTML =
                    '<i class="fa fa-eye-slash"></i> Hide Cables';
                document.getElementById('toggle-cables').className = 'btn btn-default';
            } else {
                map.removeLayer(cablesLayerGroup);
                document.getElementById('toggle-cables').innerHTML =
                    '<i class="fa fa-eye"></i> Show Cables';
                document.getElementById('toggle-cables').className = 'btn btn-success';
            }
        });
    }

    if (showCoverage) {
        showCoverage.addEventListener('change', function () {
            // Toggle coverage circles
            markersGroup.routers.eachLayer(function (layer) {
                if (layer instanceof L.Circle) {
                    if (this.checked) {
                        layer.setStyle({ opacity: 1, fillOpacity: 0.1 });
                    } else {
                        layer.setStyle({ opacity: 0, fillOpacity: 0 });
                    }
                }
            }.bind(this));
        });
    }

    // TAMBAHAN BARU UNTUK POLES
    var showPoles = document.getElementById('show-poles');
    if (showPoles) {
        showPoles.addEventListener('change', function () {
            if (this.checked) {
                map.addLayer(markersGroup.poles);
            } else {
                map.removeLayer(markersGroup.poles);
            }
        });
    }
}
