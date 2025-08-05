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
                setTimeout(function () {
                    performLiveSearch(searchTarget);

                    // Auto-navigate to first result after search completes
                    setTimeout(function () {
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

            setTimeout(function () {
                scrollToMap();
                performLiveSearch(searchTarget);
                setTimeout(function () {
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
    searchInput.addEventListener('input', function () {
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

        searchTimeout = setTimeout(function () {
            performLiveSearch(query);
        }, 300); // Delay 300ms setelah user berhenti mengetik
    });

    // Clear search
    clearButton.addEventListener('click', function () {
        searchInput.value = '';
        hideSearchResults();
        searchInput.focus();
    });

    // Hide results ketika click di luar
    document.addEventListener('click', function (e) {
        if (!e.target.closest('#live-search-container')) {
            hideSearchResults();
        }
    });

    // Show results ketika focus pada input
    searchInput.addEventListener('focus', function () {
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
                    networkData.routers.forEach(function (router) {
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
                    networkData.odcs.forEach(function (odc) {
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
                    networkData.odps.forEach(function (odp) {
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
                    networkData.customers.forEach(function (customer) {
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
                    networkData.poles.forEach(function (pole) {
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
            networkData.routers.forEach(function (router) {
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
            networkData.odcs.forEach(function (odc) {
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
            networkData.odps.forEach(function (odp) {
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
            networkData.customers.forEach(function (customer) {
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
            networkData.poles.forEach(function (pole) {
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

    displayResults.forEach(function (result) {
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
        case 'odc':
            zoomLevel = 19;
            break;
        case 'odp':
            zoomLevel = 19;
            break;
        case 'customer':
            zoomLevel = 19;
            break;
        case 'pole': // TAMBAHAN BARU
            zoomLevel = 18;
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
    setTimeout(function () {
        // Find and open popup if marker exists
        var markerKey = type + '_' + id;
        if (allMarkers[markerKey] && allMarkers[markerKey].marker) {
            // Open popup after animation completes
            setTimeout(function () {
                allMarkers[markerKey].marker.openPopup();

                // Temporary highlight effect
                var markerElement = document.querySelector('[data-type="' + type + '"][data-id="' +
                    id + '"]');
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
    setTimeout(function () {
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
    setTimeout(function () {
        if (indicator && indicator.parentNode) {
            indicator.style.opacity = '0';
            indicator.style.transform = 'translateY(-20px)';
            setTimeout(function () {
                if (indicator && indicator.parentNode) {
                    indicator.parentNode.removeChild(indicator);
                }
            }, 300);
        }
    }, 2000);
}