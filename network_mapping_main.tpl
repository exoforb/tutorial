{include file="sections/header.tpl"}

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- Network Mapping CSS Files -->
<link rel="stylesheet" href="/system/plugin/ui/css/base.css?v={$smarty.now}" />
<link rel="stylesheet" href="/system/plugin/ui/css/modal-addpole.css?v={$smarty.now}" />
<link rel="stylesheet" href="/system/plugin/ui/css/modal-disconnect.css?v={$smarty.now}" />
<link rel="stylesheet" href="/system/plugin/ui/css/modal-editpole.css?v={$smarty.now}" />
<link rel="stylesheet" href="/system/plugin/ui/css/modal-editolt.css?v={$smarty.now}" />
<link rel="stylesheet" href="/system/plugin/ui/css/modal-odc.css?v={$smarty.now}" />
<link rel="stylesheet" href="/system/plugin/ui/css/modal-odp.css?v={$smarty.now}" />


<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                <i class="ion ion-ios-location"></i> Mapping Jaringan FFTH
                <div class="pull-right">
                    <div class="btn-group">
                        <a href="{$_url}plugin/network_mapping/add-odc" class="btn btn-success btn-xs">
                            <i class="fa fa-plus"></i> Tambah ODC
                        </a>
                        <a href="{$_url}plugin/network_mapping/add-odp" class="btn btn-info btn-xs">
                            <i class="fa fa-plus"></i> Tambah ODP
                        </a>
                        <a href="{$_url}plugin/network_mapping/odc" class="btn btn-warning btn-xs">
                            <i class="fa fa-list"></i> List ODC
                        </a>
                        <a href="{$_url}plugin/network_mapping/odp" class="btn btn-primary btn-xs">
                            <i class="fa fa-list"></i> List ODP
                        </a>
                    </div>
                </div>
            </div>

            <div class="panel-body">
                <div class="row" style="margin-bottom: 20px;">
                    <div class="col-md-3 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #007bff; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa fa-server"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    {$stats.total_routers}
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    Mikrotik
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #e74c3c; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa-solid fa-broadcast-tower"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    {$stats.total_olts}
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    OLT
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #28a745; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa-solid fa-tower-cell"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    {$stats.total_odcs}
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    ODC
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #ffc107; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa-solid fa-circle-nodes"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    {$stats.total_odps}
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    ODP
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #17a2b8; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa fa-users"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    {$stats.total_customers}
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    Client
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Baris 2: 3 Stats terakhir (4×3=12 kolom) -->
                <div class="row" style="margin-bottom: 20px;">
                    <div class="col-md-4 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #6f42c1; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa fa-map-pin"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    {$stats.total_poles}
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    Tiang
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #dc3545; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa fa-sitemap"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    <span id="cable-count">{if $cables_data}{count($cables_data)}{else}0{/if}</span>
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    Rute Kabel
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="panel panel-default">
                            <div class="panel-body text-center" style="padding: 15px;">
                                <div class="stat-icon" style="color: #6c757d; font-size: 24px; margin-bottom: 8px;">
                                    <i class="fa fa-road"></i>
                                </div>
                                <div class="stat-number"
                                    style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">
                                    <span id="total-cable-length">0</span>m
                                </div>
                                <div class="stat-label"
                                    style="font-size: 12px; opacity: 0.7; text-transform: uppercase;">
                                    Panjang Kabel
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-12">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a data-toggle="collapse" href="#cableLegend">
                                        <i class="fa fa-palette"></i> Statistik Kabel
                                    </a>
                                </h4>
                            </div>
                            <div id="cableLegend" class="panel-collapse collapse in">
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h5><i class="fa fa-info-circle"></i> Type Kabel</h5>
                                            <div class="cable-legend">
                                                <div class="legend-item">
                                                    <div class="legend-line" style="background: #ff0000; height: 4px;">
                                                    </div>
                                                    <span><strong>Router ↔ Router</strong> - Core Backbone (Red)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line" style="background: #ff3300; height: 4px;">
                                                    </div>
                                                    <span><strong>Router → OLT</strong> - Uplink Connection
                                                        (Red-orange)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line" style="background: #cc0000; height: 4px;">
                                                    </div>
                                                    <span><strong>OLT ↔ OLT</strong> - Cascade Connection (Dark
                                                        red)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line" style="background: #ff6600; height: 4px;">
                                                    </div>
                                                    <span><strong>OLT → ODC</strong> - PON Distribution (Orange)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line" style="background: #00aa00; height: 4px;">
                                                    </div>
                                                    <span><strong>ODC → ODP</strong> - Secondary Distribution
                                                        (Green)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line" style="background: #0066ff; height: 4px;">
                                                    </div>
                                                    <span><strong>ODP → Customer</strong> - Customer Access
                                                        (Blue)</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <h5><i class="fa fa-bar-chart"></i> Statistik Metrik Kabel</h5>
                                            <div class="cable-stats" id="cable-statistics">
                                                <div class="cable-stat-item stat-backbone">
                                                    <div class="stat-number" id="backbone-count">0</div>
                                                    <div class="stat-label">Backbone</div>
                                                </div>
                                                <div class="cable-stat-item stat-primary">
                                                    <div class="stat-number" id="primary-count">0</div>
                                                    <div class="stat-label">Feeder</div>
                                                </div>
                                                <div class="cable-stat-item stat-distribution">
                                                    <div class="stat-number" id="distribution-count">0</div>
                                                    <div class="stat-label">Distribusi</div>
                                                </div>
                                                <div class="cable-stat-item stat-access">
                                                    <div class="stat-number" id="access-count">0</div>
                                                    <div class="stat-label">Drop Core</div>
                                                </div>
                                            </div>

                                            <div style="margin-top: 15px;">
                                                <h6><i class="fa fa-ruler"></i> Total Cable Length by Type</h6>
                                                <div class="progress" style="margin-bottom: 5px;">
                                                    <div id="backbone-progress" class="progress-bar"
                                                        style="background: linear-gradient(90deg, #ff0000 0%, #cc0000 100%); width: 0%"
                                                        title="Backbone: Router-Router, OLT-OLT"></div>
                                                    <div id="primary-progress" class="progress-bar"
                                                        style="background: linear-gradient(90deg, #ff3300 0%, #ff6600 100%); width: 0%"
                                                        title="Primary: Router-OLT, OLT-ODC"></div>
                                                    <div id="distribution-progress" class="progress-bar"
                                                        style="background-color: #00aa00; width: 0%"
                                                        title="Distribution: ODC-ODP, ODC-ODC"></div>
                                                    <div id="access-progress" class="progress-bar"
                                                        style="background-color: #0066ff; width: 0%"
                                                        title="Access: ODP-Customer, ODP-ODP"></div>
                                                </div>
                                                <div class="text-center">
                                                    <small>
                                                        <span style="color: #ff0000;">■</span> Backbone: <span
                                                            id="backbone-length">0m</span>
                                                        <small>(Router-Router, OLT-OLT)</small> |
                                                        <span style="color: #ff6600;">■</span> Primary: <span
                                                            id="primary-length">0m</span>
                                                        <small>(Router-OLT, OLT-ODC)</small> |
                                                        <span style="color: #00aa00;">■</span> Distribution: <span
                                                            id="distribution-length">0m</span>
                                                        <small>(ODC-ODP)</small> |
                                                        <span style="color: #0066ff;">■</span> Access: <span
                                                            id="access-length">0m</span>
                                                        <small>(ODP-Customer)</small>
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="live-search-container" style="margin-bottom: 20px;">
                    <div class="input-group">
                        <div class="input-group-addon">
                            <span class="fa fa-search"></span>
                        </div>
                        <input type="text" id="live-search-input" class="form-control"
                            placeholder="Search routers, ODC, ODP, customers...">
                        <div class="input-group-btn">
                            <button class="btn btn-info" type="button" id="clear-search">
                                <i class="fa fa-times"></i> Clear
                            </button>
                        </div>
                    </div>
                    <div id="search-results" style="display: none; position: relative; z-index: 1000;"></div>
                </div>
                <div id="map" class="well" style="width: 100%; height: 70vh; margin: 20px auto; position: relative;">
                    <div id="loading"
                        style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 1000;">
                        <i class="fa fa-spinner fa-spin fa-3x"></i>
                        <br><br>Loading map...
                    </div>

                    <!-- MAP NAVIGATION CONTROLS -->
                    <div class="map-navigation-panel" id="mapNavPanel">
                        <div class="nav-toggle" id="navToggle">
                            <i class="fa fa-chevron-left"></i>
                        </div>

                        <!-- Navigation Content -->
                        <div class="nav-content" id="navContent">
                            <!-- Section 1: Cable Routing Controls -->
                            <div class="nav-section" id="cable-controls">
                                <div class="nav-header">
                                    <i class="fa fa-sitemap"></i> Cable Routing
                                    <span class="badge nav-indicator" id="routing-mode-indicator"
                                        style="display: none;">Routing</span>
                                </div>
                                <div class="nav-buttons">
                                    <button type="button" id="toggle-routing" class="nav-btn nav-btn-default"
                                        title="Start Cable Routing">
                                        <i class="fa fa-sitemap"></i>
                                    </button>
                                    <button type="button" id="undo-waypoint" class="nav-btn nav-btn-warning" disabled
                                        title="Undo Last Waypoint">
                                        <i class="fa fa-undo"></i>
                                    </button>
                                    <button type="button" id="quick-add-mode" class="nav-btn nav-btn-success"
                                        title="Quick Add Mode">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </div>
                                <div id="quick-add-info" style="display: none; margin-top: 8px;">
                                    <div class="nav-alert nav-alert-success">
                                        <strong><i class="fa fa-plus"></i> Quick Add Active</strong><br>
                                        <small>Click map to add ODC/ODP/Pole</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 2: View All Data -->
                            <div class="nav-section" id="view-controls">
                                <div class="nav-header">
                                    <i class="fa fa-eye"></i> View All Data
                                </div>
                                <div class="nav-buttons nav-buttons-grid">
                                    <button type="button" id="view-cables"
                                        class="nav-btn nav-btn-default nav-btn-with-text" title="View All Cables">
                                        <i class="fa fa-plug"></i>
                                        <span>Cables</span>
                                    </button>
                                    <button type="button" id="view-poles"
                                        class="nav-btn nav-btn-purple nav-btn-with-text" title="View All Poles">
                                        <i class="fa fa-map-pin"></i>
                                        <span>Poles</span>
                                    </button>
                                    <button type="button" id="view-customers"
                                        class="nav-btn nav-btn-info nav-btn-with-text" title="View All Customers">
                                        <i class="fa fa-users"></i>
                                        <span>Customers</span>
                                    </button>
                                </div>
                            </div>

                            <!-- Layer Controls -->
                            <div class="nav-section" id="layer-controls">
                                <div class="nav-header">
                                    <i class="fa fa-eye"></i> Icon Layer
                                </div>
                                <div class="nav-checkboxes">
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-routers" checked>
                                        <i class="fa fa-server text-primary"></i> Routers
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-olts" checked>
                                        <i class="fa-solid fa-broadcast-tower text-danger"></i> OLTs
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-odcs" checked>
                                        <i class="fa fa-cube text-success"></i> ODCs
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-odps" checked>
                                        <i class="fa fa-circle-o text-warning"></i> ODPs
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-customers" checked>
                                        <i class="fa fa-user text-info"></i> Customers
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-cables" checked>
                                        <i class="fa fa-minus text-danger"></i> Cables
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-poles" checked>
                                        <i class="fa fa-map-pin text-secondary"></i> Poles
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-coverage" checked>
                                        <i class="fa fa-circle-o text-muted"></i> Coverage
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Set data from PHP
    var baseUrl = '{$_url}';
    console.log('Base URL is:', baseUrl);
    var networkData = {$network_data|json_encode};
    var cablesData = {if $cables_data}{$cables_data|json_encode}{else}[]{/if};

    {literal}
        // Cable Routing Variables
        var map;
        var markersGroup = {
            routers: L.layerGroup(),
            olts: L.layerGroup(), // TAMBAHAN BARU
            odcs: L.layerGroup(),
            odps: L.layerGroup(),
            customers: L.layerGroup(),
            poles: L.layerGroup()
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
            savePosition: function() {
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
            loadPosition: function() {
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
            clearPosition: function() {
                try {
                    localStorage.removeItem(this.storageKey);
                    console.log('Map position cleared');
                } catch (e) {
                    console.warn('Could not clear map position:', e);
                }
            }
        };


        function editOdcFromMap(id) {
            var protocol = window.location.protocol;
            var host = window.location.host;
            var editUrl = protocol + '//' + host + '/?_route=plugin/network_mapping/edit-odc&id=' + id + '&from_map=1';

            console.log('Edit ODC from map, ID:', id);
            window.location.href = editUrl;
        }

        function editOdpFromMap(id) {
            var protocol = window.location.protocol;
            var host = window.location.host;
            var editUrl = protocol + '//' + host + '/?_route=plugin/network_mapping/edit-odp&id=' + id + '&from_map=1';

            console.log('Edit ODP from map, ID:', id);
            window.location.href = editUrl;
        }

        function getLocation() {
            document.getElementById('loading').style.display = 'block';

            // Cek apakah ada posisi tersimpan
            var savedPosition = mapPositionMemory.loadPosition();

            if (window.location.protocol == "https:" && navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    function(position) {
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
                    function() {
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
        map.on('zoomend', function() {
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
    var layerControl = L.control({position: 'topright'});
    layerControl.onAdd = function(map) {
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
    setTimeout(function() {
        var container = document.getElementById('layerControlContainer');
        var toggle = document.getElementById('layerControlToggle');
        var options = document.querySelectorAll('.layer-option');

        if (!container || !toggle) {
            console.error('Layer control elements not found');
            return;
        }

        // Toggle expand/collapse
        toggle.addEventListener('click', function(e) {
            e.stopPropagation();
            console.log('Layer control clicked');
            container.classList.toggle('expanded');
        });

        // Close when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.custom-layer-control')) {
                container.classList.remove('expanded');
            }
        });

        // Handle option selection
        options.forEach(function(option) {
            option.addEventListener('click', function(e) {
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
        saveTimeout = setTimeout(function() {
            mapPositionMemory.savePosition();
        }, 1000); // Save 1 detik setelah user berhenti move/zoom
    }

    map.on('moveend', debouncedSave);
    map.on('zoomend', debouncedSave);

    // Save position juga saat user interact dengan map
    map.on('click', function() {
        setTimeout(function() {
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
        setTimeout(function() {
            notification.style.opacity = '1';
            notification.style.transform = 'translateX(0)';
        }, 100);

        // Auto remove after 3 seconds
        setTimeout(function() {
            if (notification && notification.parentNode) {
                notification.style.opacity = '0';
                notification.style.transform = 'translateX(100px)';
                setTimeout(function() {
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
            networkData.routers.forEach(function(router) {
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

            // Add OLTs with IMPROVED ICONS AND Z-INDEX
            if (networkData.olts) {
                networkData.olts.forEach(function(olt) {
                    var coords = olt.coordinates.split(',').map(parseFloat);
                    allCoordinates.push(coords);

                    var oltIcon = L.divIcon({
                        className: 'custom-div-icon',
                        html: '<div class="olt-marker" data-type="olt" data-id="' + olt.id +
                            '" data-name="' + olt.name + '" data-coords="' + olt.coordinates +
                            '"><i class="fa-solid fa-broadcast-tower"></i></div>',
                        iconSize: [30, 30],
                        iconAnchor: [15, 15],
                        popupAnchor: [0, -15]
                    });

                    var marker = L.marker(coords, {
                        icon: oltIcon,
                        zIndexOffset: 9500
                    }).addTo(markersGroup.olts);

                    // Enhanced popup with routing button
                    var popupContent = olt.popup_content;

                    // ✅ Add Route Cable if not exists
                    if (popupContent.indexOf('Route Cable') === -1) {
                        if (popupContent.indexOf('showOltDetail') !== -1) {
                            popupContent = popupContent.replace(
                                '<a href=\'javascript:void(0)\' onclick=\'showOltDetail(' + olt.id +
                                ')\'>Detail</a>',
                                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("olt", ' + olt
                                .id + ', "' + olt.name + '", "' + olt.coordinates + '")\'>Route Cable</a> | ' +
                                '<a href=\'javascript:void(0)\' onclick=\'showOltDetail(' + olt.id +
                                ')\'>Detail</a>'
                            );
                        } else {
                            popupContent +=
                                '<br><a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("olt", ' + olt
                                .id + ', "' + olt.name + '", "' + olt.coordinates +
                                '")\' class="route-cable-link">Route Cable</a>';
                        }
                    }

                    marker.bindPopup(popupContent);
                    marker.bindTooltip(olt.name + ' (U:' + olt.available_uplink_ports + '/P:' + olt
                        .available_pon_ports + ')', {
                            permanent: false,
                            direction: 'top'
                        });

                    // Store marker reference
                    allMarkers['olt_' + olt.id] = {
                        marker: marker,
                        data: olt,
                        type: 'olt'
                    };
                });
            }

            // Add ODCs with IMPROVED ICONS AND Z-INDEX
            if (networkData.odcs) {
                networkData.odcs.forEach(function(odc) {
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
                networkData.odps.forEach(function(odp) {
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
                networkData.customers.forEach(function(customer) {
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
                        setTimeout(function() {
                            mapPositionMemory.savePosition();
                        }, 1000);
                    }
                } else {
                    console.log('Using saved position, skipping auto-fit');
                }
            }

            // Add poles with IMPROVED ICONS AND Z-INDEX
            if (networkData.poles) {
                networkData.poles.forEach(function(pole) {
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
            setTimeout(function() {
                updateAllPopupsWithCableStatus();
            }, 1000);
        }

        function initializeCableRouting() {
            loadExistingCables();
            setupCableRoutingEvents();
            setupMarkerClickHandlers();

            // Update popups after cables loaded
            setTimeout(function() {
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

            cableRoutes.forEach(function(cable) {
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

        // Get cable color based on type
        function getCableColor(cableType) {
            switch (cableType) {
                case 'fiber_optic':
                    return '#007bff';
                case 'copper':
                    return '#ffc107';
                case 'coaxial':
                    return '#28a745';
                default:
                    return '#6c757d';
            }
        }

        // Calculate cable length
        function calculateCableLength(waypoints) {
            if (waypoints.length < 2) return 0;

            var totalLength = 0;
            for (var i = 0; i < waypoints.length - 1; i++) {
                var from = L.latLng(waypoints[i].lat, waypoints[i].lng);
                var to = L.latLng(waypoints[i + 1].lat, waypoints[i + 1].lng);
                totalLength += from.distanceTo(to);
            }
            return totalLength;
        }

        // Setup cable routing event handlers
        function setupCableRoutingEvents() {
            // Toggle routing button (Start/Cancel)
            document.getElementById('toggle-routing').addEventListener('click', function() {
                if (cableRoutingMode) {
                    cancelCableRouting();
                } else {
                    startCableRouting();
                }
            });

            // Undo waypoint button
            document.getElementById('undo-waypoint').addEventListener('click', function() {
                undoLastWaypoint();
            });

            // View cables button
            document.getElementById('view-cables').addEventListener('click', function() {
                showAllCables();
            });
            // View poles button
            document.getElementById('view-poles').addEventListener('click', function() {
                showAllPoles();
            });
            // View customers button
            document.getElementById('view-customers').addEventListener('click', function() {
                showAllCustomers();
            });

            // Quick add button - TOGGLE BEHAVIOR
            document.getElementById('quick-add-mode').addEventListener('click', function() {
                if (quickAddMode) {
                    // Jika sedang aktif, langsung cancel
                    cancelQuickAddMode();
                } else {
                    // Jika tidak aktif, tampilkan pilihan type
                    showQuickAddTypeSelection();
                }
            });

            // Map click event for waypoints and quick add
            map.on('click', function(e) {
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
                    '.router-marker, .olt-marker, .odc-marker, .odp-marker, .customer-marker, .pole-marker');

                markerDivs.forEach(div => {
                    div.addEventListener('click', function(e) {
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
        marker.on('contextmenu', function() {
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
            waypointMarkers.forEach(function(marker, index) {
                var icon = L.divIcon({
                    className: 'custom-div-icon',
                    html: '<div class="waypoint-marker">' + index + '</div>',
                    iconSize: [20, 20],
                    iconAnchor: [10, 10]
                });
                marker.setIcon(icon);
            });
        }

        // Update temporary polyline
        function updateTempPolyline() {
            if (tempPolyline) {
                map.removeLayer(tempPolyline);
            }

            if (currentWaypoints.length >= 2) {
                var coordinates = currentWaypoints.map(wp => [wp.lat, wp.lng]);

                tempPolyline = L.polyline(coordinates, {
                    color: '#ff6b6b',
                    weight: 4,
                    opacity: 0.8,
                    dashArray: '10, 10',
                    className: 'cable-temp'
                }).addTo(map);
            }
        }

        function handleMarkerClickForRouting(type, id, name, coordinates) {
            console.log('DEBUG: handleMarkerClickForRouting called with:', {type, id, name, coordinates});
            console.log('DEBUG: cableRoutingMode:', cableRoutingMode);
            console.log('DEBUG: routingFromPoint:', routingFromPoint);

            if (!cableRoutingMode) {
                console.log('DEBUG: Not in cable routing mode, returning');
                return;
            }

            var coords = coordinates.split(',').map(parseFloat);
            var point = {
                type: type,
                id: id,
                name: name,
                lat: coords[0],
                lng: coords[1]
            };

            // TAMBAHAN BARU: Handle pole clicks as waypoints only
            if (type === 'pole') {
                console.log('DEBUG: Pole clicked - adding as waypoint');

                if (!routingFromPoint) {
                    // Cannot start routing from pole
                    Swal.fire({
                        icon: 'info',
                        title: 'Poles are Waypoints Only',
                        html: '<p>Poles serve as <strong>waypoints/bridges</strong> in cable routing.</p>' +
                            '<p>Please start routing from:</p>' +
                            '<ul><li>Router</li><li>ODC</li><li>ODP</li><li>Customer</li></ul>',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#007bff'
                    });
                    return;
                }
                // ✅ PASTIKAN OLT DI-HANDLE SAMA SEPERTI ODC
                // OLT, ODC, ODP, Customer semuanya bisa jadi endpoint
                if (['router', 'olt', 'odc', 'odp', 'customer'].includes(type)) {
                    if (!routingFromPoint) {
                        // First point selected
                        routingFromPoint = point;
                        currentWaypoints = [{ lat: point.lat, lng: point.lng }];

                        addActiveClass(type, id);
                        updateRoutingStatus('📍 Starting from "' + name +
                            '". Now click destination or add waypoints.');
                    } else if (routingFromPoint.type === type && routingFromPoint.id == id) {
                        // Same point - show error
                        Swal.fire({
                            icon: 'error',
                            title: 'Invalid Destination!',
                            text: 'Cannot create cable route to the same point!'
                        });
                        return;
                    } else {
                        // Valid destination - save route
                        routingToPoint = point;
                        currentWaypoints.push({ lat: point.lat, lng: point.lng });

                        addActiveClass(type, id);
                        saveCableRoute(); // ✅ Langsung save tanpa buka popup
                    }
                }

                // Add pole as waypoint
                currentWaypoints.push({ lat: point.lat, lng: point.lng });

                // Add visual waypoint marker
                var waypointIcon = L.divIcon({
                    className: 'custom-div-icon',
                    html: '<div class="waypoint-marker">' + (currentWaypoints.length - 1) + '</div>',
                    iconSize: [20, 20],
                    iconAnchor: [10, 10]
                });

                var marker = L.marker([point.lat, point.lng], {
                    icon: waypointIcon,
                    zIndexOffset: 6000
                }).addTo(map);

                waypointMarkers.push(marker);

                // Update temp polyline
                updateTempPolyline();

                // Enable undo button
                if (currentWaypoints.length > 1) {
                    document.getElementById('undo-waypoint').disabled = false;
                }

                // Add visual feedback to pole
                addActiveClass(type, id);

                updateRoutingStatus('📍 Added pole "' + name + '" as waypoint ' + (currentWaypoints.length - 1) +
                    '. Continue adding waypoints or click final destination.');

                // Show notification that pole was added as waypoint
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'success',
                    title: 'Pole Added as Waypoint',
                    text: name + ' (Waypoint ' + (currentWaypoints.length - 1) + ')',
                    showConfirmButton: false,
                    timer: 2000,
                    timerProgressBar: true
                });

                return;
            }

            if (!routingFromPoint) {
                console.log('DEBUG: Setting first point:', point);
                // First point selected
                routingFromPoint = point;
                currentWaypoints = [{ lat: point.lat, lng: point.lng }];

                // Add active class to marker
                addActiveClass(type, id);

                updateRoutingStatus('📍 Starting from "' + name +
                    '". Now click on map to add waypoints (cable bends), or click poles as bridges, then click destination.<br>' +
                    '<span style="color: #6f42c1;">💡 Poles act as waypoints and won\'t be cable endpoints!</span>');
            } else if (routingFromPoint.type === type && routingFromPoint.id == id) {
                console.log('DEBUG: Same point clicked - showing error');
                // Same point clicked - show error
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Destination!',
                    html: '<p>Cannot create cable route to the same point!</p>' +
                        '<p><strong>From:</strong> ' + routingFromPoint.name + ' (' + routingFromPoint.type
                        .toUpperCase() + ')</p>' +
                        '<p><strong>To:</strong> ' + name + ' (' + type.toUpperCase() + ')</p>' +
                        '<p class="text-info">Please select a different destination point.</p>',
                    confirmButtonText: 'Choose Different Point',
                    confirmButtonColor: '#007bff'
                });
                return;
            } else {
                console.log('DEBUG: Setting destination point:', point);
                // Valid destination selected
                routingToPoint = point;
                currentWaypoints.push({ lat: point.lat, lng: point.lng });

                // Add active class to destination marker
                addActiveClass(type, id);

                // Save the cable route
                saveCableRoute();
            }
        }

        // Add active class to marker
        function addActiveClass(type, id) {
            var markerElement = document.querySelector('[data-type="' + type + '"][data-id="' + id + '"]');
            if (markerElement) {
                markerElement.classList.add('routing-active');
            }
        }

        // Remove active classes from all markers
        function removeActiveClasses() {
            var activeMarkers = document.querySelectorAll('.routing-active');
            activeMarkers.forEach(marker => {
                marker.classList.remove('routing-active');
            });
        }

        // Start routing from a specific point (called from popup)
        function startRoutingFromPoint(type, id, name, coordinates) {
            if (!cableRoutingMode) {
                startCableRouting();
            }

            // Close any open popups
            map.closePopup();

            handleMarkerClickForRouting(type, id, name, coordinates);
        }

        // Validate cable route function
        function validateCableRoute(fromPoint, toPoint) {
            // Check if same point
            if (fromPoint.type === toPoint.type && fromPoint.id === toPoint.id) {
                return {
                    valid: false,
                    message: 'Cannot create cable route to the same point!'
                };
            }

            // Check if route already exists
            var existingRoute = cableRoutes.find(function(route) {
                return (route.from_type === fromPoint.type && route.from_id == fromPoint.id &&
                        route.to_type === toPoint.type && route.to_id == toPoint.id) ||
                    (route.from_type === toPoint.type && route.from_id == toPoint.id &&
                        route.to_type === fromPoint.type && route.to_id == fromPoint.id);
            });

            if (existingRoute) {
                return {
                    valid: false,
                    message: 'Cable route already exists between these points!'
                };
            }

            return { valid: true };
        }



        // Save cable route success message - DIPERBAIKI
        function saveCableRoute() {
            if (!routingFromPoint || !routingToPoint || currentWaypoints.length < 2) {
                Swal.fire('Error', 'Invalid routing data', 'error');
                return;
            }

            // TAMBAHAN BARU: Filter out poles from routing endpoints
            if (routingFromPoint.type === 'pole' || routingToPoint.type === 'pole') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Poles are Waypoints Only',
                    html: '<p>Poles cannot be cable endpoints. They serve as waypoints/bridges only.</p>' +
                        '<p>Please select a different start or end point:</p>' +
                        '<ul><li>Router → ODC</li><li>ODC → ODP</li><li>ODP → Customer</li></ul>',
                    confirmButtonText: 'OK'
                });
                return;
            }

            // Validasi cable route
            var validation = validateCableRoute(routingFromPoint, routingToPoint);
            if (!validation.valid) {
                Swal.fire({
                    icon: 'error',
                    title: 'Cannot Create Cable Route',
                    text: validation.message,
                    confirmButtonText: 'OK'
                });
                return;
            }

            // AMAN - cek cable type selector
            var cableTypeElement = document.getElementById('cable-type-selector');
            var cableType = 'fiber_optic'; // default value
            if (cableTypeElement && cableTypeElement.value) {
                cableType = cableTypeElement.value;
            }

            updateRoutingStatus('💾 Saving cable route...');

            // AMAN - cari CSRF token dari berbagai sumber
            var csrfToken = null;

            // Coba cari di berbagai tempat
            var csrfInput = document.querySelector('input[name="csrf_token"]') ||
                document.querySelector('meta[name="csrf-token"]') ||
                document.querySelector('#csrf_token') ||
                document.querySelector('[name="csrf_token"]');

            if (csrfInput) {
                csrfToken = csrfInput.value || csrfInput.getAttribute('content');
            }

            // Jika tidak ada, coba ambil dari form yang ada
            if (!csrfToken) {
                var forms = document.getElementsByTagName('form');
                for (var i = 0; i < forms.length; i++) {
                    var tokenInput = forms[i].querySelector('input[name="csrf_token"]');
                    if (tokenInput && tokenInput.value) {
                        csrfToken = tokenInput.value;
                        break;
                    }
                }
            }

            // Jika masih tidak ada, coba dari template variable
            if (!csrfToken && typeof window.csrfToken !== 'undefined') {
                csrfToken = window.csrfToken;
            }

            console.log('CSRF Token found:', csrfToken ? 'Yes' : 'No');

            var formData = new FormData();

            // Hanya append csrf_token jika ada
            if (csrfToken) {
                formData.append('csrf_token', csrfToken);
            } else {
                console.warn('CSRF token not found, proceeding without it');
            }

            formData.append('from_type', routingFromPoint.type);
            formData.append('from_id', routingFromPoint.id);
            formData.append('to_type', routingToPoint.type);
            formData.append('to_id', routingToPoint.id);
            formData.append('waypoints', JSON.stringify(currentWaypoints));
            formData.append('cable_type', cableType);

            // Debug: Log form data
            console.log('Saving cable route:', {
                from: routingFromPoint.name,
                to: routingToPoint.name,
                waypoints: currentWaypoints.length,
                cableType: cableType,
                hasToken: !!csrfToken
            });

            fetch(baseUrl + 'plugin/network_mapping/save-cable-route', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        // SIMPAN POSISI SEBELUM RELOAD
                        mapPositionMemory.savePosition();

                        Swal.fire({
                            icon: 'success',
                            title: 'Cable Route Saved!',
                            html: '<p><strong>From:</strong> ' + data.from_name + '</p>' +
                                '<p><strong>To:</strong> ' + data.to_name + '</p>' +
                                '<p><strong>Length:</strong> ' + calculateCableLength(currentWaypoints).toFixed(
                                    0) + 'm</p>' +
                                '<p class="text-info"><i class="fa fa-refresh"></i> Map akan tetap di posisi ini setelah reload...</p>',
                            timer: 2000,
                            showConfirmButton: false
                        }).then(() => {
                            // Auto reload page to refresh cable status
                            window.location.reload();
                        });

                        cancelCableRouting();
                    } else {
                        Swal.fire('Error', data.message || 'Unknown error occurred', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error saving cable:', error);
                    Swal.fire('Error', 'Failed to save cable route: ' + error.message, 'error');
                });
        }

        // Delete cable route - FIXED VERSION
        function deleteCableRoute(id) {
            Swal.fire({
                title: 'Delete Cable Route?',
                text: 'This action cannot be undone.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it!',
                confirmButtonColor: '#d33'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Create FormData with CSRF token
                    var formData = new FormData();
                    formData.append('id', id);
                    formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);

                    // Use POST method with proper URL
                    fetch(baseUrl + 'plugin/network_mapping/delete-cable-route', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => {
                            // Check if response is ok first
                            if (!response.ok) {
                                throw new Error('Network response was not ok: ' + response.status);
                            }
                            return response.json();
                        })
                        .then(data => {
                            if (data.success) {
                                Swal.fire('Deleted!', 'Cable route has been deleted.', 'success');
                                loadExistingCables(); // Reload cables

                                // Update cable count
                                var currentCount = parseInt(document.getElementById('cable-count').textContent);
                                document.getElementById('cable-count').textContent = Math.max(0, currentCount -
                                    1);
                            } else {
                                Swal.fire('Error', data.message || 'Unknown error occurred', 'error');
                            }
                        })
                        .catch(error => {
                            console.error('Error deleting cable:', error);
                            Swal.fire('Error', 'Failed to delete cable route: ' + error.message, 'error');
                        });
                }
            });
        }


        function getCableColorByConnection(fromType, toType, cableType) {
            // ✅ SKEMA WARNA FINAL SESUAI PERMINTAAN
            const connectionColors = {
                // 🔴 RED - Core Backbone Network
                'router-router': '#ff0000', // Router → Router (Red)

                // 🟠 RED-ORANGE - Router to OLT Uplink
                'router-olt': '#ff3300', // Router → OLT (Red-orange)
                'olt-router': '#ff3300', // OLT → Router (Red-orange)

                // 🔴 DARK RED - OLT Cascade
                'olt-olt': '#cc0000', // OLT → OLT (Dark red)

                // 🟠 ORANGE - PON Distribution
                'olt-odc': '#ff6600', // OLT → ODC (Orange - PON)
                'odc-olt': '#ff6600', // ODC → OLT (Orange - PON)

                // 🟢 GREEN - Secondary Distribution
                'odc-odc': '#00aa00', // ODC → ODC (Green)
                'odc-odp': '#00aa00', // ODC → ODP (Green)
                'odp-odc': '#00aa00', // ODP → ODC (Green)

                // 🔵 BLUE - Customer Access
                'odp-odp': '#0066ff', // ODP → ODP (Blue)
                'odp-customer': '#0066ff', // ODP → Customer (Blue)
                'customer-odp': '#0066ff', // Customer → ODP (Blue)
                'customer-customer': '#0066ff', // Customer → Customer (Blue)

                // Pole connections (inherit from main connection)
                'router-pole': '#ff3300', // Use router color
                'pole-router': '#ff3300',
                'olt-pole': '#ff6600', // Use OLT color  
                'pole-olt': '#ff6600',
                'odc-pole': '#00aa00', // Use ODC color
                'pole-odc': '#00aa00',
                'odp-pole': '#0066ff', // Use ODP color
                'pole-odp': '#0066ff',
                'pole-pole': '#cccccc', // Gray for pole-to-pole

                // Default fallback
                'default': '#888888' // Gray
            };

            var actualConnection = determineActualConnection(fromType, toType);
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
            // Backbone - Thickest (8-7px)
            'router-router': 8, // 🔴 Core backbone
            'router-olt': 7, // 🟠 Router uplink
            'olt-router': 7, // 🟠 Router uplink
            'olt-olt': 7, // 🔴 OLT cascade

            // Primary Distribution - Medium (6-5px)
            'olt-odc': 6, // 🟠 PON distribution
            'odc-olt': 6, // 🟠 PON distribution

            // Secondary Distribution - Medium (5-4px)
            'odc-odc': 5, // 🟢 ODC ring
            'odc-odp': 5, // 🟢 ODC to ODP
            'odp-odc': 5, // 🟢 ODP to ODC

            // Access - Thin (4-3px)
            'odp-odp': 4, // 🔵 ODP ring
            'odp-customer': 4, // 🔵 Customer access
            'customer-odp': 4, // 🔵 Customer access
            'customer-customer': 3, // 🔵 Customer peer

            // Default
            'default': 4
        };

        const connectionKey = fromType + '-' + toType;
        return connectionWidths[connectionKey] || connectionWidths['default'];
    }

    // 3. ✅ Fix connection type names
    function getConnectionTypeName(fromType, toType) {
        const connectionNames = {
            // 🔴 BACKBONE
            'router-router': 'Core Backbone',
            'olt-olt': 'OLT Cascade',

            // 🟠 PRIMARY  
            'router-olt': 'Router Uplink',
            'olt-router': 'Router Uplink',
            'olt-odc': 'PON Distribution',
            'odc-olt': 'PON Distribution',

            // 🟢 DISTRIBUTION
            'odc-odc': 'ODC Ring',
            'odc-odp': 'Secondary Distribution',
            'odp-odc': 'Secondary Distribution',

            // 🔵 ACCESS
            'odp-odp': 'ODP Ring',
            'odp-customer': 'Customer Access',
            'customer-odp': 'Customer Access',
            'customer-customer': 'Customer Peer',

            'default': 'Unknown Connection'
        };

        const connectionKey = fromType + '-' + toType;
        return connectionNames[connectionKey] || connectionNames['default'];
    }

    // 4. ✅ Fix connection categories
    function getConnectionCategory(fromType, toType) {
        var connectionKey = fromType + '-' + toType;

        var categories = {
            // 🔴 BACKBONE (Red + Dark Red)
            'router-router': 'backbone', // Router → Router
            'olt-olt': 'backbone', // OLT → OLT cascade

            // 🟠 PRIMARY (Red-orange + Orange)  
            'router-olt': 'primary', // Router → OLT uplink
            'olt-router': 'primary', // OLT → Router uplink
            'olt-odc': 'primary', // OLT → ODC (PON)
            'odc-olt': 'primary', // ODC → OLT (PON)

            // 🟢 DISTRIBUTION (Green)
            'odc-odc': 'distribution', // ODC → ODC
            'odc-odp': 'distribution', // ODC → ODP
            'odp-odc': 'distribution', // ODP → ODC

            // 🔵 ACCESS (Blue)
            'odp-odp': 'access', // ODP → ODP
            'odp-customer': 'access', // ODP → Customer
            'customer-odp': 'access', // Customer → ODP
            'customer-customer': 'access' // Customer → Customer
        };

        return categories[connectionKey] || 'access';
    }
    // Center map on cable
    function centerOnCable(id) {
        var cable = cableRoutes.find(c => c.id == id);
        if (cable && cable.waypoints.length > 0) {
            var coordinates = cable.waypoints.map(wp => [wp.lat, wp.lng]);
            var group = new L.featureGroup([L.polyline(coordinates)]);

            // Simpan posisi peta sebelum navigasi
            mapPositionMemory.savePosition();

            // Gunakan flyToBounds dengan animasi yang smooth untuk efek lebih baik
            map.flyToBounds(group.getBounds(), {
                padding: [50, 50],
                duration: 1.5, // durasi animasi dalam detik
                easeLinearity: 0.25
            });

            // Cari polyline kabel di layer group
            var targetPolyline = null;
            cablesLayerGroup.eachLayer(function(layer) {
                if (layer instanceof L.Polyline && layer.cableId === id) {
                    targetPolyline = layer;
                }
            });

            // Tampilkan popup kabel setelah animasi selesai
            if (targetPolyline) {
                setTimeout(function() {
                    targetPolyline.openPopup();

                    // Efek highlight kabel
                    var originalWeight = targetPolyline.options.weight;
                    var originalOpacity = targetPolyline.options.opacity;

                    // Animasi highlight
                    targetPolyline.setStyle({
                        weight: originalWeight * 1.5,
                        opacity: 1
                    });

                    // Kembalikan ke style normal setelah beberapa detik
                    setTimeout(function() {
                        targetPolyline.setStyle({
                            weight: originalWeight,
                            opacity: originalOpacity
                        });
                    }, 3000);

                    // Tampilkan notifikasi sukses
                    Swal.fire({
                        toast: true,
                        position: 'top-end',
                        icon: 'success',
                        title: 'Cable Route #' + id,
                        text: 'Route between ' + cable.from_name + ' and ' + cable.to_name,
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        background: '#28a745',
                        color: '#fff'
                    });

                }, 1600); // Tunggu animasi selesai
            }
        }
    }

    // Show all cables in modal with enhanced filtering
    function showAllCables() {
        // Get unique device types for filter dropdowns
        var fromTypes = getUniqueDeviceTypes('from');
        var toTypes = getUniqueDeviceTypes('to');

        var filterControls =
            '<div class="cable-filter-controls" style="margin-bottom: 15px; padding: 12px; background: #f8f9fa; border-radius: 6px;">' +
            '<div class="row">' +
            '<div class="col-md-3">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-filter text-primary"></i> From Device Type</label>' +
            '<select id="cable-filter-from" class="form-control input-sm">' +
            '<option value="">All Types</option>' +
            fromTypes.map(type => '<option value="' + type + '">' + type.toUpperCase() + '</option>').join('') +
            '</select>' +
            '</div>' +
            '<div class="col-md-3">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-filter text-success"></i> To Device Type</label>' +
            '<select id="cable-filter-to" class="form-control input-sm">' +
            '<option value="">All Types</option>' +
            toTypes.map(type => '<option value="' + type + '">' + type.toUpperCase() + '</option>').join('') +
            '</select>' +
            '</div>' +
            '<div class="col-md-4">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-search text-warning"></i> Search Device Name</label>' +
            '<input type="text" id="cable-filter-search" class="form-control input-sm" placeholder="Type device name...">' +
            '</div>' +
            '<div class="col-md-2">' +
            '<label style="font-size: 12px; margin-bottom: 4px;">&nbsp;</label>' +
            '<button type="button" id="cable-filter-clear" class="btn btn-default btn-sm btn-block">' +
            '<i class="fa fa-times"></i> Clear' +
            '</button>' +
            '</div>' +
            '</div>' +
            '<div class="row" style="margin-top: 8px;">' +
            '<div class="col-md-12">' +
            '<div id="cable-filter-info" class="text-center" style="font-size: 11px; color: #666;">' +
            'Showing <span id="filtered-count">' + cableRoutes.length + '</span> of <span id="total-count">' +
            cableRoutes.length + '</span> cables' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';

        var tableContent = buildCableTable(cableRoutes);

        var modalContent = filterControls + tableContent +
            '<div class="alert alert-info" style="margin-top: 10px; font-size: 12px;">' +
            '<i class="fa fa-info-circle"></i> <strong>Tips:</strong> Use filters to narrow down results, then click <strong>Center & Show</strong> to navigate to specific cables.' +
            '</div>';

        Swal.fire({
            title: 'Cable Routes Management',
            html: modalContent,
            width: 1000,
            showConfirmButton: false,
            showCancelButton: true,
            cancelButtonText: 'Close',
            didOpen: () => {
                // Initialize filter event handlers
                initializeCableFilters();
            }
        });
    }
    // ===== POLE MODAL FUNCTIONS =====

    function showAllPoles() {
        console.log('Loading poles data...');

        // Get unique device types for filter dropdowns
        var fromTypes = getUniqueDeviceTypesForPoles('from');
        var toTypes = getUniqueDeviceTypesForPoles('to');

        var filterControls = buildPoleFilterControls(fromTypes, toTypes);
        var tableContent = buildPoleTable(networkData.poles || []);

        var modalContent = filterControls + tableContent +
            '<div class="alert alert-info" style="margin-top: 10px; font-size: 12px;">' +
            '<i class="fa fa-info-circle"></i> <strong>Tips:</strong> Use filters to find poles by bridge connections, then click <strong>Center & Show</strong> to navigate to specific poles.' +
            '</div>';

        Swal.fire({
            title: 'Poles Management - Bridge Connections',
            html: modalContent,
            width: 1100,
            showConfirmButton: false,
            showCancelButton: true,
            cancelButtonText: 'Close',
            didOpen: () => {
                // Initialize filter event handlers
                initializePoleFilters();
            }
        });
    }

    function buildPoleFilterControls(fromTypes, toTypes) {
        var filterControls =
            '<div class="cable-filter-controls" style="margin-bottom: 15px; padding: 12px; background: #f8f9fa; border-radius: 6px;">' +
            '<div class="row">' +
            '<div class="col-md-2">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-filter text-primary"></i> From Type</label>' +
            '<select id="pole-filter-from-type" class="form-control input-sm">' +
            '<option value="">All Types</option>' +
            fromTypes.map(type => '<option value="' + type + '">' + type.toUpperCase() + '</option>').join('') +
            '</select>' +
            '</div>' +
            '<div class="col-md-2">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-list text-success"></i> From Device</label>' +
            '<select id="pole-filter-from-device" class="form-control input-sm" disabled>' +
            '<option value="">Select Type First</option>' +
            '</select>' +
            '</div>' +
            '<div class="col-md-2">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-filter text-warning"></i> To Type</label>' +
            '<select id="pole-filter-to-type" class="form-control input-sm">' +
            '<option value="">All Types</option>' +
            toTypes.map(type => '<option value="' + type + '">' + type.toUpperCase() + '</option>').join('') +
            '</select>' +
            '</div>' +
            '<div class="col-md-2">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-list text-info"></i> To Device</label>' +
            '<select id="pole-filter-to-device" class="form-control input-sm" disabled>' +
            '<option value="">Select Type First</option>' +
            '</select>' +
            '</div>' +
            '<div class="col-md-3">' +
            '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-search text-danger"></i> Search Pole Name</label>' +
            '<input type="text" id="pole-filter-search" class="form-control input-sm" placeholder="Type pole name...">' +
            '</div>' +
            '<div class="col-md-1">' +
            '<label style="font-size: 12px; margin-bottom: 4px;">&nbsp;</label>' +
            '<button type="button" id="pole-filter-clear" class="btn btn-default btn-sm btn-block">' +
            '<i class="fa fa-times"></i> Clear' +
            '</button>' +
            '</div>' +
            '</div>' +
            '<div class="row" style="margin-top: 8px;">' +
            '<div class="col-md-12">' +
            '<div id="pole-filter-info" class="text-center" style="font-size: 11px; color: #666;">' +
            'Showing <span id="pole-filtered-count">' + (networkData.poles ? networkData.poles.length : 0) +
            '</span> of <span id="pole-total-count">' +
            (networkData.poles ? networkData.poles.length : 0) + '</span> poles' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';

        return filterControls;
    }

    function getUniqueDeviceTypesForPoles(direction) {
        var types = new Set();

        // Add types based on existing network data
        if (networkData.routers && networkData.routers.length > 0) {
            types.add('router');
        }
        if (networkData.odcs && networkData.odcs.length > 0) {
            types.add('odc');
        }
        if (networkData.odps && networkData.odps.length > 0) {
            types.add('odp');
        }
        if (networkData.customers && networkData.customers.length > 0) {
            types.add('customer');
        }

        return Array.from(types).sort();
    }

    function getDevicesByType(deviceType) {
        var devices = [];

        switch (deviceType) {
            case 'router':
                if (networkData.routers) {
                    devices = networkData.routers.map(device => ({
                        id: device.id,
                        name: device.name,
                        type: 'router'
                    }));
                }
                break;
            case 'odc':
                if (networkData.odcs) {
                    devices = networkData.odcs.map(device => ({
                        id: device.id,
                        name: device.name,
                        type: 'odc'
                    }));
                }
                break;
            case 'odp':
                if (networkData.odps) {
                    devices = networkData.odps.map(device => ({
                        id: device.id,
                        name: device.name,
                        type: 'odp'
                    }));
                }
                break;
            case 'customer':
                if (networkData.customers) {
                    devices = networkData.customers.map(device => ({
                        id: device.id,
                        name: device.name,
                        type: 'customer'
                    }));
                }
                break;
        }

        return devices.sort((a, b) => a.name.localeCompare(b.name));
    }

    function buildPoleTable(poles) {
        if (!poles || poles.length === 0) {
            return '<div class="table-responsive">' +
                '<table class="table table-striped table-bordered table-hover" id="poles-table">' +
                '<thead class="bg-secondary">' +
                '<tr>' +
                '<th>ID</th>' +
                '<th>Pole Name</th>' +
                '<th>Address</th>' +
                '<th>Bridge Count</th>' +
                '<th>Bridge Connections</th>' +
                '<th>Actions</th>' +
                '</tr>' +
                '</thead>' +
                '<tbody>' +
                '<tr><td colspan="6" class="text-center">No poles found</td></tr>' +
                '</tbody>' +
                '</table>' +
                '</div>';
        }

        var polesList = poles.map(function(pole) {
            var bridgeInfo = 'Loading...'; // Will be loaded via AJAX

            return '<tr data-pole-id="' + pole.id + '">' +
                '<td>' + pole.id + '</td>' +
                '<td><strong>' + pole.name + '</strong></td>' +
                '<td>' + (pole.address || 'No address') + '</td>' +
                '<td class="bridge-count-' + pole.id + '">-</td>' +
                '<td class="bridge-details-' + pole.id + '">Loading bridge data...</td>' +
                '<td>' +
                '<button class="btn btn-info btn-xs" onclick="centerOnPole(' + pole.id +
                '); Swal.close();" title="Center and Show Pole Details" style="margin-right: 5px;">' +
                '<i class="fa fa-crosshairs"></i> Center & Show' +
                '</button>' +
                '<button class="btn btn-warning btn-xs" onclick="editPoleFromModal(' + pole.id +
                ', \'' + pole.name.replace(/'/g, "\\'") + '\');" title="Edit Pole">' +
                    '<i class="fa fa-edit"></i> Edit' +
                    '</button>' +
                    '</td>' +
                    '</tr>';
            }).join('');

            var tableHtml = '<div class="table-responsive">' +
                '<table class="table table-striped table-bordered table-hover" id="poles-table">' +
                '<thead class="bg-secondary">' +
                '<tr>' +
                '<th>ID</th>' +
                '<th>Pole Name</th>' +
                '<th>Address</th>' +
                '<th>Bridge Count</th>' +
                '<th>Bridge Connections</th>' +
                '<th>Actions</th>' +
                '</tr>' +
                '</thead>' +
                '<tbody>' +
                polesList +
                '</tbody>' +
                '</table>' +
                '</div>';

            // Load bridge data after table is rendered
            setTimeout(function() {
                loadAllPoleBridgeData(poles);
            }, 100);

            return tableHtml;
        }

        function loadAllPoleBridgeData(poles) {
            if (!poles || poles.length === 0) return;

            // Store bridge data for filtering
            window.poleBridgeData = {};

            var promises = poles.map(pole => {
                return fetch(baseUrl + 'plugin/network_mapping/get-pole-bridges&pole_id=' + pole.id)
                    .then(response => response.json())
                    .then(data => {
                        var bridgeCount = 0;
                        var bridgeDetails = 'No bridges';

                        if (data.success && data.bridges && data.bridges.length > 0) {
                            bridgeCount = data.bridges.length;

                            // Store for filtering
                            window.poleBridgeData[pole.id] = data.bridges;

                            // Create bridge details HTML
                            var bridgeTexts = data.bridges.map((bridge, index) => {
                                return (index + 1) + '. ' + bridge.from_name + ' (' + bridge.from_type
                                    .toUpperCase() + ') → ' +
                                    bridge.to_name + ' (' + bridge.to_type.toUpperCase() + ')';
                            });

                            bridgeDetails = bridgeTexts.join('<br>');
                        } else {
                            window.poleBridgeData[pole.id] = [];
                        }

                        // Update table cells
                        var countCell = document.querySelector('.bridge-count-' + pole.id);
                        var detailCell = document.querySelector('.bridge-details-' + pole.id);

                        if (countCell) countCell.textContent = bridgeCount;
                        if (detailCell) detailCell.innerHTML = bridgeDetails;

                        return { poleId: pole.id, bridges: data.bridges || [] };
                    })
                    .catch(error => {
                        console.error('Error loading bridges for pole ' + pole.id + ':', error);

                        var countCell = document.querySelector('.bridge-count-' + pole.id);
                        var detailCell = document.querySelector('.bridge-details-' + pole.id);

                        if (countCell) countCell.textContent = 'Error';
                        if (detailCell) detailCell.innerHTML = 'Error loading bridge data';

                        window.poleBridgeData[pole.id] = [];

                        return { poleId: pole.id, bridges: [] };
                    });
            });

            Promise.all(promises).then(results => {
                console.log('All pole bridge data loaded:', results.length + ' poles processed');

                // Enable filtering after data is loaded
                updatePoleFilterInfo();
            });
        }

        function initializePoleFilters() {
            var fromTypeFilter = document.getElementById('pole-filter-from-type');
            var fromDeviceFilter = document.getElementById('pole-filter-from-device');
            var toTypeFilter = document.getElementById('pole-filter-to-type');
            var toDeviceFilter = document.getElementById('pole-filter-to-device');
            var searchFilter = document.getElementById('pole-filter-search');
            var clearButton = document.getElementById('pole-filter-clear');

            if (!fromTypeFilter || !toTypeFilter || !searchFilter) return;

            // From Type change - populate device list
            fromTypeFilter.addEventListener('change', function() {
                var selectedType = this.value;
                populateDeviceDropdown('pole-filter-from-device', selectedType);
                applyPoleFilters();
            });

            // To Type change - populate device list  
            toTypeFilter.addEventListener('change', function() {
                var selectedType = this.value;
                populateDeviceDropdown('pole-filter-to-device', selectedType);
                applyPoleFilters();
            });

            // Device selection changes
            fromDeviceFilter.addEventListener('change', applyPoleFilters);
            toDeviceFilter.addEventListener('change', applyPoleFilters);

            // Search input with debounce
            searchFilter.addEventListener('input', debounce(applyPoleFilters, 300));

            // Clear button
            if (clearButton) {
                clearButton.addEventListener('click', function() {
                    fromTypeFilter.value = '';
                    fromDeviceFilter.value = '';
                    fromDeviceFilter.disabled = true;
                    fromDeviceFilter.innerHTML = '<option value="">Select Type First</option>';

                    toTypeFilter.value = '';
                    toDeviceFilter.value = '';
                    toDeviceFilter.disabled = true;
                    toDeviceFilter.innerHTML = '<option value="">Select Type First</option>';

                    searchFilter.value = '';
                    applyPoleFilters();
                });
            }
        }

        function applyPoleFilters() {
            var fromType = document.getElementById('pole-filter-from-type').value.toLowerCase();
            var fromDevice = document.getElementById('pole-filter-from-device').value;
            var toType = document.getElementById('pole-filter-to-type').value.toLowerCase();
            var toDevice = document.getElementById('pole-filter-to-device').value;
            var searchTerm = document.getElementById('pole-filter-search').value.toLowerCase().trim();

            var poles = networkData.poles || [];

            var filteredPoles = poles.filter(function(pole) {
                // Filter by search term (pole name)
                if (searchTerm && !pole.name.toLowerCase().includes(searchTerm)) {
                    return false;
                }

                // If no bridge filters are set, show all poles matching search
                if (!fromType && !fromDevice && !toType && !toDevice) {
                    return true;
                }

                // Check bridge connections
                var bridgeData = window.poleBridgeData && window.poleBridgeData[pole.id];
                if (!bridgeData || bridgeData.length === 0) {
                    return false; // No bridges, don't show if bridge filters are active
            }

            // Check if any bridge matches the filter criteria
            return bridgeData.some(function(bridge) {
                var fromMatches = true;
                var toMatches = true;

                // Check From criteria
                if (fromType || fromDevice) {
                    fromMatches = false;

                    if (fromType && !fromDevice) {
                        // Type only filter
                        fromMatches = matchesDeviceType(bridge.from_type, fromType);
                    } else if (fromType && fromDevice) {
                        // Type and specific device filter
                        fromMatches = matchesDeviceType(bridge.from_type, fromType) && bridge.from_id ==
                            fromDevice;
                    } else if (fromDevice && !fromType) {
                        // Device only filter (shouldn't happen but handle it)
                            fromMatches = bridge.from_id == fromDevice;
                        }
                    }

                    // Check To criteria
                    if (toType || toDevice) {
                        toMatches = false;

                        if (toType && !toDevice) {
                            // Type only filter
                            toMatches = matchesDeviceType(bridge.to_type, toType);
                        } else if (toType && toDevice) {
                            // Type and specific device filter
                            toMatches = matchesDeviceType(bridge.to_type, toType) && bridge.to_id ==
                                toDevice;
                        } else if (toDevice && !toType) {
                            // Device only filter (shouldn't happen but handle it)
                        toMatches = bridge.to_id == toDevice;
                    }
                }

                return fromMatches && toMatches;
            });
        });

        // Update table content
        updatePoleTable(filteredPoles);

        // Update filter info
        updatePoleFilterInfo(filteredPoles.length, poles.length);
    }

    function updatePoleTable(filteredPoles) {
        var tableContainer = document.querySelector('#poles-table tbody');
        if (!tableContainer) return;

        if (filteredPoles.length === 0) {
            tableContainer.innerHTML =
                '<tr><td colspan="6" class="text-center">No poles match the current filters</td></tr>';
            return;
        }

        var polesList = filteredPoles.map(function(pole) {
            var bridgeData = window.poleBridgeData && window.poleBridgeData[pole.id];
            var bridgeCount = bridgeData ? bridgeData.length : 0;
            var bridgeDetails = 'No bridges';

            if (bridgeData && bridgeData.length > 0) {
                var bridgeTexts = bridgeData.map((bridge, index) => {
                    return (index + 1) + '. ' + bridge.from_name + ' (' + bridge.from_type
                        .toUpperCase() + ') → ' +
                        bridge.to_name + ' (' + bridge.to_type.toUpperCase() + ')';
                });
                bridgeDetails = bridgeTexts.join('<br>');
            }

            return '<tr data-pole-id="' + pole.id + '">' +
                '<td>' + pole.id + '</td>' +
                '<td><strong>' + pole.name + '</strong></td>' +
                '<td>' + (pole.address || 'No address') + '</td>' +
                '<td>' + bridgeCount + '</td>' +
                '<td>' + bridgeDetails + '</td>' +
                '<td>' +
                '<button class="btn btn-info btn-xs" onclick="centerOnPole(' + pole.id +
                '); Swal.close();" title="Center and Show Pole Details" style="margin-right: 5px;">' +
                '<i class="fa fa-crosshairs"></i> Center & Show' +
                '</button>' +
                '<button class="btn btn-warning btn-xs" onclick="editPoleFromModal(' + pole.id +
                ', \'' + pole.name.replace(/'/g, "\\'") + '\');" title="Edit Pole">' +
                    '<i class="fa fa-edit"></i> Edit' +
                    '</button>' +
                    '</td>' +
                    '</tr>';
            }).join('');

            tableContainer.innerHTML = polesList;
        }

        function updatePoleFilterInfo(filteredCount, totalCount) {
            var filteredCountEl = document.getElementById('pole-filtered-count');
            var totalCountEl = document.getElementById('pole-total-count');
            var filterInfo = document.getElementById('pole-filter-info');

            if (!filteredCountEl || !totalCountEl || !filterInfo) return;

            if (filteredCount === undefined) {
                // Initial load
                var poles = networkData.poles || [];
                filteredCount = poles.length;
                totalCount = poles.length;
            }

            filteredCountEl.textContent = filteredCount;
            totalCountEl.textContent = totalCount;

            // Update filter info color based on results
            if (filteredCount === 0) {
                filterInfo.style.color = '#d9534f';
                filterInfo.innerHTML = '<i class="fa fa-exclamation-triangle"></i> No poles match the current filters';
            } else if (filteredCount < totalCount) {
                filterInfo.style.color = '#f0ad4e';
                filterInfo.innerHTML = 'Showing <span id="pole-filtered-count">' + filteredCount +
                    '</span> of <span id="pole-total-count">' + totalCount + '</span> poles (filtered)';
            } else {
                filterInfo.style.color = '#666';
                filterInfo.innerHTML = 'Showing <span id="pole-filtered-count">' + filteredCount +
                    '</span> of <span id="pole-total-count">' + totalCount + '</span> poles';
            }
        }
        // ===== EDIT POLE FROM MODAL FUNCTION =====

        // ===== CENTER ON POLE FUNCTION =====

        function centerOnPole(poleId) {
            // Find pole data from networkData
            var pole = null;
            if (networkData.poles) {
                pole = networkData.poles.find(function(p) {
                    return p.id == poleId;
                });
            }

            if (!pole) {
                Swal.fire({
                    icon: 'error',
                    title: 'Pole Not Found',
                    text: 'Unable to find pole coordinates'
                });
                return;
            }

            // Parse coordinates
            var coords = pole.coordinates.split(',').map(parseFloat);

            if (coords.length !== 2 || isNaN(coords[0]) || isNaN(coords[1])) {
                console.error('Invalid coordinates for pole:', pole.coordinates);
                Swal.fire('Error', 'Invalid coordinates for pole: ' + pole.name, 'error');
                return;
            }

            // Save current map position before navigating
            if (typeof mapPositionMemory !== 'undefined') {
                mapPositionMemory.savePosition();
            }

            // Smooth pan and zoom to pole location
            map.flyTo(coords, 18, {
                duration: 1.5, // 1.5 seconds animation
                easeLinearity: 0.25
            });

            // Show success message and open popup
            setTimeout(function() {
                // Find and open popup if marker exists
                var markerKey = 'pole_' + poleId;
                if (allMarkers[markerKey] && allMarkers[markerKey].marker) {
                    // Open popup after animation completes
                    setTimeout(function() {
                        allMarkers[markerKey].marker.openPopup();

                        // Temporary highlight effect
                        var markerElement = document.querySelector('[data-type="pole"][data-id="' + poleId +
                            '"]');
                        if (markerElement) {
                            markerElement.style.animation = 'pulse 2s ease-in-out 3';
                            setTimeout(function() {
                                markerElement.style.animation = '';
                            }, 6000);
                        }
                    }, 300);
                }

                // Show enhanced toast notification
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'success',
                    title: 'Located: ' + pole.name,
                    text: 'Found POLE at zoom level 18',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    background: '#6f42c1',
                    color: '#fff'
                });

            }, 1600); // After flyTo animation completes

            console.log('Navigated to pole', pole.name, 'at', coords);
        }
        // ===== CUSTOMER MODAL FUNCTIONS =====

        function showAllCustomers() {
            console.log('Loading customers data...');

            var customers = networkData.customers || [];

            var filterControls = buildCustomerFilterControls();
            var tableContent = buildCustomerTable(customers);

            var modalContent = filterControls + tableContent +
                '<div class="alert alert-info" style="margin-top: 10px; font-size: 12px;">' +
                '<i class="fa fa-info-circle"></i> <strong>Tips:</strong> Use search to find customers by name or username, then click <strong>Center & Show</strong> to navigate to customer location.' +
                '</div>';

            Swal.fire({
                title: 'Customers Management - All Customers',
                html: modalContent,
                width: 1000,
                showConfirmButton: false,
                showCancelButton: true,
                cancelButtonText: 'Close',
                didOpen: () => {
                    // Initialize filter event handlers
                    initializeCustomerFilters();
                }
            });
        }

        function buildCustomerFilterControls() {
            var filterControls =
                '<div class="cable-filter-controls" style="margin-bottom: 15px; padding: 12px; background: #f8f9fa; border-radius: 6px;">' +
                '<div class="row">' +
                '<div class="col-md-8">' +
                '<label style="font-size: 12px; margin-bottom: 4px;"><i class="fa fa-search text-primary"></i> Search Customer</label>' +
                '<input type="text" id="customer-filter-search" class="form-control input-sm" placeholder="Search by name, username, or address...">' +
                '</div>' +
                '<div class="col-md-2">' +
                '<label style="font-size: 12px; margin-bottom: 4px;">&nbsp;</label>' +
                '<button type="button" id="customer-filter-clear" class="btn btn-default btn-sm btn-block">' +
                '<i class="fa fa-times"></i> Clear' +
                '</button>' +
                '</div>' +
                '<div class="col-md-2">' +
                '<label style="font-size: 12px; margin-bottom: 4px;">&nbsp;</label>' +
                '<div class="text-center" style="padding-top: 6px; font-size: 11px; color: #666;">' +
                '<i class="fa fa-users"></i> <span id="customer-total-shown">' + (networkData.customers ? networkData
                    .customers.length : 0) + '</span> customers' +
                '</div>' +
                '</div>' +
                '</div>' +
                '<div class="row" style="margin-top: 8px;">' +
                '<div class="col-md-12">' +
                '<div id="customer-filter-info" class="text-center" style="font-size: 11px; color: #666;">' +
                'Showing <span id="customer-filtered-count">' + (networkData.customers ? networkData.customers.length : 0) +
                '</span> of <span id="customer-total-count">' +
                (networkData.customers ? networkData.customers.length : 0) + '</span> customers' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';

            return filterControls;
        }

        function buildCustomerTable(customers) {
            if (!customers || customers.length === 0) {
                return '<div class="table-responsive">' +
                    '<table class="table table-striped table-bordered table-hover" id="customers-table">' +
                    '<thead class="bg-info">' +
                    '<tr>' +
                    '<th>ID</th>' +
                    '<th>Name</th>' +
                    '<th>Username</th>' +
                    '<th>Balance</th>' +
                    '<th>Address</th>' +
                    '<th>Connection</th>' +
                    '<th>Actions</th>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody>' +
                    '<tr><td colspan="7" class="text-center">No customers found</td></tr>' +
                    '</tbody>' +
                    '</table>' +
                    '</div>';
            }

            var customersList = customers.map(function(customer) {
                // Connection info
                var connectionInfo = 'Not Connected';
                if (customer.odp_id && customer.port_number) {
                    // Find ODP name
                    var odpName = 'ODP #' + customer.odp_id;
                    if (networkData.odps) {
                        var odp = networkData.odps.find(function(o) { return o.id == customer.odp_id; });
                        if (odp) odpName = odp.name;
                    }
                    connectionInfo = odpName + ' (Port ' + customer.port_number + ')';
                }

                return '<tr data-customer-id="' + customer.id + '">' +
                    '<td>' + customer.id + '</td>' +
                    '<td><strong>' + customer.name + '</strong></td>' +
                    '<td>' + customer.username + '</td>' +
                    '<td>' + (customer.balance || 'Rp 0') + '</td>' +
                    '<td>' + (customer.address || 'No address') + '</td>' +
                    '<td>' + connectionInfo + '</td>' +
                    '<td>' +
                    '<button class="btn btn-info btn-xs" onclick="centerOnCustomer(' + customer.id +
                    '); Swal.close();" title="Center and Show Customer Details">' +
                    '<i class="fa fa-crosshairs"></i> Center & Show' +
                    '</button>' +
                    '</td>' +
                    '</tr>';
            }).join('');

            return '<div class="table-responsive">' +
                '<table class="table table-striped table-bordered table-hover" id="customers-table">' +
                '<thead class="bg-info">' +
                '<tr>' +
                '<th>ID</th>' +
                '<th>Name</th>' +
                '<th>Username</th>' +
                '<th>Balance</th>' +
                '<th>Address</th>' +
                '<th>Connection</th>' +
                '<th>Actions</th>' +
                '</tr>' +
                '</thead>' +
                '<tbody>' +
                customersList +
                '</tbody>' +
                '</table>' +
                '</div>';
        }

        function initializeCustomerFilters() {
            var searchFilter = document.getElementById('customer-filter-search');
            var clearButton = document.getElementById('customer-filter-clear');

            if (!searchFilter) return;

            // Search input with debounce
            searchFilter.addEventListener('input', debounce(applyCustomerFilters, 300));

            // Clear button
            if (clearButton) {
                clearButton.addEventListener('click', function() {
                    searchFilter.value = '';
                    applyCustomerFilters();
                });
            }
        }

        function applyCustomerFilters() {
            var searchTerm = document.getElementById('customer-filter-search').value.toLowerCase().trim();
            var customers = networkData.customers || [];

            var filteredCustomers = customers.filter(function(customer) {
                if (!searchTerm) return true;

                // Search in name, username, and address
                return customer.name.toLowerCase().includes(searchTerm) ||
                    customer.username.toLowerCase().includes(searchTerm) ||
                    (customer.address && customer.address.toLowerCase().includes(searchTerm));
            });

            // Update table content
            updateCustomerTable(filteredCustomers);

            // Update filter info
            updateCustomerFilterInfo(filteredCustomers.length, customers.length);
        }

        function updateCustomerTable(filteredCustomers) {
            var tableContainer = document.querySelector('#customers-table tbody');
            if (!tableContainer) return;

            if (filteredCustomers.length === 0) {
                tableContainer.innerHTML =
                    '<tr><td colspan="7" class="text-center">No customers match the search criteria</td></tr>';
                return;
            }

            var customersList = filteredCustomers.map(function(customer) {
                // Connection info
                var connectionInfo = 'Not Connected';
                if (customer.odp_id && customer.port_number) {
                    var odpName = 'ODP #' + customer.odp_id;
                    if (networkData.odps) {
                        var odp = networkData.odps.find(function(o) { return o.id == customer.odp_id; });
                        if (odp) odpName = odp.name;
                    }
                    connectionInfo = odpName + ' (Port ' + customer.port_number + ')';
                }

                return '<tr data-customer-id="' + customer.id + '">' +
                    '<td>' + customer.id + '</td>' +
                    '<td><strong>' + customer.name + '</strong></td>' +
                    '<td>' + customer.username + '</td>' +
                    '<td>' + (customer.balance || 'Rp 0') + '</td>' +
                    '<td>' + (customer.address || 'No address') + '</td>' +
                    '<td>' + connectionInfo + '</td>' +
                    '<td>' +
                    '<button class="btn btn-info btn-xs" onclick="centerOnCustomer(' + customer.id +
                    '); Swal.close();" title="Center and Show Customer Details">' +
                    '<i class="fa fa-crosshairs"></i> Center & Show' +
                    '</button>' +
                    '</td>' +
                    '</tr>';
            }).join('');

            tableContainer.innerHTML = customersList;
        }

        function updateCustomerFilterInfo(filteredCount, totalCount) {
            var filteredCountEl = document.getElementById('customer-filtered-count');
            var totalCountEl = document.getElementById('customer-total-count');
            var totalShownEl = document.getElementById('customer-total-shown');
            var filterInfo = document.getElementById('customer-filter-info');

            if (!filteredCountEl || !totalCountEl || !filterInfo) return;

            if (filteredCount === undefined) {
                // Initial load
                var customers = networkData.customers || [];
                filteredCount = customers.length;
                totalCount = customers.length;
            }

            filteredCountEl.textContent = filteredCount;
            totalCountEl.textContent = totalCount;
            if (totalShownEl) totalShownEl.textContent = filteredCount;

            // Update filter info color based on results
            if (filteredCount === 0) {
                filterInfo.style.color = '#d9534f';
                filterInfo.innerHTML = '<i class="fa fa-exclamation-triangle"></i> No customers match the search criteria';
            } else if (filteredCount < totalCount) {
                filterInfo.style.color = '#f0ad4e';
                filterInfo.innerHTML = 'Showing <span id="customer-filtered-count">' + filteredCount +
                    '</span> of <span id="customer-total-count">' + totalCount + '</span> customers (filtered)';
            } else {
                filterInfo.style.color = '#666';
                filterInfo.innerHTML = 'Showing <span id="customer-filtered-count">' + filteredCount +
                    '</span> of <span id="customer-total-count">' + totalCount + '</span> customers';
            }
        }
        // ===== CENTER ON CUSTOMER FUNCTION =====

        function centerOnCustomer(customerId) {
            // Find customer data from networkData
            var customer = null;
            if (networkData.customers) {
                customer = networkData.customers.find(function(c) {
                    return c.id == customerId;
                });
            }

            if (!customer) {
                Swal.fire({
                    icon: 'error',
                    title: 'Customer Not Found',
                    text: 'Unable to find customer coordinates'
                });
                return;
            }

            // Parse coordinates
            var coords = customer.coordinates.split(',').map(parseFloat);

            if (coords.length !== 2 || isNaN(coords[0]) || isNaN(coords[1])) {
                console.error('Invalid coordinates for customer:', customer.coordinates);
                Swal.fire('Error', 'Invalid coordinates for customer: ' + customer.name, 'error');
                return;
            }

            // Save current map position before navigating
            if (typeof mapPositionMemory !== 'undefined') {
                mapPositionMemory.savePosition();
            }

            // Smooth pan and zoom to customer location
            map.flyTo(coords, 19, {
                duration: 1.5, // 1.5 seconds animation
                easeLinearity: 0.25
            });

            // Show success message and open popup
            setTimeout(function() {
                // Find and open popup if marker exists
                var markerKey = 'customer_' + customerId;
                if (allMarkers[markerKey] && allMarkers[markerKey].marker) {
                    // Open popup after animation completes
                    setTimeout(function() {
                        allMarkers[markerKey].marker.openPopup();

                        // Temporary highlight effect
                        var markerElement = document.querySelector('[data-type="customer"][data-id="' +
                            customerId + '"]');
                        if (markerElement) {
                            markerElement.style.animation = 'pulse 2s ease-in-out 3';
                            setTimeout(function() {
                                markerElement.style.animation = '';
                            }, 6000);
                        }
                    }, 300);
                }

                // Show enhanced toast notification
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'success',
                    title: 'Located: ' + customer.name,
                    text: 'Found CUSTOMER (' + customer.username + ') at zoom level 19',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    background: '#17a2b8',
                    color: '#fff'
                });

            }, 1600); // After flyTo animation completes

            console.log('Navigated to customer', customer.name, 'at', coords);
        }

        function editPoleFromModal(poleId, poleName) {
            // Close the poles modal first
            Swal.close();

            // Use existing edit pole bridges modal
            showEditPoleBridgesModal(poleId, poleName);
        }

        function populateDeviceDropdown(dropdownId, deviceType) {
            var dropdown = document.getElementById(dropdownId);
            if (!dropdown) return;

            if (!deviceType) {
                dropdown.disabled = true;
                dropdown.innerHTML = '<option value="">Select Type First</option>';
                return;
            }

            dropdown.disabled = false;
            dropdown.innerHTML = '<option value="">All ' + deviceType.toUpperCase() + 's</option>';

            var devices = getDevicesByType(deviceType);
            devices.forEach(device => {
                var option = document.createElement('option');
                option.value = device.id;
                option.textContent = device.name;
                dropdown.appendChild(option);
            });
        }
        // Get unique device types from cable routes
        function getUniqueDeviceTypes(direction) {
            var types = new Set();

            cableRoutes.forEach(function(cable) {
                var deviceType = direction === 'from' ? cable.from_type : cable.to_type;

                // Map device types to categories
                switch (deviceType) {
                    case 'router':
                    case 'mikrotik':
                    case 'server':
                        types.add('router');
                        break;
                    case 'odc':
                        types.add('odc');
                        break;
                    case 'odp':
                        types.add('odp');
                        break;
                    case 'customer':
                    case 'cust_all':
                        types.add('customer');
                        break;
                    default:
                        types.add(deviceType);
                }
            });

            return Array.from(types).sort();
        }

        // Build cable table HTML
        function buildCableTable(cables) {
            var cablesList = cables.map(function(cable) {
                var length = calculateCableLength(cable.waypoints);
                return '<tr>' +
                    '<td>' + cable.id + '</td>' +
                    '<td><span class="device-from" data-type="' + cable.from_type + '">' + cable.from_name +
                    '</span></td>' +
                    '<td><span class="device-to" data-type="' + cable.to_type + '">' + cable.to_name +
                    '</span></td>' +
                    '<td><span class="label label-info">' + cable.cable_type + '</span></td>' +
                    '<td>' + length.toFixed(0) + 'm</td>' +
                    '<td>' + cable.waypoints.length + '</td>' +
                    '<td>' +
                    '<button class="btn btn-info btn-xs" onclick="centerOnCable(' + cable.id +
                    '); Swal.close();" title="Center and Show Cable Details">' +
                    '<i class="fa fa-crosshairs"></i> Center & Show' +
                    '</button>' +
                    '</td>' +
                    '</tr>';
            }).join('');

            return '<div class="table-responsive">' +
                '<table class="table table-striped table-bordered table-hover" id="cables-table">' +
                '<thead class="bg-primary">' +
                '<tr>' +
                '<th>ID</th>' +
                '<th>From</th>' +
                '<th>To</th>' +
                '<th>Type</th>' +
                '<th>Length</th>' +
                '<th>Waypoints</th>' +
                '<th>Actions</th>' +
                '</tr>' +
                '</thead>' +
                '<tbody>' +
                (cablesList || '<tr><td colspan="7" class="text-center">No cables found</td></tr>') +
                '</tbody>' +
                '</table>' +
                '</div>';
        }

        // Initialize cable filter event handlers
        function initializeCableFilters() {
            var fromFilter = document.getElementById('cable-filter-from');
            var toFilter = document.getElementById('cable-filter-to');
            var searchFilter = document.getElementById('cable-filter-search');
            var clearButton = document.getElementById('cable-filter-clear');

            if (!fromFilter || !toFilter || !searchFilter) return;

            // Add event listeners
            fromFilter.addEventListener('change', applyCableFilters);
            toFilter.addEventListener('change', applyCableFilters);
            searchFilter.addEventListener('input', debounce(applyCableFilters, 300));

            if (clearButton) {
                clearButton.addEventListener('click', function() {
                    fromFilter.value = '';
                    toFilter.value = '';
                    searchFilter.value = '';
                    applyCableFilters();
                });
            }
        }

        // Apply filters to cable table
        function applyCableFilters() {
            var fromFilter = document.getElementById('cable-filter-from');
            var toFilter = document.getElementById('cable-filter-to');
            var searchFilter = document.getElementById('cable-filter-search');

            if (!fromFilter || !toFilter || !searchFilter) return;

            var fromType = fromFilter.value.toLowerCase();
            var toType = toFilter.value.toLowerCase();
            var searchTerm = searchFilter.value.toLowerCase().trim();

            var filteredCables = cableRoutes.filter(function(cable) {
                // Filter by from device type
                if (fromType && !matchesDeviceType(cable.from_type, fromType)) {
                    return false;
                }

                // Filter by to device type  
                if (toType && !matchesDeviceType(cable.to_type, toType)) {
                    return false;
                }

                // Filter by search term (in device names)
                if (searchTerm &&
                    !cable.from_name.toLowerCase().includes(searchTerm) &&
                    !cable.to_name.toLowerCase().includes(searchTerm)) {
                    return false;
                }

                return true;
            });

            // Update table content
            var tableContainer = document.querySelector('.table-responsive');
            if (tableContainer) {
                tableContainer.innerHTML = buildCableTable(filteredCables).match(/<table[\s\S]*<\/table>/)[0];
            }

            // Update filter info
            var filteredCount = document.getElementById('filtered-count');
            var totalCount = document.getElementById('total-count');

            if (filteredCount) filteredCount.textContent = filteredCables.length;
            if (totalCount) totalCount.textContent = cableRoutes.length;

            // Update filter info color based on results
            var filterInfo = document.getElementById('cable-filter-info');
            if (filterInfo) {
                if (filteredCables.length === 0) {
                    filterInfo.style.color = '#d9534f';
                    filterInfo.innerHTML = '<i class="fa fa-exclamation-triangle"></i> No cables match the current filters';
                } else if (filteredCables.length < cableRoutes.length) {
                    filterInfo.style.color = '#f0ad4e';
                    filterInfo.innerHTML = 'Showing <span id="filtered-count">' + filteredCables.length +
                        '</span> of <span id="total-count">' + cableRoutes.length + '</span> cables (filtered)';
                } else {
                    filterInfo.style.color = '#666';
                    filterInfo.innerHTML = 'Showing <span id="filtered-count">' + filteredCables.length +
                        '</span> of <span id="total-count">' + cableRoutes.length + '</span> cables';
                }
            }
        }

        // Check if device type matches category
        function matchesDeviceType(deviceType, category) {
            switch (category) {
                case 'router':
                    return ['router', 'mikrotik', 'server'].includes(deviceType);
                case 'odc':
                    return deviceType === 'odc';
                case 'odp':
                    return deviceType === 'odp';
                case 'customer':
                    return ['customer', 'cust_all'].includes(deviceType);
                default:
                    return deviceType === category;
            }
        }

        // Debounce function for search input
        function debounce(func, wait) {
            var timeout;
            return function executedFunction(...args) {
                var later = function() {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }


        function showQuickAddTypeSelection() {
            Swal.fire({
                title: '<i class="fa fa-plus-circle text-success"></i> Quick Add Device',
                html: `
            <div class="quick-add-grid">
                <div class="quick-add-item" onclick="Swal.close(); startQuickAddMode('olt');">
                    <div class="quick-add-icon olt">
                        <i class="fa-solid fa-broadcast-tower"></i>
                    </div>
                    <div class="quick-add-label">OLT</div>
                    <div class="quick-add-desc">Optical Line Terminal</div>
                </div>

                <div class="quick-add-item" onclick="Swal.close(); startQuickAddMode('odc');">
                    <div class="quick-add-icon odc">
                        <i class="fa fa-cube"></i>
                    </div>
                    <div class="quick-add-label">ODC</div>
                    <div class="quick-add-desc">Optical Distribution Cabinet</div>
                </div>

                <div class="quick-add-item" onclick="Swal.close(); startQuickAddMode('odp');">
                    <div class="quick-add-icon odp">
                        <i class="fa fa-circle-nodes"></i>
                    </div>
                    <div class="quick-add-label">ODP</div>
                    <div class="quick-add-desc">Optical Distribution Point</div>
                </div>

                <div class="quick-add-item" onclick="Swal.close(); startQuickAddMode('pole');">
                    <div class="quick-add-icon pole">
                        <i class="fa fa-map-pin"></i>
                    </div>
                    <div class="quick-add-label">Tiang</div>
                    <div class="quick-add-desc">Cable Waypoint</div>
                </div>
            </div>

            <div class="quick-add-info">
                <i class="fa fa-info-circle text-info"></i> 
                Pilih jenis device yang ingin ditambahkan ke peta
            </div>
        `,
                showConfirmButton: false,
                showCancelButton: true,
                cancelButtonText: '<i class="fa fa-times"></i> Cancel',
                width: 500,
                customClass: {
                    htmlContainer: 'quick-add-modal'
                }
            });
        }

        function startQuickAddMode(type) {
            quickAddMode = true;
            quickAddType = type;

            // Add body class untuk styling
            document.body.classList.add('quick-add-mode-active');

            // Update button - HANYA GANTI CLASS, TETAP ICON PLUS
            var btn = document.getElementById('quick-add-mode');
            btn.className = 'nav-btn nav-btn-danger';
            btn.title = 'Cancel Quick Add Mode';
            btn.innerHTML = '<i class="fa fa-times"></i>'; // UBAH ICON KE X

            // Show info
            document.getElementById('quick-add-info').style.display = 'block';
            document.getElementById('quick-add-info').querySelector('small').textContent =
                'Klik map untuk menambahkan ' + type.toUpperCase() + ' di lokasi tersebut';

            // Add cursor style
            document.getElementById('map').style.cursor = 'crosshair';

            // PERBAIKAN: Stop semua auto-minimize timer sebelum minimize
            clearAutoMinimizeTimer();

            // Auto minimize tray saat masuk Quick Add mode
            minimizeNavigationPanel();

            // Update routing status dengan instruksi untuk buka tray
            updateRoutingStatus('QUICK ADD MODE: Click map to add ' + type.toUpperCase() +
                '<br><small style="color: #17a2b8;"><i class="fa fa-info-circle"></i> Klik navigation panel untuk cancel</small>'
            );
        }

        function cancelQuickAddMode() {
            quickAddMode = false;
            quickAddType = '';

            // Reset button ke state normal
            resetQuickAddButton();

            // Hide info
            document.getElementById('quick-add-info').style.display = 'none';

            // Reset cursor
            document.getElementById('map').style.cursor = '';

            // TAMBAHAN BARU: Remove quick add mode class dari body
            document.body.classList.remove('quick-add-mode-active');

            hideRoutingStatus();

            // TIDAK auto-minimize lagi, biarkan user yang kontrolkan tray
            // Karena user baru saja buka tray untuk cancel
        }
        // TAMBAHKAN FUNGSI BARU INI
        function resetQuickAddButton() {
            var btn = document.getElementById('quick-add-mode');
            if (btn) {
                btn.className = 'nav-btn nav-btn-success'; // Kembali ke hijau
                btn.title = 'Quick Add Mode'; // Reset tooltip
                btn.innerHTML = '<i class="fa fa-plus"></i>'; // KEMBALIKAN ICON ASLI
                // Icon tetap sama, tidak perlu ubah innerHTML
            }
        }

        function handleQuickAddClick(e) {
            if (!quickAddMode) return;

            var lat = e.latlng.lat.toFixed(6);
            var lng = e.latlng.lng.toFixed(6);

            if (quickAddType === 'olt') { // TAMBAHAN BARU
                showQuickAddOltModal(lat, lng);
            } else if (quickAddType === 'odc') {
                showQuickAddOdcModal(lat, lng);
            } else if (quickAddType === 'odp') {
                showQuickAddOdpModal(lat, lng);
            } else if (quickAddType === 'pole') {
                showQuickAddPoleModal(lat, lng);
            }
        }

        function showQuickAddOdcModal(lat, lng) {
            var coordinates = lat + ',' + lng;
            var url = baseUrl + 'plugin/network_mapping/quick-add-odc&lat=' + lat + '&lng=' + lng;

            console.log('Fetching ODC data from:', url);

            // Fetch OLTs data (CHANGED: routers -> olts)
            fetch(url)
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers.get('Content-Type'));

                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }

                    return response.text();
                })
                .then(text => {
                    console.log('Raw response:', text);

                    try {
                        var data = JSON.parse(text);
                        console.log('Parsed data:', data);

                        if (data.success) {
                            // Populate coordinates
                            document.getElementById('odc-coordinates').value = coordinates;
                            document.getElementById('odc-coords-display').textContent = coordinates;

                            // Populate OLTs dropdown (CHANGED: routers -> olts)
                            var oltSelect = document.getElementById('odc-olt');
                            oltSelect.innerHTML = '<option value="">Select OLT (Optional)</option>';

                            if (data.olts && data.olts.length > 0) {
                                data.olts.forEach(function(olt) {
                                    var option = document.createElement('option');
                                    option.value = olt.id;
                                    option.textContent = olt.name + ' (Available: ' + olt
                                        .available_pon_ports_detail.length + '/' + olt.total_pon_ports +
                                        ' PON ports)';
                                    if (olt.available_pon_ports_detail.length <= 0) {
                                        option.disabled = true;
                                        option.textContent += ' - FULL';
                                    }
                                    oltSelect.appendChild(option);
                                });
                            }
                            // Populate ODCs dropdown for parent connection
                            var odcParentSelect = document.getElementById('odc-parent');
                            var portSelect = document.getElementById('odc-parent-port');
                            var portSection = document.getElementById('port-selection-section');

                            if (odcParentSelect) {
                                odcParentSelect.innerHTML = '<option value="">Select Parent ODC (Optional)</option>';

                                console.log('Available ODCs from networkData:', networkData.odcs);

                                if (networkData.odcs && networkData.odcs.length > 0) {
                                    networkData.odcs.forEach(function(odc) {
                                        var option = document.createElement('option');
                                        option.value = odc.id;
                                        option.textContent = odc.name + ' (Available: ' + odc.available_ports +
                                            '/' + odc.total_ports + ' ports)';
                                        odcParentSelect.appendChild(option);
                                    });
                                }
                            }

                            // Add mutual exclusive selection for modal (CHANGED: router -> olt)
                            var modalOltSelect = document.getElementById('odc-olt');
                            var modalOdcSelect = document.getElementById('odc-parent');

                            if (modalOltSelect && modalOdcSelect) {
                                modalOltSelect.addEventListener('change', function() {
                                    if (this.value) {
                                        modalOdcSelect.value = '';
                                        modalOdcSelect.disabled = true;
                                        portSelect.disabled = true;
                                        portSection.style.display = 'none';
                                        loadAvailablePonPortsForQuickAdd(this.value);
                                        loadParentOltPonPorts(this.value);
                                        document.getElementById('olt-pon-port-section').style.display = 'block';
                                    } else {
                                        modalOdcSelect.disabled = false;
                                        document.getElementById('olt-pon-port-section').style.display = 'none';
                                    }
                                });

                                modalOdcSelect.addEventListener('change', function() {
                                    if (this.value) {
                                        modalOltSelect.value = '';
                                        modalOltSelect.disabled = true;
                                        loadAvailablePortsForQuickAdd(this.value);
                                        portSection.style.display = 'block';
                                        document.getElementById('olt-pon-port-section').style.display = 'none';
                                    } else {
                                        modalOltSelect.disabled = false;
                                        portSelect.disabled = true;
                                        portSection.style.display = 'none';
                                        portSelect.innerHTML = '<option value="">Select Port</option>';
                                        document.getElementById('port-status-info').innerHTML = '';
                                    }
                                });
                            }

                            // Clear form
                            document.getElementById('quickAddOdcForm').reset();
                            document.getElementById('odc-coordinates').value = coordinates;

                            // Show modal
                            $('#quickAddOdcModal').modal('show');

                            // Focus on name field
                            setTimeout(function() {
                                document.getElementById('odc-name').focus();
                            }, 500);

                        } else {
                            Swal.fire('Error', data.message || 'Unknown error', 'error');
                        }

                    } catch (parseError) {
                        console.error('JSON Parse Error:', parseError);
                        console.error('Response was:', text);
                        Swal.fire('Error', 'Invalid response format. Check console for details.', 'error');
                    }
                })
                .catch(error => {
                    console.error('Fetch Error:', error);
                    Swal.fire('Error', 'Failed to load ODC form: ' + error.message, 'error');
                });
        }

        function loadAvailablePortsForQuickAdd(odcId) {
            var portSelect = document.getElementById('odc-parent-port');
            var portStatusInfo = document.getElementById('port-status-info');

            if (!portSelect || !odcId) return;

            portSelect.innerHTML = '<option value="">Loading ports...</option>';
            portSelect.disabled = true;
            portStatusInfo.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Loading port information...';

            fetch(baseUrl + 'plugin/network_mapping/get-available-ports&odc_id=' + odcId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        portSelect.innerHTML = '<option value="">Auto port</option>';

                        // Add available ports
                        if (data.available_ports && data.available_ports.length > 0) {
                            data.available_ports.forEach(function(port) {
                                var option = document.createElement('option');
                                option.value = port;
                                option.textContent = 'Port ' + port + ' (Available)';
                                portSelect.appendChild(option);
                            });

                            portSelect.disabled = false;
                        } else {
                            var option = document.createElement('option');
                            option.value = '';
                            option.textContent = 'No available ports';
                            option.disabled = true;
                            portSelect.appendChild(option);
                        }

                        // Update port status info
                        updatePortStatusInfo(data.used_ports_detail, data.available_ports);

                    } else {
                        portSelect.innerHTML = '<option value="">Error loading ports</option>';
                        portStatusInfo.innerHTML = '<span class="text-danger">Error: ' + data.message + '</span>';
                    }
                })
                .catch(error => {
                    console.error('Error loading ports:', error);
                    portSelect.innerHTML = '<option value="">Error loading ports</option>';
                    portStatusInfo.innerHTML = '<span class="text-danger">Error loading ports</span>';
                });
        }


        function loadAvailablePortsForOdpQuickAdd(odcId) {
            var portSelect = document.getElementById('odp-port-number');
            var portStatusInfo = document.getElementById('odp-port-status-info');

            if (!portSelect || !odcId) return;

            portSelect.innerHTML = '<option value="">Loading ports...</option>';
            portSelect.disabled = true;
            portStatusInfo.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Loading port information...';

            fetch(baseUrl + 'plugin/network_mapping/get-available-ports&odc_id=' + odcId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        portSelect.innerHTML = '<option value="">Auto port</option>';

                        // Add available ports
                        if (data.available_ports && data.available_ports.length > 0) {
                            data.available_ports.forEach(function(port) {
                                var option = document.createElement('option');
                                option.value = port;
                                option.textContent = 'Port ' + port + ' (Available)';
                                portSelect.appendChild(option);
                            });

                            portSelect.disabled = false;
                        } else {
                            var option = document.createElement('option');
                            option.value = '';
                            option.textContent = 'No available ports';
                            option.disabled = true;
                            portSelect.appendChild(option);
                        }

                        // Update port status info for ODP
                        updateOdpPortStatusInfo(data.used_ports_detail, data.available_ports);

                    } else {
                        portSelect.innerHTML = '<option value="">Error loading ports</option>';
                        portStatusInfo.innerHTML = '<span class="text-danger">Error: ' + data.message + '</span>';
                    }
                })
                .catch(error => {
                    console.error('Error loading ports:', error);
                    portSelect.innerHTML = '<option value="">Error loading ports</option>';
                    portStatusInfo.innerHTML = '<span class="text-danger">Error loading ports</span>';
                });
        }

        function updateOdpPortStatusInfo(usedPortsDetail, availablePorts) {
            var portStatusInfo = document.getElementById('odp-port-status-info');
            if (!portStatusInfo) return;

            var statusHtml = '';

            // Show used ports
            if (usedPortsDetail && Object.keys(usedPortsDetail).length > 0) {
                statusHtml +=
                    '<div style="background: rgba(255, 193, 7, 0.1); border: 1px solid #ffc107; padding: 4px 6px; border-radius: 3px; margin-bottom: 4px;">';
                statusHtml += '<strong style="color: #856404;">Used Ports:</strong><br>';

                Object.keys(usedPortsDetail).forEach(function(port) {
                    var detail = usedPortsDetail[port];
                    statusHtml += '• Port ' + port + ': ' + detail.name + ' (' + detail.type.toUpperCase() +
                        ')<br>';
                });

                statusHtml = statusHtml.slice(0, -4); // Remove last <br>
                statusHtml += '</div>';
            }

            // Show available ports
            if (availablePorts && availablePorts.length > 0) {
                statusHtml +=
                    '<div style="background: rgba(40, 167, 69, 0.1); border: 1px solid #28a745; padding: 4px 6px; border-radius: 3px;">';
                statusHtml += 'Port ' + availablePorts.join(', Port ');
                statusHtml += '</div>';
            } else if (!usedPortsDetail || Object.keys(usedPortsDetail).length === 0) {
                statusHtml +=
                    '<div style="background: rgba(108, 117, 125, 0.1); border: 1px solid #6c757d; padding: 4px 6px; border-radius: 3px;">';
                statusHtml += '<strong style="color: #495057;">No ports available</strong>';
                statusHtml += '</div>';
            }

            portStatusInfo.innerHTML = statusHtml;
        }

        function updatePortStatusInfo(usedPortsDetail, availablePorts) {
            var portStatusInfo = document.getElementById('port-status-info');
            if (!portStatusInfo) return;

            var statusHtml = '';

            // Show used ports
            if (usedPortsDetail && Object.keys(usedPortsDetail).length > 0) {
                statusHtml +=
                    '<div style="background: rgba(255, 193, 7, 0.1); border: 1px solid #ffc107; padding: 4px 6px; border-radius: 3px; margin-bottom: 4px;">';
                statusHtml += '<strong style="color: #856404;">Used Ports:</strong><br>';

                Object.keys(usedPortsDetail).forEach(function(port) {
                    var detail = usedPortsDetail[port];
                    statusHtml += '• Port ' + port + ': ' + detail.name + ' (' + detail.type.toUpperCase() +
                        ')<br>';
                });

                statusHtml = statusHtml.slice(0, -4); // Remove last <br>
                statusHtml += '</div>';
            }

            // Show available ports
            if (availablePorts && availablePorts.length > 0) {
                statusHtml +=
                    '<div style="background: rgba(40, 167, 69, 0.1); border: 1px solid #28a745; padding: 4px 6px; border-radius: 3px;">';
                statusHtml += '<strong style="color: #155724;">Available Ports:</strong> ';
                statusHtml += 'Port ' + availablePorts.join(', Port ');
                statusHtml += '</div>';
            } else if (!usedPortsDetail || Object.keys(usedPortsDetail).length === 0) {
                statusHtml +=
                    '<div style="background: rgba(108, 117, 125, 0.1); border: 1px solid #6c757d; padding: 4px 6px; border-radius: 3px;">';
                statusHtml += '<strong style="color: #495057;">No ports available</strong>';
                statusHtml += '</div>';
            }

            portStatusInfo.innerHTML = statusHtml;
        }

        function showQuickAddOdpModal(lat, lng) {
            var coordinates = lat + ',' + lng;

            console.log('Fetching data from:', baseUrl + 'plugin/network_mapping/quick-add-odp&lat=' + lat + '&lng=' + lng);

            // Fetch ODCs and customers data
            fetch(baseUrl + 'plugin/network_mapping/quick-add-odp&lat=' + lat + '&lng=' + lng)
                .then(response => {
                    console.log('Response status:', response.status);
                    return response.json();
                })
                .then(data => {
                    console.log('Response data:', data);

                    if (data.success) {
                        // Store data globally
                        window.quickAddData = data;
                        console.log('Stored customer count:', data.customers ? data.customers.length : 0);

                        // Populate coordinates
                        document.getElementById('odp-coordinates').value = coordinates;
                        document.getElementById('odp-coords-display').textContent = coordinates;

                        // Populate ODCs dropdown
                        var odcSelect = document.getElementById('odp-odc');
                        var portSelect = document.getElementById('odp-port-number');
                        var portSection = document.getElementById('odp-port-selection-section');

                        odcSelect.innerHTML = '<option value="">Select ODC (Optional)</option>';

                        data.odcs.forEach(function(odc) {
                            var availablePorts = odc.total_ports - odc.used_ports;
                            var option = document.createElement('option');
                            option.value = odc.id;
                            option.textContent = odc.name + ' (Available: ' + availablePorts + '/' + odc
                                .total_ports + ' ports)';
                            if (availablePorts <= 0) {
                                option.disabled = true;
                                option.textContent += ' - FULL';
                            }
                            odcSelect.appendChild(option);
                        });

                        // Add ODC selection handler
                        odcSelect.addEventListener('change', function() {
                            if (this.value) {
                                loadAvailablePortsForOdpQuickAdd(this.value);
                                portSection.style.display = 'block';
                            } else {
                                portSelect.disabled = true;
                                portSection.style.display = 'none';
                                portSelect.innerHTML = '<option value="">Select Port</option>';
                                document.getElementById('odp-port-status-info').innerHTML = '';
                            }
                        });

                        // Load customers
                        loadQuickAddCustomers();

                        // Clear form
                        document.getElementById('quickAddOdpForm').reset();
                        document.getElementById('odp-coordinates').value = coordinates;
                        document.getElementById('odp-coords-display').textContent = coordinates;

                        // Show modal
                        $('#quickAddOdpModal').modal('show');

                        // Focus on name field
                        setTimeout(function() {
                            document.getElementById('odp-name').focus();
                        }, 500);
                    } else {
                        console.error('API returned error:', data.message);
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    Swal.fire('Error', 'Failed to load ODP form', 'error');
                });
        }

        function loadCustomerPageWithPorts(searchTerm, page, limit) {
            var customerList = document.getElementById('quick-customer-list');

            if (page === 1) {
                customerList.innerHTML = '<div class="text-center"><i class="fa fa-spinner fa-spin"></i> ' +
                    (searchTerm ? 'Searching...' : 'Loading customers...') + '</div>';
            }

            var url = baseUrl + 'plugin/network_mapping/search-customers&q=' + encodeURIComponent(searchTerm) +
                '&page=' + page + '&limit=' + limit;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.customers) {
                        if (page === 1) {
                            customerList.innerHTML = '';
                        }

                        if (data.customers.length === 0) {
                            customerList.innerHTML = '<div class="text-center text-muted">No customers found' +
                                (searchTerm ? ' for "' + searchTerm + '"' : '') + '</div>';
                            return;
                        }

                        // Render customers with port selection
                        renderCustomersWithPortSelection(data.customers);

                        // Add pagination if needed
                        if (data.has_more) {
                            var loadMoreDiv = document.createElement('div');
                            loadMoreDiv.className = 'text-center';
                            loadMoreDiv.style.padding = '8px';
                            loadMoreDiv.innerHTML =
                                '<button type="button" class="btn btn-xs btn-default" onclick="loadMoreCustomersWithPorts(\'' +
                                searchTerm + '\', ' + (page + 1) + ', ' + limit + ')">' +
                                '<i class="fa fa-plus"></i> Load More (' + data.remaining + ' more available)' +
                                '</button>';
                            customerList.appendChild(loadMoreDiv);
                        }

                        // Show summary
                        if (page === 1) {
                            var summaryDiv = document.createElement('div');
                            summaryDiv.className = 'text-center text-info';
                            summaryDiv.style.padding = '4px 8px';
                            summaryDiv.style.fontSize = '11px';
                            summaryDiv.style.borderBottom = '1px solid #eee';
                            summaryDiv.innerHTML = 'Showing ' + data.customers.length +
                                (data.total_found > data.customers.length ? ' of ' + data.total_found : '') +
                                ' customers';
                            customerList.insertBefore(summaryDiv, customerList.firstChild);
                        }

                        setupCustomerPortSelectionHandlers();

                    } else {
                        customerList.innerHTML = '<div class="text-center text-danger">Error loading customers</div>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    customerList.innerHTML = '<div class="text-center text-danger">Error loading customers</div>';
                });
        }

        // Load customers for quick add
        function loadQuickAddCustomers() {
            var customerList = document.getElementById('quick-customer-list');
            customerList.innerHTML =
                '<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Loading first 5 customers...</div>';

            // Load first 5 customers by default
            loadCustomerPageWithPorts('', 1, 5);

            var searchInput = document.getElementById('quick-customer-search');
            var searchTimeout;

            // Clear existing event listeners
            if (searchInput) {
                searchInput.removeEventListener('input', searchInput._searchHandler);

                // Real-time search
                searchInput._searchHandler = function() {
                    var searchTerm = this.value.trim();

                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(function() {
                        loadCustomerPage(searchTerm, 1, 10); // Show more results when searching
                    }, 300);
                };

                searchInput.addEventListener('input', searchInput._searchHandler);
            }
        }


        function renderCustomersWithPortSelection(customers) {
            var customerList = document.getElementById('quick-customer-list');

            customers.forEach(function(customer) {
                var customerDiv = document.createElement('div');
                customerDiv.className = 'customer-port-item';

                // Check if customer already connected to another ODP
                var isConnected = customer.odp_id && customer.connection_status === 'Active';
                var isDisabled = isConnected ? 'disabled' : '';
                var connectedInfo = isConnected ?
                    '<br><small style="color: #d9534f;">⚠ Already connected to ODP</small>' : '';

                // ✅ PERBAIKAN: Process customer photo dengan structure yang benar
                var photoHtml = '';
                if (customer.photo && customer.photo !== '/user.default.jpg' && customer.photo.indexOf(
                        'user.default.jpg') === -1) {
                    // ✅ FIX KONSISTENSI: Photo URL sudah auto-prefix di PHP, tidak perlu prefix lagi di JavaScript
                    var photoUrl = customer.photo; // Sudah include /system/uploads dari PHP processing

                    console.log('Loading customer photo:', photoUrl);

                    var initials = customer.fullname.split(' ').map(function(n) { return n[0]; }).join('').substr(0,
                        2).toUpperCase();

                    photoHtml = '<div class="customer-photo-mini">' +
                        '<div class="customer-photo-container-mini" style="width: 35px; height: 35px; position: relative;">' +
                        '<img src="' + photoUrl + '" alt="' + customer.fullname + '" ' +
                        'style="width: 35px; height: 35px; border-radius: 50%; object-fit: cover; border: 2px solid #17a2b8; display: block;" ' +
                        'onload="handleMiniPhotoSuccess(this)" ' +
                        'onerror="handleMiniPhotoError(this)">' +
                        '<div class="customer-avatar-mini-fallback" style="display: none; width: 35px; height: 35px; border-radius: 50%; background: linear-gradient(135deg, #17a2b8, #138496); color: white; font-size: 12px; font-weight: bold; align-items: center; justify-content: center; border: 2px solid #fff; position: absolute; top: 0; left: 0;">' +
                        initials +
                        '</div>' +
                        '</div>' +
                        '</div>';
                } else {
                    // Langsung tampilkan avatar inisial
                    var initials = customer.fullname.split(' ').map(function(n) { return n[0]; }).join('').substr(0,
                        2).toUpperCase();
                    var colors = ['#e74c3c', '#f39c12', '#f1c40f', '#27ae60', '#2ecc71', '#3498db', '#9b59b6',
                        '#e67e22'
                    ];
                    var bgColor = colors[customer.fullname.length % colors.length];

                    photoHtml = '<div class="customer-photo-mini">' +
                        '<div style="width: 35px; height: 35px; border-radius: 50%; background: linear-gradient(135deg, ' +
                        bgColor +
                        ', #2c3e50); color: white; font-size: 12px; font-weight: bold; display: flex; align-items: center; justify-content: center; border: 2px solid #fff;">' +
                        initials +
                        '</div>' +
                        '</div>';
                }

                // Get total ports for port options
                var totalPorts = parseInt(document.getElementById('odp-total-ports').value) || 8;
                var portOptions = '<option value="">Select Port</option>';
                for (var i = 1; i <= totalPorts; i++) {
                    portOptions += '<option value="' + i + '">Port ' + i + '</option>';
                }

                customerDiv.innerHTML =
                    '<div class="customer-checkbox-section">' +
                    '<input type="checkbox" class="customer-checkbox quick-customer-checkbox" value="' +
                    customer.id + '" name="customers[]" ' + isDisabled + '>' +
                    '</div>' +
                    '<div class="customer-photo-section">' + photoHtml + '</div>' +
                    '<div class="customer-info-section ' + (isConnected ? 'customer-already-connected' : '') +
                    '">' +
                    '<div class="customer-name">' + customer.fullname + '</div>' +
                    '<div class="customer-details">Username: ' + customer.username +
                    (customer.address ? ' | ' + customer.address : '') + connectedInfo + '</div>' +
                    '</div>' +
                    '<div class="customer-port-section">' +
                    '<select class="customer-port-select" name="customer_ports[' + customer.id + ']" disabled ' +
                    isDisabled + '>' +
                    portOptions +
                    '</select>' +
                    '</div>';

                if (isConnected) {
                    customerDiv.style.opacity = '0.5';
                    customerDiv.title = 'Customer already connected to another ODP';
                }

                customerList.appendChild(customerDiv);
            });
        }

        function loadMoreCustomersWithPorts(searchTerm, page, limit) {
            // Similar to loadMoreCustomers but calls loadCustomerPageWithPorts
            var loadMoreBtn = document.querySelector('#quick-customer-list .btn');
            if (loadMoreBtn && loadMoreBtn.parentElement) {
                loadMoreBtn.parentElement.remove();
            }

            var loadingDiv = document.createElement('div');
            loadingDiv.className = 'text-center';
            loadingDiv.style.padding = '8px';
            loadingDiv.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Loading more...';
            document.getElementById('quick-customer-list').appendChild(loadingDiv);

            loadCustomerPageWithPorts(searchTerm, page, limit);

            setTimeout(() => {
                if (loadingDiv.parentElement) {
                    loadingDiv.remove();
                }
            }, 1000);
        }



        function setupCustomerPortSelectionHandlers() {
            // Handle checkbox changes
            document.querySelectorAll('.quick-customer-checkbox').forEach(function(checkbox) {
                checkbox.addEventListener('change', function() {
                    var portSelect = this.closest('.customer-port-item').querySelector(
                        '.customer-port-select');

                    if (this.checked) {
                        portSelect.disabled = false;
                        this.closest('.customer-port-item').classList.add('selected');
                    } else {
                        portSelect.disabled = true;
                        portSelect.value = '';
                        this.closest('.customer-port-item').classList.remove('selected');

                        // Update port availability
                        updatePortAvailability();
                    }

                    updateQuickCustomerCountWithPorts();
                    validatePortAssignments();
                });
            });

            // Handle port selection changes
            document.querySelectorAll('.customer-port-select').forEach(function(select) {
                select.addEventListener('change', function() {
                    validatePortAssignments();
                    updatePortAvailability();
                });
            });

            // Handle total ports change
            document.getElementById('odp-total-ports').addEventListener('change', function() {
                updatePortOptionsForAllCustomers();
                updateQuickCustomerCountWithPorts();
                validatePortAssignments();
            });
        }

        function updateQuickCustomerCountWithPorts() {
            var checkedBoxes = document.querySelectorAll('.quick-customer-checkbox:checked');
            var totalPorts = parseInt(document.getElementById('odp-total-ports').value) || 8;
            var selectedCount = checkedBoxes.length;
            var availablePorts = totalPorts - selectedCount;

            // Update counters
            document.getElementById('quick-selected-count').textContent = selectedCount + '/' + totalPorts;
            document.getElementById('quick-available-ports').textContent = Math.max(0, availablePorts);

            // Update counter color
            var counterElement = document.getElementById('quick-selected-count');
            if (selectedCount > totalPorts) {
                counterElement.style.backgroundColor = '#d9534f';
            } else if (selectedCount === totalPorts) {
                counterElement.style.backgroundColor = '#f0ad4e';
            } else {
                counterElement.style.backgroundColor = '#5cb85c';
            }
        }

        function validatePortAssignments() {
            var checkedBoxes = document.querySelectorAll('.quick-customer-checkbox:checked');
            var usedPorts = [];
            var hasConflict = false;

            checkedBoxes.forEach(function(checkbox) {
                var portSelect = checkbox.closest('.customer-port-item').querySelector('.customer-port-select');
                var selectedPort = portSelect.value;

                if (selectedPort) {
                    if (usedPorts.includes(selectedPort)) {
                        // Port conflict
                        portSelect.style.borderColor = '#d9534f';
                        portSelect.style.backgroundColor = '#fff5f5';
                        hasConflict = true;
                    } else {
                        // Port OK
                        portSelect.style.borderColor = '#28a745';
                        portSelect.style.backgroundColor = '#f8fff8';
                        usedPorts.push(selectedPort);
                    }
                } else {
                    // No port selected
                    portSelect.style.borderColor = '#ffc107';
                    portSelect.style.backgroundColor = '#fffdf5';
                }
            });

            // Update submit button state
            var submitBtn = document.querySelector('#quickAddOdpForm button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = hasConflict;
            }

            return !hasConflict;
        }

        function updatePortAvailability() {
            var checkedBoxes = document.querySelectorAll('.quick-customer-checkbox:checked');
            var usedPorts = [];

            // Collect used ports
            checkedBoxes.forEach(function(checkbox) {
                var portSelect = checkbox.closest('.customer-port-item').querySelector('.customer-port-select');
                var selectedPort = portSelect.value;
                if (selectedPort) {
                    usedPorts.push(selectedPort);
                }
            });

            // Update all port selects
            document.querySelectorAll('.customer-port-select').forEach(function(select) {
                var currentValue = select.value;
                var isDisabled = select.disabled;

                // Rebuild options
                var totalPorts = parseInt(document.getElementById('odp-total-ports').value) || 8;
                select.innerHTML = '<option value="">Select Port</option>';

                for (var i = 1; i <= totalPorts; i++) {
                    var option = document.createElement('option');
                    option.value = i;
                    option.textContent = 'Port ' + i;

                    // Disable if port is used by another customer
                    if (usedPorts.includes(i.toString()) && currentValue !== i.toString()) {
                        option.disabled = true;
                        option.textContent += ' (Used)';
                    }

                    select.appendChild(option);
                }

                // Restore value if still valid
                if (currentValue && !isDisabled) {
                    select.value = currentValue;
                }
            });
        }

        function updatePortOptionsForAllCustomers() {
            var totalPorts = parseInt(document.getElementById('odp-total-ports').value) || 8;

            document.querySelectorAll('.customer-port-select').forEach(function(select) {
                var currentValue = select.value;
                var isDisabled = select.disabled;

                select.innerHTML = '<option value="">Select Port</option>';

                for (var i = 1; i <= totalPorts; i++) {
                    var option = document.createElement('option');
                    option.value = i;
                    option.textContent = 'Port ' + i;
                    select.appendChild(option);
                }

                // Restore value if within new range
                if (currentValue && parseInt(currentValue) <= totalPorts && !isDisabled) {
                    select.value = currentValue;
                }
            });

            updatePortAvailability();
        }

        function saveQuickAddOdc() {
            var form = document.getElementById('quickAddOdcForm');
            var formData = new FormData(form);

            // Show loading
            Swal.fire({
                title: 'Saving ODC...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            fetch(baseUrl + 'plugin/network_mapping/quick-save-odc', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Close modal
                        $('#quickAddOdcModal').modal('hide');

                        // SIMPAN POSISI SEBELUM RELOAD
                        mapPositionMemory.savePosition();

                        // Success message
                        Swal.fire({
                            icon: 'success',
                            title: 'ODC Added!',
                            html: '<p><strong>Name:</strong> ' + data.odc.name + '</p>' +
                                '<p><strong>Coordinates:</strong> ' + data.odc.coordinates + '</p>' +
                                '<p><strong>Total Ports:</strong> ' + data.odc.total_ports + '</p>' +
                                '<p class="text-info"><i class="fa fa-refresh"></i> Map akan tetap di posisi ini setelah reload...</p>',
                            timer: 2000,
                            showConfirmButton: false
                        }).then(() => {
                            // TAMBAHAN BARU: Reset body class sebelum reload
                            document.body.classList.remove('quick-add-mode-active');
                            // TAMBAHAN BARU: Reset button sebelum reload
                            resetQuickAddButton();

                            // Reload page - posisi akan di-restore otomatis
                            window.location.reload();
                        });

                        // Cancel quick add mode immediately
                        cancelQuickAddMode();

                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to save ODC', 'error');
                });
        }

        function saveQuickAddOdp() {
            var form = document.getElementById('quickAddOdpForm');
            var formData = new FormData(form);

            // ✅ PERBAIKAN: Validate dan auto-assign ports
            var selectedCustomers = [];
            var customerPorts = {};
            var checkboxes = document.querySelectorAll('.quick-customer-checkbox:checked');

            checkboxes.forEach(function(checkbox) {
                var customerId = checkbox.value;
                selectedCustomers.push(customerId);

                var portSelect = checkbox.closest('.customer-port-item').querySelector('.customer-port-select');
                var selectedPort = portSelect.value;

                // ✅ PERBAIKAN: Hanya set port jika ada value yang dipilih
                if (selectedPort && selectedPort !== '') {
                    customerPorts[customerId] = selectedPort;
                }
                // Jika tidak ada port dipilih, biarkan kosong - akan di-auto-assign di backend
            });

            console.log('Selected customers:', selectedCustomers);
            console.log('Customer ports (manual only):', customerPorts);

            // ✅ PERBAIKAN: Clear existing customer_ports di FormData dan set yang baru
            // Remove existing customer_ports entries
            var keysToDelete = [];
            for (var pair of formData.entries()) {
                if (pair[0].startsWith('customer_ports[')) {
                    keysToDelete.push(pair[0]);
                }
            }
            keysToDelete.forEach(key => formData.delete(key));

            // Add valid customer ports only
            Object.keys(customerPorts).forEach(function(customerId) {
                if (customerPorts[customerId] && customerPorts[customerId] !== '') {
                    formData.append('customer_ports[' + customerId + ']', customerPorts[customerId]);
                }
            });

            // Show loading
            Swal.fire({
                title: 'Saving ODP...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            fetch(baseUrl + 'plugin/network_mapping/quick-save-odp', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    console.log('Save response:', data);

                    if (data.success) {
                        // Close modal
                        $('#quickAddOdpModal').modal('hide');

                        // SIMPAN POSISI SEBELUM RELOAD
                        mapPositionMemory.savePosition();

                        // Success message
                        Swal.fire({
                            icon: 'success',
                            title: 'ODP Added!',
                            html: '<p><strong>Name:</strong> ' + data.odp.name + '</p>' +
                                '<p><strong>Coordinates:</strong> ' + data.odp.coordinates + '</p>' +
                                '<p><strong>Total Ports:</strong> ' + data.odp.total_ports + '</p>' +
                                '<p><strong>Used Ports:</strong> ' + data.odp.used_ports + '</p>' +
                                '<p class="text-info"><i class="fa fa-refresh"></i> Map akan tetap di posisi ini setelah reload...</p>',
                            timer: 2000,
                            showConfirmButton: false
                        }).then(() => {
                            // TAMBAHAN BARU: Reset body class sebelum reload
                            document.body.classList.remove('quick-add-mode-active');
                            // TAMBAHAN BARU: Reset button sebelum reload
                            resetQuickAddButton();

                            // Reload page - posisi akan di-restore otomatis
                            window.location.reload();
                        });

                        // Cancel quick add mode immediately
                        cancelQuickAddMode();

                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to save ODP', 'error');
                });
        }


        // Update routing status
        // GANTI:
        function updateRoutingStatus(message) {
            var statusElement = document.getElementById('status-text'); // ← ERROR
            if (statusElement) {
                statusElement.innerHTML = message;
            }
            // ... dst
        }

        // DENGAN:
        function updateRoutingStatus(message) {
            // Cek beberapa kemungkinan element
            var statusElement = document.getElementById('status-text') ||
                document.getElementById('connection-type-info') ||
                document.getElementById('routing-connection-info');

            if (statusElement) {
                statusElement.innerHTML = message;
            } else {
                console.log('Routing Status:', message); // Fallback
            }

            var routingElement = document.getElementById('routing-status') ||
                document.getElementById('routing-connection-info');
            if (routingElement) {
                routingElement.style.display = 'block';
            }
        }

        // Hide routing status
        function hideRoutingStatus() {
            var routingElement = document.getElementById('routing-status');
            if (routingElement) {
                routingElement.style.display = 'none';
            }
        }

        function setupLayerControls() {
            var showRouters = document.getElementById('show-routers');
            var showOlts = document.getElementById('show-olts'); // TAMBAHAN BARU
            var showOdcs = document.getElementById('show-odcs');
            var showOdps = document.getElementById('show-odps');
            var showCustomers = document.getElementById('show-customers');
            var showCables = document.getElementById('show-cables');
            var showCoverage = document.getElementById('show-coverage');

            if (showRouters) {
                showRouters.addEventListener('change', function() {
                    if (this.checked) {
                        map.addLayer(markersGroup.routers);
                    } else {
                        map.removeLayer(markersGroup.routers);
                    }
                });
            }
            // TAMBAHAN BARU - OLT layer control
            if (showOlts) {
                showOlts.addEventListener('change', function() {
                    if (this.checked) {
                        map.addLayer(markersGroup.olts);
                    } else {
                        map.removeLayer(markersGroup.olts);
                    }
                });
            }

            if (showOdcs) {
                showOdcs.addEventListener('change', function() {
                    if (this.checked) {
                        map.addLayer(markersGroup.odcs);
                    } else {
                        map.removeLayer(markersGroup.odcs);
                    }
                });
            }

            if (showOdps) {
                showOdps.addEventListener('change', function() {
                    if (this.checked) {
                        map.addLayer(markersGroup.odps);
                    } else {
                        map.removeLayer(markersGroup.odps);
                    }
                });
            }

            if (showCustomers) {
                showCustomers.addEventListener('change', function() {
                    if (this.checked) {
                        map.addLayer(markersGroup.customers);
                    } else {
                        map.removeLayer(markersGroup.customers);
                    }
                });
            }

            if (showCables) {
                showCables.addEventListener('change', function() {
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
                showCoverage.addEventListener('change', function() {
                    // Toggle coverage circles
                    markersGroup.routers.eachLayer(function(layer) {
                        if (layer instanceof L.Circle) {
                            if (this.checked) {
                                layer.setStyle({opacity: 1, fillOpacity: 0.1});
                            } else {
                                layer.setStyle({opacity: 0, fillOpacity: 0});
                            }
                        }
                    }.bind(this));
                });
            }
            // TAMBAHAN: Event handler untuk Quick Add OLT form
            document.getElementById('quickAddOltForm').addEventListener('submit', function(e) {
                e.preventDefault();
                saveQuickAddOlt();
            });

            // TAMBAHAN BARU UNTUK POLES
            var showPoles = document.getElementById('show-poles');
            if (showPoles) {
                showPoles.addEventListener('change', function() {
                    if (this.checked) {
                        map.addLayer(markersGroup.poles);
                    } else {
                        map.removeLayer(markersGroup.poles);
                    }
                });
            }
        }


        function showRouterDetail(id) {
            // Find router data from networkData
            var router = null;
            if (networkData.routers) {
                router = networkData.routers.find(function(r) {
                    return r.id == id;
                });
            }

            if (router) {
                var detailHtml = '<div class="text-left">' +
                    '<h4><i class="fa fa-server text-primary"></i> ' + router.name + '</h4>' +
                    '<hr>' +
                    '<p><strong>Description:</strong> ' + (router.description || 'No description') + '</p>' +
                    '<p><strong>Coordinates:</strong> ' + router.coordinates + '</p>' +
                    '<p><strong>Coverage:</strong> ' + router.coverage + ' meters</p>' +
                    '<p><strong>Status:</strong> ' + (router.enabled == 1 ?
                        '<span class="label label-success">Active</span>' :
                        '<span class="label label-danger">Inactive</span>') + '</p>' +
                    '<hr>' +
                    '<div class="text-center">' +
                    '<button type="button" class="btn btn-info center-map-btn">Center on Map</button>' +
                    '<button type="button" class="btn btn-warning route-cable-btn" style="margin-left: 10px;">Route Cable</button>' +
                    '</div>' +
                    '</div>';

                Swal.fire({
                    title: 'Router Details',
                    html: detailHtml,
                    width: 600,
                    showConfirmButton: true,
                    confirmButtonText: '<i class="fa fa-edit"></i> Edit Router',
                    confirmButtonColor: '#f0ad4e',
                    showCancelButton: true,
                    cancelButtonText: 'Close',
                    showCloseButton: true,
                    didOpen: () => {
                        var centerBtn = document.querySelector('.swal2-html-container .center-map-btn');
                        var routeBtn = document.querySelector('.swal2-html-container .route-cable-btn');

                        if (centerBtn) {
                            centerBtn.addEventListener('click', function() {
                                centerMapOnRouter(router.id);
                            });
                        }

                        if (routeBtn) {
                            routeBtn.addEventListener('click', function() {
                                Swal.close();
                                startRoutingFromPoint('router', router.id, router.name, router
                                    .coordinates);
                            });
                        }
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        var editUrl = window.location.protocol + '//' + window.location.host +
                            '/?_route=routers/edit&id=' + router.id;
                        window.location.href = editUrl;
                    }
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Router Not Found',
                    text: 'Unable to find router details'
                });
            }
        }

        function showOdcDetail(id) {
            var odc = null;
            if (networkData.odcs) {
                odc = networkData.odcs.find(function(o) {
                    return o.id == id;
                });
            }

            if (odc) {
                var detailHtml = '<div class="text-left">' +
                    '<h4><i class="fa fa-cube text-success"></i> ' + odc.name + '</h4>' +
                    '<hr>' +
                    '<p><strong>Description:</strong> ' + (odc.description || 'No description') + '</p>' +
                    '<p><strong>Coordinates:</strong> ' + odc.coordinates + '</p>' +
                    '<p><strong>Address:</strong> ' + (odc.address || 'No address') + '</p>' +
                    '<p><strong>Ports:</strong> ' + odc.used_ports + '/' + odc.total_ports + ' (Available: ' + odc
                    .available_ports + ')</p>' +
                    '<p><strong>Connected Router:</strong> ' + (odc.router_id ? 'Router #' + odc.router_id :
                        'No router connected') + '</p>' +
                    '<hr>' +
                    '<div class="text-center">' +
                    '<button type="button" class="btn btn-info center-map-btn">Center on Map</button>' +
                    '<button type="button" class="btn btn-warning route-cable-btn" style="margin-left: 10px;">Route Cable</button>' +
                    '</div>' +
                    '</div>';

                Swal.fire({
                    title: 'ODC Details',
                    html: detailHtml,
                    width: 600,
                    showConfirmButton: true,
                    confirmButtonText: '<i class="fa fa-edit"></i> Edit ODC',
                    confirmButtonColor: '#f0ad4e',
                    showCancelButton: true,
                    cancelButtonText: 'Close',
                    showCloseButton: true,
                    didOpen: () => {
                        var centerBtn = document.querySelector('.swal2-html-container .center-map-btn');
                        var routeBtn = document.querySelector('.swal2-html-container .route-cable-btn');

                        if (centerBtn) {
                            centerBtn.addEventListener('click', function() {
                                centerMapOnOdc(odc.id);
                            });
                        }

                        if (routeBtn) {
                            routeBtn.addEventListener('click', function() {
                                Swal.close();
                                startRoutingFromPoint('odc', odc.id, odc.name, odc.coordinates);
                            });
                        }
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        var editUrl = window.location.protocol + '//' + window.location.host +
                            '/?_route=plugin/network_mapping/edit-odc&id=' + odc.id;
                        window.location.href = editUrl;
                    }
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'ODC Not Found',
                    text: 'Unable to find ODC details'
                });
            }
        }

        function showOdpDetail(id) {
            var odp = null;
            if (networkData.odps) {
                odp = networkData.odps.find(function(o) {
                    return o.id == id;
                });
            }

            if (odp) {
                var detailHtml = '<div class="text-left">' +
                    '<h4><i class="fa fa-circle-o text-warning"></i> ' + odp.name + '</h4>' +
                    '<hr>' +
                    '<p><strong>Description:</strong> ' + (odp.description || 'No description') + '</p>' +
                    '<p><strong>Coordinates:</strong> ' + odp.coordinates + '</p>' +
                    '<p><strong>Address:</strong> ' + (odp.address || 'No address') + '</p>' +
                    '<p><strong>Ports:</strong> ' + odp.used_ports + '/' + odp.total_ports + ' (Available: ' + odp
                    .available_ports + ')</p>' +
                    '<p><strong>Connected ODC:</strong> ' + (odp.odc_id ? 'ODC #' + odp.odc_id : 'No ODC connected') +
                    '</p>' +
                    '<hr>' +
                    '<div class="text-center">' +
                    '<button type="button" class="btn btn-info center-map-btn">Center on Map</button>' +
                    '<button type="button" class="btn btn-warning route-cable-btn" style="margin-left: 10px;">Route Cable</button>' +
                    '</div>' +
                    '</div>';

                Swal.fire({
                    title: 'ODP Details',
                    html: detailHtml,
                    width: 600,
                    showConfirmButton: true,
                    confirmButtonText: '<i class="fa fa-edit"></i> Edit ODP',
                    confirmButtonColor: '#f0ad4e',
                    showCancelButton: true,
                    cancelButtonText: 'Close',
                    showCloseButton: true,
                    didOpen: () => {
                        var centerBtn = document.querySelector('.swal2-html-container .center-map-btn');
                        var routeBtn = document.querySelector('.swal2-html-container .route-cable-btn');

                        if (centerBtn) {
                            centerBtn.addEventListener('click', function() {
                                centerMapOnOdp(odp.id);
                            });
                        }

                        if (routeBtn) {
                            routeBtn.addEventListener('click', function() {
                                Swal.close();
                                startRoutingFromPoint('odp', odp.id, odp.name, odp.coordinates);
                            });
                        }
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        var editUrl = window.location.protocol + '//' + window.location.host +
                            '/?_route=plugin/network_mapping/edit-odp&id=' + odp.id;
                        window.location.href = editUrl;
                    }
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'ODP Not Found',
                    text: 'Unable to find ODP details'
                });
            }
        }

        // Helper functions to center map on specific elements
        function centerMapOnRouter(id) {
            var router = networkData.routers.find(function(r) { return r.id == id; });
            if (router) {
                var coords = router.coordinates.split(',').map(parseFloat);
                map.setView(coords, 16);
                Swal.close();
            }
        }

        function centerMapOnOdc(id) {
            var odc = networkData.odcs.find(function(o) { return o.id == id; });
            if (odc) {
                var coords = odc.coordinates.split(',').map(parseFloat);
                map.setView(coords, 18);
                Swal.close();
            }
        }

        function centerMapOnOdp(id) {
            var odp = networkData.odps.find(function(o) { return o.id == id; });
            if (odp) {
                var coords = odp.coordinates.split(',').map(parseFloat);
                map.setView(coords, 18);
                Swal.close();
            }
        }


        // Delete ODC from map popup
        function deleteOdcFromMap(id, name) {
            // First check if ODC has connections
            var odcData = null;
            if (networkData.odcs) {
                odcData = networkData.odcs.find(function(o) {
                    return o.id == id;
                });
            }

            var usedPorts = odcData ? odcData.used_ports : 0;

            if (usedPorts > 0) {
                Swal.fire({
                    title: 'Cannot Delete ODC',
                    html: '<p>ODC <strong>' + name + '</strong> cannot be deleted because it has <strong>' +
                        usedPorts + ' active connections</strong>.</p>' +
                        '<p class="text-info"><i class="fa fa-info-circle"></i> Please disconnect all connections first using the <strong>"Disconnect"</strong> button.</p>' +
                        '<p>Would you like to disconnect connections now?</p>',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: '<i class="fa fa-unlink"></i> Disconnect Now',
                    confirmButtonColor: '#f0ad4e',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Close popup and show disconnect modal
                        map.closePopup();
                        showOdcDisconnectModal(id, name, usedPorts);
                    }
                });
                return;
            }

            Swal.fire({
                title: 'Delete ODC?',
                html: '<p>Are you sure you want to delete <strong>' + name + '</strong>?</p>' +
                    '<p class="text-success"><i class="fa fa-check-circle"></i> ODC has no active connections (0/' +
                    (odcData ? odcData.total_ports : 'X') + ' ports)</p>' +
                    '<p class="text-danger"><small>This action cannot be undone!</small></p>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, Delete!',
                confirmButtonColor: '#d33',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading
                    Swal.fire({
                        title: 'Deleting...',
                        text: 'Please wait',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    // Create FormData
                    var formData = new FormData();
                    formData.append('id', id);
                    formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);

                    fetch(baseUrl + 'plugin/network_mapping/ajax-delete-odc', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Deleted!',
                                    text: data.message + ' - Page akan direload...',
                                    timer: 1500,
                                    showConfirmButton: false
                                }).then(() => {
                                    // Reload page to refresh all data
                                    window.location.reload();
                                });

                                // Remove marker from map
                                var markerKey = 'odc_' + id;
                                if (allMarkers[markerKey]) {
                                    markersGroup.odcs.removeLayer(allMarkers[markerKey].marker);
                                    delete allMarkers[markerKey];
                                }

                                // Update statistics
                                // Update statistics - find ODC stat panel
                                var odcStatElement = document.querySelector('[data-stat="odcs"] .stat-number');
                                if (!odcStatElement) {
                                    var panels = document.querySelectorAll('.panel-default .stat-number');
                                    if (panels.length >= 2) {
                                        odcStatElement = panels[1]; // ODC is 2nd panel
                                    }
                                }
                                if (odcStatElement) {
                                    var currentCount = parseInt(odcStatElement.textContent) || 0;
                                    odcStatElement.textContent = Math.max(0, currentCount - 1);
                                }

                                // Close popup
                                map.closePopup();
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: data.message
                                });
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Failed to delete ODC: ' + error.message
                            });
                        });
                }
            });
        }

        // Delete ODP from map popup
        function deleteOdpFromMap(id, name) {
            // First check if ODP has connections
            var odpData = null;
            if (networkData.odps) {
                odpData = networkData.odps.find(function(o) {
                    return o.id == id;
                });
            }

            var usedPorts = odpData ? odpData.used_ports : 0;

            if (usedPorts > 0) {
                Swal.fire({
                    title: 'Cannot Delete ODP',
                    html: '<p>ODP <strong>' + name + '</strong> cannot be deleted because it has <strong>' +
                        usedPorts + ' connected customers</strong>.</p>' +
                        '<p class="text-info"><i class="fa fa-info-circle"></i> Please disconnect all customers first using the <strong>"Disconnect"</strong> button.</p>' +
                        '<p>Would you like to disconnect customers now?</p>',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: '<i class="fa fa-unlink"></i> Disconnect Now',
                    confirmButtonColor: '#f0ad4e',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Close popup and show disconnect modal
                        map.closePopup();
                        showOdpDisconnectModal(id, name, usedPorts);
                    }
                });
                return;
            }

            Swal.fire({
                title: 'Delete ODP?',
                html: '<p>Are you sure you want to delete <strong>' + name + '</strong>?</p>' +
                    '<p class="text-success"><i class="fa fa-check-circle"></i> ODP has no connected customers (0/' +
                    (odpData ? odpData.total_ports : 'X') + ' ports)</p>' +
                    '<p class="text-danger"><small>This action cannot be undone!</small></p>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, Delete!',
                confirmButtonColor: '#d33',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading
                    Swal.fire({
                        title: 'Deleting...',
                        text: 'Please wait',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    // Create FormData
                    var formData = new FormData();
                    formData.append('id', id);
                    formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);

                    fetch(baseUrl + 'plugin/network_mapping/ajax-delete-odp', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Deleted!',
                                    text: data.message + ' - Page akan direload...',
                                    timer: 1500,
                                    showConfirmButton: false
                                }).then(() => {
                                    // Reload page to refresh all data
                                    window.location.reload();
                                });

                                // Remove marker from map
                                var markerKey = 'odp_' + id;
                                if (allMarkers[markerKey]) {
                                    markersGroup.odps.removeLayer(allMarkers[markerKey].marker);
                                    delete allMarkers[markerKey];
                                }

                                // Update statistics - find ODP stat panel
                                var odpStatElement = document.querySelector('[data-stat="odps"] .stat-number');
                                if (!odpStatElement) {
                                    var panels = document.querySelectorAll('.panel-default .stat-number');
                                    if (panels.length >= 3) {
                                        odpStatElement = panels[2]; // ODP is 3rd panel
                                    }
                                }
                                if (odpStatElement) {
                                    var currentCount = parseInt(odpStatElement.textContent) || 0;
                                    odpStatElement.textContent = Math.max(0, currentCount - 1);
                                }

                                // Close popup
                                map.closePopup();
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: data.message
                                });
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Failed to delete ODP: ' + error.message
                            });
                        });
                }
            });
        }



        // ===== DISCONNECT MODAL FUNCTIONS =====

        var currentDisconnectData = {
            type: '', // 'odc' or 'odp'
            id: '',
            name: '',
            connections: [],
            currentPage: 1,
            searchTerm: '',
            selectedIds: []
        };

        function showOdcDisconnectModal(odcId, odcName, connectionCount) {
            currentDisconnectData = {
                type: 'odc',
                id: odcId,
                name: odcName,
                connections: [],
                currentPage: 1,
                searchTerm: '',
                selectedIds: []
            };

            document.getElementById('disconnect-odc-name').textContent = odcName;
            document.getElementById('odc-total-connections').textContent = connectionCount;
            document.getElementById('odc-selected-count').textContent = '0';
            document.getElementById('odc-disconnect-count').textContent = '0';

            // Reset form
            document.getElementById('odc-disconnect-search').value = '';
            document.getElementById('odc-connections-list').innerHTML =
                '<div class="text-center text-muted" style="padding: 40px;"><i class="fa fa-spinner fa-spin"></i> Loading connections...</div>';

            // Show modal
            $('#disconnectOdcModal').modal('show');

            // Load connections
            loadOdcConnections();

            // Setup event handlers
            setupOdcDisconnectHandlers();
        }

        function showOdpDisconnectModal(odpId, odpName, connectionCount) {
            currentDisconnectData = {
                type: 'odp',
                id: odpId,
                name: odpName,
                connections: [],
                currentPage: 1,
                searchTerm: '',
                selectedIds: []
            };

            document.getElementById('disconnect-odp-name').textContent = odpName;
            document.getElementById('odp-total-connections').textContent = connectionCount;
            document.getElementById('odp-selected-count').textContent = '0';
            document.getElementById('odp-disconnect-count').textContent = '0';

            // Reset form
            document.getElementById('odp-disconnect-search').value = '';
            document.getElementById('odp-connections-list').innerHTML =
                '<div class="text-center text-muted" style="padding: 40px;"><i class="fa fa-spinner fa-spin"></i> Loading customers...</div>';

            // Show modal
            $('#disconnectOdpModal').modal('show');

            // Load connections
            loadOdpConnections();

            // Setup event handlers
            setupOdpDisconnectHandlers();
        }

        function loadOdcConnections(page = 1, search = '') {
            var url = baseUrl + 'plugin/network_mapping/get-odc-connections&odc_id=' + currentDisconnectData.id +
                '&page=' + page + '&limit=5&search=' + encodeURIComponent(search);

            if (page === 1) {
                document.getElementById('odc-connections-list').innerHTML =
                    '<div class="text-center text-muted" style="padding: 20px;"><i class="fa fa-spinner fa-spin"></i> Loading...</div>';
            }

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        if (page === 1) {
                            currentDisconnectData.connections = data.connections;
                            document.getElementById('odc-connections-list').innerHTML = '';
                        } else {
                            currentDisconnectData.connections = currentDisconnectData.connections.concat(data
                                .connections);
                        }

                        renderOdcConnections(data.connections, page === 1);

                        // Handle load more button
                        if (data.has_more) {
                            document.getElementById('odc-load-more-container').style.display = 'block';
                            document.getElementById('odc-remaining').textContent = data.remaining;
                        } else {
                            document.getElementById('odc-load-more-container').style.display = 'none';
                        }

                        currentDisconnectData.currentPage = page;
                        currentDisconnectData.searchTerm = search;

                    } else {
                        document.getElementById('odc-connections-list').innerHTML =
                            '<div class="text-center text-danger">Error loading connections</div>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('odc-connections-list').innerHTML =
                        '<div class="text-center text-danger">Error loading connections</div>';
                });
        }

        function loadOdpConnections(page = 1, search = '') {
            var url = baseUrl + 'plugin/network_mapping/get-odp-connections&odp_id=' + currentDisconnectData.id +
                '&page=' + page + '&limit=5&search=' + encodeURIComponent(search);

            if (page === 1) {
                document.getElementById('odp-connections-list').innerHTML =
                    '<div class="text-center text-muted" style="padding: 20px;"><i class="fa fa-spinner fa-spin"></i> Loading...</div>';
            }

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        if (page === 1) {
                            currentDisconnectData.connections = data.connections;
                            document.getElementById('odp-connections-list').innerHTML = '';
                        } else {
                            currentDisconnectData.connections = currentDisconnectData.connections.concat(data
                                .connections);
                        }

                        renderOdpConnections(data.connections, page === 1);

                        // Handle load more button
                        if (data.has_more) {
                            document.getElementById('odp-load-more-container').style.display = 'block';
                            document.getElementById('odp-remaining').textContent = data.remaining;
                        } else {
                            document.getElementById('odp-load-more-container').style.display = 'none';
                        }

                        currentDisconnectData.currentPage = page;
                        currentDisconnectData.searchTerm = search;

                    } else {
                        document.getElementById('odp-connections-list').innerHTML =
                            '<div class="text-center text-danger">Error loading customers</div>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('odp-connections-list').innerHTML =
                        '<div class="text-center text-danger">Error loading customers</div>';
                });
        }

        function renderOdcConnections(connections, clearFirst = false) {
            var container = document.getElementById('odc-connections-list');

            if (clearFirst) {
                container.innerHTML = '';
            }

            if (connections.length === 0 && clearFirst) {
                container.innerHTML =
                    '<div class="text-center text-muted" style="padding: 20px;">No connections found</div>';
                return;
            }

            connections.forEach(function(connection) {
                var connectionDiv = document.createElement('div');
                connectionDiv.className = 'connection-item';
                connectionDiv.innerHTML =
                    '<label>' +
                    '<input type="checkbox" class="connection-checkbox odc-connection-checkbox" value="' +
                    connection.id + '" data-type="' + connection.type + '"> ' +
                    '<strong>' + connection.name + '</strong>' +
                    '<span class="connection-type-badge connection-type-' + connection.type + '">' + connection.type
                    .toUpperCase() + '</span>' +
                    '<div class="connection-details">' +
                    'Ports: ' + connection.ports + ' | Address: ' + (connection.address || 'Not specified') +
                    '</div>' +
                    '</label>';
                container.appendChild(connectionDiv);
            });

            // Restore selections
            updateOdcCheckboxStates();
        }

        function renderOdpConnections(connections, clearFirst = false) {
            var container = document.getElementById('odp-connections-list');

            if (clearFirst) {
                container.innerHTML = '';
            }

            if (connections.length === 0 && clearFirst) {
                container.innerHTML = '<div class="text-center text-muted" style="padding: 20px;">No customers found</div>';
                return;
            }

            connections.forEach(function(connection) {
                var connectionDiv = document.createElement('div');
                connectionDiv.className = 'connection-item';
                connectionDiv.innerHTML =
                    '<label>' +
                    '<input type="checkbox" class="connection-checkbox odp-connection-checkbox" value="' +
                    connection.id + '"> ' +
                    '<strong>' + connection.name + '</strong>' +
                    '<span class="connection-type-badge connection-type-customer">CUSTOMER</span>' +
                    '<div class="connection-details">' +
                    'Username: ' + connection.username + ' | Balance: ' + connection.balance +
                    (connection.port_number ? ' | Port: ' + connection.port_number : '') + '<br>' +
                    'Address: ' + (connection.address || 'Not specified') +
                    '</div>' +
                    '</label>';
                container.appendChild(connectionDiv);
            });

            // Restore selections
            updateOdpCheckboxStates();
        }

        function setupOdcDisconnectHandlers() {
            // Search handler
            var searchInput = document.getElementById('odc-disconnect-search');
            var searchTimeout;

            searchInput.removeEventListener('input', searchInput._searchHandler);
            searchInput._searchHandler = function() {
                var searchTerm = this.value.trim();
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(function() {
                    loadOdcConnections(1, searchTerm);
                }, 300);
            };
            searchInput.addEventListener('input', searchInput._searchHandler);

            // Load more handler
            document.getElementById('odc-load-more').onclick = function() {
                loadOdcConnections(currentDisconnectData.currentPage + 1, currentDisconnectData.searchTerm);
            };

            // Select all handler
            document.getElementById('odc-select-all').onclick = function() {
                var checkboxes = document.querySelectorAll('.odc-connection-checkbox');
                var allChecked = Array.from(checkboxes).every(cb => cb.checked);

                checkboxes.forEach(function(checkbox) {
                    checkbox.checked = !allChecked;
                    handleOdcConnectionChange();
                });
            };

            // Disconnect button handler
            document.getElementById('odc-disconnect-selected').onclick = function() {
                executeOdcDisconnect();
            };
        }

        function setupOdpDisconnectHandlers() {
            // Search handler
            var searchInput = document.getElementById('odp-disconnect-search');
            var searchTimeout;

            searchInput.removeEventListener('input', searchInput._searchHandler);
            searchInput._searchHandler = function() {
                var searchTerm = this.value.trim();
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(function() {
                    loadOdpConnections(1, searchTerm);
                }, 300);
            };
            searchInput.addEventListener('input', searchInput._searchHandler);

            // Load more handler
            document.getElementById('odp-load-more').onclick = function() {
                loadOdpConnections(currentDisconnectData.currentPage + 1, currentDisconnectData.searchTerm);
            };

            // Select all handler
            document.getElementById('odp-select-all').onclick = function() {
                var checkboxes = document.querySelectorAll('.odp-connection-checkbox');
                var allChecked = Array.from(checkboxes).every(cb => cb.checked);

                checkboxes.forEach(function(checkbox) {
                    checkbox.checked = !allChecked;
                    handleOdpConnectionChange();
                });
            };

            // Disconnect button handler
            document.getElementById('odp-disconnect-selected').onclick = function() {
                executeOdpDisconnect();
            };
        }

        // Delegate event handlers for checkboxes (because they're dynamically loaded)
    document.addEventListener('change', function(e) {
        if (e.target.classList.contains('odc-connection-checkbox')) {
            handleOdcConnectionChange();
        } else if (e.target.classList.contains('odp-connection-checkbox')) {
            handleOdpConnectionChange();
        }
    });

    function handleOdcConnectionChange() {
        var checkboxes = document.querySelectorAll('.odc-connection-checkbox:checked');
        var selectedCount = checkboxes.length;

        currentDisconnectData.selectedIds = Array.from(checkboxes).map(cb => ({
            id: cb.value,
            type: cb.getAttribute('data-type')
        }));

        document.getElementById('odc-selected-count').textContent = selectedCount;
        document.getElementById('odc-disconnect-count').textContent = selectedCount;
        document.getElementById('odc-disconnect-selected').disabled = selectedCount === 0;

        // Update visual selection
        updateOdcSelectionDisplay();
    }

    function handleOdpConnectionChange() {
        var checkboxes = document.querySelectorAll('.odp-connection-checkbox:checked');
        var selectedCount = checkboxes.length;

        currentDisconnectData.selectedIds = Array.from(checkboxes).map(cb => cb.value);

        document.getElementById('odp-selected-count').textContent = selectedCount;
        document.getElementById('odp-disconnect-count').textContent = selectedCount;
        document.getElementById('odp-disconnect-selected').disabled = selectedCount === 0;

        // Update visual selection
        updateOdpSelectionDisplay();
    }

    function updateOdcCheckboxStates() {
        document.querySelectorAll('.odc-connection-checkbox').forEach(function(checkbox) {
            var isSelected = currentDisconnectData.selectedIds.some(item =>
                item.id === checkbox.value && item.type === checkbox.getAttribute('data-type')
            );
            checkbox.checked = isSelected;
        });
        updateOdcSelectionDisplay();
    }

    function updateOdpCheckboxStates() {
        document.querySelectorAll('.odp-connection-checkbox').forEach(function(checkbox) {
            checkbox.checked = currentDisconnectData.selectedIds.includes(checkbox.value);
        });
        updateOdpSelectionDisplay();
    }

    function updateOdcSelectionDisplay() {
        document.querySelectorAll('.connection-item').forEach(function(item) {
            var checkbox = item.querySelector('.odc-connection-checkbox');
            if (checkbox && checkbox.checked) {
                item.classList.add('selected');
            } else {
                item.classList.remove('selected');
            }
        });
    }

    function updateOdpSelectionDisplay() {
        document.querySelectorAll('.connection-item').forEach(function(item) {
            var checkbox = item.querySelector('.odp-connection-checkbox');
            if (checkbox && checkbox.checked) {
                item.classList.add('selected');
            } else {
                item.classList.remove('selected');
            }
        });
    }

    function executeOdcDisconnect() {
        if (currentDisconnectData.selectedIds.length === 0) {
            Swal.fire('Warning', 'Please select connections to disconnect', 'warning');
            return;
        }

        var disconnectText = currentDisconnectData.selectedIds.length === 1 ?
            '1 connection' : currentDisconnectData.selectedIds.length + ' connections';

        Swal.fire({
            title: 'Disconnect Connections?',
            html: '<p>Are you sure you want to disconnect <strong>' + disconnectText +
                '</strong> from ODC <strong>' + currentDisconnectData.name + '</strong>?</p>' +
                '<p class="text-warning"><i class="fa fa-exclamation-triangle"></i> This will free up ports on the ODC.</p>',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, Disconnect!',
            confirmButtonColor: '#f0ad4e',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                performOdcDisconnect();
            }
        });
    }

    function executeOdpDisconnect() {
        if (currentDisconnectData.selectedIds.length === 0) {
            Swal.fire('Warning', 'Please select customers to disconnect', 'warning');
            return;
        }

        var disconnectText = currentDisconnectData.selectedIds.length === 1 ?
            '1 customer' : currentDisconnectData.selectedIds.length + ' customers';

        Swal.fire({
            title: 'Disconnect Customers?',
            html: '<p>Are you sure you want to disconnect <strong>' + disconnectText +
                '</strong> from ODP <strong>' + currentDisconnectData.name + '</strong>?</p>' +
                '<p class="text-warning"><i class="fa fa-exclamation-triangle"></i> This will free up ports on the ODP.</p>',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, Disconnect!',
            confirmButtonColor: '#f0ad4e',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                performOdpDisconnect();
            }
        });
    }

    function performOdcDisconnect() {
        // Show loading
        Swal.fire({
            title: 'Disconnecting...',
            text: 'Please wait while we disconnect the connections',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        // Group by type
        var odcIds = currentDisconnectData.selectedIds.filter(item => item.type === 'odc').map(item => item.id);
        var odpIds = currentDisconnectData.selectedIds.filter(item => item.type === 'odp').map(item => item.id);

        var promises = [];

        // Disconnect ODPs if any
        if (odpIds.length > 0) {
            var formData1 = new FormData();
            formData1.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);
            formData1.append('odc_id', currentDisconnectData.id);
            formData1.append('disconnect_type', 'odp');
            odpIds.forEach(id => formData1.append('disconnect_ids[]', id));

            promises.push(
                fetch(baseUrl + 'plugin/network_mapping/disconnect-from-odc', {
                    method: 'POST',
                    body: formData1
                }).then(response => response.json())
            );
        }

        // Disconnect child ODCs if any
        if (odcIds.length > 0) {
            var formData2 = new FormData();
            formData2.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);
            formData2.append('odc_id', currentDisconnectData.id);
            formData2.append('disconnect_type', 'odc');
            odcIds.forEach(id => formData2.append('disconnect_ids[]', id));

            promises.push(
                fetch(baseUrl + 'plugin/network_mapping/disconnect-from-odc', {
                    method: 'POST',
                    body: formData2
                }).then(response => response.json())
            );
        }

        Promise.all(promises)
            .then(results => {
                var totalDisconnected = 0;
                var hasError = false;
                var errorMessage = '';

                results.forEach(result => {
                    if (result.success) {
                        totalDisconnected += result.disconnected_count;
                    } else {
                        hasError = true;
                        errorMessage = result.message;
                    }
                });

                if (hasError) {
                    Swal.fire('Error', errorMessage, 'error');
                } else {
                    Swal.fire({
                        icon: 'success',
                        title: 'Disconnected Successfully!',
                        html: '<p><strong>' + totalDisconnected +
                            ' connections</strong> have been disconnected from ODC <strong>' +
                            currentDisconnectData.name + '</strong></p>' +
                            '<p class="text-info"><i class="fa fa-refresh"></i> Page will reload to update the map...</p>',
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        // Close modal and reload page
                        $('#disconnectOdcModal').modal('hide');
                        window.location.reload();
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire('Error', 'Failed to disconnect connections', 'error');
            });
    }

    function performOdpDisconnect() {
        // Show loading
        Swal.fire({
            title: 'Disconnecting...',
            text: 'Please wait while we disconnect the customers',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        var formData = new FormData();
        formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);
        formData.append('odp_id', currentDisconnectData.id);
        currentDisconnectData.selectedIds.forEach(id => formData.append('disconnect_ids[]', id));

        fetch(baseUrl + 'plugin/network_mapping/disconnect-from-odp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Disconnected Successfully!',
                        html: '<p><strong>' + data.disconnected_count +
                            ' customers</strong> have been disconnected from ODP <strong>' +
                            currentDisconnectData.name + '</strong></p>' +
                            '<p class="text-info"><i class="fa fa-refresh"></i> Page will reload to update the map...</p>',
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        // Close modal and reload page
                        $('#disconnectOdpModal').modal('hide');
                        window.location.reload();
                    });
                } else {
                    Swal.fire('Error', data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire('Error', 'Failed to disconnect customers', 'error');
            });
    }

    // ===== END DISCONNECT MODAL FUNCTIONS =====
    // ===== CUSTOMER PHOTO MODAL TANPA SCROLL =====

    function getCustomerInitials(name) {
        return name.split(' ').map(function(n) { return n[0]; }).join('').substr(0, 2).toUpperCase();
    }

    function handleLargePhotoSuccess(imgElement) {
        imgElement.style.display = 'block';
        var fallback = document.querySelector('.customer-photo-fallback-large');
        if (fallback) fallback.style.display = 'none';
    }

    function handleLargePhotoError(imgElement, customerName) {
        imgElement.style.display = 'none';
        var fallback = document.querySelector('.customer-photo-fallback-large');
        if (fallback) {
            fallback.style.display = 'flex';
            fallback.textContent = getCustomerInitials(customerName);
        }
    }

    function showCustomerPhotoModal(photoUrl, customerName, customerInfo) {
        Swal.fire({
            html: '<img src="' + photoUrl + '" alt="' + customerName + '" class="customer-photo-large" ' +
                'onload="handleLargePhotoSuccess(this)" onerror="handleLargePhotoError(this, \'' +
                customerName + '\')">' +
                '<div class="customer-photo-fallback-large" style="display: none;">' +
                getCustomerInitials(customerName) +
                '</div>',
            showConfirmButton: false,
            showCloseButton: false,
            allowOutsideClick: true,
            allowEscapeKey: true,
            customClass: {
                popup: 'customer-photo-modal'
            },
            background: 'transparent',
            padding: '0',
            width: 'auto',
            backdrop: 'rgba(0,0,0,0.8)',
            scrollbarPadding: false,
            heightAuto: false,
            didOpen: () => {
                // Disable body scroll
                document.body.style.overflow = 'hidden';

                document.querySelector('.swal2-backdrop').addEventListener('click', () => {
                    Swal.close();
                });
            },
            willClose: () => {
                // Re-enable body scroll
                document.body.style.overflow = '';
            }
        });
    }

    // ===== END CUSTOMER PHOTO MODAL TANPA SCROLL =====



    // ===== CABLE STATUS FUNCTIONS =====

    function getCableConnectionStatus(entityType, entityId) {
        if (!cableRoutes || cableRoutes.length === 0) {
            return '';
        }

        var incomingCables = [];
        var outgoingCables = [];

        // Find cables connected to this entity
        cableRoutes.forEach(function(cable) {
            // ✅ NEW: Only include VISIBLE cables (not hidden bridges)
            if (cable.visible === undefined || cable.visible === 1) {
                if (cable.to_type === entityType && cable.to_id == entityId) {
                    incomingCables.push(cable);
                } else if (cable.from_type === entityType && cable.from_id == entityId) {
                    outgoingCables.push(cable);
                }
            }
        });

        // Filter out pole connections from display
        incomingCables = incomingCables.filter(function(cable) {
            return cable.from_type !== 'pole';
        });

        outgoingCables = outgoingCables.filter(function(cable) {
            return cable.to_type !== 'pole';
        });

        var cableInfo = '';

        if (incomingCables.length > 0) {
            cableInfo +=
                '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(40, 167, 69, 0.1); border-left: 3px solid #28a745; font-size: 11px;">';
            cableInfo += '<i class="fa fa-arrow-down text-success"></i> <strong>Cable Input:</strong><br>';

            incomingCables.forEach(function(cable, index) {
                var cableLength = calculateCableLength(cable.waypoints);
                cableInfo += '• From ' + cable.from_name + ' (' + cable.from_type.toUpperCase() + ')';
                cableInfo += ' - ' + cableLength.toFixed(0) + 'm';
                if (index < incomingCables.length - 1) cableInfo += '<br>';
            });

            cableInfo += '</div>';
        }

        if (outgoingCables.length > 0) {
            cableInfo +=
                '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(255, 193, 7, 0.1); border-left: 3px solid #ffc107; font-size: 11px;">';
            cableInfo += '<i class="fa fa-arrow-up text-warning"></i> <strong>Cable Output:</strong><br>';

            outgoingCables.forEach(function(cable, index) {
                var cableLength = calculateCableLength(cable.waypoints);
                cableInfo += '• To ' + cable.to_name + ' (' + cable.to_type.toUpperCase() + ')';
                cableInfo += ' - ' + cableLength.toFixed(0) + 'm';
                if (index < outgoingCables.length - 1) cableInfo += '<br>';
            });

            cableInfo += '</div>';
        }

        if (incomingCables.length === 0 && outgoingCables.length === 0) {
            cableInfo =
                '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(108, 117, 125, 0.1); border-left: 3px solid #6c757d; font-size: 11px;">';
            cableInfo += '<i class="fa fa-unlink text-muted"></i> <strong>No Cable Connections</strong>';
            cableInfo += '</div>';
        }

        return cableInfo;
    }


    function getOdpPortConnectionStatus(odp) {
        if (!odp.odc_id || !odp.port_number) {
            return '';
        }

        // Find the connected ODC from networkData
        var connectedOdc = null;
        if (networkData.odcs) {
            connectedOdc = networkData.odcs.find(function(odc) {
                return odc.id == odp.odc_id;
            });
        }

        if (!connectedOdc) {
            return '';
        }

        var portConnectionStatus =
            '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(23, 162, 184, 0.1); border-left: 3px solid #17a2b8; font-size: 11px;">';
        portConnectionStatus += '<i class="fa fa-link text-info"></i> <strong>Connected to Port:</strong><br>';
        portConnectionStatus += '• Port ' + odp.port_number + ' (' + connectedOdc.name + ')';
        portConnectionStatus += '</div>';

        return portConnectionStatus;
    }


    function getCustomerPortConnectionStatus(customer) {
        if (!customer.odp_id || !customer.port_number) {
            return '';
        }

        // Find the connected ODP from networkData
        var connectedOdp = null;
        if (networkData.odps) {
            connectedOdp = networkData.odps.find(function(odp) {
                return odp.id == customer.odp_id;
            });
        }

        if (!connectedOdp) {
            return '';
        }

        var portConnectionStatus =
            '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(23, 162, 184, 0.1); border-left: 3px solid #17a2b8; font-size: 11px;">';
        portConnectionStatus += '<i class="fa fa-link text-info"></i> <strong>Connected to Port:</strong><br>';
        portConnectionStatus += '• Port ' + customer.port_number + ' (' + connectedOdp.name + ')';
        portConnectionStatus += '</div>';

        return portConnectionStatus;
    }



    function updateAllPopupsWithCableStatus() {
        // Update ODC popups
        // ✅ PERBAIKAN: Update ODC popups TANPA extra <br>
        if (networkData.odcs) {
            networkData.odcs.forEach(function(odc) {
                var marker = allMarkers['odc_' + odc.id];
                if (marker) {
                    var cableStatus = getCableConnectionStatus('odc', odc.id);
                    var uplinkStatus = odc.uplink_port_status || '';
                    var ponStatus = odc.pon_port_status || '';
                    var originalContent = marker.data.popup_content;

                    // Add Route Cable if not exists
                    if (originalContent.indexOf('Route Cable') === -1) {
                        if (originalContent.indexOf('deleteOdcFromMap') !== -1) {
                            originalContent = originalContent.replace(
                                '<a href=\'javascript:void(0)\' onclick=\'deleteOdcFromMap(',
                                    '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("odc", ' +
                                    odc.id + ', "' + odc.name + '", "' + odc.coordinates +
                                    '")\'>Route Cable</a> | ' +
                                    '<a href=\'javascript:void(0)\' onclick=\'deleteOdcFromMap('
                                );
                            }
                        }

                        // ✅ PERBAIKAN: Gabung content TANPA extra <br>
                        var contentParts = [originalContent];

                        if (cableStatus && cableStatus.trim() !== '') {
                            contentParts.push(cableStatus);
                        }

                        if (uplinkStatus && uplinkStatus.trim() !== '') {
                            contentParts.push(uplinkStatus);
                        }

                        if (ponStatus && ponStatus.trim() !== '') {
                            contentParts.push(ponStatus);
                        }

                        // ✅ Join tanpa <br> (karena backend sudah ada proper spacing)
                        var newContent = contentParts.join('');
                        marker.marker.setPopupContent(newContent);
                        marker.data.popup_content = originalContent;
                    }
                });
            }
            // Update ODP popups  
            if (networkData.odps) {
                networkData.odps.forEach(function(odp) {
                    var marker = allMarkers['odp_' + odp.id];
                    if (marker) {
                        var cableStatus = getCableConnectionStatus('odp', odp.id);
                        var portConnectionStatus = getOdpPortConnectionStatus(odp);
                        var originalContent = marker.data.popup_content;

                        // Add Route Cable if not exists
                        if (originalContent.indexOf('Route Cable') === -1) {
                            originalContent = originalContent.replace(
                                '<a href=\'javascript:void(0)\' onclick=\'deleteOdpFromMap(',
                                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("odp", ' + odp
                                .id + ', "' + odp.name + '", "' + odp.coordinates + '")\'>Route Cable</a> | ' +
                                '<a href=\'javascript:void(0)\' onclick=\'deleteOdpFromMap('
                            );
                        }

                        var newContent = originalContent + '<br>' + cableStatus + portConnectionStatus + (odp
                            .port_status || '');
                        marker.marker.setPopupContent(newContent);
                        marker.data.popup_content = originalContent;
                    }
                });
            }

            // ✅ TAMBAH BAGIAN INI - Update OLT popups
            if (networkData.olts) {
                networkData.olts.forEach(function(olt) {
                    var marker = allMarkers['olt_' + olt.id];
                    if (marker) {
                        var cableStatus = getCableConnectionStatus('olt', olt.id);
                        var uplinkStatus = olt.uplink_port_status || '';
                        var ponStatus = olt.pon_port_status || '';
                        var originalContent = marker.data.popup_content;

                        // Add Route Cable if not exists
                        if (originalContent.indexOf('Route Cable') === -1) {
                            if (originalContent.indexOf('showOltDetail') !== -1) {
                                originalContent = originalContent.replace(
                                    '<a href=\'javascript:void(0)\' onclick=\'showOltDetail(' + olt.id +
                                    ')\'>Detail</a>',
                                    '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("olt", ' +
                                    olt.id + ', "' + olt.name + '", "' + olt.coordinates +
                                    '")\'>Route Cable</a> | ' +
                                    '<a href=\'javascript:void(0)\' onclick=\'showOltDetail(' + olt.id +
                                    ')\'>Detail</a>'
                                );
                            } else {
                                originalContent +=
                                    '<br><a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("olt", ' +
                                    olt.id + ', "' + olt.name + '", "' + olt.coordinates +
                                    '")\' class="route-cable-link">Route Cable</a>';
                            }
                        }
                        // ✅ TAMBAH INI - Update Edit button to use modal instead of page redirect
                        if (originalContent.indexOf('editOltFromMap') !== -1) {
                            originalContent = originalContent.replace(
                                /onclick='editOltFromMap\([^)]+\)'/g,
                                'onclick=\'showEditOltModal(' + olt.id + ', "' + olt.name.replace(/'/g, "\\'") +
                            '")\''
                            );
                        }

                        var newContent = originalContent + '<br>' + cableStatus + uplinkStatus + ponStatus;
                        marker.marker.setPopupContent(newContent);
                        marker.data.popup_content = originalContent;
                    }
                });
            }

            // Update Customer popups
            if (networkData.customers) {
                networkData.customers.forEach(function(customer) {
                    var marker = allMarkers['customer_' + customer.id];
                    if (marker) {
                        var cableStatus = getCableConnectionStatus('customer', customer.id);
                        var portConnectionStatus = getCustomerPortConnectionStatus(customer);
                        var originalContent = marker.data.popup_content;

                        // Add Route Cable if not exists
                        if (originalContent.indexOf('Route Cable') === -1) {
                            originalContent = originalContent.replace(
                                '<a href=\'https://www.google.com/maps/dir//',
                                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("customer", ' +
                                customer.id + ', "' + customer.name + '", "' + customer.coordinates +
                                '")\'>Route Cable</a> | ' +
                                '<a href=\'https://www.google.com/maps/dir//'
                            );
                        }

                        var newContent = originalContent + '<br>' + cableStatus + portConnectionStatus;
                        marker.marker.setPopupContent(newContent);
                        marker.data.popup_content = originalContent;
                    }
                });
            }

            // ✅ TAMBAHKAN DI SINI - Update OLT popups
            if (networkData.olts) {
                networkData.olts.forEach(function(olt) {
                    var marker = allMarkers['olt_' + olt.id];
                    if (marker) {
                        var cableStatus = getCableConnectionStatus('olt', olt.id);
                        var uplinkStatus = olt.uplink_port_status || '';
                        var ponStatus = olt.pon_port_status || '';
                        var originalContent = marker.data.popup_content;

                        // Add Route Cable if not exists
                        if (originalContent.indexOf('Route Cable') === -1) {
                            originalContent = originalContent.replace(
                                '<a href=\'javascript:void(0)\' onclick=\'deleteOltFromMap(',
                                '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("olt", ' + olt
                                .id + ', "' + olt.name + '", "' + olt.coordinates + '")\'>Route Cable</a> | ' +
                                '<a href=\'javascript:void(0)\' onclick=\'deleteOltFromMap('
                            );
                        }

                        var newContent = originalContent + '<br>' + cableStatus + uplinkStatus + ponStatus;
                        marker.marker.setPopupContent(newContent);
                        marker.data.popup_content = originalContent;
                    }
                });
            }



            // TAMBAHAN BARU: Update Poles popups (NO ROUTE CABLE, NO CABLE STATUS)
            if (networkData.poles) {
                networkData.poles.forEach(function(pole) {
                    var marker = allMarkers['pole_' + pole.id];
                    if (marker) {
                        // Poles keep their original popup content without any cable status
                        // They are pure waypoints, so no cable status needed
                        marker.marker.setPopupContent(pole.popup_content);
                    }
                });
            }

            console.log('Updated all popups with cable status and route cable buttons');
        }

        function refreshCableDataAndPopups() {
            // Refresh cable routes data
            fetch(baseUrl + 'plugin/network_mapping/api-cable-routes')
                .then(response => response.json())
                .then(data => {
                    cableRoutes = data;
                    console.log('Cable routes refreshed:', cableRoutes.length + ' routes loaded');
                })
                .catch(error => {
                    console.error('Error refreshing cable routes:', error);
                });
        }

        function initializeMap() {
            console.log('Initializing map...');

            // TAMBAH: Tunggu sampai DOM benar-benar ready
            if (document.readyState !== 'complete') {
                console.log('Document not ready, waiting...');
                setTimeout(initializeMap, 100);
                return;
            }

            // PERBAIKAN: Cek ketersediaan Leaflet
            if (typeof L === 'undefined') {
                console.error('Leaflet library not loaded, retrying...');
                var loadingEl = document.getElementById('loading');
                if (loadingEl) {
                    loadingEl.innerHTML = '<i class="fa fa-exclamation-triangle"></i><br><br>Loading map library...';
                }
                setTimeout(initializeMap, 1000);
                return;
            }

            // PERBAIKAN: Cek ketersediaan map container
            var mapContainer = document.getElementById('map');
            if (!mapContainer) {
                console.error('Map container not found, retrying...');
                setTimeout(initializeMap, 500);
                return;
            }

            // PERBAIKAN: Pastikan container visible dan punya dimensi
            if (mapContainer.offsetWidth === 0 || mapContainer.offsetHeight === 0) {
                console.log('Map container has no dimensions, waiting...');
                setTimeout(initializeMap, 200);
                return;
            }

            console.log('All checks passed, proceeding with map initialization');
            getLocation();
        }

        window.onload = function() {
            initializeMap();
            // Initialize live search
            initializeLiveSearch();

            // Initialize navigation panel
            setTimeout(function() {
                initializeNavigationPanel();

                // TAMBAHKAN INI: Reset quick add button state
                resetQuickAddButton();
            }, 2000);

            // Initialize keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && cableRoutingMode) {
                    cancelCableRouting();
                }
                if (e.key === 'Enter' && cableRoutingMode && routingFromPoint && currentWaypoints.length >= 2) {
                    // Auto-complete routing with nearest point (future enhancement)
                }
            });


            // Initialize keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && cableRoutingMode) {
                    cancelCableRouting();
                }
                if (e.key === 'Escape' && quickAddMode) {
                    cancelQuickAddMode();
                }
                if (e.key === 'Enter' && cableRoutingMode && routingFromPoint && currentWaypoints.length >= 2) {
                    // Auto-complete routing with nearest point (future enhancement)
                }
            });

            // Quick Add Form Handlers
            document.getElementById('quickAddOdcForm').addEventListener('submit', function(e) {
                e.preventDefault();
                saveQuickAddOdc();
            });

            document.getElementById('quickAddOdpForm').addEventListener('submit', function(e) {
                e.preventDefault();
                saveQuickAddOdp();
            });

            // TAMBAHAN BARU UNTUK POLE
            document.getElementById('quickAddPoleForm').addEventListener('submit', function(e) {
                e.preventDefault();
                saveQuickAddPole();
            });
        }
        // Navigation Panel Auto-Minimize Functionality
        var navAutoMinimizeTimer;
        var isNavPanelActive = false;

        function initializeNavigationPanel() {
            var navPanel = document.getElementById('mapNavPanel');
            var navToggle = document.getElementById('navToggle');
            var navContent = document.getElementById('navContent');

            if (!navPanel || !navToggle) return;

            // ✅ TAMBAHAN: Start minimized by default
            minimizeNavigationPanel();

            // Toggle minimize/maximize
            // Toggle minimize/maximize
            navToggle.addEventListener('click', function(e) {
                e.stopPropagation();

                // PERBAIKAN: Jika dalam quick add mode dan panel minimized, 
                // klik akan maximize panel dan stop auto-minimize
                if (quickAddMode && navPanel.classList.contains('minimized')) {
                    maximizeNavigationPanel();

                    // PENTING: Stop auto-minimize timer saat user buka tray
                    clearAutoMinimizeTimer();

                    // Update status untuk memberitahu user bisa cancel
                    updateRoutingStatus('QUICK ADD MODE: Click map to add ' + quickAddType.toUpperCase() +
                        '<br><small style="color: #dc3545;"><i class="fa fa-times-circle"></i> Klik tombol + merah untuk cancel</small>'
                    );
                } else {
                    toggleNavigationPanel();
                }
            });

            // Prevent auto-minimize when interacting with panel
            navPanel.addEventListener('mouseenter', function() {
                clearAutoMinimizeTimer();
                isNavPanelActive = true;
            });

            navPanel.addEventListener('mouseleave', function() {
                isNavPanelActive = false;

                // PERBAIKAN: Jangan start auto-minimize timer jika dalam Quick Add mode
                if (!quickAddMode) {
                    startAutoMinimizeTimer();
                }
            });

            // Prevent auto-minimize when clicking inside panel
            navPanel.addEventListener('click', function(e) {
                e.stopPropagation();
                clearAutoMinimizeTimer();
                startAutoMinimizeTimer();
            });

            // Auto-minimize when clicking empty map area
            document.getElementById('map').addEventListener('click', function(e) {
                // PERBAIKAN: Izinkan Quick Add mode untuk click map tanpa auto-minimize
                // Tapi tetap minimize jika user klik area kosong saat tidak ada mode aktif
                if (!cableRoutingMode && !quickAddMode && !isNavPanelActive) {
                    if (!e.target.closest('.map-navigation-panel') &&
                        !e.target.closest('.leaflet-control') &&
                        !e.target.closest('.router-marker') &&
                        !e.target.closest('.odc-marker') &&
                        !e.target.closest('.odp-marker') &&
                        !e.target.closest('.customer-marker')) {
                        minimizeNavigationPanel();
                    }
                }

                // TAMBAHAN: Jika dalam Quick Add mode dan user klik map area kosong,
                // jangan minimize tray (biarkan user kontrol sendiri)
            });

            // Auto-minimize when map interaction stops
            if (map) {
                map.on('moveend zoomend', function() {
                    if (!isNavPanelActive && !cableRoutingMode && !quickAddMode) {
                        startAutoMinimizeTimer();
                    }
                });
            }

            // ✅ TIDAK perlu start auto-minimize timer karena sudah minimized
            // startAutoMinimizeTimer();
        }

        function toggleNavigationPanel() {
            var navPanel = document.getElementById('mapNavPanel');
            if (navPanel.classList.contains('minimized')) {
                maximizeNavigationPanel();
            } else {
                minimizeNavigationPanel();
            }
        }

        function minimizeNavigationPanel() {
            var navPanel = document.getElementById('mapNavPanel');
            navPanel.classList.add('minimized');
            clearAutoMinimizeTimer();
        }

        function maximizeNavigationPanel() {
            var navPanel = document.getElementById('mapNavPanel');
            navPanel.classList.remove('minimized');
            startAutoMinimizeTimer();
        }

        function startAutoMinimizeTimer() {
            clearAutoMinimizeTimer();
            navAutoMinimizeTimer = setTimeout(function() {
                // PERBAIKAN: Jangan auto-minimize jika user sedang dalam Quick Add mode
                // KECUALI jika Quick Add baru saja dimulai (untuk auto-minimize pertama kali)
                if (!isNavPanelActive && !cableRoutingMode && !quickAddMode) {
                    minimizeNavigationPanel();
                }
            }, 5000); // Auto-minimize after 5 seconds of inactivity
        }

        function clearAutoMinimizeTimer() {
            if (navAutoMinimizeTimer) {
                clearTimeout(navAutoMinimizeTimer);
                navAutoMinimizeTimer = null;
            }
        }

        // Override routing functions to prevent auto-minimize during routing
        var originalStartRouting = startCableRouting;
        var originalCancelRouting = cancelCableRouting;
        var originalStartQuickAdd = startQuickAddMode;
        var originalCancelQuickAdd = cancelQuickAddMode;

        startCableRouting = function() {
            clearAutoMinimizeTimer();
            originalStartRouting.call(this);
        };

        cancelCableRouting = function() {
            originalCancelRouting.call(this);
            startAutoMinimizeTimer();
        };

        startQuickAddMode = function(type) {
            clearAutoMinimizeTimer();
            originalStartQuickAdd.call(this, type);
        };

        cancelQuickAddMode = function() {
            originalCancelQuickAdd.call(this);
            startAutoMinimizeTimer();
        };
        // ===== LIVE SEARCH FUNCTIONALITY =====
        var searchTimeout;
        var currentSearchResults = [];

        function initializeLiveSearch() {
            var searchInput = document.getElementById('live-search-input');
            var clearButton = document.getElementById('clear-search');
            var searchResults = document.getElementById('search-results');

            if (!searchInput) return;
            // === TAMBAHAN BARU: AUTO-SEARCH FROM OTHER PAGES ===
            // Check if we have a search target from another page
            try {
                var searchTarget = localStorage.getItem('network_map_search_target');
                var searchTimestamp = localStorage.getItem('network_map_search_timestamp');

                if (searchTarget && searchTimestamp) {
                    var timestamp = parseInt(searchTimestamp);
                    var maxAge = 10000; // 10 seconds max age

                    if (Date.now() - timestamp < maxAge) {
                        console.log('Auto-searching for:', searchTarget);

                        // Clear the stored values
                        localStorage.removeItem('network_map_search_target');
                        localStorage.removeItem('network_map_search_timestamp');

                        // Set the search input and trigger search
                        searchInput.value = searchTarget;

                        // Scroll to map section first
                        scrollToMap();

                        // Delay the search to ensure map is fully loaded
                        setTimeout(function() {
                            performLiveSearch(searchTarget);

                            // Auto-navigate to first result after search completes
                            setTimeout(function() {
                                if (currentSearchResults.length > 0) {
                                    var firstResult = currentSearchResults[0];
                                    console.log('Auto-navigating to first result:', firstResult.name);
                                    goToSearchResult(firstResult.type, firstResult.id, firstResult
                                        .coordinates, firstResult.name);
                                }
                            }, 300); // Wait 1 second for search to complete
                        }, 500); // Wait 2 seconds for map to load
                    } else {
                        // Clear expired values
                        localStorage.removeItem('network_map_search_target');
                        localStorage.removeItem('network_map_search_timestamp');
                    }
                }
            } catch (e) {
                console.warn('Could not check for auto-search target:', e);
            }
            // === FALLBACK: CHECK URL PARAMETER ===
            if (!searchTarget) {
                // Check URL parameter as fallback
                var urlParams = new URLSearchParams(window.location.search);
                var autoSearch = urlParams.get('auto_search');

                if (autoSearch) {
                    console.log('Auto-searching from URL parameter:', autoSearch);
                    searchTarget = autoSearch;

                    // Clean URL without reloading
                    var newUrl = window.location.protocol + '//' + window.location.host + window.location.pathname +
                        '?_route=plugin/network_mapping';
                    window.history.replaceState({}, document.title, newUrl);

                    // Set search input and trigger auto-search
                    searchInput.value = searchTarget;

                    setTimeout(function() {
                        scrollToMap();
                        performLiveSearch(searchTarget);
                        setTimeout(function() {
                            if (currentSearchResults.length > 0) {
                                var firstResult = currentSearchResults[0];
                                goToSearchResult(firstResult.type, firstResult.id, firstResult.coordinates,
                                    firstResult.name);
                            }
                        }, 1000);
                    }, 2000);
                }
            }
            // === END FALLBACK ===

            // Live search dengan debounce
            searchInput.addEventListener('input', function() {
                var query = this.value.trim();

                clearTimeout(searchTimeout);

                if (query.length === 0) {
                    hideSearchResults();
                    return;
                }

                if (query.length < 2) {
                    showSearchMessage('Type at least 2 characters to search...');
                    return;
                }

                searchTimeout = setTimeout(function() {
                    performLiveSearch(query);
                }, 300); // Delay 300ms setelah user berhenti mengetik
            });

            // Clear search
            clearButton.addEventListener('click', function() {
                searchInput.value = '';
                hideSearchResults();
                searchInput.focus();
            });

            // Hide results ketika click di luar
            document.addEventListener('click', function(e) {
                if (!e.target.closest('#live-search-container')) {
                    hideSearchResults();
                }
            });

            // Show results ketika focus pada input
            searchInput.addEventListener('focus', function() {
                if (this.value.trim().length >= 2 && currentSearchResults.length > 0) {
                    showSearchResults();
                }
            });
        }

        function performLiveSearch(query) {
            showSearchMessage('<i class="fa fa-spinner fa-spin"></i> Searching...');

            var results = [];
            var queryLower = query.toLowerCase();

            // Check if searching by device type
            var searchByType = false;
            var targetType = '';

            var typeMap = {
                'router': 'router',
                'routers': 'router',
                'mikrotik': 'router',
                'odc': 'odc',
                'odcs': 'odc',
                'odp': 'odp',
                'odps': 'odp',
                'customer': 'customer',
                'customers': 'customer',
                'client': 'customer',
                'clients': 'customer',
                'pelanggan': 'customer',
                'pole': 'pole', // TAMBAHAN BARU
                'poles': 'pole',
                'tiang': 'pole',
                'tower': 'pole'
            };

            // Check if query matches any device type
            if (typeMap[queryLower]) {
                searchByType = true;
                targetType = typeMap[queryLower];
            }

            // If searching by device type, show all devices of that type
            if (searchByType) {
                switch (targetType) {
                    case 'router':
                        if (networkData.routers) {
                            networkData.routers.forEach(function(router) {
                                results.push({
                                    type: 'router',
                                    id: router.id,
                                    name: router.name,
                                    description: router.description || '',
                                    coordinates: router.coordinates,
                                    icon: 'fa-server',
                                    enabled: router.enabled,
                                    typeSearch: true
                                });
                            });
                        }
                        break;

                    case 'odc':
                        if (networkData.odcs) {
                            networkData.odcs.forEach(function(odc) {
                                results.push({
                                    type: 'odc',
                                    id: odc.id,
                                    name: odc.name,
                                    description: odc.description || '',
                                    address: odc.address || '',
                                    coordinates: odc.coordinates,
                                    icon: 'fa-cube',
                                    ports: odc.available_ports + '/' + odc.total_ports + ' ports',
                                    typeSearch: true
                                });
                            });
                        }
                        break;

                    case 'odp':
                        if (networkData.odps) {
                            networkData.odps.forEach(function(odp) {
                                results.push({
                                    type: 'odp',
                                    id: odp.id,
                                    name: odp.name,
                                    description: odp.description || '',
                                    address: odp.address || '',
                                    coordinates: odp.coordinates,
                                    icon: 'fa-circle-o',
                                    ports: odp.available_ports + '/' + odp.total_ports + ' ports',
                                    typeSearch: true
                                });
                            });
                        }
                        break;

                    case 'customer':
                        if (networkData.customers) {
                            networkData.customers.forEach(function(customer) {
                                results.push({
                                    type: 'customer',
                                    id: customer.id,
                                    name: customer.name,
                                    username: customer.username,
                                    address: customer.address || '',
                                    coordinates: customer.coordinates,
                                    icon: 'fa-user',
                                    balance: customer.balance || '0',
                                    typeSearch: true
                                });
                            });
                        }
                        break;

                        // TAMBAHAN BARU
                    case 'pole':
                        if (networkData.poles) {
                            networkData.poles.forEach(function(pole) {
                                results.push({
                                    type: 'pole',
                                    id: pole.id,
                                    name: pole.name,
                                    description: pole.description || '',
                                    address: pole.address || '',
                                    coordinates: pole.coordinates,
                                    icon: 'fa-map-pin',
                                    from_type: pole.from_type,
                                    to_type: pole.to_type,
                                    typeSearch: true
                                });
                            });
                        }
                        break;
                }
            } else {
                // Normal search by name/description (existing code)

                // Search routers
                if (networkData.routers) {
                    networkData.routers.forEach(function(router) {
                        if (router.name.toLowerCase().includes(queryLower) ||
                            (router.description && router.description.toLowerCase().includes(queryLower))) {
                            results.push({
                                type: 'router',
                                id: router.id,
                                name: router.name,
                                description: router.description || '',
                                coordinates: router.coordinates,
                                icon: 'fa-server',
                                enabled: router.enabled
                            });
                        }
                    });
                }

                // Search ODCs
                if (networkData.odcs) {
                    networkData.odcs.forEach(function(odc) {
                        if (odc.name.toLowerCase().includes(queryLower) ||
                            (odc.description && odc.description.toLowerCase().includes(queryLower)) ||
                            (odc.address && odc.address.toLowerCase().includes(queryLower))) {
                            results.push({
                                type: 'odc',
                                id: odc.id,
                                name: odc.name,
                                description: odc.description || '',
                                address: odc.address || '',
                                coordinates: odc.coordinates,
                                icon: 'fa-cube',
                                ports: odc.available_ports + '/' + odc.total_ports + ' ports'
                            });
                        }
                    });
                }

                // Search ODPs
                if (networkData.odps) {
                    networkData.odps.forEach(function(odp) {
                        if (odp.name.toLowerCase().includes(queryLower) ||
                            (odp.description && odp.description.toLowerCase().includes(queryLower)) ||
                            (odp.address && odp.address.toLowerCase().includes(queryLower))) {
                            results.push({
                                type: 'odp',
                                id: odp.id,
                                name: odp.name,
                                description: odp.description || '',
                                address: odp.address || '',
                                coordinates: odp.coordinates,
                                icon: 'fa-circle-o',
                                ports: odp.available_ports + '/' + odp.total_ports + ' ports'
                            });
                        }
                    });
                }

                // Search customers
                if (networkData.customers) {
                    networkData.customers.forEach(function(customer) {
                        if (customer.name.toLowerCase().includes(queryLower) ||
                            customer.username.toLowerCase().includes(queryLower) ||
                            (customer.address && customer.address.toLowerCase().includes(queryLower))) {
                            results.push({
                                type: 'customer',
                                id: customer.id,
                                name: customer.name,
                                username: customer.username,
                                address: customer.address || '',
                                coordinates: customer.coordinates,
                                icon: 'fa-user',
                                balance: customer.balance || '0'
                            });
                        }
                    });
                }

                // TAMBAHAN BARU - Search poles
                if (networkData.poles) {
                    networkData.poles.forEach(function(pole) {
                        if (pole.name.toLowerCase().includes(queryLower) ||
                            (pole.description && pole.description.toLowerCase().includes(queryLower)) ||
                            (pole.address && pole.address.toLowerCase().includes(queryLower))) {
                            results.push({
                                type: 'pole',
                                id: pole.id,
                                name: pole.name,
                                description: pole.description || '',
                                address: pole.address || '',
                                coordinates: pole.coordinates,
                                icon: 'fa-map-pin',
                                from_type: pole.from_type,
                                to_type: pole.to_type
                            });
                        }
                    });
                }
            }

            currentSearchResults = results;
            displaySearchResults(results, query);
        }

        function displaySearchResults(results, query) {
            var searchResults = document.getElementById('search-results');

            if (results.length === 0) {
                showSearchMessage('No results found for "' + query + '"');
                return;
            }

            var html = '';

            // Check if this is a type search
            var isTypeSearch = results.length > 0 && results[0].typeSearch;

            if (isTypeSearch) {
                // Show header for type search
                var deviceType = results[0].type.toUpperCase();
                html += '<div class="search-type-header">';
                html += '<i class="fa ' + results[0].icon + ' text-' + getResultColor(results[0].type) + '"></i> ';
                html += 'All ' + deviceType + 'S (' + results.length + ' found)';
                html += '</div>';

                // Show first 15 results for type search
                var displayResults = results.slice(0, 15);
            } else {
                // Normal search - limit to 10 results
                var displayResults = results.slice(0, 10);
            }

            displayResults.forEach(function(result) {
                var details = '';

                switch (result.type) {
                    case 'router':
                        details = (result.description || 'No description') +
                            (result.enabled == 1 ? ' • Active' : ' • Inactive');
                        break;
                    case 'odc':
                        details = (result.ports || '') +
                            (result.address ? ' • ' + result.address : '');
                        break;
                    case 'odp':
                        details = (result.ports || '') +
                            (result.address ? ' • ' + result.address : '');
                        break;
                    case 'customer':
                        details = 'Username: ' + result.username +
                            ' • Balance: ' + result.balance +
                            (result.address ? ' • ' + result.address : '');
                        break;
                        // TAMBAHAN BARU
                    case 'pole':
                        var bridgeInfo = '';
                        if (result.from_type && result.to_type) {
                            bridgeInfo = ' • Bridge: ' + result.from_type.toUpperCase() + ' → ' + result.to_type
                                .toUpperCase();
                        }
                        details = (result.description || 'No description') +
                            (result.address ? ' • ' + result.address : '') + bridgeInfo;
                        break;
                }

                html += '<div class="search-result-item" onclick="goToSearchResult(\'' +
                    result.type + '\', ' + result.id + ', \'' +
                    result.coordinates + '\', \'' + result.name + '\')">';
                html += '<div class="search-result-icon">';
                html += '<i class="fa ' + result.icon + ' text-' + getResultColor(result.type) + '"></i>';
                html += '</div>';
                html += '<div class="search-result-info">';
                html += '<div class="search-result-name">' + result.name + '</div>';
                html += '<div class="search-result-details">' + details + '</div>';
                html += '</div>';
                html += '<div class="search-result-type ' + result.type + '">' + result.type + '</div>';
                html += '</div>';
            });

            if (results.length > 10) {
                html += '<div class="search-no-results">Showing first 10 of ' + results.length +
                    ' results. Type more to narrow down.</div>';
            }

            searchResults.innerHTML = html;
            showSearchResults();
        }

        function getResultColor(type) {
            switch (type) {
                case 'router':
                    return 'primary';
                case 'odc':
                    return 'success';
                case 'odp':
                    return 'warning';
                case 'customer':
                    return 'info';
                case 'pole': // TAMBAHAN BARU
                    return 'secondary';
                default:
                    return 'secondary';
            }
        }

        function showSearchMessage(message) {
            var searchResults = document.getElementById('search-results');
            searchResults.innerHTML = '<div class="search-no-results">' + message + '</div>';
            showSearchResults();
        }

        function showSearchResults() {
            document.getElementById('search-results').style.display = 'block';
        }

        function hideSearchResults() {
            document.getElementById('search-results').style.display = 'none';
        }

        function goToSearchResult(type, id, coordinates, name) {
            hideSearchResults();

            // Parse coordinates
            var coords = coordinates.split(',').map(parseFloat);

            if (coords.length !== 2 || isNaN(coords[0]) || isNaN(coords[1])) {
                console.error('Invalid coordinates:', coordinates);
                Swal.fire('Error', 'Invalid coordinates for ' + name, 'error');
                return;
            }

            // Save current map position before navigating
            mapPositionMemory.savePosition();

            // Determine zoom level based on type
            var zoomLevel;
            switch (type) {
                case 'router':
                    zoomLevel = 19;
                    break;
                case 'olt': // ← TAMBAH INI
                    zoomLevel = 19;
                    break;
                case 'odc':
                    zoomLevel = 19;
                    break;
                case 'odp':
                    zoomLevel = 19;
                    break;
                case 'customer':
                    zoomLevel = 19;
                    break;
                case 'pole':
                    zoomLevel = 19;
                    break;
                default:
                    zoomLevel = 17;
            }

            // Smooth pan and zoom to location
            map.flyTo(coords, zoomLevel, {
                duration: 1.5, // 1.5 seconds animation
                easeLinearity: 0.25
            });

            // Show success message
            setTimeout(function() {
                // Find and open popup if marker exists
                var markerKey = type + '_' + id;
                if (allMarkers[markerKey] && allMarkers[markerKey].marker) {
                    // Open popup after animation completes
                    setTimeout(function() {
                        allMarkers[markerKey].marker.openPopup();

                        // Temporary highlight effect
                        var markerElement = document.querySelector('[data-type="' + type + '"][data-id="' +
                            id + '"]');
                        if (markerElement) {
                            markerElement.style.animation = 'pulse 2s ease-in-out 3';
                            setTimeout(function() {
                                markerElement.style.animation = '';
                            }, 6000);
                        }
                    }, 300);
                }

                // Show enhanced toast notification
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'success',
                    title: 'Located: ' + name,
                    text: 'Ditemukan ' + type.toUpperCase() + ' (Level ' + zoomLevel + ')',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    background: '#28a745',
                    color: '#fff'
                });

            }, 1600); // After flyTo animation completes

            // Auto-clear search input after delay (but not immediately for manual search)
            setTimeout(function() {
                var searchInput = document.getElementById('live-search-input');
                if (searchInput && searchInput.value.trim().length > 0) {
                    // Only clear if this was an auto-search (check if results are still showing)
                    if (document.getElementById('search-results').style.display === 'block') {
                        searchInput.value = '';
                        hideSearchResults();
                    }
                }
            }, 5000); // Clear after 5 seconds

            console.log('Navigated to', type, name, 'at', coords);
        }

        function scrollToMap() {
            // Try multiple selectors to find the map
            var mapElement = document.getElementById('map') ||
                document.querySelector('#map') ||
                document.querySelector('.leaflet-container') ||
                document.querySelector('[id*="map"]');

            if (mapElement) {
                console.log('Scrolling to map element');

                // Calculate scroll position
                var headerOffset = window.innerWidth <= 768 ? 80 : 100; // Mobile vs desktop header
                var elementPosition = mapElement.getBoundingClientRect().top;
                var offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                // Try modern smooth scroll first
                if ('scrollBehavior' in document.documentElement.style) {
                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                } else {
                    // Fallback for older browsers - animate manually
                    animateScrollTo(offsetPosition, 1000); // 1 second duration
                }

                showScrollNotification();

            } else {
                console.warn('Map element not found, using fallback scroll');

                // Fallback scroll position
                var fallbackPosition = Math.max(window.innerHeight * 0.5, 400);

                if ('scrollBehavior' in document.documentElement.style) {
                    window.scrollTo({
                        top: fallbackPosition,
                        behavior: 'smooth'
                    });
                } else {
                    animateScrollTo(fallbackPosition, 800);
                }
            }
        }

        // Manual scroll animation for old browsers
        function animateScrollTo(targetY, duration) {
            var startY = window.pageYOffset;
            var distance = targetY - startY;
            var startTime = Date.now();

            function step() {
                var elapsed = Date.now() - startTime;
                var progress = Math.min(elapsed / duration, 1);

                // Easing function (ease-out)
                var easeOut = 1 - Math.pow(1 - progress, 3);

                window.scrollTo(0, startY + (distance * easeOut));

                if (progress < 1) {
                    requestAnimationFrame(step);
                }
            }

            requestAnimationFrame(step);
        }

        function showScrollNotification() {
            // Create temporary scroll indicator
            var indicator = document.createElement('div');
            indicator.innerHTML = '<i class="fa fa-arrow-down"></i> Scrolling to map...';
            indicator.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: rgba(0, 123, 255, 0.9);
        color: white;
        padding: 8px 15px;
        border-radius: 20px;
        font-size: 12px;
        z-index: 9999;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        transition: all 0.3s ease;
    `;

            document.body.appendChild(indicator);

            // Remove indicator after scroll completes
            setTimeout(function() {
                if (indicator && indicator.parentNode) {
                    indicator.style.opacity = '0';
                    indicator.style.transform = 'translateY(-20px)';
                    setTimeout(function() {
                        if (indicator && indicator.parentNode) {
                            indicator.parentNode.removeChild(indicator);
                        }
                    }, 300);
                }
            }, 2000);
        }
        // ✅ PERBAIKAN: Photo error handler yang benar
        function handlePhotoError(imgElement) {
            console.log('Photo failed to load:', imgElement.src);

            // Hide image
            imgElement.style.display = 'none';

            // Show avatar fallback
            var container = imgElement.parentElement;
            var avatarFallback = container.querySelector('.customer-avatar-fallback');
            if (avatarFallback) {
                avatarFallback.style.display = 'flex';
            }
        }

        // Tambahan: Function untuk handle photo success
        function handlePhotoSuccess(imgElement) {
            console.log('Photo loaded successfully:', imgElement.src);

            // Pastikan image tampil dan avatar fallback hidden
            imgElement.style.display = 'block';

            var container = imgElement.parentElement;
            var avatarFallback = container.querySelector('.customer-avatar-fallback');
            if (avatarFallback) {
                avatarFallback.style.display = 'none';
            }
        }

        // ✅ TAMBAHAN BARU: Mini photo error handlers untuk Quick Add ODP
        function handleMiniPhotoError(imgElement) {
            console.log('Mini photo failed to load:', imgElement.src);

            // Hide failed image
            imgElement.style.display = 'none';

            // Show avatar fallback
            var container = imgElement.parentElement;
            var avatarFallback = container.querySelector('.customer-avatar-mini-fallback');
            if (avatarFallback) {
                avatarFallback.style.display = 'flex';
            }
        }

        function handleMiniPhotoSuccess(imgElement) {
            console.log('Mini photo loaded successfully:', imgElement.src);

            // Ensure image is visible
            imgElement.style.display = 'block';

            // Hide avatar fallback
            var container = imgElement.parentElement;
            var avatarFallback = container.querySelector('.customer-avatar-mini-fallback');
            if (avatarFallback) {
                avatarFallback.style.display = 'none';
            }
        }

        // ===== POLE MANAGEMENT FUNCTIONS =====

        function showQuickAddPoleModal(lat, lng) {
            var coordinates = lat + ',' + lng;

            console.log('Showing simplified pole form for coordinates:', coordinates);

            // Populate coordinates directly
            document.getElementById('pole-coordinates').value = coordinates;
            document.getElementById('pole-coords-display').textContent = coordinates;

            // Clear form
            document.getElementById('quickAddPoleForm').reset();
            document.getElementById('pole-coordinates').value = coordinates;

            // Show modal
            $('#quickAddPoleModal').modal('show');

            // Focus on name field
            setTimeout(function() {
                document.getElementById('pole-name').focus();
            }, 500);
        }

        // HAPUS SEMUA FUNCTION DI ATAS - TIDAK DIPERLUKAN LAGI

        // Hanya simpan function yang diperlukan:
        function loadNetworkDevicesForPole() {
            // Function ini dikosongkan karena tidak ada device selection lagi
            console.log('Pole device selection disabled - using simplified form');
        }

        function saveQuickAddPole() {
            var form = document.getElementById('quickAddPoleForm');
            var formData = new FormData(form);

            // HAPUS SEMUA DEVICE PARSING - TIDAK DIPERLUKAN LAGI

            // Show loading
            Swal.fire({
                title: 'Saving Pole...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            fetch(baseUrl + 'plugin/network_mapping/quick-save-pole', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Close modal
                        $('#quickAddPoleModal').modal('hide');

                        // Save position before reload
                        mapPositionMemory.savePosition();

                        // Success message
                        Swal.fire({
                            icon: 'success',
                            title: 'Pole Added!',
                            html: '<p><strong>Name:</strong> ' + data.pole.name + '</p>' +
                                '<p><strong>Coordinates:</strong> ' + data.pole.coordinates + '</p>' +
                                '<p class="text-info"><i class="fa fa-refresh"></i> Map akan tetap di posisi ini setelah reload...</p>',
                            timer: 2000,
                            showConfirmButton: false
                        }).then(() => {
                            // Reset body class before reload
                            document.body.classList.remove('quick-add-mode-active');
                            resetQuickAddButton();

                            // Reload page
                            window.location.reload();
                        });

                        // Cancel quick add mode immediately
                        cancelQuickAddMode();

                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to save Pole', 'error');
                });
        }

        function showPoleDetail(id) {
            var pole = null;
            if (networkData.poles) {
                pole = networkData.poles.find(function(p) {
                    return p.id == id;
                });
            }

            if (pole) {
                // Show loading modal first
                Swal.fire({
                    title: 'Loading Pole Details...',
                    html: '<i class="fa fa-spinner fa-spin fa-2x"></i>',
                    showConfirmButton: false,
                    allowOutsideClick: false
                });

                // Fetch current bridges data from server
                fetch(baseUrl + 'plugin/network_mapping/get-pole-bridges&pole_id=' + id)
                    .then(response => response.json())
                    .then(data => {
                        var connectionInfo = '';

                        if (data.success && data.bridges && data.bridges.length > 0) {
                            connectionInfo = '<div style="margin: 10px 0;"><strong>Bridge Connections:</strong><br>';
                            connectionInfo +=
                                '<div style="max-height: 120px; overflow-y: auto; border: 1px solid #ddd; padding: 8px; border-radius: 4px; background: #f9f9f9;">';

                            data.bridges.forEach(function(bridge, index) {
                                var bridgeNum = index + 1;
                                var routeInfo = bridge.cable_route_id ? ' (Route #' + bridge.cable_route_id +
                                    ')' : '';

                                // Create clickable from device
                                var fromLink = bridge.from_name;
                                if (bridge.from_coordinates && bridge.from_type !== 'cust_all') {
                                    fromLink = '<a href="javascript:void(0)" onclick="goToSearchResult(\'' +
                                        bridge.from_type + '\', ' + bridge.from_id + ', \'' +
                                        bridge.from_coordinates + '\', \'' + bridge.from_name.replace(/'/g,
                                        "\\'") +
                                    '\')" style="color: #007bff; text-decoration: none;">' + bridge
                                    .from_name + '</a>';
                            }

                            // Create clickable to device  
                            var toLink = bridge.to_name;
                            if (bridge.to_coordinates && bridge.to_type !== 'cust_all') {
                                toLink = '<a href="javascript:void(0)" onclick="goToSearchResult(\'' +
                                    bridge.to_type + '\', ' + bridge.to_id + ', \'' +
                                    bridge.to_coordinates + '\', \'' + bridge.to_name.replace(/'/g, "\\'") +
                                    '\')" style="color: #007bff; text-decoration: none;">' + bridge
                                        .to_name + '</a>';
                                }

                                connectionInfo +=
                                    '<div style="margin-bottom: 6px; padding: 4px; background: white; border-radius: 3px; border-left: 3px solid #007bff;">';
                                connectionInfo += '<strong>' + bridgeNum + '.</strong> ' + fromLink + ' → ' +
                                    toLink + routeInfo;
                                connectionInfo += '<br><small style="color: #666;">Added: ' + new Date(bridge
                                    .created_at).toLocaleDateString() + '</small>';
                                connectionInfo += '</div>';
                            });

                            connectionInfo += '</div>';
                            connectionInfo += '<small style="color: #666;"><i class="fa fa-info-circle"></i> Total: ' +
                                data.bridges.length + ' bridge connections</small>';
                            connectionInfo += '</div>';
                        } else {
                            connectionInfo =
                                '<div style="margin: 10px 0;"><div style="padding: 8px; background: #f8f9fa; border-radius: 4px; color: #6c757d; text-align: center;">';
                            connectionInfo += '<i class="fa fa-info-circle"></i> No bridge connections recorded';
                            connectionInfo += '</div></div>';
                        }

                        // Close loading modal and show pole detail modal
                        Swal.close();
                        showPoleDetailModal(pole, connectionInfo);
                    })
                    .catch(error => {
                        console.error('Error fetching pole bridges:', error);

                        // Close loading modal
                        Swal.close();

                        // Fallback to legacy display
                        var connectionInfo = '';
                        if (pole.from_type && pole.to_type) {
                            var fromDisplay = pole.from_type === 'cust_all' ? 'CUSTOMER' : pole.from_type.toUpperCase();
                            var toDisplay = pole.to_type === 'cust_all' ? 'CUSTOMER' : pole.to_type.toUpperCase();
                            connectionInfo = '<p><strong>Bridge Connection:</strong><br>' +
                                'From: ' + fromDisplay + ' → To: ' + toDisplay + '</p>';
                        }
                        showPoleDetailModal(pole, connectionInfo);
                    });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Pole Not Found',
                    text: 'Unable to find pole details'
                });
            }
        }

        function showPoleDetailModal(pole, connectionInfo) {
            var detailHtml = '<div class="text-left">' +
                '<h4><i class="fa fa-map-pin text-secondary"></i> ' + pole.name + '</h4>' +
                '<hr>' +
                '<p><strong>Description:</strong> ' + (pole.description || 'No description') + '</p>' +
                '<p><strong>Coordinates:</strong> ' + pole.coordinates + '</p>' +
                '<p><strong>Address:</strong> ' + (pole.address || 'No address') + '</p>' +
                connectionInfo +
                '<hr>' +
                '<div class="alert alert-info" style="margin: 10px 0; padding: 8px; font-size: 12px;">' +
                '<i class="fa fa-info-circle"></i> <strong>Waypoint Role:</strong> ' +
                'This pole serves as a cable waypoint. Click it during cable routing to add as intermediate point.' +
                '</div>' +
                '<div class="text-center">' +
                '<button type="button" class="btn btn-info center-map-btn">Center on Map</button>' +
                '<button type="button" class="btn btn-success refresh-bridges-btn" style="margin-left: 10px;">Refresh Bridges</button>' +
                '</div>' +
                '</div>';

            Swal.fire({
                title: 'Pole Details',
                html: detailHtml,
                width: 700,
                showConfirmButton: true,
                confirmButtonText: '<i class="fa fa-edit"></i> Edit Pole',
                confirmButtonColor: '#f0ad4e',
                showCancelButton: true,
                cancelButtonText: 'Close',
                showCloseButton: true,
                didOpen: () => {
                    var centerBtn = document.querySelector('.swal2-html-container .center-map-btn');
                    var refreshBtn = document.querySelector('.swal2-html-container .refresh-bridges-btn');

                    if (centerBtn) {
                        centerBtn.addEventListener('click', function() {
                            centerMapOnPole(pole.id);
                        });
                    }

                    if (refreshBtn) {
                        refreshBtn.addEventListener('click', function() {
                            refreshBtn.innerHTML =
                                '<i class="fa fa-spinner fa-spin"></i> Refreshing...';
                            refreshBtn.disabled = true;

                            fetch(baseUrl + 'plugin/network_mapping/get-pole-bridges&pole_id=' + pole
                                    .id)
                                .then(response => response.json())
                                .then(data => {
                                    refreshBtn.innerHTML =
                                        '<i class="fa fa-refresh"></i> Refresh Bridges';
                                    refreshBtn.disabled = false;

                                    if (data.success) {
                                        Swal.close();
                                        showPoleDetail(pole.id);
                                    }
                                })
                                .catch(error => {
                                    refreshBtn.innerHTML =
                                        '<i class="fa fa-refresh"></i> Refresh Bridges';
                                    refreshBtn.disabled = false;
                                    console.error('Error refreshing bridges:', error);
                                });
                        });
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire('Info', 'Edit pole functionality coming soon!', 'info');
                }
            });
        }
        // ===== POLE BRIDGES API FUNCTIONS =====

        function refreshPoleBridgeDisplay(poleId) {
            // Refresh bridge display for a specific pole
            fetch(baseUrl + 'plugin/network_mapping/get-pole-bridges&pole_id=' + poleId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        console.log('Pole ' + poleId + ' bridges updated:', data.bridges.length + ' bridges');

                        // Update popup if open
                        var openPopup = map.getPopup();
                        if (openPopup && openPopup.getContent().includes('Tiang: ')) {
                            // Refresh the popup content
                            showPoleDetail(poleId);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error refreshing pole bridges:', error);
                });
        }

        function getPoleBridgeSummary(poleId) {
            // Get summary text for pole bridges (for use in popup content)
            return fetch(baseUrl + 'plugin/network_mapping/get-pole-bridges&pole_id=' + poleId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.bridges && data.bridges.length > 0) {
                        var summary = 'Bridges: ';
                        var bridgeTexts = data.bridges.map(function(bridge, index) {
                            return (index + 1) + '. ' + bridge.from_name + ' → ' + bridge.to_name;
                        });
                        summary += bridgeTexts.join(' | ');
                        return summary;
                    } else {
                        return 'No bridge connections';
                    }
                })
                .catch(error => {
                    console.error('Error getting pole bridge summary:', error);
                    return 'Bridge info unavailable';
                });
        }

        function centerMapOnPole(id) {
            var pole = networkData.poles.find(function(p) { return p.id == id; });
            if (pole) {
                var coords = pole.coordinates.split(',').map(parseFloat);
                map.setView(coords, 18);
                Swal.close();
            }
        }

        function editPoleFromMap(id) {
            Swal.fire('Info', 'Edit pole functionality coming soon!', 'info');
        }

        function deletePoleFromMap(id, name) {
            Swal.fire({
                title: 'Delete Pole?',
                html: '<p>Are you sure you want to delete <strong>' + name + '</strong>?</p>' +
                    '<p class="text-danger"><small>This action cannot be undone!</small></p>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, Delete!',
                confirmButtonColor: '#d33',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading
                    Swal.fire({
                        title: 'Checking bridges...',
                        text: 'Please wait while we check for all bridges (active and hidden)',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    // Create FormData
                    var formData = new FormData();
                    formData.append('id', id);
                    formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);

                    fetch(baseUrl + 'plugin/network_mapping/ajax-delete-pole', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Deleted!',
                                    text: data.message + ' - Page akan direload...',
                                    timer: 1500,
                                    showConfirmButton: false
                                }).then(() => {
                                    // Reload page to refresh all data
                                    window.location.reload();
                                });

                                // Remove marker from map
                                var markerKey = 'pole_' + id;
                                if (allMarkers[markerKey]) {
                                    markersGroup.poles.removeLayer(allMarkers[markerKey].marker);
                                    delete allMarkers[markerKey];
                                }

                                // Close popup
                                map.closePopup();
                            } else {
                                // ✅ FIXED: Handle ALL bridges (active + hidden) blocking deletion
                                if (data.reason === 'has_bridges') {
                                    var bridgeListHtml =
                                        '<ul style="text-align: left; margin: 10px 0; max-height: 150px; overflow-y: auto;">';
                                    data.bridge_details.forEach(function(bridge) {
                                        bridgeListHtml += '<li style="margin: 3px 0;">' + bridge +
                                            '</li>';
                                    });
                                    bridgeListHtml += '</ul>';

                                    var statusInfo = '';
                                    if (data.active_bridges > 0 && data.inactive_bridges > 0) {
                                        statusInfo = '<p class="text-info"><strong>Bridge Status:</strong> ' +
                                            data.active_bridges + ' active, ' + data.inactive_bridges +
                                            ' hidden</p>';
                                    } else if (data.active_bridges > 0) {
                                        statusInfo = '<p class="text-info"><strong>Bridge Status:</strong> ' +
                                            data.active_bridges + ' active bridges</p>';
                                    } else if (data.inactive_bridges > 0) {
                                        statusInfo = '<p class="text-info"><strong>Bridge Status:</strong> ' +
                                            data.inactive_bridges + ' hidden bridges</p>';
                                    }

                                    Swal.fire({
                                        icon: 'warning',
                                        title: 'Cannot Delete Pole!',
                                        html: '<p>Pole <strong>' + data.pole_name +
                                            '</strong> has <strong>' + data.bridge_count +
                                            ' bridge(s)</strong>:</p>' +
                                            statusInfo + bridgeListHtml +
                                            '<div class="alert alert-danger" style="margin: 15px 0; padding: 10px; border-radius: 5px;">' +
                                            '<i class="fa fa-exclamation-triangle"></i> <strong>Required Action:</strong><br>' +
                                            'You must <strong>PERMANENTLY REMOVE</strong> all bridges (both active and hidden) before deleting this pole.<br>' +
                                            '<small class="text-muted">Hidden bridges still count as existing bridges and prevent deletion.</small>' +
                                            '</div>' +
                                            '<p>Would you like to open the bridge management interface?</p>',
                                        showCancelButton: true,
                                        confirmButtonText: '<i class="fa fa-edit"></i> Manage Bridges',
                                        confirmButtonColor: '#f0ad4e',
                                        cancelButtonText: 'Cancel',
                                        width: 650
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            // Close current popup and open edit bridges modal
                                            map.closePopup();
                                            showEditPoleBridgesModal(data.pole_id, data.pole_name);
                                        }
                                    });
                                } else {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error',
                                        text: data.message
                                    });
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Failed to delete pole: ' + error.message
                            });
                        });
                }
            });
        }
        // ===== EDIT POLE BRIDGES MODAL FUNCTIONS =====

        var currentEditPoleData = {
            pole_id: '',
            pole_name: '',
            bridges: [],
            selectedIds: []
        };

        function showEditPoleBridgesModal(poleId, poleName) {
            currentEditPoleData = {
                pole_id: poleId,
                pole_name: poleName,
                bridges: [],
                selectedIds: []
            };

            document.getElementById('edit-pole-name').textContent = poleName;
            document.getElementById('edit-pole-bridges-list').innerHTML =
                '<div class="text-center text-muted" style="padding: 40px;"><i class="fa fa-spinner fa-spin"></i> Loading bridges...</div>';

            // Hide bulk actions panel initially
            document.getElementById('bulk-actions-panel').style.display = 'none';

            // Show modal
            $('#editPoleBridgesModal').modal('show');

            // Load bridges data
            loadPoleBridgesForEdit(poleId);
        }

        function loadPoleBridgesForEdit(poleId) {
            var url = baseUrl + 'plugin/network_mapping/edit-pole-bridges&pole_id=' + poleId;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        currentEditPoleData.bridges = data.bridges;
                        renderBridgesForEdit(data.bridges);
                        updateEditBridgeStats();
                    } else {
                        document.getElementById('edit-pole-bridges-list').innerHTML =
                            '<div class="text-center text-danger">Error loading bridges: ' + data.message + '</div>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('edit-pole-bridges-list').innerHTML =
                        '<div class="text-center text-danger">Error loading bridges</div>';
                });
        }

        function renderBridgesForEdit(bridges) {
            var container = document.getElementById('edit-pole-bridges-list');

            if (bridges.length === 0) {
                container.innerHTML = '<div class="text-center text-muted" style="padding: 20px;">No bridges found</div>';
                return;
            }

            var html = '';
            bridges.forEach(function(bridge, index) {
                var statusBadge = bridge.status === 'active' ?
                    '<span class="label label-success">Active</span>' :
                    '<span class="label label-warning">Inactive</span>';

                var cableInfo = bridge.cable_info ?
                    ' (Route #' + bridge.cable_info.id + ')' : '';

                html += '<div class="bridge-edit-item" data-bridge-id="' + bridge.id + '">';

                // Add checkbox for bulk selection
                html += '<input type="checkbox" class="bridge-checkbox" value="' + bridge.id + '" ';
                html += 'data-bridge-name="' + bridge.from_name + ' → ' + bridge.to_name + '" ';
                html += 'data-bridge-status="' + bridge.status + '">';

                html += '<div class="bridge-edit-header">';
                html += '<div class="bridge-edit-info">';
                html += '<strong>' + (index + 1) + '. ' + bridge.from_name + ' → ' + bridge.to_name + '</strong>';
                html += cableInfo + ' ' + statusBadge;
                html += '<div class="bridge-edit-details">';
                html += 'Created: ' + new Date(bridge.created_at).toLocaleDateString();
                if (bridge.cable_info) {
                    html += ' | Cable Type: ' + bridge.cable_info.cable_type;
                }
                html += '</div>';
                html += '</div>';
                html += '<div class="bridge-edit-actions">';

                if (bridge.status === 'active') {
                    html += '<button class="btn btn-warning btn-xs" onclick="toggleBridgeStatus(' + bridge.id +
                        ', \'inactive\')" title="Hide Bridge">';
                    html += '<i class="fa fa-eye-slash"></i> Hide</button>';
                } else {
                    html += '<button class="btn btn-success btn-xs" onclick="toggleBridgeStatus(' + bridge.id +
                        ', \'active\')" title="Show Bridge">';
                    html += '<i class="fa fa-eye"></i> Show</button>';
                }

                html += '<button class="btn btn-danger btn-xs" onclick="deleteBridgeFromPole(' + bridge.id +
                    ', \'' +
                    bridge.from_name + ' → ' + bridge.to_name +
                    '\')" title="Delete Bridge" style="margin-left: 5px;">';
                html += '<i class="fa fa-trash"></i> Delete</button>';
                html += '</div>';
                html += '</div>';
                html += '</div>';
            });

            container.innerHTML = html;

            // Setup bulk selection event handlers
            setupBulkSelectionHandlers();
        }

        function updateEditBridgeStats() {
            var activeBridges = currentEditPoleData.bridges.filter(b => b.status === 'active').length;
            var inactiveBridges = currentEditPoleData.bridges.filter(b => b.status === 'inactive').length;
            var totalBridges = currentEditPoleData.bridges.length;

            document.getElementById('edit-total-bridges').textContent = totalBridges;
            document.getElementById('edit-active-bridges').textContent = activeBridges;
            document.getElementById('edit-inactive-bridges').textContent = inactiveBridges;
            document.getElementById('edit-selected-bridges').textContent = '0'; // Initialize selected count
        }

        function toggleBridgeStatus(bridgeId, newStatus) {
            var action = newStatus === 'active' ? 'show' : 'hide';
            var bridge = currentEditPoleData.bridges.find(b => b.id == bridgeId);
            var bridgeName = bridge ? bridge.from_name + ' → ' + bridge.to_name : 'Bridge';

            Swal.fire({
                title: 'Confirm Action',
                html: '<p>Are you sure you want to <strong>' + action + '</strong> this bridge?</p>' +
                    '<p><strong>' + bridgeName + '</strong></p>' +
                    '<div class="alert alert-' + (newStatus === 'active' ? 'success' : 'warning') +
                    '" style="margin: 10px 0; padding: 8px; font-size: 12px;">' +
                    '<i class="fa fa-info-circle"></i> <strong>This will:</strong><br>' +
                    '• ' + (newStatus === 'active' ? 'Show' : 'Hide') +
                    ' bridge status in all poles along the route<br>' +
                    '• ' + (newStatus === 'active' ? 'Show' : 'Hide') + ' cable route on the map<br>' +
                    '• ' + (newStatus === 'active' ? 'Restore' : 'Temporarily hide') + ' all visual elements' +
                    '</div>',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, ' + action + ' it!',
                confirmButtonColor: newStatus === 'active' ? '#28a745' : '#ffc107',
                cancelButtonText: 'Cancel',
                width: 500
            }).then((result) => {
                if (result.isConfirmed) {
                    performToggleBridgeStatus(bridgeId, newStatus);
                }
            });
        }

        function performToggleBridgeStatus(bridgeId, newStatus) {
            // Show loading
            Swal.fire({
                title: 'Updating...',
                text: 'Please wait while we update the bridge and cable visibility',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            var formData = new FormData();
            formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);
            formData.append('bridge_id', bridgeId);
            formData.append('status', newStatus);

            fetch(baseUrl + 'plugin/network_mapping/update-bridge-status', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        var action = newStatus === 'active' ? 'shown' : 'hidden';
                        var cableAction = newStatus === 'active' ? 'visible' : 'hidden';

                        Swal.fire({
                            icon: 'success',
                            title: 'Bridge & Cable ' + action + '!',
                            html: '<p>' + data.message + '</p>' +
                                '<p class="text-info">Affected bridges: ' + data.affected_bridges + '</p>' +
                                '<p class="text-warning">Cable route: ' + cableAction + '</p>' +
                                '<p class="text-success">Popup content: updated</p>' +
                                '<p><i class="fa fa-refresh"></i> Map will reload to update all displays...</p>',
                            timer: 3000,
                            showConfirmButton: false
                        }).then(() => {
                            console.log('🔥 DEBUG: About to reload after hide/show');
                            console.log('🔧 mapPositionMemory exists:', typeof mapPositionMemory !==
                                'undefined');

                            // Save position before reload
                            if (typeof mapPositionMemory !== 'undefined') {
                                mapPositionMemory.savePosition();
                                console.log('✅ Position saved');
                            }

                            console.log('🚀 Starting reload process...');

                            // Simplify reload - remove cache buster first
                            window.location.reload(true); // Force reload from server

                            console.log('📍 Reload command sent');
                        });
                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to update bridge status', 'error');
                });
        }

        function deleteBridgeFromPole(bridgeId, bridgeName) {
            Swal.fire({
                title: 'Delete Bridge & Cable?',
                html: '<p>Are you sure you want to <strong>permanently delete</strong> this bridge?</p>' +
                    '<p><strong>' + bridgeName + '</strong></p>' +
                    '<div class="alert alert-danger" style="margin: 10px 0; padding: 8px; font-size: 12px;">' +
                    '<i class="fa fa-warning"></i> <strong>Warning:</strong> This will also delete the cable route and remove the bridge from all poles along the route.' +
                    '</div>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, Delete!',
                confirmButtonColor: '#d33',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    performDeleteBridge(bridgeId);
                }
            });
        }

        function performDeleteBridge(bridgeId) {
            // Show loading
            Swal.fire({
                title: 'Deleting...',
                text: 'Please wait while we delete the bridge and cable route',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            var formData = new FormData();
            formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);
            formData.append('bridge_id', bridgeId);

            fetch(baseUrl + 'plugin/network_mapping/delete-bridge-from-pole', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Bridge Deleted!',
                            html: '<p>' + data.message + '</p>' +
                                '<p class="text-info">Deleted bridges: ' + data.deleted_bridges + '</p>' +
                                '<p class="text-info">Cable route deleted: ' + (data.deleted_cable ? 'Yes' :
                                    'No') + '</p>' +
                                '<p><i class="fa fa-refresh"></i> Map will reload to update display...</p>',
                            timer: 2500,
                            showConfirmButton: false
                        }).then(() => {
                            // Reload page to refresh map
                            window.location.reload();
                        });
                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to delete bridge', 'error');
                });
        }

        // ===== BULK SELECTION FUNCTIONS =====

        function setupBulkSelectionHandlers() {
            // Individual checkbox change
            document.addEventListener('change', function(e) {
                if (e.target.classList.contains('bridge-checkbox')) {
                    updateBulkSelectionDisplay();
                }
            });

            // Select all bridges
            document.getElementById('select-all-bridges').addEventListener('click', function() {
                var checkboxes = document.querySelectorAll('.bridge-checkbox');
                var allChecked = Array.from(checkboxes).every(cb => cb.checked);

                checkboxes.forEach(function(checkbox) {
                    checkbox.checked = !allChecked;
                    updateBridgeItemSelection(checkbox);
                });

                updateBulkSelectionDisplay();
            });

            // Bulk show bridges
            document.getElementById('bulk-show-bridges').addEventListener('click', function() {
                performBulkShowHide('active');
            });

            // Bulk hide bridges
            document.getElementById('bulk-hide-bridges').addEventListener('click', function() {
                performBulkShowHide('inactive');
            });

            // Bulk delete bridges
            document.getElementById('bulk-delete-bridges').addEventListener('click', function() {
                performBulkDelete();
            });

            // Clear selection
            document.getElementById('bulk-clear-selection').addEventListener('click', function() {
                clearBulkSelection();
            });
        }

        function updateBulkSelectionDisplay() {
            var selectedCheckboxes = document.querySelectorAll('.bridge-checkbox:checked');
            var selectedCount = selectedCheckboxes.length;

            // Update statistics
            document.getElementById('edit-selected-bridges').textContent = selectedCount;
            document.getElementById('bulk-selected-count').textContent = selectedCount + ' selected';

            // Show/hide bulk actions panel
            var bulkPanel = document.getElementById('bulk-actions-panel');
            if (selectedCount > 0) {
                bulkPanel.style.display = 'block';

                // Enable/disable buttons
                document.getElementById('bulk-show-bridges').disabled = false;
                document.getElementById('bulk-hide-bridges').disabled = false;
                document.getElementById('bulk-delete-bridges').disabled = false;
            } else {
                bulkPanel.style.display = 'none';

                // Disable buttons
                document.getElementById('bulk-show-bridges').disabled = true;
                document.getElementById('bulk-hide-bridges').disabled = true;
                document.getElementById('bulk-delete-bridges').disabled = true;
            }

            // Update visual selection for bridge items
            selectedCheckboxes.forEach(function(checkbox) {
                updateBridgeItemSelection(checkbox);
            });

            // Update select all button text
            var allCheckboxes = document.querySelectorAll('.bridge-checkbox');
            var selectAllBtn = document.getElementById('select-all-bridges');
            if (selectedCount === allCheckboxes.length && selectedCount > 0) {
                selectAllBtn.innerHTML = '<i class="fa fa-square-o"></i> Unselect All';
            } else {
                selectAllBtn.innerHTML = '<i class="fa fa-check-square-o"></i> Select All';
            }
        }

        function updateBridgeItemSelection(checkbox) {
            var bridgeItem = checkbox.closest('.bridge-edit-item');
            if (checkbox.checked) {
                bridgeItem.classList.add('selected-for-bulk');
            } else {
                bridgeItem.classList.remove('selected-for-bulk');
            }
        }

        function clearBulkSelection() {
            var checkboxes = document.querySelectorAll('.bridge-checkbox');
            checkboxes.forEach(function(checkbox) {
                checkbox.checked = false;
                updateBridgeItemSelection(checkbox);
            });
            updateBulkSelectionDisplay();
        }

        function performBulkShowHide(newStatus) {
            var selectedCheckboxes = document.querySelectorAll('.bridge-checkbox:checked');
            var selectedBridges = Array.from(selectedCheckboxes).map(cb => ({
                id: cb.value,
                name: cb.getAttribute('data-bridge-name')
            }));

            if (selectedBridges.length === 0) {
                Swal.fire('Warning', 'Please select bridges first', 'warning');
                return;
            }

            var actionText = newStatus === 'active' ? 'show' : 'hide';
            var actionTextCap = newStatus === 'active' ? 'Show' : 'Hide';

            Swal.fire({
                title: 'Bulk ' + actionTextCap + ' Bridges?',
                html: '<p>Are you sure you want to <strong>' + actionText + '</strong> ' + selectedBridges.length +
                    ' selected bridges?</p>' +
                    '<div class="alert alert-' + (newStatus === 'active' ? 'success' : 'warning') +
                    '" style="margin: 10px 0; padding: 8px; font-size: 12px;">' +
                    '<i class="fa fa-info-circle"></i> <strong>This will:</strong><br>' +
                    '• ' + actionTextCap + ' all selected bridges and their cable routes<br>' +
                    '• Update visibility across all poles in the routes<br>' +
                    '• ' + (newStatus === 'active' ? 'Restore' : 'Temporarily hide') + ' visual elements' +
                    '</div>',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, ' + actionText + ' them!',
                confirmButtonColor: newStatus === 'active' ? '#28a745' : '#ffc107',
                cancelButtonText: 'Cancel',
                width: 600
            }).then((result) => {
                if (result.isConfirmed) {
                    executeBulkShowHide(selectedBridges, newStatus);
                }
            });
        }

        function executeBulkShowHide(bridges, newStatus) {
            // Show loading
            Swal.fire({
                title: 'Processing...',
                text: 'Please wait while we update ' + bridges.length + ' bridges',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Process bridges one by one (you could also create a bulk endpoint)
            var promises = bridges.map(bridge => {
                var formData = new FormData();
                formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);
                formData.append('bridge_id', bridge.id);
                formData.append('status', newStatus);

                return fetch(baseUrl + 'plugin/network_mapping/update-bridge-status', {
                    method: 'POST',
                    body: formData
                }).then(response => response.json());
            });

            Promise.all(promises)
                .then(results => {
                    var successCount = results.filter(r => r.success).length;
                    var failCount = results.length - successCount;

                    if (successCount > 0) {
                        var actionText = newStatus === 'active' ? 'shown' : 'hidden';
                        Swal.fire({
                            icon: 'success',
                            title: 'Bulk Operation Complete!',
                            html: '<p><strong>' + successCount + ' bridges</strong> successfully ' +
                                actionText + '</p>' +
                                (failCount > 0 ? '<p class="text-warning">' + failCount +
                                    ' bridges failed to update</p>' : '') +
                                '<p><i class="fa fa-refresh"></i> Map will reload to update all displays...</p>',
                            timer: 3000,
                            showConfirmButton: false
                        }).then(() => {
                            // Save position and reload
                            if (typeof mapPositionMemory !== 'undefined') {
                                mapPositionMemory.savePosition();
                            }
                            window.location.reload();
                        });
                    } else {
                        Swal.fire('Error', 'Failed to update bridges', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to process bulk operation', 'error');
                });
        }

        function performBulkDelete() {
            var selectedCheckboxes = document.querySelectorAll('.bridge-checkbox:checked');
            var selectedBridges = Array.from(selectedCheckboxes).map(cb => ({
                id: cb.value,
                name: cb.getAttribute('data-bridge-name')
            }));

            if (selectedBridges.length === 0) {
                Swal.fire('Warning', 'Please select bridges first', 'warning');
                return;
            }

            var bridgeListHtml = '<ul style="text-align: left; margin: 10px 0; max-height: 120px; overflow-y: auto;">';
            selectedBridges.forEach(bridge => {
                bridgeListHtml += '<li style="margin: 2px 0;">' + bridge.name + '</li>';
            });
            bridgeListHtml += '</ul>';

            Swal.fire({
                title: 'Bulk Delete Bridges?',
                html: '<p>Are you sure you want to <strong>permanently delete</strong> ' + selectedBridges.length +
                    ' selected bridges?</p>' +
                    bridgeListHtml +
                    '<div class="alert alert-danger" style="margin: 10px 0; padding: 8px; font-size: 12px;">' +
                    '<i class="fa fa-warning"></i> <strong>Warning:</strong> This will also delete cable routes and remove bridges from all poles along the routes.' +
                    '</div>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, Delete All!',
                confirmButtonColor: '#d33',
                cancelButtonText: 'Cancel',
                width: 650
            }).then((result) => {
                if (result.isConfirmed) {
                    executeBulkDelete(selectedBridges);
                }
            });
        }

        function executeBulkDelete(bridges) {
            // Show loading
            Swal.fire({
                title: 'Deleting...',
                text: 'Please wait while we delete ' + bridges.length + ' bridges and cable routes',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Process bridges one by one
            var promises = bridges.map(bridge => {
                var formData = new FormData();
                formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);
                formData.append('bridge_id', bridge.id);

                return fetch(baseUrl + 'plugin/network_mapping/delete-bridge-from-pole', {
                    method: 'POST',
                    body: formData
                }).then(response => response.json());
            });

            Promise.all(promises)
                .then(results => {
                    var successCount = results.filter(r => r.success).length;
                    var failCount = results.length - successCount;
                    var totalDeletedBridges = results.reduce((sum, r) => sum + (r.deleted_bridges || 0), 0);
                    var deletedCableRoutes = results.filter(r => r.deleted_cable).length;

                    if (successCount > 0) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Bulk Delete Complete!',
                            html: '<p><strong>' + successCount +
                                ' bridge operations</strong> completed successfully</p>' +
                                '<p class="text-info">Total bridges deleted: ' + totalDeletedBridges + '</p>' +
                                '<p class="text-info">Cable routes deleted: ' + deletedCableRoutes + '</p>' +
                                (failCount > 0 ? '<p class="text-warning">' + failCount +
                                    ' operations failed</p>' : '') +
                                '<p><i class="fa fa-refresh"></i> Map will reload to update display...</p>',
                            timer: 3000,
                            showConfirmButton: false
                        }).then(() => {
                            // Save position and reload
                            if (typeof mapPositionMemory !== 'undefined') {
                                mapPositionMemory.savePosition();
                            }
                            window.location.reload();
                        });
                    } else {
                        Swal.fire('Error', 'Failed to delete bridges', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to process bulk delete operation', 'error');
                });
        }
        // ===== OLT FUNCTIONS =====

        function showQuickAddOltModal(lat, lng) {
            var coordinates = lat + ',' + lng;
            var url = baseUrl + 'plugin/network_mapping/quick-add-olt&lat=' + lat + '&lng=' + lng;

            console.log('Fetching OLT data from:', url);

            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        // Populate coordinates
                        document.getElementById('olt-coordinates').value = coordinates;
                        document.getElementById('olt-coords-display').textContent = coordinates;

                        // Populate routers dropdown
                        var routerSelect = document.getElementById('olt-router');
                        routerSelect.innerHTML = '<option value="">Select Router (Optional)</option>';

                        if (data.routers && data.routers.length > 0) {
                            data.routers.forEach(function(router) {
                                var option = document.createElement('option');
                                option.value = router.id;
                                option.textContent = router.name + (router.description ? ' (' + router
                                    .description + ')' : '');
                                routerSelect.appendChild(option);
                            });
                        }

                        // PERBAIKAN: Populate parent OLTs dropdown dengan status
                        var oltParentSelect = document.getElementById('olt-parent');
                        oltParentSelect.innerHTML = '<option value="">Select Parent OLT (Optional)</option>';

                        if (data.parent_olts && data.parent_olts.length > 0) {
                            data.parent_olts.forEach(function(olt) {
                                var option = document.createElement('option');
                                option.value = olt.id;

                                var available_count = olt.available_pon_count || 0; // ✅ PON
                                var total_ports = olt.total_pon_ports; // ✅ PON
                                var status_text = available_count > 0 ?
                                    ' (Available: ' + available_count + '/' + total_ports + ' PON)' : // ✅ PON
                                    ' (FULL - No available PON)';

                                option.textContent = olt.name + status_text;

                                // PERBAIKAN: Disable jika tidak ada port tersedia
                                if (available_count <= 0) {
                                    option.disabled = true;
                                    option.style.color = '#999';
                                }

                                oltParentSelect.appendChild(option);
                            });
                        } else {
                            // PERBAIKAN: Tampilkan pesan jika tidak ada OLT yang tersedia
                            var option = document.createElement('option');
                            option.value = '';
                            option.textContent = 'No OLT with available PON found'; // ✅ PON
                            option.disabled = true;
                            oltParentSelect.appendChild(option);
                        }

                        // Setup mutual exclusive selection
                        setupOltConnectionHandlers();

                        // Clear form
                        document.getElementById('quickAddOltForm').reset();
                        document.getElementById('olt-coordinates').value = coordinates;

                        // Show modal
                        $('#quickAddOltModal').modal('show');

                        // Focus on name field
                        setTimeout(function() {
                            document.getElementById('olt-name').focus();
                        }, 500);
                    } else {
                        Swal.fire('Error', data.message || 'Unknown error', 'error');
                    }
                })
                .catch(error => {
                    console.error('Fetch Error:', error);
                    Swal.fire('Error', 'Failed to load OLT form: ' + error.message, 'error');
                });
        }

        function setupOltConnectionHandlers() {
            var routerSelect = document.getElementById('olt-router');
            var oltSelect = document.getElementById('olt-parent');
            var uplinkSection = document.getElementById('olt-uplink-port-section');
            var routerPortSection = document.getElementById('router-port-section');
            var ponPortSelect = document.getElementById('olt-parent-pon-port'); // ✅ GANTI ID
            var uplinkPortsCount = document.getElementById('olt-uplink-ports-count');
            var myUplinkPortSelect = document.getElementById('olt-my-uplink-port');
            var routerUplinkCount = document.getElementById('olt-router-uplink-count');
            var routerPortSelect = document.getElementById('olt-router-port');

            if (routerSelect && oltSelect) {
                routerSelect.addEventListener('change', function() {
                    if (this.value) {
                        oltSelect.value = '';
                        oltSelect.disabled = true;
                        uplinkSection.style.display = 'none';
                        if (ponPortSelect) ponPortSelect.disabled = true; // ✅ GANTI + null check

                        // Show router port selection
                        routerPortSection.style.display = 'block';
                        updateRouterPortOptions();
                    } else {
                        oltSelect.disabled = false;
                        routerPortSection.style.display = 'none';
                    }
                });

                oltSelect.addEventListener('change', function() {
                    if (this.value) {
                        routerSelect.value = '';
                        routerSelect.disabled = true;
                        loadAvailableUplinkPortsForOlt(this.value);
                        loadParentOltPonPorts(this.value); // ✅ Load PON ports
                        uplinkSection.style.display = 'block';
                        routerPortSection.style.display = 'none';

                        // ✅ ENABLE PON port dropdown
                        if (ponPortSelect) {
                            ponPortSelect.disabled = false; // ✅ Enable dropdown
                        }

                        updateMyUplinkPortOptions();
                    } else {
                        routerSelect.disabled = false;
                        uplinkSection.style.display = 'none';
                        if (ponPortSelect) { // ✅ GANTI + null check
                            ponPortSelect.disabled = true;
                            ponPortSelect.innerHTML = '<option value="">Select parent OLT first</option>';
                        }
                        document.getElementById('olt-uplink-port-status-info').innerHTML = '';
                    }
                });

                // Handle router uplink count change
                if (routerUplinkCount) {
                    routerUplinkCount.addEventListener('change', function() {
                        updateRouterPortOptions();
                    });
                }

                // Handle OLT uplink ports count change
                if (uplinkPortsCount) {
                    uplinkPortsCount.addEventListener('change', function() {
                        updateMyUplinkPortOptions();
                    });
                }
            }
        }
        // ✅ TAMBAH FUNCTION BARU INI DI SINI
        function loadParentOltPonPorts(parentOltId) {
            var ponPortSelect = document.getElementById('olt-parent-pon-port');
            ponPortSelect.innerHTML = '<option value="">Loading PON ports...</option>';

            // ✅ GET PON usage info from backend
            fetch(baseUrl + 'plugin/network_mapping/get-olt-pon-usage&olt_id=' + parentOltId)
                .then(response => response.json())
                .then(data => {
                    console.log('PON Usage Response:', data); // ✅ Debug log

                    ponPortSelect.innerHTML = '<option value="">Auto select PON</option>';

                    if (data.success) {
                        for (var i = 1; i <= data.total_pon_ports; i++) {
                            var option = document.createElement('option');
                            option.value = i;

                            // ✅ Check if PON is used
                            var usedDetail = data.used_pon_details.find(function(detail) {
                                return detail.port == i;
                            });

                            if (usedDetail) {
                                option.textContent = 'PON ' + i + ' (Used by ' + usedDetail.device_name + ')';
                                option.disabled = true; // ✅ Cannot be clicked
                                option.style.color = '#999';
                                option.style.fontStyle = 'italic';
                                option.style.backgroundColor = '#f5f5f5';
                            } else {
                                option.textContent = 'PON ' + i + ' (Available)';
                                option.style.color = '#333';
                            }

                            ponPortSelect.appendChild(option);
                        }
                    } else {
                        console.error('Backend error:', data.message);
                        ponPortSelect.innerHTML = '<option value="">Error loading PON ports</option>';
                    }
                })
                .catch(error => {
                    console.error('Error loading PON ports:', error);
                    ponPortSelect.innerHTML = '<option value="">Network error - try again</option>';
                });
        }

        // NEW: Function to update "my uplink port" options
        function updateMyUplinkPortOptions() {
            var uplinkPortsCount = document.getElementById('olt-uplink-ports-count');
            var myUplinkPortSelect = document.getElementById('olt-my-uplink-port');

            if (!uplinkPortsCount || !myUplinkPortSelect) return;

            var totalPorts = parseInt(uplinkPortsCount.value);
            var currentValue = myUplinkPortSelect.value;

            // Rebuild port options
            myUplinkPortSelect.innerHTML = '';
            for (var i = 1; i <= totalPorts; i++) {
                var option = document.createElement('option');
                option.value = i;
                option.textContent = 'Port ' + i;
                if (i == currentValue || (i == 2 && !currentValue)) {
                    option.selected = true;
                }
                myUplinkPortSelect.appendChild(option);
            }
        }

        // Function to update router port options (existing)
        function updateRouterPortOptions() {
            var routerUplinkCount = document.getElementById('olt-router-uplink-count');
            var routerPortSelect = document.getElementById('olt-router-port');

            if (!routerUplinkCount || !routerPortSelect) return;

            var totalPorts = parseInt(routerUplinkCount.value);
            var currentValue = routerPortSelect.value;

            // Rebuild port options
            routerPortSelect.innerHTML = '';
            for (var i = 1; i <= totalPorts; i++) {
                var option = document.createElement('option');
                option.value = i;
                option.textContent = 'Port ' + i;
                if (i == currentValue || (i == 1 && !currentValue)) {
                    option.selected = true;
                }
                routerPortSelect.appendChild(option);
            }
        }

        // Function to update router port options
        function updateRouterPortOptions() {
            var routerUplinkCount = document.getElementById('olt-router-uplink-count');
            var routerPortSelect = document.getElementById('olt-router-port');

            if (!routerUplinkCount || !routerPortSelect) return;

            var totalPorts = parseInt(routerUplinkCount.value);
            var currentValue = routerPortSelect.value;

            // Rebuild port options
            routerPortSelect.innerHTML = '';
            for (var i = 1; i <= totalPorts; i++) {
                var option = document.createElement('option');
                option.value = i;
                option.textContent = 'Port ' + i;
                if (i == currentValue || (i == 1 && !currentValue)) {
                    option.selected = true;
                }
                routerPortSelect.appendChild(option);
            }
        }

        // NEW: Function to update router port options
        function updateRouterPortOptions() {
            var routerUplinkCount = document.getElementById('olt-router-uplink-count');
            var routerPortSelect = document.getElementById('olt-router-port');

            if (!routerUplinkCount || !routerPortSelect) return;

            var totalPorts = parseInt(routerUplinkCount.value);
            var currentValue = routerPortSelect.value;

            // Rebuild port options
            routerPortSelect.innerHTML = '';
            for (var i = 1; i <= totalPorts; i++) {
                var option = document.createElement('option');
                option.value = i;
                option.textContent = 'Port ' + i;
                if (i == currentValue || (i == 1 && !currentValue)) {
                    option.selected = true;
                }
                routerPortSelect.appendChild(option);
            }
        }

        function loadAvailableUplinkPortsForOlt(oltId) {
            var portSelect = document.getElementById('olt-uplink-port-number');
            var portStatusInfo = document.getElementById('olt-uplink-port-status-info');

            if (!portSelect || !oltId) return;

            portSelect.innerHTML = '<option value="">Loading ports...</option>';
            portSelect.disabled = true;
            portStatusInfo.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Loading port information...';

            fetch(baseUrl + 'plugin/network_mapping/get-available-uplink-ports&olt_id=' + oltId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        portSelect.innerHTML = '<option value="">Auto port</option>';

                        if (data.available_ports && data.available_ports.length > 0) {
                            data.available_ports.forEach(function(port) {
                                var option = document.createElement('option');
                                option.value = port;
                                option.textContent = 'Port ' + port + ' (Available)';
                                portSelect.appendChild(option);
                            });

                            portSelect.disabled = false;
                        } else {
                            // PERBAIKAN: Tampilkan error jika tidak ada port tersedia
                            var option = document.createElement('option');
                            option.value = '';
                            option.textContent = 'No available uplink ports - OLT is FULL!';
                            option.disabled = true;
                            option.style.color = '#d9534f';
                            portSelect.appendChild(option);

                            portStatusInfo.innerHTML =
                                '<div style="color: #d9534f; font-weight: bold;"><i class="fa fa-exclamation-triangle"></i> Warning: Selected OLT has no available uplink ports!</div>';
                        }

                        updateOltUplinkPortStatusInfo(data.used_ports_detail, data.available_ports);
                    } else {
                        portSelect.innerHTML = '<option value="">Error loading ports</option>';
                        portStatusInfo.innerHTML = '<span class="text-danger">Error: ' + data.message + '</span>';
                    }
                })
                .catch(error => {
                    console.error('Error loading uplink ports:', error);
                    portSelect.innerHTML = '<option value="">Error loading ports</option>';
                    portStatusInfo.innerHTML = '<span class="text-danger">Error loading ports</span>';
                });
        }

        function updateUplinkPortOptions(maxPorts) {
            var portSelect = document.getElementById('olt-uplink-port-number');
            if (!portSelect) return;

            // Reset to auto if current selection exceeds max
            var currentValue = portSelect.value;
            if (currentValue && parseInt(currentValue) > maxPorts) {
                portSelect.value = '';
            }
        }

        function updateOltUplinkPortStatusInfo(usedPortsDetail, availablePorts) {
            var portStatusInfo = document.getElementById('olt-uplink-port-status-info');
            if (!portStatusInfo) return;

            var statusHtml = '';

            if (usedPortsDetail && Object.keys(usedPortsDetail).length > 0) {
                statusHtml +=
                    '<div style="background: rgba(255, 193, 7, 0.1); border: 1px solid #ffc107; padding: 4px 6px; border-radius: 3px; margin-bottom: 4px;">';
                statusHtml += '<strong style="color: #856404;">Used Uplink Ports:</strong><br>';

                Object.keys(usedPortsDetail).forEach(function(port) {
                    var detail = usedPortsDetail[port];
                    statusHtml += '• Port ' + port + ': ' + detail.name + ' (' + detail.type.toUpperCase() +
                        ')<br>';
                });

                statusHtml = statusHtml.slice(0, -4);
                statusHtml += '</div>';
            }

            if (availablePorts && availablePorts.length > 0) {
                statusHtml +=
                    '<div style="background: rgba(40, 167, 69, 0.1); border: 1px solid #28a745; padding: 4px 6px; border-radius: 3px;">';
                statusHtml += '<strong style="color: #155724;">Available Uplink Ports:</strong> ';
                statusHtml += 'Port ' + availablePorts.join(', Port ');
                statusHtml += '</div>';
            }

            portStatusInfo.innerHTML = statusHtml;
        }

        function saveQuickAddOlt() {
            console.log('🔥 DEBUG: saveQuickAddOlt called');

            var form = document.getElementById('quickAddOltForm');
            if (!form) {
                console.error('❌ Form quickAddOltForm not found!');
                Swal.fire('Error', 'Form tidak ditemukan', 'error');
                return;
            }

            console.log('✅ Form found, creating FormData');

            // PERBAIKAN: Ambil total uplink ports dari router section
            var routerUplinkCount = document.getElementById('olt-router-uplink-count');
            var totalUplinkPorts = routerUplinkCount ? routerUplinkCount.value : '4';

            var formData = new FormData(form);

            // TAMBAHAN: Set total uplink ports dari router selection
            formData.set('total_uplink_ports', totalUplinkPorts);

            // Debug: Log form data
            for (var pair of formData.entries()) {
                console.log('📝 Form data:', pair[0] + ' = ' + pair[1]);
            }

            Swal.fire({
                title: 'Saving OLT...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            var saveUrl = baseUrl + 'plugin/network_mapping/quick-save-olt';
            console.log('🌐 Fetch URL:', saveUrl);

            fetch(saveUrl, {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    console.log('📡 Response status:', response.status);
                    console.log('📡 Response headers:', response.headers.get('Content-Type'));

                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }

                    return response.text();
                })
                .then(text => {
                    console.log('📄 Raw response:', text);

                    try {
                        var data = JSON.parse(text);
                        console.log('✅ Parsed response:', data);

                        if (data.success) {
                            $('#quickAddOltModal').modal('hide');

                            mapPositionMemory.savePosition();

                            Swal.fire({
                                icon: 'success',
                                title: 'OLT Added!',
                                html: '<p><strong>Name:</strong> ' + data.olt.name + '</p>' +
                                    '<p><strong>Coordinates:</strong> ' + data.olt.coordinates + '</p>' +
                                    '<p><strong>Uplink Ports:</strong> ' + data.olt.total_uplink_ports +
                                    '</p>' +
                                    '<p><strong>PON Ports:</strong> ' + data.olt.total_pon_ports + '</p>' +
                                    (data.olt.router_uplink_port ? '<p><strong>Router Port:</strong> ' + data
                                        .olt.router_uplink_port + '</p>' : '') +
                                    '<p class="text-info"><i class="fa fa-refresh"></i> Map akan tetap di posisi ini setelah reload...</p>',
                                timer: 3000,
                                showConfirmButton: false
                            }).then(() => {
                                document.body.classList.remove('quick-add-mode-active');
                                resetQuickAddButton();
                                window.location.reload();
                            });

                            cancelQuickAddMode();
                        } else {
                            Swal.fire('Error', data.message, 'error');
                        }
                    } catch (parseError) {
                        console.error('❌ JSON Parse Error:', parseError);
                        Swal.fire('Error', 'Invalid response format', 'error');
                    }
                })
                .catch(error => {
                    console.error('❌ Fetch Error:', error);
                    Swal.fire('Error', 'Failed to save OLT: ' + error.message, 'error');
                });
        }

        function showOltDetail(id) {
            var olt = null;
            if (networkData.olts) {
                olt = networkData.olts.find(function(o) {
                    return o.id == id;
                });
            }

            if (olt) {
                var detailHtml = '<div class="text-left">' +
                    '<h4><i class="fa-solid fa-broadcast-tower text-danger"></i> ' + olt.name + '</h4>' +
                    '<hr>' +
                    '<p><strong>Description:</strong> ' + (olt.description || 'No description') + '</p>' +
                    '<p><strong>Coordinates:</strong> ' + olt.coordinates + '</p>' +
                    '<p><strong>Address:</strong> ' + (olt.address || 'No address') + '</p>' +
                    '<p><strong>Uplink Ports:</strong> ' + olt.used_uplink_ports + '/' + olt.total_uplink_ports +
                    ' (Available: ' + olt.available_uplink_ports + ')</p>' +
                    '<p><strong>PON Ports:</strong> ' + olt.used_pon_ports + '/' + olt.total_pon_ports +
                    ' (Available: ' + olt.available_pon_ports + ')</p>' +
                    '<p><strong>Connected Router:</strong> ' + (olt.router_id ? 'Router #' + olt.router_id :
                        'No router connected') + '</p>' +
                    '<hr>' +
                    '<div class="text-center">' +
                    '<button type="button" class="btn btn-info center-map-btn">Center on Map</button>' +
                    '<button type="button" class="btn btn-warning route-cable-btn" style="margin-left: 10px;">Route Cable</button>' +
                    '</div>' +
                    '</div>';

                Swal.fire({
                    title: 'OLT Details',
                    html: detailHtml,
                    width: 600,
                    showConfirmButton: true,
                    confirmButtonText: '<i class="fa fa-edit"></i> Edit OLT',
                    confirmButtonColor: '#f0ad4e',
                    showCancelButton: true,
                    cancelButtonText: 'Close',
                    showCloseButton: true,
                    didOpen: () => {
                        var centerBtn = document.querySelector('.swal2-html-container .center-map-btn');
                        var routeBtn = document.querySelector('.swal2-html-container .route-cable-btn');

                        if (centerBtn) {
                            centerBtn.addEventListener('click', function() {
                                centerMapOnOlt(olt.id);
                            });
                        }

                        if (routeBtn) {
                            routeBtn.addEventListener('click', function() {
                                Swal.close();
                                startRoutingFromPoint('olt', olt.id, olt.name, olt.coordinates);
                            });
                        }
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        var editUrl = window.location.protocol + '//' + window.location.host +
                            '/?_route=plugin/network_mapping/edit-olt&id=' + olt.id;
                        window.location.href = editUrl;
                    }
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'OLT Not Found',
                    text: 'Unable to find OLT details'
                });
            }
        }

        function centerMapOnOlt(id) {
            var olt = networkData.olts.find(function(o) { return o.id == id; });
            if (olt) {
                var coords = olt.coordinates.split(',').map(parseFloat);
                map.setView(coords, 18);
                Swal.close();
            }
        }

        function editOltFromMap(id) {
            var protocol = window.location.protocol;
            var host = window.location.host;
            var editUrl = protocol + '//' + host + '/?_route=plugin/network_mapping/edit-olt&id=' + id + '&from_map=1';

            console.log('Edit OLT from map, ID:', id);
            window.location.href = editUrl;
        }

        function deleteOltFromMap(id, name) {
            var oltData = null;
            if (networkData.olts) {
                oltData = networkData.olts.find(function(o) {
                    return o.id == id;
                });
            }

            var usedUplinkPorts = oltData ? oltData.used_uplink_ports : 0;
            var usedPonPorts = oltData ? oltData.used_pon_ports : 0;
            var totalConnections = usedUplinkPorts + usedPonPorts;

            if (totalConnections > 0) {
                Swal.fire({
                    title: 'Cannot Delete OLT',
                    html: '<p>OLT <strong>' + name + '</strong> cannot be deleted because it has <strong>' +
                        totalConnections + ' active connections</strong>.</p>' +
                        '<p><strong>Child OLTs:</strong> ' + usedUplinkPorts + '</p>' +
                        '<p><strong>Connected ODCs:</strong> ' + usedPonPorts + '</p>' +
                        '<p class="text-info"><i class="fa fa-info-circle"></i> Please disconnect all connections first using the <strong>"Unplug"</strong> button.</p>' +
                        '<p>Would you like to disconnect connections now?</p>',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: '<i class="fa fa-unlink"></i> Disconnect Now',
                    confirmButtonColor: '#f0ad4e',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        map.closePopup();
                        showOltDisconnectModal(id, name, totalConnections);
                    }
                });
                return;
            }

            Swal.fire({
                title: 'Delete OLT?',
                html: '<p>Are you sure you want to delete <strong>' + name + '</strong>?</p>' +
                    '<p class="text-success"><i class="fa fa-check-circle"></i> OLT has no active connections</p>' +
                    '<p class="text-danger"><small>This action cannot be undone!</small></p>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, Delete!',
                confirmButtonColor: '#d33',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Deleting...',
                        text: 'Please wait',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    var formData = new FormData();
                    formData.append('id', id);
                    formData.append('csrf_token', document.querySelector('input[name="csrf_token"]').value);

                    fetch(baseUrl + 'plugin/network_mapping/ajax-delete-olt', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Deleted!',
                                    text: data.message + ' - Page akan direload...',
                                    timer: 1500,
                                    showConfirmButton: false
                                }).then(() => {
                                    window.location.reload();
                                });

                                var markerKey = 'olt_' + id;
                                if (allMarkers[markerKey]) {
                                    markersGroup.olts.removeLayer(allMarkers[markerKey].marker);
                                    delete allMarkers[markerKey];
                                }

                                map.closePopup();
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: data.message
                                });
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Failed to delete OLT: ' + error.message
                            });
                        });
                }
            });
        }

        // ===== END OLT FUNCTIONS =====
        function loadAvailablePonPortsForQuickAdd(oltId) {
            var portSelect = document.getElementById('odc-pon-port');
            var portStatusInfo = document.getElementById('olt-pon-port-status-info');

            if (!portSelect || !oltId) return;

            portSelect.innerHTML = '<option value="">Loading PON ports...</option>';
            portSelect.disabled = true;
            portStatusInfo.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Loading PON port information...';

            fetch(baseUrl + 'plugin/network_mapping/get-available-pon-ports&olt_id=' + oltId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        portSelect.innerHTML = '<option value="">Auto PON port</option>';

                        if (data.available_ports && data.available_ports.length > 0) {
                            data.available_ports.forEach(function(port) {
                                var option = document.createElement('option');
                                option.value = port;
                                option.textContent = 'PON ' + port + ' (Available)';
                                portSelect.appendChild(option);
                            });

                            portSelect.disabled = false;
                        } else {
                            var option = document.createElement('option');
                            option.value = '';
                            option.textContent = 'No available PON ports';
                            option.disabled = true;
                            portSelect.appendChild(option);
                        }

                        updateOltPonPortStatusInfo(data.used_ports_detail, data.available_ports);
                    } else {
                        portSelect.innerHTML = '<option value="">Error loading PON ports</option>';
                        portStatusInfo.innerHTML = '<span class="text-danger">Error: ' + data.message + '</span>';
                    }
                })
                .catch(error => {
                    console.error('Error loading PON ports:', error);
                    portSelect.innerHTML = '<option value="">Error loading PON ports</option>';
                    portStatusInfo.innerHTML = '<span class="text-danger">Error loading PON ports</span>';
                });
        }

        function updateOltPonPortStatusInfo(usedPortsDetail, availablePorts) {
            var portStatusInfo = document.getElementById('olt-pon-port-status-info');
            if (!portStatusInfo) return;

            var statusHtml = '';

            if (usedPortsDetail && Object.keys(usedPortsDetail).length > 0) {
                statusHtml +=
                    '<div style="background: rgba(255, 193, 7, 0.1); border: 1px solid #ffc107; padding: 4px 6px; border-radius: 3px; margin-bottom: 4px;">';
                statusHtml += '<strong style="color: #856404;">Used PON Ports:</strong><br>';

                Object.keys(usedPortsDetail).forEach(function(port) {
                    var detail = usedPortsDetail[port];
                    statusHtml += '• PON ' + port + ': ' + detail.name + ' (' + detail.type.toUpperCase() + ')<br>';
                });

                statusHtml = statusHtml.slice(0, -4);
                statusHtml += '</div>';
            }

            if (availablePorts && availablePorts.length > 0) {
                statusHtml +=
                    '<div style="background: rgba(40, 167, 69, 0.1); border: 1px solid #28a745; padding: 4px 6px; border-radius: 3px;">';
                statusHtml += '<strong style="color: #155724;">Available PON Ports:</strong> ';
                statusHtml += 'PON ' + availablePorts.join(', PON ');
                statusHtml += '</div>';
            }

            portStatusInfo.innerHTML = statusHtml;
        }
        // ===== EDIT OLT MODAL FUNCTIONS =====

        function showEditOltModal(oltId, oltName) {
            // Show loading first
            Swal.fire({
                title: 'Loading OLT Data...',
                html: '<i class="fa fa-spinner fa-spin fa-2x"></i>',
                showConfirmButton: false,
                allowOutsideClick: false
            });

            // Load OLT details
            fetch(baseUrl + 'plugin/network_mapping/get-olt-details&id=' + oltId)
                .then(response => response.json())
                .then(data => {
                    Swal.close();

                    if (data.success) {
                        populateEditOltModal(data.olt, oltName);
                        $('#editOltModal').modal('show');
                    } else {
                        Swal.fire('Error', data.message || 'Failed to load OLT details', 'error');
                    }
                })
                .catch(error => {
                    Swal.close();
                    console.error('Error loading OLT details:', error);
                    Swal.fire('Error', 'Failed to load OLT details', 'error');
                });
        }

        function populateEditOltModal(olt, oltName) {
            // Basic info
            document.getElementById('edit-olt-id').value = olt.id;
            document.getElementById('edit-olt-name').textContent = oltName;
            document.getElementById('edit-olt-name-input').value = olt.name;
            document.getElementById('edit-olt-description').value = olt.description || '';
            document.getElementById('edit-olt-address').value = olt.address || '';

            // Port settings
            document.getElementById('edit-olt-uplink-ports').value = olt.total_uplink_ports;
            document.getElementById('edit-olt-pon-ports').value = olt.total_pon_ports;

            // ✅ RESET port dropdowns ke state awal
            resetAllPortDropdowns();

            // Load options
            loadRoutersForEdit();
            loadOltsForEdit(olt.id);
            loadConnectedOdcsForEdit(olt.id);

            // Determine current connection type and set default tab
            if (olt.router_id) {
                document.getElementById('edit-conn-router').checked = true;
                showConnectionSection('router');


            } else if (olt.parent_olt_id) {
                document.getElementById('edit-conn-olt').checked = true;
                showConnectionSection('olt');

                setTimeout(() => {
                    document.getElementById('edit-parent-olt').value = olt.parent_olt_id;
                    document.getElementById('edit-my-uplink-port').value = olt.my_uplink_port || '1';
                    loadParentUplinkPorts(olt.parent_olt_id, olt.uplink_port_number);
                }, 500);

            } else {
                // Check if has ODC connections for PON tab, otherwise default to Router
                var hasOdcConnections = checkIfHasOdcConnections(olt.id);
                if (hasOdcConnections) {
                    document.getElementById('edit-conn-pon').checked = true;
                    showConnectionSection('pon');
                } else {
                    document.getElementById('edit-conn-router').checked = true;
                    showConnectionSection('router');
                }
            }

            // Setup event handlers
            setupEditOltHandlers();

            // Update available ports based on current usage
            updateAvailableUplinkPorts(olt.id);
        }
        // ✅ TAMBAH FUNCTION BARU
        function resetAllPortDropdowns() {
            // Reset router uplink port
            var routerUplinkSelect = document.getElementById('edit-router-uplink-port');
            routerUplinkSelect.innerHTML = '<option value="">Select router first</option>';
            routerUplinkSelect.disabled = true;

            // Reset my uplink port (untuk OLT connection)
            var myUplinkSelect = document.getElementById('edit-my-uplink-port');
            myUplinkSelect.innerHTML = '<option value="">Select parent OLT first</option>';
            myUplinkSelect.disabled = true;

            // Reset parent uplink port
            var parentUplinkSelect = document.getElementById('edit-parent-uplink-port');
            parentUplinkSelect.innerHTML = '<option value="">Select parent OLT first</option>';
            parentUplinkSelect.disabled = true;

            // Reset PON port
            var ponPortSelect = document.getElementById('edit-olt-pon-port');
            ponPortSelect.innerHTML = '<option value="">Select child ODC first</option>';
            ponPortSelect.disabled = true;
        }

        function loadConnectedOdcsForEdit(oltId) {
            var odcSelect = document.getElementById('edit-child-odc');
            odcSelect.innerHTML = '<option value="">Loading connected ODCs...</option>';

            // Get ODCs connected to this OLT
            if (networkData.odcs) {
                var connectedOdcs = networkData.odcs.filter(function(odc) {
                    return odc.olt_id == oltId;
                });

                odcSelect.innerHTML = '<option value="">Select ODC to modify</option>';

                if (connectedOdcs.length > 0) {
                    connectedOdcs.forEach(function(odc) {
                        var option = document.createElement('option');
                        option.value = odc.id;
                        option.textContent = odc.name + ' (PON ' + odc.pon_port_number + ')';
                        option.setAttribute('data-pon-port', odc.pon_port_number);
                        odcSelect.appendChild(option);
                    });

                    // Enable PON tab
                    document.getElementById('edit-conn-pon').disabled = false;
                } else {
                    odcSelect.innerHTML = '<option value="">No ODCs connected</option>';
                    // Disable PON tab
                    document.getElementById('edit-conn-pon').disabled = true;
                }
            }
        }

        function checkIfHasOdcConnections(oltId) {
            if (networkData.odcs) {
                return networkData.odcs.some(function(odc) {
                    return odc.olt_id == oltId;
                });
            }
            return false;
        }

        function updateAvailableUplinkPorts(oltId) {
            fetch(baseUrl + 'plugin/network_mapping/get-olt-port-usage&olt_id=' + oltId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        updateUplinkPortOptions(data.used_uplink_ports, data.router_connection);
                    }
                })
                .catch(error => {
                    console.error('Error loading port usage:', error);
                });
        }

        function updateUplinkPortOptions(usedPorts, routerConnection) {
            var totalPorts = parseInt(document.getElementById('edit-olt-uplink-ports').value);
            var routerPortSelect = document.getElementById('edit-router-uplink-port');
            var myUplinkPortSelect = document.getElementById('edit-my-uplink-port');

            // Update router uplink port options
            updatePortSelect(routerPortSelect, totalPorts, usedPorts, routerConnection?.my_uplink_port);

            // Update my uplink port options  
            updatePortSelect(myUplinkPortSelect, totalPorts, usedPorts, null);
        }

        function updatePortSelect(selectElement, totalPorts, usedPorts, currentValue) {
            var currentSelected = currentValue || selectElement.value;
            selectElement.innerHTML = '';

            for (var i = 1; i <= totalPorts; i++) {
                var option = document.createElement('option');
                option.value = i;

                if (usedPorts.includes(i) && i != currentSelected) {
                    option.textContent = 'Port ' + i + ' (Used)';
                    option.disabled = true;
                } else {
                    option.textContent = 'Port ' + i;
                }

                if (i == currentSelected) {
                    option.selected = true;
                }

                selectElement.appendChild(option);
            }
        }

        function loadRoutersForEdit(oltId) { // ✅ Tambah parameter
            var routerSelect = document.getElementById('edit-connected-router');

            routerSelect.innerHTML = '<option value="">Select router to modify</option>';

            if (networkData.routers) {
                networkData.routers.forEach(function(router) {
                    // ✅ Sekarang oltId sudah defined
                    var isConnected = checkIfRouterConnectedToOlt(router.id, oltId);

                    var option = document.createElement('option');
                    option.value = router.id;
                    option.textContent = router.name;

                    if (isConnected) {
                        option.textContent += ' (Connected)';
                    }

                    routerSelect.appendChild(option);
                });
            }
        }
        // ✅ TAMBAH FUNCTION BARU
        function checkIfRouterConnectedToOlt(routerId, oltId) {
            // Cek di networkData.olts apakah router ini connected ke OLT yang sedang diedit
            if (networkData.olts) {
                var currentOlt = networkData.olts.find(function(olt) {
                    return olt.id == oltId;
                });

                if (currentOlt && currentOlt.router_id == routerId) {
                    return true;
                }
            }
            return false;
        }

        function loadOltsForEdit(currentOltId) {
            var oltSelect = document.getElementById('edit-parent-olt');
            oltSelect.innerHTML = '<option value="">Select OLT to modify</option>'; // ✅ NEW TEXT

            if (networkData.olts) {
                networkData.olts.forEach(function(olt) {
                    if (olt.id != currentOltId) {
                        var option = document.createElement('option');
                        option.value = olt.id;

                        var used_pon = olt.used_pon_ports || 0;
                        var total_pon = olt.total_pon_ports || 4;
                        var available_pon = total_pon - used_pon;

                        option.textContent = olt.name + ' (' + used_pon + '/' + total_pon + ')';

                        if (available_pon <= 0) {
                            option.disabled = true;
                            option.textContent += ' - FULL';
                        }

                        oltSelect.appendChild(option);
                    }
                });
            }
        }

        function setupEditOltHandlers() {
            // Connection type change handlers
            document.querySelectorAll('input[name="connection_type"]').forEach(function(radio) {
                radio.addEventListener('change', function() {
                    showConnectionSection(this.value);
                });
            });
            // ✅ Router selection change - auto fill uplink port
            document.getElementById('edit-connected-router').addEventListener('change', function() {
                var routerUplinkSelect = document.getElementById('edit-router-uplink-port');

                if (this.value) {
                    // Enable uplink port dropdown and load current connection
                    routerUplinkSelect.disabled = false;
                    loadRouterUplinkPortOptions(this.value);
                } else {
                    // Disable uplink port dropdown
                    routerUplinkSelect.disabled = true;
                    routerUplinkSelect.innerHTML = '<option value="">Select Router first</option>';
                }
            });
            // ✅ TAMBAH INI - Parent OLT selection change
            document.getElementById('edit-parent-olt').addEventListener('change', function() {
                var myUplinkSelect = document.getElementById('edit-my-uplink-port');
                var parentPonSelect = document.getElementById('edit-parent-pon-port');

                if (this.value) {
                    // ✅ Enable both dropdowns when OLT selected
                    myUplinkSelect.disabled = false;
                    parentPonSelect.disabled = false;

                    // ✅ Load My Uplink Port options (from current OLT being edited)
                    loadMyUplinkPortOptions();

                    // ✅ Load Parent PON Port options (from selected parent OLT)
                    loadParentPonPortsForEdit(this.value);

                } else {
                    // ✅ Disable both dropdowns when back to "Select OLT to modify"
                    myUplinkSelect.disabled = true;
                    myUplinkSelect.innerHTML = '<option value="">Select OLT first</option>';

                    parentPonSelect.disabled = true;
                    parentPonSelect.innerHTML = '<option value="">Select OLT first</option>';
                }
            });

            // ODC selection change - auto fill PON port
            document.getElementById('edit-child-odc').addEventListener('change', function() {
                var selectedOption = this.options[this.selectedIndex];
                var ponPortSelect = document.getElementById('edit-olt-pon-port');

                if (this.value && selectedOption.getAttribute('data-pon-port')) {
                    // Enable and populate PON port dropdown
                    ponPortSelect.disabled = false;
                    loadPonPortOptions(selectedOption.getAttribute('data-pon-port'));
                } else {
                    // Disable PON port dropdown
                    ponPortSelect.disabled = true;
                    ponPortSelect.innerHTML = '<option value="">Select Child ODC first</option>';
                }
            });

            // Uplink ports change
            document.getElementById('edit-olt-uplink-ports').addEventListener('change', function() {
                updateEditUplinkPortOptions();
            });

            // Parent OLT change
            document.getElementById('edit-parent-olt').addEventListener('change', function() {
                if (this.value) {
                    loadParentUplinkPorts(this.value);
                }
            });
        }
        // ✅ TAMBAH FUNCTION BARU
        function loadMyUplinkPortOptions() {
            var myUplinkSelect = document.getElementById('edit-my-uplink-port');
            var totalUplinkPorts = parseInt(document.getElementById('edit-olt-uplink-ports').value);

            myUplinkSelect.innerHTML = '';

            for (var i = 1; i <= totalUplinkPorts; i++) {
                var option = document.createElement('option');
                option.value = i;
                option.textContent = 'Port ' + i;
                myUplinkSelect.appendChild(option);
            }
        }


        function loadPonPortOptions(currentPonPort) {
            var ponPortSelect = document.getElementById('edit-olt-pon-port');
            var totalPonPorts = parseInt(document.getElementById('edit-olt-pon-ports').value);

            ponPortSelect.innerHTML = '';

            for (var i = 1; i <= totalPonPorts; i++) {
                var option = document.createElement('option');
                option.value = i;

                if (i == currentPonPort) {
                    option.textContent = 'PON ' + i + ' (Currently Used)';
                    option.selected = true;
                } else {
                    option.textContent = 'PON ' + i;
                }

                ponPortSelect.appendChild(option);
            }
        }


        // ✅ TAMBAH FUNCTION BARU
        function forceResetAllDropdowns() {
            // ✅ Reset router section - paksa kosong
            var routerSelect = document.getElementById('edit-connected-router');
            routerSelect.innerHTML = '<option value="">Select router to modify</option>';
            routerSelect.value = '';

            var routerUplinkSelect = document.getElementById('edit-router-uplink-port');
            routerUplinkSelect.innerHTML = '<option value="">Select router first</option>';
            routerUplinkSelect.disabled = true;
            routerUplinkSelect.value = '';

            // ✅ Reset OLT section with NEW TEXT
            var parentOltSelect = document.getElementById('edit-parent-olt');
            parentOltSelect.innerHTML = '<option value="">Select OLT to modify</option>'; // ✅ CHANGED
            parentOltSelect.value = '';

            var myUplinkSelect = document.getElementById('edit-my-uplink-port');
            myUplinkSelect.innerHTML = '<option value="">Select OLT first</option>'; // ✅ CHANGED
            myUplinkSelect.disabled = true;
            myUplinkSelect.value = '';

            var parentPonSelect = document.getElementById('edit-parent-pon-port'); // ✅ FIXED ID
            parentPonSelect.innerHTML = '<option value="">Select OLT first</option>'; // ✅ CHANGED
            parentPonSelect.disabled = true;
            parentPonSelect.value = '';

            // ✅ Reset PON section
            var odcSelect = document.getElementById('edit-child-odc');
            odcSelect.innerHTML = '<option value="">Select ODC to modify</option>';
            odcSelect.value = '';

            var ponPortSelect = document.getElementById('edit-olt-pon-port');
            ponPortSelect.innerHTML = '<option value="">Select child ODC first</option>';
            ponPortSelect.disabled = true;
            ponPortSelect.value = '';
        }

        function updateEditUplinkPortOptions() {
            var totalPorts = parseInt(document.getElementById('edit-olt-uplink-ports').value);
            var routerPortSelect = document.getElementById('edit-router-port');
            var myUplinkPortSelect = document.getElementById('edit-my-uplink-port');

            // Update router port options
            var currentRouterPort = routerPortSelect.value;
            routerPortSelect.innerHTML = '';
            for (var i = 1; i <= totalPorts; i++) {
                var option = document.createElement('option');
                option.value = i;
                option.textContent = 'Port ' + i;
                if (i == currentRouterPort || (i == 1 && !currentRouterPort)) {
                    option.selected = true;
                }
                routerPortSelect.appendChild(option);
            }

            // Update my uplink port options
            var currentMyPort = myUplinkPortSelect.value;
            myUplinkPortSelect.innerHTML = '';
            for (var i = 1; i <= totalPorts; i++) {
                var option = document.createElement('option');
                option.value = i;
                option.textContent = 'Port ' + i;
                if (i == currentMyPort || (i == 1 && !currentMyPort)) {
                    option.selected = true;
                }
                myUplinkPortSelect.appendChild(option);
            }
        }

        function loadParentUplinkPorts(parentOltId, selectedPort) {
            var portSelect = document.getElementById('edit-parent-uplink-port');
            portSelect.innerHTML = '<option value="">Loading ports...</option>';

            fetch(baseUrl + 'plugin/network_mapping/get-available-uplink-ports&olt_id=' + parentOltId)
                .then(response => response.json())
                .then(data => {
                    portSelect.innerHTML = '<option value="">Auto select</option>';

                    if (data.success && data.available_ports) {
                        data.available_ports.forEach(function(port) {
                            var option = document.createElement('option');
                            option.value = port;
                            option.textContent = 'Port ' + port + ' (Available)';
                            if (port == selectedPort) {
                                option.selected = true;
                            }
                            portSelect.appendChild(option);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error loading parent uplink ports:', error);
                    portSelect.innerHTML = '<option value="">Error loading ports</option>';
                });
        }
        // ✅ TAMBAH FUNCTION BARU INI SETELAH } DI ATAS
        function loadParentPonPortsForEdit(parentOltId, selectedPort) {
            var ponPortSelect = document.getElementById('edit-parent-pon-port');
            ponPortSelect.innerHTML = '<option value="">Loading PON ports...</option>';

            if (networkData.olts) {
                var parentOlt = networkData.olts.find(function(olt) {
                    return olt.id == parentOltId;
                });

                if (parentOlt) {
                    ponPortSelect.innerHTML = '<option value="">Auto select PON</option>';

                    for (var i = 1; i <= parentOlt.total_pon_ports; i++) {
                        var option = document.createElement('option');
                        option.value = i;
                        option.textContent = 'PON ' + i;

                        if (i == selectedPort) {
                            option.selected = true;
                        }

                        ponPortSelect.appendChild(option);
                    }
                }
            }
        }


        function saveEditOlt() {
            var form = document.getElementById('editOltForm');
            var formData = new FormData(form);

            // ✅ KIRIM semua data connection, bukan cuma 1 type
            var selectedTab = document.querySelector('input[name="connection_type"]:checked').value;
            formData.append('selected_tab', selectedTab); // Tab yang sedang aktif

            // ✅ Selalu kirim router data (jika ada)
            var routerId = document.getElementById('edit-connected-router').value;
            var routerPort = document.getElementById('edit-router-uplink-port').value;
            if (routerId && routerPort) {
                formData.append('router_id', routerId);
                formData.append('router_uplink_port', routerPort);
            }

            // ✅ Selalu kirim PON data (jika ada)
            var childOdc = document.getElementById('edit-child-odc').value;
            var ponPort = document.getElementById('edit-olt-pon-port').value;
            if (childOdc && ponPort) {
                formData.append('child_odc_id', childOdc);
                formData.append('pon_port_number', ponPort);
            }

            // ✅ Selalu kirim OLT data (jika ada)
            var parentOlt = document.getElementById('edit-parent-olt').value;
            var myUplinkPort = document.getElementById('edit-my-uplink-port').value;
            var parentUplinkPort = document.getElementById('edit-parent-uplink-port').value;
            if (parentOlt) {
                formData.append('parent_olt_id', parentOlt);
                formData.append('my_uplink_port', myUplinkPort);
                formData.append('uplink_port_number', parentUplinkPort);
            }

            // ✅ Add connection type specific data
            var connectionType = document.querySelector('input[name="connection_type"]:checked').value;
            formData.append('connection_type', connectionType);

            // ✅ Add PON connection data if PON tab is selected
            if (connectionType === 'pon') {
                var childOdc = document.getElementById('edit-child-odc').value;
                var ponPort = document.getElementById('edit-olt-pon-port').value;

                if (childOdc && ponPort) {
                    formData.append('child_odc_id', childOdc);
                    formData.append('pon_port_number', ponPort);
                }
            }

            // Show loading
            Swal.fire({
                title: 'Saving Changes...',
                text: 'Updating OLT and recalculating port status...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            fetch(baseUrl + 'plugin/network_mapping/update-olt', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        $('#editOltModal').modal('hide');

                        Swal.fire({
                            icon: 'success',
                            title: 'OLT Updated!',
                            html: '<p>' + data.message + '</p>' +
                                '<p><i class="fa fa-refresh"></i> Port status updated. Map will reload...</p>',
                            timer: 2500,
                            showConfirmButton: false
                        }).then(() => {
                            // ✅ Reload to show updated status
                            window.location.reload();
                        });
                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error saving OLT:', error);
                    Swal.fire('Error', 'Failed to save OLT changes', 'error');
                });
        }
        // ✅ TAMBAH FUNCTION INI
        function showConnectionSection(type) {
            // Hide all sections
            document.getElementById('edit-router-connection').style.display = 'none';
            document.getElementById('edit-olt-connection').style.display = 'none';
            document.getElementById('edit-pon-connection').style.display = 'none';

            // Show selected section
            if (type === 'router') {
                document.getElementById('edit-router-connection').style.display = 'block';

            } else if (type === 'olt') {
                document.getElementById('edit-olt-connection').style.display = 'block';

                // Check if other OLTs are available
                var oltSelect = document.getElementById('edit-parent-olt');
                if (oltSelect.options.length <= 1) {
                    alert('No other OLTs available for connection');
                    document.getElementById('edit-conn-router').checked = true;
                    showConnectionSection('router');
                    return;
                }
            } else if (type === 'pon') {
                document.getElementById('edit-pon-connection').style.display = 'block';

                // Check if ODCs are connected
                var odcSelect = document.getElementById('edit-child-odc');
                if (odcSelect.options.length <= 1) {
                    alert('No ODCs connected to this OLT');
                    document.getElementById('edit-conn-router').checked = true;
                    showConnectionSection('router');
                    return;
                }
            }
        }
    {/literal}
</script>


<!-- Quick Add ODC Modal -->
<div class="modal fade" id="quickAddOdcModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="quickAddOdcForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title form-label-adaptive">
                        <i class="fa fa-cube text-success"></i> Quick Add ODC
                    </h4>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="odc-coordinates" name="coordinates">

                    <div class="form-section">
                        <label for="odc-name" class="form-label-adaptive">
                            <i class="fa fa-tag text-primary"></i> ODC Name *
                        </label>
                        <input type="text" class="form-control" id="odc-name" name="name" required
                            placeholder="e.g., ODC-001, ODC-Downtown">
                    </div>

                    <div class="form-section">
                        <label for="odc-description" class="form-label-adaptive">
                            <i class="fa fa-info-circle text-info"></i> Description
                        </label>
                        <textarea class="form-control" id="odc-description" name="description"
                            placeholder="Brief description of this ODC"></textarea>
                    </div>

                    <div class="form-section">
                        <label for="odc-olt" class="form-label-adaptive">
                            <i class="fa-solid fa-broadcast-tower text-danger"></i> Connected OLT
                        </label>
                        <select class="form-control" id="odc-olt" name="olt_id">
                            <option value="">Select OLT (Optional)</option>
                        </select>
                        <small class="help-block">Which OLT feeds this ODC via PON</small>
                    </div>
                    <div class="form-section">
                        <label for="odc-parent" class="form-label-adaptive">
                            <i class="fa fa-cube text-success"></i> Or Connect to ODC
                        </label>
                        <select class="form-control" id="odc-parent" name="parent_odc_id">
                            <option value="">Select Parent ODC (Optional)</option>
                        </select>
                        <small class="help-block">Choose Router OR ODC connection</small>
                    </div>

                    <div class="form-section" id="olt-pon-port-section" style="display: none;">
                        <label for="odc-pon-port" class="form-label-adaptive">
                            <i class="fa fa-sitemap text-success"></i> Select PON Port on OLT
                        </label>
                        <select class="form-control" id="odc-pon-port" name="pon_port_number" disabled>
                            <option value="">Auto PON port</option>
                        </select>
                        <small class="help-block">
                            <i class="fa fa-magic text-success"></i> <strong>Auto-select:</strong> Leave blank to
                            automatically choose the smallest available PON port<br>
                            <i class="fa fa-hand-pointer-o text-info"></i> Or choose a specific PON port manually
                        </small>
                        <div id="olt-pon-port-status-info" style="margin-top: 8px; font-size: 12px;"></div>
                    </div>

                    <div class="form-section" id="port-selection-section" style="display: none;">
                        <label for="odc-parent-port" class="form-label-adaptive">
                            <i class="fa fa-plug text-warning"></i> Select Port on Parent ODC
                        </label>
                        <select class="form-control" id="odc-parent-port" name="parent_port_number" disabled>
                            <option value="">Auto port</option>
                        </select>
                        <small class="help-block">
                            <i class="fa fa-magic text-success"></i> <strong>Auto-select:</strong> Leave blank to
                            automatically choose the smallest available port<br>
                            <i class="fa fa-hand-pointer-o text-info"></i> Or choose a specific port manually
                        </small>
                        <div id="port-status-info" style="margin-top: 8px; font-size: 12px;"></div>
                    </div>

                    <div class="form-section">
                        <label for="odc-address" class="form-label-adaptive">
                            <i class="fa fa-map-marker text-danger"></i> Physical Address
                        </label>
                        <textarea class="form-control" id="odc-address" name="address"
                            placeholder="Complete physical address"></textarea>
                    </div>

                    <div class="form-section">
                        <label for="odc-total-ports" class="form-label-adaptive">
                            <i class="fa fa-plug text-warning"></i> Total Ports
                        </label>
                        <select class="form-control" id="odc-total-ports" name="total_ports">
                            <option value="4">4 Ports</option>
                            <option value="8">8 Ports</option>
                            <option value="16" selected>16 Ports</option>
                            <option value="24">24 Ports</option>
                            <option value="32">32 Ports</option>
                            <option value="48">48 Ports</option>
                        </select>
                        <small class="help-block">Maximum number of ODPs that can connect</small>
                    </div>

                    <div class="form-section">
                        <label class="form-label-adaptive">
                            <i class="fa fa-crosshairs text-success"></i> Location
                        </label>
                        <div class="coords-display-box" id="odc-coords-display">
                            Waiting for coordinates...
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <i class="fa fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-success">
                        <i class="fa fa-save"></i> Save ODC
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>



<!-- Quick Add ODP Modal -->
<div class="modal fade" id="quickAddOdpModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="quickAddOdpForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title form-label-adaptive">
                        <i class="fa fa-circle-o"></i> Quick Add ODP
                    </h4>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="odp-coordinates" name="coordinates">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-section">
                                <label for="odp-name" class="form-label-adaptive">
                                    <i class="fa fa-circle text-primary"></i> ODP Name *
                                </label>
                                <input type="text" class="form-control" id="odp-name" name="name" required
                                    placeholder="e.g., ODP-001-A, ODP-Block-C">
                            </div>

                            <div class="form-section">
                                <label for="odp-description" class="form-label-adaptive">
                                    <i class="fa fa-info-circle text-info"></i> Description
                                </label>
                                <textarea class="form-control" id="odp-description" name="description"
                                    placeholder="Brief description"></textarea>
                            </div>

                            <div class="form-section">
                                <label for="odp-odc" class="form-label-adaptive">
                                    <i class="fa fa-cube text-success"></i> Connected ODC
                                </label>
                                <select class="form-control" id="odp-odc" name="odc_id">
                                    <option value="">Select ODC (Optional)</option>
                                </select>
                                <small class="help-block">Choose which ODC will feed this ODP</small>
                            </div>

                            <div class="form-section" id="odp-port-selection-section" style="display: none;">
                                <label for="odp-port-number" class="form-label-adaptive">
                                    <i class="fa fa-plug text-warning"></i> Select Port on ODC
                                </label>
                                <select class="form-control" id="odp-port-number" name="port_number" disabled>
                                    <option value="">Auto port</option>
                                </select>
                                <small class="help-block">
                                    <i class="fa fa-magic text-success"></i> <strong>Auto-select:</strong> Leave blank
                                    to automatically choose the smallest available port<br>
                                    <i class="fa fa-hand-pointer-o text-info"></i> Or choose a specific port manually
                                </small>
                                <div id="odp-port-status-info" style="margin-top: 8px; font-size: 12px;"></div>
                            </div>

                            <div class="form-section">
                                <label for="odp-address" class="form-label-adaptive">
                                    <i class="fa fa-map-marker text-danger"></i> Address
                                </label>
                                <textarea class="form-control" id="odp-address" name="address"
                                    placeholder="Physical address"></textarea>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-section">
                                <label for="odp-total-ports" class="form-label-adaptive">
                                    <i class="fa fa-plug text-warning"></i> Total Ports
                                </label>
                                <select class="form-control" id="odp-total-ports" name="total_ports">
                                    <option value="4">4 Ports</option>
                                    <option value="8" selected>8 Ports</option>
                                    <option value="16">16 Ports</option>
                                    <option value="24">24 Ports</option>
                                    <option value="32">32 Ports</option>
                                </select>
                            </div>

                            <div class="form-section">
                                <label class="form-label-adaptive">
                                    <i class="fa fa-crosshairs text-success"></i> Coordinates
                                </label>
                                <div class="coords-display-box" id="odp-coords-display">
                                    Waiting for coordinates...
                                </div>
                            </div>

                            <div class="form-section">
                                <label class="form-label-adaptive">
                                    <i class="fa fa-users text-info"></i> Connect Customers with Port Assignment
                                    <span class="badge pull-right" id="quick-selected-count">0/8</span>
                                </label>

                                <div class="ports-info">
                                    <strong>Available Ports:</strong> <span id="quick-available-ports">8</span>
                                    <br><small>Select customers and assign them to specific ports</small>
                                </div>

                                <input type="text" id="quick-customer-search" class="form-control customer-search"
                                    placeholder="Search customers...">

                                <div class="customer-selection-with-ports" id="quick-customer-list">
                                    <div class="text-center text-muted" style="padding: 20px;">
                                        <i class="fa fa-spinner fa-spin"></i> Loading customers...
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fa fa-save"></i> Save ODP
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>



<!-- Disconnect ODC Modal -->
<div class="modal fade" id="disconnectOdcModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <i class="fa fa-unlink text-warning"></i> Disconnect from ODC: <span
                        id="disconnect-odc-name"></span>
                </h4>
            </div>

            <div class="modal-body">
                <!-- Statistics Panel -->
                <div class="disconnect-stats-panel">
                    <div class="disconnect-stat-item">
                        <span class="disconnect-stat-number" id="odc-total-connections">0</span>
                        <span class="disconnect-stat-label">Total Connected</span>
                    </div>
                    <div class="disconnect-stat-item">
                        <span class="disconnect-stat-number" id="odc-selected-count">0</span>
                        <span class="disconnect-stat-label">Selected</span>
                    </div>
                    <div class="disconnect-stat-item">
                        <span class="disconnect-stat-number" id="odc-disconnect-count">0</span>
                        <span class="disconnect-stat-label">To Disconnect</span>
                    </div>
                </div>

                <!-- Search -->
                <div class="form-group">
                    <label for="odc-disconnect-search">
                        <i class="fa fa-search text-primary"></i> Search Connections
                    </label>
                    <input type="text" id="odc-disconnect-search" class="form-control"
                        placeholder="Search ODPs or child ODCs...">
                </div>

                <!-- Connections List -->
                <div class="connections-list">
                    <div class="connections-header">
                        <div class="connections-header-title">
                            <i class="fa fa-list"></i> Connected Devices
                        </div>
                        <button type="button" class="btn btn-default btn-xs select-all-btn" id="odc-select-all">
                            <i class="fa fa-check-square-o"></i> Select All
                        </button>
                    </div>
                    <div class="connections-content">
                        <div id="odc-connections-list">
                            <div class="text-center text-muted" style="padding: 40px;">
                                <i class="fa fa-spinner fa-spin"></i> Loading connections...
                            </div>
                        </div>
                        <div id="odc-load-more-container" class="load-more-container" style="display: none;">
                            <button type="button" class="btn btn-default btn-sm load-more-btn" id="odc-load-more">
                                <i class="fa fa-plus"></i> Load More (<span id="odc-remaining">0</span> remaining)
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-warning" id="odc-disconnect-selected" disabled>
                    <i class="fa fa-unlink"></i> Disconnect Selected (<span id="odc-disconnect-count-btn">0</span>)
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Disconnect ODP Modal -->
<div class="modal fade" id="disconnectOdpModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <i class="fa fa-unlink text-warning"></i> Disconnect from ODP: <span
                        id="disconnect-odp-name"></span>
                </h4>
            </div>

            <div class="modal-body">
                <!-- Statistics Panel -->
                <div class="disconnect-stats-panel">
                    <div class="disconnect-stat-item">
                        <span class="disconnect-stat-number" id="odp-total-connections">0</span>
                        <span class="disconnect-stat-label">Connected Customers</span>
                    </div>
                    <div class="disconnect-stat-item">
                        <span class="disconnect-stat-number" id="odp-selected-count">0</span>
                        <span class="disconnect-stat-label">Selected</span>
                    </div>
                    <div class="disconnect-stat-item">
                        <span class="disconnect-stat-number" id="odp-disconnect-count">0</span>
                        <span class="disconnect-stat-label">To Disconnect</span>
                    </div>
                </div>

                <!-- Search -->
                <div class="form-group">
                    <label for="odp-disconnect-search">
                        <i class="fa fa-search text-primary"></i> Search Customers
                    </label>
                    <input type="text" id="odp-disconnect-search" class="form-control"
                        placeholder="Search customers by name or username...">
                </div>

                <!-- Connections List -->
                <div class="connections-list">
                    <div class="connections-header">
                        <div class="connections-header-title">
                            <i class="fa fa-users"></i> Connected Customers
                        </div>
                        <button type="button" class="btn btn-default btn-xs select-all-btn" id="odp-select-all">
                            <i class="fa fa-check-square-o"></i> Select All
                        </button>
                    </div>
                    <div class="connections-content">
                        <div id="odp-connections-list">
                            <div class="text-center text-muted" style="padding: 40px;">
                                <i class="fa fa-spinner fa-spin"></i> Loading customers...
                            </div>
                        </div>
                        <div id="odp-load-more-container" class="load-more-container" style="display: none;">
                            <button type="button" class="btn btn-default btn-sm load-more-btn" id="odp-load-more">
                                <i class="fa fa-plus"></i> Load More (<span id="odp-remaining">0</span> remaining)
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-warning" id="odp-disconnect-selected" disabled>
                    <i class="fa fa-unlink"></i> Disconnect Selected (<span id="odp-disconnect-count-btn">0</span>)
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Quick Add Pole Modal -->
<div class="modal fade" id="quickAddPoleModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="quickAddPoleForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title form-label-adaptive">
                        <i class="fa fa-map-pin text-secondary"></i> Quick Add Tiang
                    </h4>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="pole-coordinates" name="coordinates">

                    <div class="form-section">
                        <label for="pole-name" class="form-label-adaptive">
                            <i class="fa fa-tag text-primary"></i> Identitas Tiang *
                        </label>
                        <input type="text" class="form-control" id="pole-name" name="name" required
                            placeholder="e.g., POLE-001, Tiang-Utama-A">
                    </div>

                    <div class="form-section">
                        <label for="pole-description" class="form-label-adaptive">
                            <i class="fa fa-info-circle text-info"></i> Deskripsi
                        </label>
                        <textarea class="form-control" id="pole-description" name="description"
                            placeholder="Brief description of this pole"></textarea>
                    </div>

                    <div class="form-section">
                        <label for="pole-address" class="form-label-adaptive">
                            <i class="fa fa-map-marker text-danger"></i> Alamat
                        </label>
                        <textarea class="form-control" id="pole-address" name="address"
                            placeholder="Complete physical address"></textarea>
                    </div>

                    <div class="form-section">
                        <label class="form-label-adaptive">
                            <i class="fa fa-crosshairs text-success"></i> Lokasi
                        </label>
                        <div class="coords-display-box" id="pole-coords-display">
                            Menunggu Koordinat...
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <i class="fa fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-secondary">
                        <i class="fa fa-save"></i> Save Pole
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>




<!-- Edit Pole Bridges Modal -->
<div class="modal fade" id="editPoleBridgesModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <i class="fa fa-edit text-warning"></i> Edit Bridges: <span id="edit-pole-name"></span>
                </h4>
            </div>

            <div class="modal-body">
                <!-- Statistics Panel -->
                <div class="edit-bridge-stats-panel">
                    <div class="edit-bridge-stat-item">
                        <span class="edit-bridge-stat-number" id="edit-total-bridges">0</span>
                        <span class="edit-bridge-stat-label">Total Bridges</span>
                    </div>
                    <div class="edit-bridge-stat-item">
                        <span class="edit-bridge-stat-number" id="edit-active-bridges">0</span>
                        <span class="edit-bridge-stat-label">Active</span>
                    </div>
                    <div class="edit-bridge-stat-item">
                        <span class="edit-bridge-stat-number" id="edit-inactive-bridges">0</span>
                        <span class="edit-bridge-stat-label">Inactive</span>
                    </div>
                    <div class="edit-bridge-stat-item">
                        <span class="edit-bridge-stat-number" id="edit-selected-bridges">0</span>
                        <span class="edit-bridge-stat-label">Selected</span>
                    </div>
                </div>

                <!-- Info Panel -->
                <div class="alert alert-info" style="margin-bottom: 15px; padding: 10px; font-size: 12px;">
                    <i class="fa fa-info-circle"></i> <strong>Bridge Management:</strong>
                    <ul style="margin: 5px 0 0 0; padding-left: 20px;">
                        <li><strong>Hide:</strong> Bridge becomes inactive but cable route remains (can be restored)
                        </li>
                        <li><strong>Delete:</strong> Permanently removes bridge and cable route from all poles</li>
                    </ul>
                </div>

                <!-- Bulk Actions Panel -->
                <div class="bulk-actions-panel" id="bulk-actions-panel" style="display: none;">
                    <div class="bulk-actions-header">
                        <div class="bulk-actions-title">
                            <i class="fa fa-check-square text-primary"></i> Bulk Actions
                            <span class="bulk-selected-count" id="bulk-selected-count">0 selected</span>
                        </div>
                        <div class="bulk-actions-buttons">
                            <button type="button" class="btn btn-success btn-xs" id="bulk-show-bridges" disabled>
                                <i class="fa fa-eye"></i> Show Selected
                            </button>
                            <button type="button" class="btn btn-warning btn-xs" id="bulk-hide-bridges" disabled>
                                <i class="fa fa-eye-slash"></i> Hide Selected
                            </button>
                            <button type="button" class="btn btn-danger btn-xs" id="bulk-delete-bridges" disabled>
                                <i class="fa fa-trash"></i> Delete Selected
                            </button>
                            <button type="button" class="btn btn-default btn-xs" id="bulk-clear-selection">
                                <i class="fa fa-times"></i> Clear
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Bridges List -->
                <div class="bridges-edit-list">
                    <div class="bridges-list-header">
                        <div class="bridges-list-title">
                            <i class="fa fa-list"></i> Bridge Connections
                        </div>
                        <div class="bridges-list-controls">
                            <button type="button" class="btn btn-default btn-xs" id="select-all-bridges">
                                <i class="fa fa-check-square-o"></i> Select All
                            </button>
                        </div>
                    </div>
                    <div id="edit-pole-bridges-list">
                        <div class="text-center text-muted" style="padding: 40px;">
                            <i class="fa fa-spinner fa-spin"></i> Loading bridges...
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <div class="footer-left">
                    <small class="text-muted">
                        <i class="fa fa-info-circle"></i> Select multiple bridges for bulk operations
                    </small>
                </div>
                <div class="footer-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <i class="fa fa-times"></i> Close
                    </button>
                    <button type="button" class="btn btn-info"
                        onclick="loadPoleBridgesForEdit(currentEditPoleData.pole_id)">
                        <i class="fa fa-refresh"></i> Refresh
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Quick Add OLT Modal -->
<div class="modal fade" id="quickAddOltModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="quickAddOltForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title form-label-adaptive">
                        <i class="fa-solid fa-broadcast-tower text-danger"></i> Quick Add OLT
                    </h4>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="olt-coordinates" name="coordinates">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-section">
                                <label for="olt-name" class="form-label-adaptive">
                                    <i class="fa fa-tag text-primary"></i> OLT Name *
                                </label>
                                <input type="text" class="form-control" id="olt-name" name="name" required
                                    placeholder="e.g., OLT-001, OLT-Central">
                            </div>

                            <div class="form-section">
                                <label for="olt-description" class="form-label-adaptive">
                                    <i class="fa fa-info-circle text-info"></i> Description
                                </label>
                                <textarea class="form-control" id="olt-description" name="description"
                                    placeholder="Brief description of this OLT"></textarea>
                            </div>

                            <div class="form-section">
                                <label for="olt-router" class="form-label-adaptive">
                                    <i class="fa fa-server text-primary"></i> Connected Router
                                </label>
                                <select class="form-control" id="olt-router" name="router_id">
                                    <option value="">Select Router (Optional)</option>
                                </select>
                                <small class="help-block">Which router feeds this OLT</small>
                            </div>

                            <div class="form-section" id="router-port-section" style="display: none;">
                                <label class="form-label-adaptive">
                                    <i class="fa fa-plug text-primary"></i> Router Connection Port
                                </label>

                                <div class="row">
                                    <div class="col-md-6">
                                        <label for="olt-router-uplink-count">Total Uplink Ports</label>
                                        <select class="form-control" id="olt-router-uplink-count">
                                            <option value="2">2 Ports</option>
                                            <option value="4" selected>4 Ports</option>
                                            <option value="8">8 Ports</option>
                                            <option value="16">16 Ports</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="olt-router-port">Router Connection Port</label>
                                        <select class="form-control" id="olt-router-port" name="router_uplink_port">
                                            <option value="1" selected>Port 1</option>
                                            <option value="2">Port 2</option>
                                            <option value="3">Port 3</option>
                                            <option value="4">Port 4</option>
                                        </select>
                                    </div>
                                </div>

                                <small class="help-block">
                                    <i class="fa fa-info-circle text-info"></i> Select which uplink port will be used
                                    for router connection
                                </small>
                            </div>

                            <div class="form-section">
                                <label for="olt-parent" class="form-label-adaptive">
                                    <i class="fa-solid fa-broadcast-tower text-danger"></i> Or Connect to OLT
                                </label>
                                <select class="form-control" id="olt-parent" name="parent_olt_id">
                                    <option value="">Select Parent OLT (Optional)</option>
                                </select>
                                <small class="help-block">Choose Router OR OLT connection</small>
                            </div>

                            <div class="form-section" id="olt-uplink-port-section" style="display: none;">
                                <label class="form-label-adaptive">
                                    <i class="fa fa-plug text-warning"></i> OLT to OLT Connection Configuration
                                </label>

                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="olt-uplink-ports-count">Uplink Ports</label>
                                        <select class="form-control" id="olt-uplink-ports-count">
                                            <option value="2">2 Ports</option>
                                            <option value="4" selected>4 Ports</option>
                                            <option value="8">8 Ports</option>
                                            <option value="16">16 Ports</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="olt-my-uplink-port">OLT Uses Port</label>
                                        <select class="form-control" id="olt-my-uplink-port" name="my_uplink_port">
                                            <option value="1">Port 1</option>
                                            <option value="2" selected>Port 2</option>
                                            <option value="3">Port 3</option>
                                            <option value="4">Port 4</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="olt-parent-pon-port">Parent PON Port</label>
                                        <select class="form-control" id="olt-parent-pon-port" name="uplink_port_number"
                                            disabled>
                                            <option value="">Select parent OLT first</option>
                                        </select>
                                    </div>
                                </div>

                                <small class="help-block">
                                    <i class="fa fa-info-circle text-info"></i> <strong>Configuration:</strong><br>
                                    • <strong>This OLT Total Uplink Ports:</strong> How many uplink ports this new OLT
                                    will have<br>
                                    • <strong>This OLT Uses Port:</strong> Which port on this new OLT will connect to
                                    parent<br>
                                    • <strong>Parent PON Port:</strong> Which PON port on parent OLT to connect to
                                </small>
                                <div id="olt-uplink-port-status-info" style="margin-top: 8px; font-size: 12px;"></div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-section">
                                <label for="olt-address" class="form-label-adaptive">
                                    <i class="fa fa-map-marker text-danger"></i> Physical Address
                                </label>
                                <textarea class="form-control" id="olt-address" name="address"
                                    placeholder="Complete physical address"></textarea>
                            </div>

                            <div class="form-section">
                                <label for="olt-total-pon-ports" class="form-label-adaptive">
                                    <i class="fa fa-sitemap text-success"></i> Total PON Ports
                                </label>
                                <select class="form-control" id="olt-total-pon-ports" name="total_pon_ports">
                                    <option value="4" selected>4 PON</option>
                                    <option value="8">8 PON</option>
                                    <option value="16">16 PON</option>
                                    <option value="24">24 PON</option>
                                    <option value="32">32 PON</option>
                                </select>
                                <small class="help-block">Maximum number of ODCs that can connect</small>
                            </div>

                            <div class="form-section">
                                <label class="form-label-adaptive">
                                    <i class="fa fa-crosshairs text-success"></i> Location
                                </label>
                                <div class="coords-display-box" id="olt-coords-display">
                                    Waiting for coordinates...
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <i class="fa fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fa fa-save"></i> Save OLT
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit OLT Modal -->
<div class="modal fade" id="editOltModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <i class="fa-solid fa-broadcast-tower text-danger"></i> Edit OLT: <span id="edit-olt-name"></span>
                </h4>
            </div>

            <div class="modal-body">
                <form id="editOltForm">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="edit-olt-id" name="id">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="edit-olt-name-input">
                                    <i class="fa fa-tag text-primary"></i> OLT Name *
                                </label>
                                <input type="text" class="form-control" id="edit-olt-name-input" name="name" required>
                            </div>

                            <div class="form-group">
                                <label for="edit-olt-description">
                                    <i class="fa fa-info-circle text-info"></i> Description
                                </label>
                                <textarea class="form-control" id="edit-olt-description" name="description"></textarea>
                            </div>

                            <div class="form-group">
                                <label for="edit-olt-address">
                                    <i class="fa fa-map-marker text-danger"></i> Address
                                </label>
                                <textarea class="form-control" id="edit-olt-address" name="address"></textarea>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="edit-olt-uplink-ports">
                                    <i class="fa fa-plug text-warning"></i> Total Uplink Ports
                                </label>
                                <select class="form-control" id="edit-olt-uplink-ports" name="total_uplink_ports">
                                    <option value="2">2 Ports</option>
                                    <option value="4">4 Ports</option>
                                    <option value="8">8 Ports</option>
                                    <option value="16">16 Ports</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="edit-olt-pon-ports">
                                    <i class="fa fa-sitemap text-success"></i> Total PON Ports
                                </label>
                                <select class="form-control" id="edit-olt-pon-ports" name="total_pon_ports">
                                    <option value="4">4 PON</option>
                                    <option value="8">8 PON</option>
                                    <option value="16">16 PON</option>
                                    <option value="24">24 PON</option>
                                    <option value="32">32 PON</option>
                                </select>
                            </div>

                            <!-- Connection Settings -->
                            <div class="form-group">
                                <label>
                                    <i class="fa fa-link text-info"></i> Connection Type
                                </label>
                                <div class="connection-tabs">
                                    <input type="radio" name="connection_type" value="router" id="edit-conn-router">
                                    <label for="edit-conn-router" class="connection-tab">ROUTER</label>

                                    <input type="radio" name="connection_type" value="olt" id="edit-conn-olt">
                                    <label for="edit-conn-olt" class="connection-tab">OLT</label>

                                    <input type="radio" name="connection_type" value="pon" id="edit-conn-pon">
                                    <label for="edit-conn-pon" class="connection-tab">PON</label>
                                </div>
                            </div>

                            <!-- Router Connection Section -->
                            <div id="edit-router-connection" class="connection-section" style="display: none;">
                                <div class="form-group">
                                    <label for="edit-connected-router">
                                        <i class="fa fa-router text-primary"></i> Select Router
                                    </label>
                                    <select class="form-control" id="edit-connected-router" name="router_id">
                                        <option value="">Select router to modify</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="edit-router-uplink-port">
                                        <i class="fa fa-plug text-warning"></i> OLT Uplink Port
                                    </label>
                                    <select class="form-control" id="edit-router-uplink-port" name="my_uplink_port"
                                        disabled>
                                        <option value="">Select router first</option>
                                    </select>
                                </div>
                            </div>

                            <!-- OLT Connection Section -->
                            <div id="edit-olt-connection" class="connection-section" style="display: none;">
                                <div class="form-group">
                                    <label for="edit-parent-olt">
                                        <i class="fa-solid fa-broadcast-tower text-danger"></i> Parent OLT
                                    </label>
                                    <select class="form-control" id="edit-parent-olt" name="parent_olt_id">
                                        <option value="">No other OLTs available</option>
                                    </select>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <label for="edit-my-uplink-port">
                                            <i class="fa fa-plug text-info"></i> My Uplink Port
                                        </label>
                                        <select class="form-control" id="edit-my-uplink-port" name="my_uplink_port">
                                            <!-- Will be populated based on available ports -->
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="edit-parent-uplink-port">
                                            <i class="fa fa-plug text-success"></i> Parent Uplink Port
                                        </label>
                                        <select class="form-control" id="edit-parent-uplink-port"
                                            name="uplink_port_number">
                                            <option value="">Select Parent OLT first</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- PON Connection Section -->
                            <div id="edit-pon-connection" class="connection-section" style="display: none;">
                                <div class="form-group">
                                    <label for="edit-child-odc">
                                        <i class="fa fa-cube text-success"></i> Child ODC
                                    </label>
                                    <select class="form-control" id="edit-child-odc" name="child_odc_id">
                                        <option value="">No ODCs connected</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="edit-olt-pon-port">
                                        <i class="fa fa-sitemap text-warning"></i> OLT PON Port
                                    </label>
                                    <select class="form-control" id="edit-olt-pon-port" name="pon_port_number" disabled>
                                        <option value="">Select Child ODC first</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-success" onclick="saveEditOlt()">
                    <i class="fa fa-save"></i> Save Changes
                </button>
            </div>
        </div>
    </div>
</div>

{include file="sections/footer.tpl"}