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
        cablesLayerGroup.eachLayer(function (layer) {
            if (layer instanceof L.Polyline && layer.cableId === id) {
                targetPolyline = layer;
            }
        });

        // Tampilkan popup kabel setelah animasi selesai
        if (targetPolyline) {
            setTimeout(function () {
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
                setTimeout(function () {
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

    var polesList = poles.map(function (pole) {
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
    setTimeout(function () {
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
    fromTypeFilter.addEventListener('change', function () {
        var selectedType = this.value;
        populateDeviceDropdown('pole-filter-from-device', selectedType);
        applyPoleFilters();
    });

    // To Type change - populate device list  
    toTypeFilter.addEventListener('change', function () {
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
        clearButton.addEventListener('click', function () {
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

    var filteredPoles = poles.filter(function (pole) {
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
        return bridgeData.some(function (bridge) {
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

    var polesList = filteredPoles.map(function (pole) {
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
        pole = networkData.poles.find(function (p) {
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
    setTimeout(function () {
        // Find and open popup if marker exists
        var markerKey = 'pole_' + poleId;
        if (allMarkers[markerKey] && allMarkers[markerKey].marker) {
            // Open popup after animation completes
            setTimeout(function () {
                allMarkers[markerKey].marker.openPopup();

                // Temporary highlight effect
                var markerElement = document.querySelector('[data-type="pole"][data-id="' + poleId +
                    '"]');
                if (markerElement) {
                    markerElement.style.animation = 'pulse 2s ease-in-out 3';
                    setTimeout(function () {
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

    var customersList = customers.map(function (customer) {
        // Connection info
        var connectionInfo = 'Not Connected';
        if (customer.odp_id && customer.port_number) {
            // Find ODP name
            var odpName = 'ODP #' + customer.odp_id;
            if (networkData.odps) {
                var odp = networkData.odps.find(function (o) { return o.id == customer.odp_id; });
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
        clearButton.addEventListener('click', function () {
            searchFilter.value = '';
            applyCustomerFilters();
        });
    }
}

function applyCustomerFilters() {
    var searchTerm = document.getElementById('customer-filter-search').value.toLowerCase().trim();
    var customers = networkData.customers || [];

    var filteredCustomers = customers.filter(function (customer) {
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

    var customersList = filteredCustomers.map(function (customer) {
        // Connection info
        var connectionInfo = 'Not Connected';
        if (customer.odp_id && customer.port_number) {
            var odpName = 'ODP #' + customer.odp_id;
            if (networkData.odps) {
                var odp = networkData.odps.find(function (o) { return o.id == customer.odp_id; });
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
        customer = networkData.customers.find(function (c) {
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
    setTimeout(function () {
        // Find and open popup if marker exists
        var markerKey = 'customer_' + customerId;
        if (allMarkers[markerKey] && allMarkers[markerKey].marker) {
            // Open popup after animation completes
            setTimeout(function () {
                allMarkers[markerKey].marker.openPopup();

                // Temporary highlight effect
                var markerElement = document.querySelector('[data-type="customer"][data-id="' +
                    customerId + '"]');
                if (markerElement) {
                    markerElement.style.animation = 'pulse 2s ease-in-out 3';
                    setTimeout(function () {
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

    cableRoutes.forEach(function (cable) {
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
    var cablesList = cables.map(function (cable) {
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
        clearButton.addEventListener('click', function () {
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

    var filteredCables = cableRoutes.filter(function (cable) {
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
        var later = function () {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function showQuickAddTypeSelection() {
    Swal.fire({
        title: 'Quick Add',
        text: 'Apa yang ingin kamu tambahkan?',
        icon: 'question',
        showCancelButton: true,
        showDenyButton: true, // TAMBAHAN BARU
        confirmButtonText: '<i class="fa fa-cube"></i> Tambah ODC',
        denyButtonText: '<i class="fa fa-map-pin"></i> Tambah Tiang', // TAMBAHAN BARU
        cancelButtonText: '<i class="fa fa-circle-nodes"></i> Tambah ODP',
        showCloseButton: true,
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            startQuickAddMode('odc');
        } else if (result.isDenied) { // TAMBAHAN BARU
            startQuickAddMode('pole');
        } else if (result.dismiss === Swal.DismissReason.cancel) {
            startQuickAddMode('odp');
        } else {
            // User menutup modal atau tekan X
            // Pastikan tombol kembali ke state normal
            document.body.classList.remove('quick-add-mode-active');
            resetQuickAddButton();
        }
    });
}

function startQuickAddMode(type) {
    // TAMBAHAN BARU: Close any open list modals first
    $('#odcListModal').modal('hide');
    $('#odpListModal').modal('hide');
    $('#cableListModal').modal('hide');
    $('#poleListModal').modal('hide');
    $('#customerListModal').modal('hide');
    
    // ORIGINAL CODE TETAP SAMA
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

    if (quickAddType === 'odc') {
        showQuickAddOdcModal(lat, lng);
    } else if (quickAddType === 'odp') {
        showQuickAddOdpModal(lat, lng);
    } else if (quickAddType === 'pole') { // TAMBAHAN BARU
        showQuickAddPoleModal(lat, lng);
    }
}

function showQuickAddOdcModal(lat, lng) {
    var coordinates = lat + ',' + lng;
    var url = baseUrl + 'plugin/network_mapping/quick-add-odc&lat=' + lat + '&lng=' + lng;

    console.log('Fetching ODC data from:', url);

    // Fetch routers data
    fetch(url)
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers.get('Content-Type'));

            if (!response.ok) {
                throw new Error('HTTP ' + response.status + ': ' + response.statusText);
            }

            return response.text(); // Get as text first to debug
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

                    // Populate routers dropdown
                    var routerSelect = document.getElementById('odc-router');
                    routerSelect.innerHTML = '<option value="">Select Router (Optional)</option>';

                    if (data.routers && data.routers.length > 0) {
                        data.routers.forEach(function (router) {
                            var option = document.createElement('option');
                            option.value = router.id;
                            option.textContent = router.name + (router.description ? ' (' + router
                                .description + ')' : '');
                            routerSelect.appendChild(option);
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
                            networkData.odcs.forEach(function (odc) {
                                var option = document.createElement('option');
                                option.value = odc.id;
                                option.textContent = odc.name + ' (Available: ' + odc.available_ports +
                                    '/' + odc.total_ports + ' ports)';
                                odcParentSelect.appendChild(option);
                            });
                        }
                    }

                    // Add mutual exclusive selection for modal
                    var modalRouterSelect = document.getElementById('odc-router');
                    var modalOdcSelect = document.getElementById('odc-parent');

                    if (modalRouterSelect && modalOdcSelect) {
                        modalRouterSelect.addEventListener('change', function () {
                            if (this.value) {
                                modalOdcSelect.value = '';
                                modalOdcSelect.disabled = true;
                                portSelect.disabled = true;
                                portSection.style.display = 'none';
                            } else {
                                modalOdcSelect.disabled = false;
                            }
                        });

                        modalOdcSelect.addEventListener('change', function () {
                            if (this.value) {
                                modalRouterSelect.value = '';
                                modalRouterSelect.disabled = true;
                                loadAvailablePortsForQuickAdd(this.value);
                                portSection.style.display = 'block';
                            } else {
                                modalRouterSelect.disabled = false;
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
                    setTimeout(function () {
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
                    data.available_ports.forEach(function (port) {
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
                    data.available_ports.forEach(function (port) {
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

        Object.keys(usedPortsDetail).forEach(function (port) {
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

        Object.keys(usedPortsDetail).forEach(function (port) {
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

                data.odcs.forEach(function (odc) {
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
                odcSelect.addEventListener('change', function () {
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
                setTimeout(function () {
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
        searchInput._searchHandler = function () {
            var searchTerm = this.value.trim();

            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(function () {
                loadCustomerPage(searchTerm, 1, 10); // Show more results when searching
            }, 300);
        };

        searchInput.addEventListener('input', searchInput._searchHandler);
    }
}


function renderCustomersWithPortSelection(customers) {
    var customerList = document.getElementById('quick-customer-list');

    customers.forEach(function (customer) {
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

            var initials = customer.fullname.split(' ').map(function (n) { return n[0]; }).join('').substr(0,
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
            var initials = customer.fullname.split(' ').map(function (n) { return n[0]; }).join('').substr(0,
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
    document.querySelectorAll('.quick-customer-checkbox').forEach(function (checkbox) {
        checkbox.addEventListener('change', function () {
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
    document.querySelectorAll('.customer-port-select').forEach(function (select) {
        select.addEventListener('change', function () {
            validatePortAssignments();
            updatePortAvailability();
        });
    });

    // Handle total ports change
    document.getElementById('odp-total-ports').addEventListener('change', function () {
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

    checkedBoxes.forEach(function (checkbox) {
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
    checkedBoxes.forEach(function (checkbox) {
        var portSelect = checkbox.closest('.customer-port-item').querySelector('.customer-port-select');
        var selectedPort = portSelect.value;
        if (selectedPort) {
            usedPorts.push(selectedPort);
        }
    });

    // Update all port selects
    document.querySelectorAll('.customer-port-select').forEach(function (select) {
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

    document.querySelectorAll('.customer-port-select').forEach(function (select) {
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

    checkboxes.forEach(function (checkbox) {
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
    Object.keys(customerPorts).forEach(function (customerId) {
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
function showRouterDetail(id) {
    // Find router data from networkData
    var router = null;
    if (networkData.routers) {
        router = networkData.routers.find(function (r) {
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
                    centerBtn.addEventListener('click', function () {
                        centerMapOnRouter(router.id);
                    });
                }

                if (routeBtn) {
                    routeBtn.addEventListener('click', function () {
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
        odc = networkData.odcs.find(function (o) {
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
                    centerBtn.addEventListener('click', function () {
                        centerMapOnOdc(odc.id);
                    });
                }

                if (routeBtn) {
                    routeBtn.addEventListener('click', function () {
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
        odp = networkData.odps.find(function (o) {
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
                    centerBtn.addEventListener('click', function () {
                        centerMapOnOdp(odp.id);
                    });
                }

                if (routeBtn) {
                    routeBtn.addEventListener('click', function () {
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
    var router = networkData.routers.find(function (r) { return r.id == id; });
    if (router) {
        var coords = router.coordinates.split(',').map(parseFloat);
        map.setView(coords, 16);
        Swal.close();
    }
}

function centerMapOnOdc(id) {
    var odc = networkData.odcs.find(function (o) { return o.id == id; });
    if (odc) {
        var coords = odc.coordinates.split(',').map(parseFloat);
        map.setView(coords, 18);
        Swal.close();
    }
}

function centerMapOnOdp(id) {
    var odp = networkData.odps.find(function (o) { return o.id == id; });
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
        odcData = networkData.odcs.find(function (o) {
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
        odpData = networkData.odps.find(function (o) {
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

    connections.forEach(function (connection) {
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

    connections.forEach(function (connection) {
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
    searchInput._searchHandler = function () {
        var searchTerm = this.value.trim();
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function () {
            loadOdcConnections(1, searchTerm);
        }, 300);
    };
    searchInput.addEventListener('input', searchInput._searchHandler);

    // Load more handler
    document.getElementById('odc-load-more').onclick = function () {
        loadOdcConnections(currentDisconnectData.currentPage + 1, currentDisconnectData.searchTerm);
    };

    // Select all handler
    document.getElementById('odc-select-all').onclick = function () {
        var checkboxes = document.querySelectorAll('.odc-connection-checkbox');
        var allChecked = Array.from(checkboxes).every(cb => cb.checked);

        checkboxes.forEach(function (checkbox) {
            checkbox.checked = !allChecked;
            handleOdcConnectionChange();
        });
    };

    // Disconnect button handler
    document.getElementById('odc-disconnect-selected').onclick = function () {
        executeOdcDisconnect();
    };
}

function setupOdpDisconnectHandlers() {
    // Search handler
    var searchInput = document.getElementById('odp-disconnect-search');
    var searchTimeout;

    searchInput.removeEventListener('input', searchInput._searchHandler);
    searchInput._searchHandler = function () {
        var searchTerm = this.value.trim();
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function () {
            loadOdpConnections(1, searchTerm);
        }, 300);
    };
    searchInput.addEventListener('input', searchInput._searchHandler);

    // Load more handler
    document.getElementById('odp-load-more').onclick = function () {
        loadOdpConnections(currentDisconnectData.currentPage + 1, currentDisconnectData.searchTerm);
    };

    // Select all handler
    document.getElementById('odp-select-all').onclick = function () {
        var checkboxes = document.querySelectorAll('.odp-connection-checkbox');
        var allChecked = Array.from(checkboxes).every(cb => cb.checked);

        checkboxes.forEach(function (checkbox) {
            checkbox.checked = !allChecked;
            handleOdpConnectionChange();
        });
    };

    // Disconnect button handler
    document.getElementById('odp-disconnect-selected').onclick = function () {
        executeOdpDisconnect();
    };
}

// Delegate event handlers for checkboxes (because they're dynamically loaded)
document.addEventListener('change', function (e) {
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
    document.querySelectorAll('.odc-connection-checkbox').forEach(function (checkbox) {
        var isSelected = currentDisconnectData.selectedIds.some(item =>
            item.id === checkbox.value && item.type === checkbox.getAttribute('data-type')
        );
        checkbox.checked = isSelected;
    });
    updateOdcSelectionDisplay();
}

function updateOdpCheckboxStates() {
    document.querySelectorAll('.odp-connection-checkbox').forEach(function (checkbox) {
        checkbox.checked = currentDisconnectData.selectedIds.includes(checkbox.value);
    });
    updateOdpSelectionDisplay();
}

function updateOdcSelectionDisplay() {
    document.querySelectorAll('.connection-item').forEach(function (item) {
        var checkbox = item.querySelector('.odc-connection-checkbox');
        if (checkbox && checkbox.checked) {
            item.classList.add('selected');
        } else {
            item.classList.remove('selected');
        }
    });
}

function updateOdpSelectionDisplay() {
    document.querySelectorAll('.connection-item').forEach(function (item) {
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
    setTimeout(function () {
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
        pole = networkData.poles.find(function (p) {
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

                    data.bridges.forEach(function (bridge, index) {
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
                centerBtn.addEventListener('click', function () {
                    centerMapOnPole(pole.id);
                });
            }

            if (refreshBtn) {
                refreshBtn.addEventListener('click', function () {
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
                var bridgeTexts = data.bridges.map(function (bridge, index) {
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
    var pole = networkData.poles.find(function (p) { return p.id == id; });
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
                            data.bridge_details.forEach(function (bridge) {
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
    bridges.forEach(function (bridge, index) {
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
    document.addEventListener('change', function (e) {
        if (e.target.classList.contains('bridge-checkbox')) {
            updateBulkSelectionDisplay();
        }
    });

    // Select all bridges
    document.getElementById('select-all-bridges').addEventListener('click', function () {
        var checkboxes = document.querySelectorAll('.bridge-checkbox');
        var allChecked = Array.from(checkboxes).every(cb => cb.checked);

        checkboxes.forEach(function (checkbox) {
            checkbox.checked = !allChecked;
            updateBridgeItemSelection(checkbox);
        });

        updateBulkSelectionDisplay();
    });

    // Bulk show bridges
    document.getElementById('bulk-show-bridges').addEventListener('click', function () {
        performBulkShowHide('active');
    });

    // Bulk hide bridges
    document.getElementById('bulk-hide-bridges').addEventListener('click', function () {
        performBulkShowHide('inactive');
    });

    // Bulk delete bridges
    document.getElementById('bulk-delete-bridges').addEventListener('click', function () {
        performBulkDelete();
    });

    // Clear selection
    document.getElementById('bulk-clear-selection').addEventListener('click', function () {
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
    selectedCheckboxes.forEach(function (checkbox) {
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
    checkboxes.forEach(function (checkbox) {
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
// Override routing functions to prevent auto-minimize during routing
var originalStartRouting = startCableRouting;
var originalCancelRouting = cancelCableRouting;
var originalStartQuickAdd = startQuickAddMode;
var originalCancelQuickAdd = cancelQuickAddMode;

startCableRouting = function () {
    clearAutoMinimizeTimer();
    originalStartRouting.call(this);
};

cancelCableRouting = function () {
    originalCancelRouting.call(this);
    startAutoMinimizeTimer();
};

startQuickAddMode = function (type) {
    clearAutoMinimizeTimer();
    originalStartQuickAdd.call(this, type);
};

cancelQuickAddMode = function () {
    originalCancelQuickAdd.call(this);
    startAutoMinimizeTimer();
};
// Show Edit ODP Modal
function showEditOdpModal(id) {
    if (!id) {
        Swal.fire('Error', 'ODP ID tidak valid', 'error');
        return;
    }

    // Show loading modal first
    Swal.fire({
        title: 'Loading ODP Data...',
        html: '<i class="fa fa-spinner fa-spin fa-2x"></i>',
        showConfirmButton: false,
        allowOutsideClick: false
    });

    // Fetch ODP data
    fetch(baseUrl + 'plugin/network_mapping/edit-odp-modal&id=' + id)
        .then(response => response.json())
        .then(data => {
            Swal.close(); // Close loading modal

            if (data.success) {
                populateEditOdpModal(data);
                $('#editOdpModal').modal('show');
            } else {
                Swal.fire('Error', data.message, 'error');
            }
        })
        .catch(error => {
            Swal.close();
            console.error('Error:', error);
            Swal.fire('Error', 'Failed to load ODP data', 'error');
        });
}

// Populate Edit ODP Modal with data
function populateEditOdpModal(data) {
    var odp = data.odp;

    // Fill form fields
    document.getElementById('edit-odp-id').value = odp.id;
    document.getElementById('edit-odp-title').textContent = odp.name;
    document.getElementById('edit-odp-name').value = odp.name || '';
    document.getElementById('edit-odp-description').value = odp.description || '';
    document.getElementById('edit-odp-coordinates').value = odp.coordinates || '';
    document.getElementById('edit-odp-address').value = odp.address || '';
    document.getElementById('edit-odp-total-ports').value = odp.total_ports || '8';
    document.getElementById('edit-odp-status').value = odp.status || 'Active';

    // Populate ODCs dropdown
    var odcSelect = document.getElementById('edit-odp-odc');
    odcSelect.innerHTML = '<option value="">Select ODC (Optional)</option>';
    if (data.odcs) {
        data.odcs.forEach(function (odc) {
            var availablePorts = odc.total_ports - odc.used_ports;
            var option = document.createElement('option');
            option.value = odc.id;
            option.textContent = odc.name + ' (Available: ' + availablePorts + '/' + odc.total_ports + ' ports)';
            if (availablePorts <= 0) {
                option.disabled = true;
                option.textContent += ' - FULL';
            }
            if (odc.id == odp.odc_id) option.selected = true;
            odcSelect.appendChild(option);
        });
    }

    // Setup ODC selection handler
    setupEditOdpOdcSelection();

    // If ODC is selected, show port selection
    if (odp.odc_id) {
        loadAvailablePortsForEditOdp(odp.odc_id, odp.port_number);
        document.getElementById('edit-odp-port-selection-section').style.display = 'block';
    }

    // Load customers
    loadEditOdpCustomers(data);

    // Update counters
    updateEditOdpCustomerCountWithPorts();
}

// Setup ODC selection for Edit ODP
function setupEditOdpOdcSelection() {
    var odcSelect = document.getElementById('edit-odp-odc');
    var portSelect = document.getElementById('edit-odp-port-number');
    var portSection = document.getElementById('edit-odp-port-selection-section');

    odcSelect.addEventListener('change', function () {
        if (this.value) {
            loadAvailablePortsForEditOdp(this.value);
            portSection.style.display = 'block';
        } else {
            portSelect.disabled = true;
            portSection.style.display = 'none';
            portSelect.innerHTML = '<option value="">Auto port</option>';
            document.getElementById('edit-odp-port-status-info').innerHTML = '';
        }
    });
}

// Load available ports for Edit ODP
function loadAvailablePortsForEditOdp(odcId, currentPort = null) {
    var portSelect = document.getElementById('edit-odp-port-number');
    var portStatusInfo = document.getElementById('edit-odp-port-status-info');

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
                    data.available_ports.forEach(function (port) {
                        var option = document.createElement('option');
                        option.value = port;
                        option.textContent = 'Port ' + port + ' (Available)';
                        portSelect.appendChild(option);
                    });
                }

                // Add current port if it exists (for editing)
                if (currentPort && !data.available_ports.includes(parseInt(currentPort))) {
                    var currentOption = document.createElement('option');
                    currentOption.value = currentPort;
                    currentOption.textContent = 'Port ' + currentPort + ' (Current)';
                    currentOption.selected = true;
                    portSelect.appendChild(currentOption);
                } else if (currentPort) {
                    portSelect.value = currentPort;
                }

                portSelect.disabled = false;

                // Update port status info for ODP
                updateEditOdpPortStatusInfo(data.used_ports_detail, data.available_ports);

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

// Update port status info for Edit ODP
function updateEditOdpPortStatusInfo(usedPortsDetail, availablePorts) {
    var portStatusInfo = document.getElementById('edit-odp-port-status-info');
    if (!portStatusInfo) return;

    var statusHtml = '';

    // Show used ports
    if (usedPortsDetail && Object.keys(usedPortsDetail).length > 0) {
        statusHtml += '<div style="background: rgba(255, 193, 7, 0.1); border: 1px solid #ffc107; padding: 4px 6px; border-radius: 3px; margin-bottom: 4px;">';
        statusHtml += '<strong style="color: #856404;">Used Ports:</strong><br>';

        Object.keys(usedPortsDetail).forEach(function (port) {
            var detail = usedPortsDetail[port];
            statusHtml += '• Port ' + port + ': ' + detail.name + ' (' + detail.type.toUpperCase() + ')<br>';
        });

        statusHtml = statusHtml.slice(0, -4); // Remove last <br>
        statusHtml += '</div>';
    }

    // Show available ports
    if (availablePorts && availablePorts.length > 0) {
        statusHtml += '<div style="background: rgba(40, 167, 69, 0.1); border: 1px solid #28a745; padding: 4px 6px; border-radius: 3px;">';
        statusHtml += '<strong style="color: #155724;">Available Ports:</strong> ';
        statusHtml += 'Port ' + availablePorts.join(', Port ');
        statusHtml += '</div>';
    } else if (!usedPortsDetail || Object.keys(usedPortsDetail).length === 0) {
        statusHtml += '<div style="background: rgba(108, 117, 125, 0.1); border: 1px solid #6c757d; padding: 4px 6px; border-radius: 3px;">';
        statusHtml += '<strong style="color: #495057;">No ports available</strong>';
        statusHtml += '</div>';
    }

    portStatusInfo.innerHTML = statusHtml;
}

// Load customers for Edit ODP
function loadEditOdpCustomers(data) {
    var customerList = document.getElementById('edit-customer-list');
    customerList.innerHTML = '';

    // Render all customers with port selection
    renderEditCustomersWithPortSelection(data.all_customers, data.connected_customers, data.odp);

    // Setup search
    var searchInput = document.getElementById('edit-customer-search');
    var searchTimeout;

    searchInput.removeEventListener('input', searchInput._editSearchHandler);
    searchInput._editSearchHandler = function () {
        var searchTerm = this.value.trim().toLowerCase();
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function () {
            filterEditCustomers(data.all_customers, data.connected_customers, data.odp, searchTerm);
        }, 300);
    };
    searchInput.addEventListener('input', searchInput._editSearchHandler);

    // Setup customer port selection handlers
    setupEditCustomerPortSelectionHandlers();
}

// Render customers with port selection for Edit
function renderEditCustomersWithPortSelection(allCustomers, connectedCustomers, odp) {
    var customerList = document.getElementById('edit-customer-list');

    // Create map of connected customers for easy lookup
    var connectedMap = {};
    connectedCustomers.forEach(function (customer) {
        connectedMap[customer.id] = customer;
    });

    customerList.innerHTML = '';

    allCustomers.forEach(function (customer) {
        var customerDiv = document.createElement('div');
        customerDiv.className = 'customer-port-item';

        // Check if customer is connected to this ODP or another ODP
        var isConnectedToThisOdp = connectedMap[customer.id];
        var isConnectedToOtherOdp = customer.odp_id && customer.odp_id != odp.id && customer.connection_status === 'Active';
        var isDisabled = isConnectedToOtherOdp ? 'disabled' : '';
        var connectedInfo = isConnectedToOtherOdp ? '<br><small style="color: #d9534f;">⚠ Already connected to another ODP</small>' : '';

        // Process customer photo
        var photoHtml = '';
        if (customer.photo && customer.photo !== '/user.default.jpg' && customer.photo.indexOf('user.default.jpg') === -1) {
            var photoUrl = customer.photo;
            var initials = customer.fullname.split(' ').map(function (n) { return n[0]; }).join('').substr(0, 2).toUpperCase();

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
            // Avatar with initials
            var initials = customer.fullname.split(' ').map(function (n) { return n[0]; }).join('').substr(0, 2).toUpperCase();
            var colors = ['#e74c3c', '#f39c12', '#f1c40f', '#27ae60', '#2ecc71', '#3498db', '#9b59b6', '#e67e22'];
            var bgColor = colors[customer.fullname.length % colors.length];

            photoHtml = '<div class="customer-photo-mini">' +
                '<div style="width: 35px; height: 35px; border-radius: 50%; background: linear-gradient(135deg, ' + bgColor + ', #2c3e50); color: white; font-size: 12px; font-weight: bold; display: flex; align-items: center; justify-content: center; border: 2px solid #fff;">' +
                initials +
                '</div>' +
                '</div>';
        }

        // Get total ports for port options
        var totalPorts = parseInt(document.getElementById('edit-odp-total-ports').value) || 8;
        var portOptions = '<option value="">Select Port</option>';
        for (var i = 1; i <= totalPorts; i++) {
            portOptions += '<option value="' + i + '">Port ' + i + '</option>';
        }

        customerDiv.innerHTML =
            '<div class="customer-checkbox-section">' +
            '<input type="checkbox" class="customer-checkbox edit-customer-checkbox" value="' +
            customer.id + '" name="customers[]" ' + isDisabled +
            (isConnectedToThisOdp ? ' checked' : '') + '>' +
            '</div>' +
            '<div class="customer-photo-section">' + photoHtml + '</div>' +
            '<div class="customer-info-section ' + (isConnectedToOtherOdp ? 'customer-already-connected' : '') + '">' +
            '<div class="customer-name">' + customer.fullname + '</div>' +
            '<div class="customer-details">Username: ' + customer.username +
            (customer.address ? ' | ' + customer.address : '') + connectedInfo + '</div>' +
            '</div>' +
            '<div class="customer-port-section">' +
            '<select class="customer-port-select" name="customer_ports[' + customer.id + ']" ' +
            (isConnectedToThisOdp ? '' : 'disabled ') + isDisabled + '>' +
            portOptions +
            '</select>' +
            '</div>';

        if (isConnectedToOtherOdp) {
            customerDiv.style.opacity = '0.5';
            customerDiv.title = 'Customer already connected to another ODP';
        } else if (isConnectedToThisOdp) {
            customerDiv.classList.add('selected');
            // Set the port value if connected
            var portSelect = customerDiv.querySelector('.customer-port-select');
            if (connectedMap[customer.id].port_number) {
                portSelect.value = connectedMap[customer.id].port_number;
            }
        }

        customerList.appendChild(customerDiv);
    });
}

// Filter customers for Edit
function filterEditCustomers(allCustomers, connectedCustomers, odp, searchTerm) {
    var filteredCustomers = allCustomers.filter(function (customer) {
        if (!searchTerm) return true;
        return customer.fullname.toLowerCase().includes(searchTerm) ||
            customer.username.toLowerCase().includes(searchTerm) ||
            (customer.address && customer.address.toLowerCase().includes(searchTerm));
    });

    renderEditCustomersWithPortSelection(filteredCustomers, connectedCustomers, odp);
    setupEditCustomerPortSelectionHandlers();
}

// Setup customer port selection handlers for Edit
function setupEditCustomerPortSelectionHandlers() {
    // Handle checkbox changes
    document.querySelectorAll('.edit-customer-checkbox').forEach(function (checkbox) {
        checkbox.addEventListener('change', function () {
            var portSelect = this.closest('.customer-port-item').querySelector('.customer-port-select');

            if (this.checked) {
                portSelect.disabled = false;
                this.closest('.customer-port-item').classList.add('selected');
            } else {
                portSelect.disabled = true;
                portSelect.value = '';
                this.closest('.customer-port-item').classList.remove('selected');
                updateEditPortAvailability();
            }

            updateEditOdpCustomerCountWithPorts();
            validateEditPortAssignments();
        });
    });

    // Handle port selection changes
    document.querySelectorAll('.customer-port-select').forEach(function (select) {
        select.addEventListener('change', function () {
            validateEditPortAssignments();
            updateEditPortAvailability();
        });
    });

    // Handle total ports change
    document.getElementById('edit-odp-total-ports').addEventListener('change', function () {
        updateEditPortOptionsForAllCustomers();
        updateEditOdpCustomerCountWithPorts();
        validateEditPortAssignments();
    });
}

// Update customer count for Edit ODP
function updateEditOdpCustomerCountWithPorts() {
    var checkedBoxes = document.querySelectorAll('.edit-customer-checkbox:checked');
    var totalPorts = parseInt(document.getElementById('edit-odp-total-ports').value) || 8;
    var selectedCount = checkedBoxes.length;
    var availablePorts = totalPorts - selectedCount;

    // Update counters
    document.getElementById('edit-selected-count').textContent = selectedCount + '/' + totalPorts;
    document.getElementById('edit-available-ports').textContent = Math.max(0, availablePorts);

    // Update counter color
    var counterElement = document.getElementById('edit-selected-count');
    if (selectedCount > totalPorts) {
        counterElement.style.backgroundColor = '#d9534f';
    } else if (selectedCount === totalPorts) {
        counterElement.style.backgroundColor = '#f0ad4e';
    } else {
        counterElement.style.backgroundColor = '#5cb85c';
    }
}

// Validate port assignments for Edit
function validateEditPortAssignments() {
    var checkedBoxes = document.querySelectorAll('.edit-customer-checkbox:checked');
    var usedPorts = [];
    var hasConflict = false;

    checkedBoxes.forEach(function (checkbox) {
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
    var submitBtn = document.querySelector('#editOdpForm button[type="submit"]');
    if (submitBtn) {
        submitBtn.disabled = hasConflict;
    }

    return !hasConflict;
}

// Update port availability for Edit
function updateEditPortAvailability() {
    var checkedBoxes = document.querySelectorAll('.edit-customer-checkbox:checked');
    var usedPorts = [];

    // Collect used ports
    checkedBoxes.forEach(function (checkbox) {
        var portSelect = checkbox.closest('.customer-port-item').querySelector('.customer-port-select');
        var selectedPort = portSelect.value;
        if (selectedPort) {
            usedPorts.push(selectedPort);
        }
    });

    // Update all port selects
    document.querySelectorAll('.customer-port-select').forEach(function (select) {
        var currentValue = select.value;
        var isDisabled = select.disabled;

        // Rebuild options
        var totalPorts = parseInt(document.getElementById('edit-odp-total-ports').value) || 8;
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

// Update port options for all customers in Edit
function updateEditPortOptionsForAllCustomers() {
    var totalPorts = parseInt(document.getElementById('edit-odp-total-ports').value) || 8;

    document.querySelectorAll('.customer-port-select').forEach(function (select) {
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

    updateEditPortAvailability();
}

// Save Edit ODP
function saveEditOdp() {
    var form = document.getElementById('editOdpForm');
    var formData = new FormData(form);

    // Validate and get customer selections
    var selectedCustomers = [];
    var customerPorts = {};
    var checkboxes = document.querySelectorAll('.edit-customer-checkbox:checked');

    checkboxes.forEach(function (checkbox) {
        var customerId = checkbox.value;
        selectedCustomers.push(customerId);

        var portSelect = checkbox.closest('.customer-port-item').querySelector('.customer-port-select');
        var selectedPort = portSelect.value;

        if (selectedPort && selectedPort !== '') {
            customerPorts[customerId] = selectedPort;
        }
    });

    // Clear existing customer_ports in FormData and set new ones
    var keysToDelete = [];
    for (var pair of formData.entries()) {
        if (pair[0].startsWith('customer_ports[')) {
            keysToDelete.push(pair[0]);
        }
    }
    keysToDelete.forEach(key => formData.delete(key));

    // Add valid customer ports only
    Object.keys(customerPorts).forEach(function (customerId) {
        if (customerPorts[customerId] && customerPorts[customerId] !== '') {
            formData.append('customer_ports[' + customerId + ']', customerPorts[customerId]);
        }
    });

    // Show loading
    Swal.fire({
        title: 'Updating ODP...',
        text: 'Please wait',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    fetch(baseUrl + 'plugin/network_mapping/update-odp-modal', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Close modal
                $('#editOdpModal').modal('hide');

                // Save position before reload
                mapPositionMemory.savePosition();

                // Success message
                Swal.fire({
                    icon: 'success',
                    title: 'ODP Updated!',
                    html: '<p><strong>Name:</strong> ' + data.odp.name + '</p>' +
                        '<p><strong>Coordinates:</strong> ' + data.odp.coordinates + '</p>' +
                        '<p><strong>Used Ports:</strong> ' + data.odp.used_ports + '/' + data.odp.total_ports + '</p>' +
                        '<p class="text-info"><i class="fa fa-refresh"></i> Map akan tetap di posisi ini setelah reload...</p>',
                    timer: 2000,
                    showConfirmButton: false
                }).then(() => {
                    // Reload page
                    window.location.reload();
                });

            } else {
                Swal.fire('Error', data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'Failed to update ODP', 'error');
        });
}
// ===== ODC LIST MODAL FUNCTIONS =====

function showAllOdcs() {
    $('#odcListModal').modal('show');

    // Reset state
    currentOdcListData = {
        odcs: [],
        currentPage: 1,
        searchTerm: '',
        totalFound: 0,
        hasMore: false
    };

    // Setup event handlers
    setupOdcListHandlers();

    // Load initial data
    loadOdcList(1, '');
}

var currentOdcListData = {
    odcs: [],
    currentPage: 1,
    searchTerm: '',
    totalFound: 0,
    hasMore: false
};

function setupOdcListHandlers() {
    // Search handler with debounce
    var searchInput = document.getElementById('odc-search-input');
    var searchTimeout;

    searchInput.removeEventListener('input', searchInput._odcSearchHandler);
    searchInput._odcSearchHandler = function () {
        var searchTerm = this.value.trim();
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function () {
            loadOdcList(1, searchTerm);
        }, 300);
    };
    searchInput.addEventListener('input', searchInput._odcSearchHandler);

    // Clear search handler
    document.getElementById('odc-clear-search').onclick = function () {
        document.getElementById('odc-search-input').value = '';
        loadOdcList(1, '');
    };

    // Load more handler
    document.getElementById('odc-load-more').onclick = function () {
        loadOdcList(currentOdcListData.currentPage + 1, currentOdcListData.searchTerm);
    };
}

function loadOdcList(page = 1, search = '') {
    var url = baseUrl + 'plugin/network_mapping/list-odc-modal' +
        '&page=' + page + '&limit=10&search=' + encodeURIComponent(search);

    if (page === 1) {
        document.getElementById('odc-table-container').innerHTML =
            '<div class="text-center" style="padding: 20px;"><i class="fa fa-spinner fa-spin"></i> Loading...</div>';
    }

    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (page === 1) {
                    currentOdcListData.odcs = data.odcs;
                    buildOdcTable(data.odcs, true);
                } else {
                    currentOdcListData.odcs = currentOdcListData.odcs.concat(data.odcs);
                    buildOdcTable(data.odcs, false);
                }

                // Update statistics
                updateOdcStatistics(currentOdcListData.odcs);

                // Update pagination
                currentOdcListData.currentPage = page;
                currentOdcListData.searchTerm = search;
                currentOdcListData.totalFound = data.total_found;
                currentOdcListData.hasMore = data.has_more;

                // Update UI
                document.getElementById('odc-total-count').textContent = data.total_found;

                if (data.has_more) {
                    document.getElementById('odc-load-more-container').style.display = 'block';
                    document.getElementById('odc-remaining').textContent = data.remaining;
                } else {
                    document.getElementById('odc-load-more-container').style.display = 'none';
                }

            } else {
                document.getElementById('odc-table-container').innerHTML =
                    '<div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> Error loading ODCs: ' +
                    (data.message || 'Unknown error') + '</div>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('odc-table-container').innerHTML =
                '<div class="alert alert-warning"><i class="fa fa-exclamation-triangle"></i> Failed to load ODC data. Please try again.</div>';
        });
}

function buildOdcTable(odcs, clearFirst = false) {
    var container = document.getElementById('odc-table-container');

    if (clearFirst) {
        container.innerHTML = '';
    }

    if (odcs.length === 0 && clearFirst) {
        container.innerHTML = '<div class="alert alert-info text-center"><i class="fa fa-info-circle"></i> No ODCs found</div>';
        return;
    }

    // Create table if first load
    if (clearFirst) {
        var tableHtml = '<div class="table-responsive">' +
            '<table class="table table-bordered table-striped table-hover" id="odc-data-table">' +
            '<thead>' +
            '<tr>' +
            '<th>ID</th>' +
            '<th>Name</th>' +
            '<th>Connection</th>' +
            '<th>Coordinates</th>' +
            '<th>Address</th>' +
            '<th>Port Usage</th>' +
            '<th>Status</th>' +
            '<th>Actions</th>' +
            '</tr>' +
            '</thead>' +
            '<tbody id="odc-table-body">' +
            '</tbody>' +
            '</table>' +
            '</div>';
        container.innerHTML = tableHtml;
    }

    var tbody = document.getElementById('odc-table-body');

    odcs.forEach(function (odc) {
        var usagePercent = Math.round((odc.used_ports / odc.total_ports) * 100);
        var progressBarClass = getProgressBarClass(odc.used_ports, odc.total_ports);

        // Connection info
        var connectionInfo = '';
        if (odc.router_id && odc.router_name) {
            connectionInfo = '<span class="label label-primary"><i class="fa fa-server"></i> ' + odc.router_name + '</span>';
        } else if (odc.router_id) {
            connectionInfo = '<span class="label label-primary"><i class="fa fa-server"></i> Router #' + odc.router_id + '</span>';
        } else if (odc.parent_odc_id) {
            connectionInfo = '<span class="label label-success"><i class="fa fa-cube"></i> Parent ODC #' + odc.parent_odc_id + '</span>';
            if (odc.port_number) {
                connectionInfo += '<br><small class="text-info"><i class="fa fa-plug"></i> Port ' + odc.port_number + '</small>';
            }
        } else {
            connectionInfo = '<span class="label label-default">No Connection</span>';
        }

        // Coordinates
        var coordsInfo = '';
        if (odc.coordinates) {
            coordsInfo = '<span class="label label-success" style="display: block; margin-bottom: 5px;">' +
                '<i class="fa fa-map-marker"></i> ' + odc.coordinates + '</span>' +
                '<a href="https://www.google.com/maps/dir//' + odc.coordinates + '" target="_blank" ' +
                'class="btn btn-xs btn-info"><i class="fa fa-external-link"></i> Maps</a>';
        } else {
            coordsInfo = '<span class="label label-warning">No Coordinates</span>';
        }

        var row = document.createElement('tr');
        row.innerHTML =
            '<td>' + odc.id + '</td>' +
            '<td>' +
            '<strong>' + odc.name + '</strong>' +
            (odc.description ? '<br><small class="text-muted">' + odc.description + '</small>' : '') +
            '</td>' +
            '<td>' + connectionInfo + '</td>' +
            '<td>' + coordsInfo + '</td>' +
            '<td>' + (odc.address ? '<span title="' + odc.address + '">' +
                (odc.address.length > 30 ? odc.address.substring(0, 30) + '...' : odc.address) + '</span>' :
                '<span class="text-muted">-</span>') + '</td>' +
            '<td>' +
            '<div class="port-usage-container">' +
            '<div class="port-numbers">' +
            '<span class="used-ports">' + odc.used_ports + '</span>' +
            '<span class="separator">/</span>' +
            '<span class="total-ports">' + odc.total_ports + '</span>' +
            '<span class="usage-percent">(' + usagePercent + '%)</span>' +
            '</div>' +
            '<div class="progress port-progress">' +
            '<div class="progress-bar ' + progressBarClass + '" style="width: ' + usagePercent + '%"></div>' +
            '</div>' +
            '<small class="available-info"><i class="fa fa-circle-thin"></i> ' + odc.available_ports + ' available</small>' +
            '</div>' +
            '</td>' +
            '<td>' +
            (odc.status === 'Active' ?
                '<span class="label label-success"><i class="fa fa-check-circle"></i> Active</span>' :
                '<span class="label label-danger"><i class="fa fa-times-circle"></i> Inactive</span>') +
            '</td>' +
            '<td>' +
            '<div class="btn-group" role="group">' +
            '<button type="button" class="btn btn-info btn-xs" onclick="showOdcDetailFromList(' + odc.id + ')" title="View Details">' +
            '<i class="fa fa-info-circle"></i></button>' +
            '<button type="button" class="btn btn-warning btn-xs" onclick="editOdcFromList(' + odc.id + ')" title="Edit ODC">' +
            '<i class="fa fa-edit"></i></button>' +
            (odc.used_ports > 0 ?
                '<button type="button" class="btn btn-warning btn-xs" onclick="showOdcDisconnectFromList(' + odc.id + ', \'' +
                odc.name.replace(/'/g, "\\'") + '\', ' + odc.used_ports + ')" title="Disconnect Connections">' +
                '<i class="fa fa-unlink"></i></button>' : '') +
            '<button type="button" class="btn btn-danger btn-xs" onclick="deleteOdcFromList(' + odc.id + ', \'' +
            odc.name.replace(/'/g, "\\'") + '\')" title="Delete ODC">' +
            '<i class="fa fa-trash"></i></button>' +
            (odc.coordinates ?
                '<button type="button" class="btn btn-primary btn-xs" onclick="centerOnOdc(' + odc.id + ')" title="View on Map">' +
                '<i class="fa fa-map-marker"></i></button>' : '') +
            '</div>' +
            '</td>';

        tbody.appendChild(row);
    });
}

function updateOdcStatistics(odcs) {
    var activeCount = odcs.length;
    var totalPortsUsed = 0;
    var totalPortsAvailable = 0;
    var totalConnections = 0;

    odcs.forEach(function (odc) {
        totalPortsUsed += parseInt(odc.used_ports);
        totalPortsAvailable += parseInt(odc.available_ports);
        totalConnections += parseInt(odc.used_ports);
    });

    document.getElementById('odc-active-count').textContent = activeCount;
    document.getElementById('odc-ports-used').textContent = totalPortsUsed;
    document.getElementById('odc-ports-available').textContent = totalPortsAvailable;
    document.getElementById('odc-connections').textContent = totalConnections;
}

function refreshOdcList() {
    loadOdcList(1, currentOdcListData.searchTerm);
}

function centerOnOdc(odcId) {
    $('#odcListModal').modal('hide');

    // Find ODC in current data
    var odc = currentOdcListData.odcs.find(o => o.id == odcId);
    if (odc && odc.coordinates) {
        var coords = odc.coordinates.split(',');
        if (coords.length === 2) {
            var lat = parseFloat(coords[0].trim());
            var lng = parseFloat(coords[1].trim());

            map.flyTo([lat, lng], 19, {
                animate: true,
                duration: 1.5
            });

            // Show popup after animation
            setTimeout(function () {
                if (allMarkers['odc_' + odcId]) {
                    allMarkers['odc_' + odcId].openPopup();
                }
            }, 1600);
        }
    }
}

function getProgressBarClass(used, total) {
    var percent = (used / total) * 100;
    if (percent >= 90) return 'progress-bar-danger';
    if (percent >= 75) return 'progress-bar-warning';
    if (percent >= 50) return 'progress-bar-info';
    return 'progress-bar-success';
}
// ===== ODP LIST MODAL FUNCTIONS =====

function showAllOdps() {
    $('#odpListModal').modal('show');

    // Reset state
    currentOdpListData = {
        odps: [],
        currentPage: 1,
        searchTerm: '',
        totalFound: 0,
        hasMore: false
    };

    // Setup event handlers
    setupOdpListHandlers();

    // Load initial data
    loadOdpList(1, '');
}

var currentOdpListData = {
    odps: [],
    currentPage: 1,
    searchTerm: '',
    totalFound: 0,
    hasMore: false
};

function setupOdpListHandlers() {
    // Search handler with debounce
    var searchInput = document.getElementById('odp-search-input');
    var searchTimeout;

    searchInput.removeEventListener('input', searchInput._odpSearchHandler);
    searchInput._odpSearchHandler = function () {
        var searchTerm = this.value.trim();
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function () {
            loadOdpList(1, searchTerm);
        }, 300);
    };
    searchInput.addEventListener('input', searchInput._odpSearchHandler);

    // Clear search handler
    document.getElementById('odp-clear-search').onclick = function () {
        document.getElementById('odp-search-input').value = '';
        loadOdpList(1, '');
    };

    // Load more handler
    document.getElementById('odp-load-more').onclick = function () {
        loadOdpList(currentOdpListData.currentPage + 1, currentOdpListData.searchTerm);
    };
}

function loadOdpList(page = 1, search = '') {
    var url = baseUrl + 'plugin/network_mapping/list-odp-modal' +
        '&page=' + page + '&limit=10&search=' + encodeURIComponent(search);

    if (page === 1) {
        document.getElementById('odp-table-container').innerHTML =
            '<div class="text-center" style="padding: 20px;"><i class="fa fa-spinner fa-spin"></i> Loading...</div>';
    }

    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (page === 1) {
                    currentOdpListData.odps = data.odps;
                    buildOdpTable(data.odps, true);
                } else {
                    currentOdpListData.odps = currentOdpListData.odps.concat(data.odps);
                    buildOdpTable(data.odps, false);
                }

                // Update statistics
                updateOdpStatistics(currentOdpListData.odps);

                // Update pagination
                currentOdpListData.currentPage = page;
                currentOdpListData.searchTerm = search;
                currentOdpListData.totalFound = data.total_found;
                currentOdpListData.hasMore = data.has_more;

                // Update UI
                document.getElementById('odp-total-count').textContent = data.total_found;

                if (data.has_more) {
                    document.getElementById('odp-load-more-container').style.display = 'block';
                    document.getElementById('odp-remaining').textContent = data.remaining;
                } else {
                    document.getElementById('odp-load-more-container').style.display = 'none';
                }

            } else {
                document.getElementById('odp-table-container').innerHTML =
                    '<div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> Error loading ODPs: ' +
                    (data.message || 'Unknown error') + '</div>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('odp-table-container').innerHTML =
                '<div class="alert alert-warning"><i class="fa fa-exclamation-triangle"></i> Failed to load ODP data. Please try again.</div>';
        });
}

function buildOdpTable(odps, clearFirst = false) {
    var container = document.getElementById('odp-table-container');

    if (clearFirst) {
        container.innerHTML = '';
    }

    if (odps.length === 0 && clearFirst) {
        container.innerHTML = '<div class="alert alert-info text-center"><i class="fa fa-info-circle"></i> No ODPs found</div>';
        return;
    }

    // Create table if first load
    if (clearFirst) {
        var tableHtml = '<div class="table-responsive">' +
            '<table class="table table-bordered table-striped table-hover" id="odp-data-table">' +
            '<thead>' +
            '<tr>' +
            '<th>ID</th>' +
            '<th>Name</th>' +
            '<th>ODC Connection</th>' +
            '<th>Coordinates</th>' +
            '<th>Address</th>' +
            '<th>Port Usage</th>' +
            '<th>Status</th>' +
            '<th>Actions</th>' +
            '</tr>' +
            '</thead>' +
            '<tbody id="odp-table-body">' +
            '</tbody>' +
            '</table>' +
            '</div>';
        container.innerHTML = tableHtml;
    }

    var tbody = document.getElementById('odp-table-body');

    odps.forEach(function (odp) {
        var usagePercent = Math.round((odp.used_ports / odp.total_ports) * 100);
        var progressBarClass = getProgressBarClass(odp.used_ports, odp.total_ports);

        // ODC Connection info
        var connectionInfo = '';
        if (odp.odc_id && odp.odc_name) {
            connectionInfo = '<span class="label label-success"><i class="fa fa-cube"></i> ' + odp.odc_name + '</span>';
            if (odp.port_number) {
                connectionInfo += '<br><small class="text-info"><i class="fa fa-plug"></i> Port ' + odp.port_number + '</small>';
            }
        } else if (odp.odc_id) {
            connectionInfo = '<span class="label label-success"><i class="fa fa-cube"></i> ODC #' + odp.odc_id + '</span>';
            if (odp.port_number) {
                connectionInfo += '<br><small class="text-info"><i class="fa fa-plug"></i> Port ' + odp.port_number + '</small>';
            }
        } else {
            connectionInfo = '<span class="label label-default">No ODC</span>';
        }

        // Coordinates
        var coordsInfo = '';
        if (odp.coordinates) {
            coordsInfo = '<span class="label label-success" style="display: block; margin-bottom: 5px;">' +
                '<i class="fa fa-map-marker"></i> ' + odp.coordinates + '</span>' +
                '<a href="https://www.google.com/maps/dir//' + odp.coordinates + '" target="_blank" ' +
                'class="btn btn-xs btn-info"><i class="fa fa-external-link"></i> Maps</a>';
        } else {
            coordsInfo = '<span class="label label-warning">No Coordinates</span>';
        }

        var row = document.createElement('tr');
        row.innerHTML =
            '<td>' + odp.id + '</td>' +
            '<td>' +
            '<strong>' + odp.name + '</strong>' +
            (odp.description ? '<br><small class="text-muted">' + odp.description + '</small>' : '') +
            '</td>' +
            '<td>' + connectionInfo + '</td>' +
            '<td>' + coordsInfo + '</td>' +
            '<td>' + (odp.address ? '<span title="' + odp.address + '">' +
                (odp.address.length > 30 ? odp.address.substring(0, 30) + '...' : odp.address) + '</span>' :
                '<span class="text-muted">-</span>') + '</td>' +
            '<td>' +
            '<div class="port-usage-container">' +
            '<div class="port-numbers">' +
            '<span class="used-ports">' + odp.used_ports + '</span>' +
            '<span class="separator">/</span>' +
            '<span class="total-ports">' + odp.total_ports + '</span>' +
            '<span class="usage-percent">(' + usagePercent + '%)</span>' +
            '</div>' +
            '<div class="progress port-progress">' +
            '<div class="progress-bar ' + progressBarClass + '" style="width: ' + usagePercent + '%"></div>' +
            '</div>' +
            '<small class="available-info"><i class="fa fa-circle-thin"></i> ' + odp.available_ports + ' available</small>' +
            '</div>' +
            '</td>' +
            '<td>' +
            (odp.status === 'Active' ?
                '<span class="label label-success"><i class="fa fa-check-circle"></i> Active</span>' :
                '<span class="label label-danger"><i class="fa fa-times-circle"></i> Inactive</span>') +
            '</td>' +
            '<td>' +
            '<div class="btn-group" role="group">' +
            '<button type="button" class="btn btn-info btn-xs" onclick="showOdpDetailFromList(' + odp.id + ')" title="View Details">' +
            '<i class="fa fa-info-circle"></i></button>' +
            '<button type="button" class="btn btn-warning btn-xs" onclick="editOdpFromList(' + odp.id + ')" title="Edit ODP">' +
            '<i class="fa fa-edit"></i></button>' +
            (odp.used_ports > 0 ?
                '<button type="button" class="btn btn-warning btn-xs" onclick="showOdpDisconnectFromList(' + odp.id + ', \'' +
                odp.name.replace(/'/g, "\\'") + '\', ' + odp.used_ports + ')" title="Disconnect Customers">' +
                '<i class="fa fa-unlink"></i></button>' : '') +
            '<button type="button" class="btn btn-danger btn-xs" onclick="deleteOdpFromList(' + odp.id + ', \'' +
            odp.name.replace(/'/g, "\\'") + '\')" title="Delete ODP">' +
            '<i class="fa fa-trash"></i></button>' +
            (odp.coordinates ?
                '<button type="button" class="btn btn-primary btn-xs" onclick="centerOnOdp(' + odp.id + ')" title="View on Map">' +
                '<i class="fa fa-map-marker"></i></button>' : '') +
            '</div>' +
            '</td>';

        tbody.appendChild(row);
    });
}

function updateOdpStatistics(odps) {
    var activeCount = odps.length;
    var totalPortsUsed = 0;
    var totalPortsAvailable = 0;
    var totalCustomers = 0;

    odps.forEach(function (odp) {
        totalPortsUsed += parseInt(odp.used_ports);
        totalPortsAvailable += parseInt(odp.available_ports);
        totalCustomers += parseInt(odp.used_ports); // used_ports = connected customers
    });

    document.getElementById('odp-active-count').textContent = activeCount;
    document.getElementById('odp-ports-used').textContent = totalPortsUsed;
    document.getElementById('odp-ports-available').textContent = totalPortsAvailable;
    document.getElementById('odp-customers').textContent = totalCustomers;
}

function refreshOdpList() {
    loadOdpList(1, currentOdpListData.searchTerm);
}

function centerOnOdp(odpId) {
    $('#odpListModal').modal('hide');

    // Find ODP in current data
    var odp = currentOdpListData.odps.find(o => o.id == odpId);
    if (odp && odp.coordinates) {
        var coords = odp.coordinates.split(',');
        if (coords.length === 2) {
            var lat = parseFloat(coords[0].trim());
            var lng = parseFloat(coords[1].trim());

            map.flyTo([lat, lng], 19, {
                animate: true,
                duration: 1.5
            });

            // Show popup after animation
            setTimeout(function () {
                if (allMarkers['odp_' + odpId]) {
                    allMarkers['odp_' + odpId].openPopup();
                }
            }, 1600);
        }
    }
}
// ===== AUTO-CLOSE WRAPPER FUNCTIONS =====

// ODC Wrapper Functions
function showOdcDetailFromList(odcId) {
    $('#odcListModal').modal('hide');
    
    // Wait for modal to close then show detail
    setTimeout(function() {
        showOdcDetail(odcId);
    }, 300);
}

function editOdcFromList(odcId) {
    $('#odcListModal').modal('hide');
    
    // Wait for modal to close then edit
    setTimeout(function() {
        editOdcFromMap(odcId);
    }, 300);
}

function showOdcDisconnectFromList(odcId, odcName, connectionCount) {
    $('#odcListModal').modal('hide');
    
    // Wait for modal to close then show disconnect
    setTimeout(function() {
        showOdcDisconnectModal(odcId, odcName, connectionCount);
    }, 300);
}

function deleteOdcFromList(odcId, odcName) {
    $('#odcListModal').modal('hide');
    
    // Wait for modal to close then delete
    setTimeout(function() {
        deleteOdcFromMap(odcId, odcName);
    }, 300);
}

// ODP Wrapper Functions
function showOdpDetailFromList(odpId) {
    $('#odpListModal').modal('hide');
    
    // Wait for modal to close then show detail
    setTimeout(function() {
        showOdpDetail(odpId);
    }, 300);
}

function editOdpFromList(odpId) {
    $('#odpListModal').modal('hide');
    
    // Wait for modal to close then edit
    setTimeout(function() {
        editOdpFromMap(odpId);
    }, 300);
}

function showOdpDisconnectFromList(odpId, odpName, connectionCount) {
    $('#odpListModal').modal('hide');
    
    // Wait for modal to close then show disconnect
    setTimeout(function() {
        showOdpDisconnectModal(odpId, odpName, connectionCount);
    }, 300);
}

function deleteOdpFromList(odpId, odpName) {
    $('#odpListModal').modal('hide');
    
    // Wait for modal to close then delete
    setTimeout(function() {
        deleteOdpFromMap(odpId, odpName);
    }, 300);
}
// Add Functions
function addOdcFromList() {
    $('#odcListModal').modal('hide');
    
    // Wait for modal to close then start quick add
    setTimeout(function() {
        startQuickAddMode('odc');
    }, 300);
}

function addOdpFromList() {
    $('#odpListModal').modal('hide');
    
    // Wait for modal to close then start quick add
    setTimeout(function() {
        startQuickAddMode('odp');
    }, 300);
}
function editOdcFromMap(odcId) {
    // Pastikan menggunakan modal edit, bukan redirect
    editOdcModal(odcId);
}

function editOdcModal(odcId) {
    // Show loading
    Swal.fire({
        title: 'Loading ODC Data...',
        text: 'Please wait while we fetch ODC information',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    // Fetch ODC data for edit
    fetch(baseUrl + 'plugin/network_mapping/edit-odc-modal&id=' + odcId)
        .then(response => response.json())
        .then(data => {
            Swal.close();
            
            if (data.success) {
                // Populate edit modal with data
                populateOdcEditModal(data);
                $('#editOdcModal').modal('show');
            } else {
                Swal.fire('Error', data.message || 'Failed to load ODC data', 'error');
            }
        })
        .catch(error => {
            Swal.close();
            console.error('Error:', error);
            Swal.fire('Error', 'Failed to load ODC data. Please try again.', 'error');
        });
}

function populateOdcEditModal(data) {
    // Populate form fields
    document.getElementById('edit-odc-id').value = data.odc.id;
    document.getElementById('edit-odc-name').value = data.odc.name;
    document.getElementById('edit-odc-description').value = data.odc.description || '';
    document.getElementById('edit-odc-coordinates').value = data.odc.coordinates || '';
    document.getElementById('edit-odc-address').value = data.odc.address || '';
    document.getElementById('edit-odc-total-ports').value = data.odc.total_ports;
    document.getElementById('edit-odc-status').value = data.odc.status;
    
    // Update modal title
    document.getElementById('edit-odc-title').textContent = data.odc.name;
    
    // Populate router dropdown
    var routerSelect = document.getElementById('edit-odc-router');
    routerSelect.innerHTML = '<option value="">Select Router (Optional)</option>';
    data.routers.forEach(function(router) {
        var option = document.createElement('option');
        option.value = router.id;
        option.textContent = router.name;
        if (router.id == data.odc.router_id) {
            option.selected = true;
        }
        routerSelect.appendChild(option);
    });
    
    // Populate parent ODC dropdown
    var parentSelect = document.getElementById('edit-odc-parent');
    parentSelect.innerHTML = '<option value="">Select Parent ODC (Optional)</option>';
    data.parent_odcs.forEach(function(parentOdc) {
        var option = document.createElement('option');
        option.value = parentOdc.id;
        option.textContent = parentOdc.name + ' (' + parentOdc.used_ports + '/' + parentOdc.total_ports + ' ports)';
        if (parentOdc.id == data.odc.parent_odc_id) {
            option.selected = true;
        }
        parentSelect.appendChild(option);
    });
    
    // Handle port selection
    if (data.odc.parent_odc_id) {
        document.getElementById('edit-port-selection-section').style.display = 'block';
        loadEditPortOptions(data.odc.parent_odc_id, data.odc.port_number);
    } else {
        document.getElementById('edit-port-selection-section').style.display = 'none';
    }
    
    // Setup parent ODC change handler
    parentSelect.onchange = function() {
        if (this.value) {
            document.getElementById('edit-port-selection-section').style.display = 'block';
            loadEditPortOptions(this.value);
        } else {
            document.getElementById('edit-port-selection-section').style.display = 'none';
        }
    };
}

function loadEditPortOptions(odcId, currentPort = null) {
    var portSelect = document.getElementById('edit-odc-parent-port');
    portSelect.innerHTML = '<option value="">Loading...</option>';
    portSelect.disabled = true;
    
    fetch(baseUrl + 'plugin/network_mapping/get-available-ports&odc_id=' + odcId)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                portSelect.innerHTML = '<option value="">Auto-select port</option>';
                
                // Add available ports
                data.available_ports.forEach(function(port) {
                    var option = document.createElement('option');
                    option.value = port;
                    option.textContent = 'Port ' + port;
                    portSelect.appendChild(option);
                });
                
                // Add current port if editing
                if (currentPort) {
                    var currentOption = Array.from(portSelect.options).find(opt => opt.value == currentPort);
                    if (!currentOption) {
                        var option = document.createElement('option');
                        option.value = currentPort;
                        option.textContent = 'Port ' + currentPort + ' (current)';
                        portSelect.appendChild(option);
                    }
                    portSelect.value = currentPort;
                }
                
                portSelect.disabled = false;
                
                // Update port status info
                updateEditPortStatusInfo(data.used_ports_detail);
            } else {
                portSelect.innerHTML = '<option value="">Error loading ports</option>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            portSelect.innerHTML = '<option value="">Error loading ports</option>';
        });
}

function updateEditPortStatusInfo(usedPortsDetail) {
    var infoDiv = document.getElementById('edit-port-status-info');
    if (!infoDiv) return;
    
    var html = '';
    if (usedPortsDetail && Object.keys(usedPortsDetail).length > 0) {
        html += '<div class="alert alert-warning" style="margin-top: 8px; padding: 8px; font-size: 11px;">';
        html += '<strong>Used Ports:</strong><br>';
        Object.keys(usedPortsDetail).forEach(function(port) {
            var detail = usedPortsDetail[port];
            html += '• Port ' + port + ': ' + detail.name + ' (' + detail.type.toUpperCase() + ')<br>';
        });
        html += '</div>';
    }
    
    infoDiv.innerHTML = html;
}
