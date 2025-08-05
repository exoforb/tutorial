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
<link rel="stylesheet" href="/system/plugin/ui/css/modal-odc.css?v={$smarty.now}" />
<link rel="stylesheet" href="/system/plugin/ui/css/modal-odp.css?v={$smarty.now}" />

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                <i class="ion ion-ios-location"></i> Mapping Jaringan FFTH
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
                                                    <div class="legend-line legend-backbone"></div>
                                                    <span><strong>Mikrotik ↔ Mikrotik</strong> - Kabel Backbone (Fiber
                                                        Optic)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line legend-primary"></div>
                                                    <span><strong>Mikrotik → ODC</strong> - Kabel Feeder (Fiber
                                                        Optic)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line legend-distribution"></div>
                                                    <span><strong>ODC → ODP</strong> - Kabel Distribusi
                                                        (Fiber/Copper)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line legend-access"></div>
                                                    <span><strong>ODP → Customer</strong> - Kabel Drop Core
                                                        (Copper/Fiber)</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-line" style="background: #ffaa00;"></div>
                                                    <span><strong>ODC ↔ ODC</strong> - Kabel RIng (Dashed)</span>
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
                                                        style="background-color: #ff0000; width: 0%"></div>
                                                    <div id="primary-progress" class="progress-bar"
                                                        style="background-color: #ff6600; width: 0%"></div>
                                                    <div id="distribution-progress" class="progress-bar"
                                                        style="background-color: #00aa00; width: 0%"></div>
                                                    <div id="access-progress" class="progress-bar"
                                                        style="background-color: #0066ff; width: 0%"></div>
                                                </div>
                                                <div class="text-center">
                                                    <small>
                                                        <span style="color: #ff0000;">■</span> Backbone: <span
                                                            id="backbone-length">0m</span> |
                                                        <span style="color: #ff6600;">■</span> Primary: <span
                                                            id="primary-length">0m</span> |
                                                        <span style="color: #00aa00;">■</span> Distribution: <span
                                                            id="distribution-length">0m</span> |
                                                        <span style="color: #0066ff;">■</span> Access: <span
                                                            id="access-length">0m</span>
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
                                    <button type="button" id="view-odcs"
                                        class="nav-btn nav-btn-success nav-btn-with-text" title="View All ODCs">
                                        <i class="fa-solid fa-tower-cell"></i>
                                        <span>ODCs</span>
                                    </button>
                                    <button type="button" id="view-odps"
                                        class="nav-btn nav-btn-warning nav-btn-with-text" title="View All ODPs">
                                        <i class="fa-solid fa-circle-nodes"></i>
                                        <span>ODPs</span>
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
                                        <input type="checkbox" id="show-odcs" checked>
                                        <i class="fa-solid fa-tower-cell text-success"></i> ODCs
                                    </label>
                                    <label class="nav-checkbox">
                                        <input type="checkbox" id="show-odps" checked>
                                        <i class="fa-solid fa-circle-nodes text-warning"></i> ODPs
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

<!-- Quick Add ODC Modal -->
<div class="modal fade" id="quickAddOdcModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="quickAddOdcForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title form-label-adaptive">
                        <i class="fa-solid fa-tower-cell text-success"></i> Quick Add ODC
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
                        <label for="odc-router" class="form-label-adaptive">
                            <i class="fa fa-server text-primary"></i> Connected Router
                        </label>
                        <select class="form-control" id="odc-router" name="router_id">
                            <option value="">Select Router (Optional)</option>
                        </select>
                        <small class="help-block">Which router feeds this ODC</small>
                    </div>
                    <div class="form-section">
                        <label for="odc-parent" class="form-label-adaptive">
                            <i class="fa-solid fa-tower-cell text-success"></i> Or Connect to ODC
                        </label>
                        <select class="form-control" id="odc-parent" name="parent_odc_id">
                            <option value="">Select Parent ODC (Optional)</option>
                        </select>
                        <small class="help-block">Choose Router OR ODC connection</small>
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
                        <i class="fa-solid fa-circle-nodes"></i> Quick Add ODP
                    </h4>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="odp-coordinates" name="coordinates">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-section">
                                <label for="odp-name" class="form-label-adaptive">
                                    <i class="fa-solid fa-circle-nodes text-primary"></i> ODP Name *
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
                                    <i class="fa-solid fa-tower-cell text-success"></i> Connected ODC
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
<!-- Edit ODC Modal -->
<div class="modal fade" id="editOdcModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="editOdcForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title form-label-adaptive">
                        <i class="fa fa-edit text-warning"></i> Edit ODC: <span id="edit-odc-title">Loading...</span>
                    </h4>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="edit-odc-id" name="id">

                    <div class="form-section">
                        <label for="edit-odc-name" class="form-label-adaptive">
                            <i class="fa fa-tag text-primary"></i> ODC Name *
                        </label>
                        <input type="text" class="form-control" id="edit-odc-name" name="name" required>
                    </div>

                    <div class="form-section">
                        <label for="edit-odc-description" class="form-label-adaptive">
                            <i class="fa fa-info-circle text-info"></i> Description
                        </label>
                        <textarea class="form-control" id="edit-odc-description" name="description"></textarea>
                    </div>

                    <div class="form-section">
                        <label for="edit-odc-router" class="form-label-adaptive">
                            <i class="fa fa-server text-primary"></i> Connected Router
                        </label>
                        <select class="form-control" id="edit-odc-router" name="router_id">
                            <option value="">Select Router (Optional)</option>
                        </select>
                    </div>

                    <div class="form-section">
                        <label for="edit-odc-parent" class="form-label-adaptive">
                            <i class="fa-solid fa-tower-cell text-success"></i> Or Connect to ODC
                        </label>
                        <select class="form-control" id="edit-odc-parent" name="parent_odc_id">
                            <option value="">Select Parent ODC (Optional)</option>
                        </select>
                        <small class="help-block">Choose Router OR ODC connection</small>
                    </div>

                    <div class="form-section" id="edit-port-selection-section" style="display: none;">
                        <label for="edit-odc-parent-port" class="form-label-adaptive">
                            <i class="fa fa-plug text-warning"></i> Select Port on Parent ODC
                        </label>
                        <select class="form-control" id="edit-odc-parent-port" name="parent_port_number" disabled>
                            <option value="">Auto port</option>
                        </select>
                        <div id="edit-port-status-info" style="margin-top: 8px; font-size: 12px;"></div>
                    </div>

                    <div class="form-section">
                        <label for="edit-odc-coordinates" class="form-label-adaptive">
                            <i class="fa fa-crosshairs text-success"></i> Coordinates
                        </label>
                        <input type="text" class="form-control" id="edit-odc-coordinates" name="coordinates" readonly>
                    </div>

                    <div class="form-section">
                        <label for="edit-odc-address" class="form-label-adaptive">
                            <i class="fa fa-map-marker text-danger"></i> Physical Address
                        </label>
                        <textarea class="form-control" id="edit-odc-address" name="address"></textarea>
                    </div>

                    <div class="form-section">
                        <label for="edit-odc-total-ports" class="form-label-adaptive">
                            <i class="fa fa-plug text-warning"></i> Total Ports
                        </label>
                        <select class="form-control" id="edit-odc-total-ports" name="total_ports">
                            <option value="4">4 Ports</option>
                            <option value="8">8 Ports</option>
                            <option value="16">16 Ports</option>
                            <option value="24">24 Ports</option>
                            <option value="32">32 Ports</option>
                            <option value="48">48 Ports</option>
                        </select>
                    </div>

                    <div class="form-section">
                        <label for="edit-odc-status" class="form-label-adaptive">
                            <i class="fa fa-toggle-on text-success"></i> Status
                        </label>
                        <select class="form-control" id="edit-odc-status" name="status">
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <i class="fa fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fa fa-save"></i> Update ODC
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Edit ODP Modal -->
<div class="modal fade" id="editOdpModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="editOdpForm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title form-label-adaptive">
                        <i class="fa fa-edit text-warning"></i> Edit ODP: <span id="edit-odp-title">Loading...</span>
                    </h4>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" id="edit-odp-id" name="id">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-section">
                                <label for="edit-odp-name" class="form-label-adaptive">
                                    <i class="fa-solid fa-circle-nodes text-primary"></i> ODP Name *
                                </label>
                                <input type="text" class="form-control" id="edit-odp-name" name="name" required>
                            </div>

                            <div class="form-section">
                                <label for="edit-odp-description" class="form-label-adaptive">
                                    <i class="fa fa-info-circle text-info"></i> Description
                                </label>
                                <textarea class="form-control" id="edit-odp-description" name="description"></textarea>
                            </div>

                            <div class="form-section">
                                <label for="edit-odp-odc" class="form-label-adaptive">
                                    <i class="fa-solid fa-tower-cell text-success"></i> Connected ODC
                                </label>
                                <select class="form-control" id="edit-odp-odc" name="odc_id">
                                    <option value="">Select ODC (Optional)</option>
                                </select>
                            </div>

                            <div class="form-section" id="edit-odp-port-selection-section" style="display: none;">
                                <label for="edit-odp-port-number" class="form-label-adaptive">
                                    <i class="fa fa-plug text-warning"></i> Select Port on ODC
                                </label>
                                <select class="form-control" id="edit-odp-port-number" name="port_number" disabled>
                                    <option value="">Auto port</option>
                                </select>
                                <div id="edit-odp-port-status-info" style="margin-top: 8px; font-size: 12px;"></div>
                            </div>

                            <div class="form-section">
                                <label for="edit-odp-coordinates" class="form-label-adaptive">
                                    <i class="fa fa-crosshairs text-success"></i> Coordinates
                                </label>
                                <input type="text" class="form-control" id="edit-odp-coordinates" name="coordinates"
                                    readonly>
                            </div>

                            <div class="form-section">
                                <label for="edit-odp-address" class="form-label-adaptive">
                                    <i class="fa fa-map-marker text-danger"></i> Address
                                </label>
                                <textarea class="form-control" id="edit-odp-address" name="address"></textarea>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-section">
                                <label for="edit-odp-total-ports" class="form-label-adaptive">
                                    <i class="fa fa-plug text-warning"></i> Total Ports
                                </label>
                                <select class="form-control" id="edit-odp-total-ports" name="total_ports">
                                    <option value="4">4 Ports</option>
                                    <option value="8">8 Ports</option>
                                    <option value="16">16 Ports</option>
                                    <option value="24">24 Ports</option>
                                    <option value="32">32 Ports</option>
                                </select>
                            </div>

                            <div class="form-section">
                                <label for="edit-odp-status" class="form-label-adaptive">
                                    <i class="fa fa-toggle-on text-success"></i> Status
                                </label>
                                <select class="form-control" id="edit-odp-status" name="status">
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>

                            <div class="form-section">
                                <label class="form-label-adaptive">
                                    <i class="fa fa-users text-info"></i> Connect Customers with Port Assignment
                                    <span class="badge pull-right" id="edit-selected-count">0/8</span>
                                </label>

                                <div class="ports-info">
                                    <strong>Available Ports:</strong> <span id="edit-available-ports">8</span>
                                    <br><small>Select customers and assign them to specific ports</small>
                                </div>

                                <input type="text" id="edit-customer-search" class="form-control customer-search"
                                    placeholder="Search customers...">

                                <div class="customer-selection-with-ports" id="edit-customer-list">
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
                        <i class="fa fa-save"></i> Update ODP
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- ODC List Modal -->
<div class="modal fade" id="odcListModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-xl" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <i class="fa-solid fa-tower-cell text-success"></i> ODC Management
                    <span class="badge" id="odc-total-count">0</span>
                </h4>
            </div>
            <div class="modal-body">
                <!-- Search -->
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-8">
                        <div class="input-group">
                            <div class="input-group-addon">
                                <span class="fa fa-search"></span>
                            </div>
                            <input type="text" id="odc-search-input" class="form-control"
                                placeholder="Search ODC name, description, or address...">
                            <div class="input-group-btn">
                                <button class="btn btn-default" type="button" id="odc-clear-search">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-success" onclick="addOdcFromList()">
                            <i class="fa fa-plus"></i> Add ODC
                        </button>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-green">
                            <div class="inner">
                                <h3 id="odc-active-count">0</h3>
                                <p>Active ODCs</p>
                            </div>
                            <div class="icon">
                                <i class="fa-solid fa-tower-cell"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-yellow">
                            <div class="inner">
                                <h3 id="odc-ports-used">0</h3>
                                <p>Total Ports Used</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-plug"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-blue">
                            <div class="inner">
                                <h3 id="odc-ports-available">0</h3>
                                <p>Total Ports Available</p>
                            </div>
                            <div class="icon">
                                <i class="fa-solid fa-circle-nodes"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-red">
                            <div class="inner">
                                <h3 id="odc-connections">0</h3>
                                <p>Total Connections</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-sitemap"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Table Container -->
                <div id="odc-table-container">
                    <div class="text-center" style="padding: 40px;">
                        <i class="fa fa-spinner fa-spin fa-2x"></i>
                        <p style="margin-top: 10px;">Loading ODCs...</p>
                    </div>
                </div>

                <!-- Load More -->
                <div id="odc-load-more-container" class="text-center" style="display: none; margin-top: 15px;">
                    <button type="button" class="btn btn-default" id="odc-load-more">
                        <i class="fa fa-plus"></i> Load More (<span id="odc-remaining">0</span> remaining)
                    </button>
                </div>
            </div>
            <div class="modal-footer">
                <div class="pull-left">
                    <small class="text-muted">
                        <i class="fa fa-info-circle"></i> Click on ODC names to view details or use action buttons
                    </small>
                </div>
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-times"></i> Close
                </button>
                <button type="button" class="btn btn-primary" onclick="refreshOdcList()">
                    <i class="fa fa-refresh"></i> Refresh
                </button>
            </div>
        </div>
    </div>
</div>
<!-- ODP List Modal -->
<div class="modal fade" id="odpListModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-xl" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <i class="fa-solid fa-circle-nodes text-warning"></i> ODP Management
                    <span class="badge" id="odp-total-count">0</span>
                </h4>
            </div>
            <div class="modal-body">
                <!-- Search -->
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-8">
                        <div class="input-group">
                            <div class="input-group-addon">
                                <span class="fa fa-search"></span>
                            </div>
                            <input type="text" id="odp-search-input" class="form-control"
                                placeholder="Search ODP name, description, or address...">
                            <div class="input-group-btn">
                                <button class="btn btn-default" type="button" id="odp-clear-search">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-warning" onclick="addOdpFromList()">
                            <i class="fa fa-plus"></i> Add ODP
                        </button>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-yellow">
                            <div class="inner">
                                <h3 id="odp-active-count">0</h3>
                                <p>Active ODPs</p>
                            </div>
                            <div class="icon">
                                <i class="fa-solid fa-circle-nodes"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-red">
                            <div class="inner">
                                <h3 id="odp-ports-used">0</h3>
                                <p>Total Ports Used</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-plug"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-green">
                            <div class="inner">
                                <h3 id="odp-ports-available">0</h3>
                                <p>Total Ports Available</p>
                            </div>
                            <div class="icon">
                                <i class="fa-solid fa-circle-nodes"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="small-box bg-blue">
                            <div class="inner">
                                <h3 id="odp-customers">0</h3>
                                <p>Total Customers</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Table Container -->
                <div id="odp-table-container">
                    <div class="text-center" style="padding: 40px;">
                        <i class="fa fa-spinner fa-spin fa-2x"></i>
                        <p style="margin-top: 10px;">Loading ODPs...</p>
                    </div>
                </div>

                <!-- Load More -->
                <div id="odp-load-more-container" class="text-center" style="display: none; margin-top: 15px;">
                    <button type="button" class="btn btn-default" id="odp-load-more">
                        <i class="fa fa-plus"></i> Load More (<span id="odp-remaining">0</span> remaining)
                    </button>
                </div>
            </div>
            <div class="modal-footer">
                <div class="pull-left">
                    <small class="text-muted">
                        <i class="fa fa-info-circle"></i> Click on ODP names to view details or use action buttons
                    </small>
                </div>
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-times"></i> Close
                </button>
                <button type="button" class="btn btn-primary" onclick="refreshOdpList()">
                    <i class="fa fa-refresh"></i> Refresh
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ODC List Modal -->
<div class="modal fade" id="odcListModal" tabindex="-1" role="dialog">

    <script src="/system/plugin/ui/js/network-mapping-search.js?v={$smarty.now}"></script>


    <script>
        // Set data from PHP
        var baseUrl = '{$_url}';
        console.log('Base URL is:', baseUrl);
        var networkData = {$network_data|json_encode};
        var cablesData = {if $cables_data}{$cables_data|json_encode}{else}[]{/if};
    </script>

    <!-- Load external JS -->
    <script src="/system/plugin/ui/js/network-mapping-core.js?v={$smarty.now}"></script>
    <script src="/system/plugin/ui/js/network-mapping-utils.js?v={$smarty.now}"></script>
    <script src="/system/plugin/ui/js/network-mapping-modals.js?v={$smarty.now}"></script>
    <script src="/system/plugin/ui/js/network-mapping-search.js?v={$smarty.now}"></script>



{include file="sections/footer.tpl"}