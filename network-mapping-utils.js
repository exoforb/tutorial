

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
// ===== CABLE STATUS FUNCTIONS =====

function getCableConnectionStatus(entityType, entityId) {
    if (!cableRoutes || cableRoutes.length === 0) {
        return '';
    }

    var incomingCables = [];
    var outgoingCables = [];

    // Find cables connected to this entity
    cableRoutes.forEach(function (cable) {
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
    incomingCables = incomingCables.filter(function (cable) {
        return cable.from_type !== 'pole';
    });

    outgoingCables = outgoingCables.filter(function (cable) {
        return cable.to_type !== 'pole';
    });

    var cableInfo = '';

    if (incomingCables.length > 0) {
        cableInfo +=
            '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(40, 167, 69, 0.1); border-left: 3px solid #28a745; font-size: 11px;">';
        cableInfo += '<i class="fa fa-arrow-down text-success"></i> <strong>Cable Input:</strong><br>';

        incomingCables.forEach(function (cable, index) {
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

        outgoingCables.forEach(function (cable, index) {
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
        connectedOdc = networkData.odcs.find(function (odc) {
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
        connectedOdp = networkData.odps.find(function (odp) {
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
    if (networkData.odcs) {
        networkData.odcs.forEach(function (odc) {
            var marker = allMarkers['odc_' + odc.id];
            if (marker) {
                var cableStatus = getCableConnectionStatus('odc', odc.id);
                var portStatus = odc.port_status || '';
                var childPortStatus = odc.child_port_status || '';
                var originalContent = marker.data.popup_content;

                // Add Route Cable if not exists
                if (originalContent.indexOf('Route Cable') === -1) {
                    originalContent = originalContent.replace(
                        '<a href=\'javascript:void(0)\' onclick=\'deleteOdcFromMap(',
                        '<a href=\'javascript:void(0)\' onclick=\'startRoutingFromPoint("odc", ' + odc
                            .id + ', "' + odc.name + '", "' + odc.coordinates + '")\'>Route Cable</a> | ' +
                        '<a href=\'javascript:void(0)\' onclick=\'deleteOdcFromMap('
                    );
                }

                var newContent = originalContent + '<br>' + cableStatus + portStatus + childPortStatus;
                marker.marker.setPopupContent(newContent);
                marker.data.popup_content = originalContent; // Update stored content
            }
        });
    }

    // Update ODP popups  
    if (networkData.odps) {
        networkData.odps.forEach(function (odp) {
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

    // Update Customer popups
    if (networkData.customers) {
        networkData.customers.forEach(function (customer) {
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

    // TAMBAHAN BARU: Update Poles popups (NO ROUTE CABLE, NO CABLE STATUS)
    if (networkData.poles) {
        networkData.poles.forEach(function (pole) {
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
    console.log('DEBUG: handleMarkerClickForRouting called with:', { type, id, name, coordinates });
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
    var existingRoute = cableRoutes.find(function (route) {
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


// ===== CUSTOMER PHOTO MODAL TANPA SCROLL =====

function getCustomerInitials(name) {
    return name.split(' ').map(function (n) { return n[0]; }).join('').substr(0, 2).toUpperCase();
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

window.onload = function () {
    initializeMap();
    // Initialize live search
    initializeLiveSearch();

    // Initialize navigation panel
    setTimeout(function () {
        initializeNavigationPanel();

        // TAMBAHKAN INI: Reset quick add button state
        resetQuickAddButton();
    }, 2000);

    // Initialize keyboard shortcuts
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && cableRoutingMode) {
            cancelCableRouting();
        }
        if (e.key === 'Enter' && cableRoutingMode && routingFromPoint && currentWaypoints.length >= 2) {
            // Auto-complete routing with nearest point (future enhancement)
        }
    });


    // Initialize keyboard shortcuts
    document.addEventListener('keydown', function (e) {
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
    document.getElementById('quickAddOdcForm').addEventListener('submit', function (e) {
        e.preventDefault();
        saveQuickAddOdc();
    });

    document.getElementById('quickAddOdpForm').addEventListener('submit', function (e) {
        e.preventDefault();
        saveQuickAddOdp();
    });

    // TAMBAHAN BARU UNTUK POLE
    document.getElementById('quickAddPoleForm').addEventListener('submit', function (e) {
        e.preventDefault();
        saveQuickAddPole();
    });
    // Edit ODC Form Handler
    document.getElementById('editOdcForm').addEventListener('submit', function (e) {
        e.preventDefault();
        saveEditOdc();
    });
    // Edit ODP Form Handler
    document.getElementById('editOdpForm').addEventListener('submit', function (e) {
        e.preventDefault();
        saveEditOdp();
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
    navToggle.addEventListener('click', function (e) {
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
    navPanel.addEventListener('mouseenter', function () {
        clearAutoMinimizeTimer();
        isNavPanelActive = true;
    });

    navPanel.addEventListener('mouseleave', function () {
        isNavPanelActive = false;

        // PERBAIKAN: Jangan start auto-minimize timer jika dalam Quick Add mode
        if (!quickAddMode) {
            startAutoMinimizeTimer();
        }
    });

    // Prevent auto-minimize when clicking inside panel
    navPanel.addEventListener('click', function (e) {
        e.stopPropagation();
        clearAutoMinimizeTimer();
        startAutoMinimizeTimer();
    });

    // Auto-minimize when clicking empty map area
    document.getElementById('map').addEventListener('click', function (e) {
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
        map.on('moveend zoomend', function () {
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
    navAutoMinimizeTimer = setTimeout(function () {
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

