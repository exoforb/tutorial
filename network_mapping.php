<?php
// File: system/plugin/network_mapping.php

register_menu("Network Mapping", true, "network_mapping", 'AFTER_PLANS', 'ion ion-ios-location');

function network_mapping()
{
    global $ui, $routes;
    _admin();
    $ui->assign('_title', 'Mapping Jaringan FFTH');
    $ui->assign('_system_menu', 'network_mapping');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    $action = isset($routes['2']) ? $routes['2'] : '';

    switch ($action) {
        // TAMBAH: edit modal functions
        case 'edit-odc-modal':
            network_mapping_edit_odc_modal();
            break;
        case 'edit-odp-modal':
            network_mapping_edit_odp_modal();
            break;
        case 'update-odc-modal':
            network_mapping_update_odc_modal();
            break;
        case 'update-odp-modal':
            network_mapping_update_odp_modal();
            break;
        case 'delete-odc':
            network_mapping_delete_odc();
            break;
        case 'delete-odp':
            network_mapping_delete_odp();
            break;
        case 'api-router-name':
            network_mapping_api_router_name();
            break;
        case 'api-odc-name':
            network_mapping_api_odc_name();
            break;
        case 'save-cable-route':
            network_mapping_save_cable_route();
            break;
        case 'api-cable-routes':
            network_mapping_api_cable_routes();
            break;
        case 'delete-cable-route':
            network_mapping_delete_cable_route();
            break;
        case 'quick-add-odc':
            network_mapping_quick_add_odc();
            break;
        case 'quick-add-odp':
            network_mapping_quick_add_odp();
            break;
        case 'quick-save-odc':
            network_mapping_quick_save_odc();
            break;
        case 'quick-save-odp':
            network_mapping_quick_save_odp();
            break;
        case 'ajax-delete-odc':
            network_mapping_ajax_delete_odc();
            break;
        case 'ajax-delete-odp':
            network_mapping_ajax_delete_odp();
            break;
        case 'search-customers':
            network_mapping_search_customers();
            break;
        case 'debug-ports':
            network_mapping_debug_ports();
            break;
        case 'get-odc-connections':
            network_mapping_get_odc_connections();
            break;
        case 'get-odp-connections':
            network_mapping_get_odp_connections();
            break;
        case 'disconnect-from-odc':
            network_mapping_disconnect_from_odc();
            break;
        case 'disconnect-from-odp':
            network_mapping_disconnect_from_odp();
            break;
        case 'get-available-ports':
            network_mapping_get_available_ports();
            break;
        case 'get-available-ports-odp':
            network_mapping_get_available_ports_odp();
            break;
        case 'list-odc-modal':
            network_mapping_list_odc_modal();
            break;
        case 'list-odp-modal':
            network_mapping_list_odp_modal();
            break;

        // TAMBAHAN BARU UNTUK POLES
        case 'quick-add-pole':
            network_mapping_quick_add_pole();
            break;
        case 'quick-save-pole':
            network_mapping_quick_save_pole();
            break;
        case 'ajax-delete-pole':
            network_mapping_ajax_delete_pole();
            break;
        case 'get-network-devices':
            network_mapping_get_network_devices();
            break;
        case 'get-pole-bridges':
            network_mapping_get_pole_bridges();
            break;
        case 'edit-pole-bridges':
            network_mapping_edit_pole_bridges();
            break;
        case 'update-bridge-status':
            network_mapping_update_bridge_status();
            break;
        case 'delete-bridge-from-pole':
            network_mapping_delete_bridge_from_pole();
            break;
        default:
            network_mapping_main();
            break;
    }
}




function network_mapping_main()
{
    global $ui;

    // Get search parameter
    $search = _req('search');

    // Get all active routers with coordinates
    $routers_query = ORM::for_table('tbl_routers')
        ->where_not_equal('coordinates', '')
        ->where('enabled', 1)
        ->order_by_asc('name');

    if (!empty($search)) {
        $routers_query->where_like('name', '%' . $search . '%');
    }

    $routers = $routers_query->find_array();

    // Get all active ODCs with coordinates
    $odcs_query = ORM::for_table('tbl_odc')
        ->where_not_equal('coordinates', '')
        ->where('status', 'Active')
        ->order_by_asc('name');

    if (!empty($search)) {
        $odcs_query->where_like('name', '%' . $search . '%');
    }

    $odcs = $odcs_query->find_array();

    // Get all active ODPs with coordinates
    $odps_query = ORM::for_table('tbl_odp')
        ->where_not_equal('coordinates', '')
        ->where('status', 'Active')
        ->order_by_asc('name');

    if (!empty($search)) {
        $odps_query->where_like('name', '%' . $search . '%');
    }

    $odps = $odps_query->find_array();

    // Get customers with coordinates
    $customers_query = ORM::for_table('tbl_customers')
        ->where_not_equal('coordinates', '')
        ->where('status', 'Active')
        ->order_by_asc('fullname');

    if (!empty($search)) {
        $customers_query->where_raw("(fullname LIKE '%$search%' OR username LIKE '%$search%')");
    }

    $customers = $customers_query->find_array();

    // Get poles with coordinates
    $poles_query = ORM::for_table('tbl_poles')
        ->where_not_equal('coordinates', '')
        ->where('status', 'Active')
        ->order_by_asc('name');

    if (!empty($search)) {
        $poles_query->where_like('name', '%' . $search . '%');
    }

    $poles = $poles_query->find_array();

    // Format data for mapping
    $network_data = [
        'routers' => [],
        'odcs' => [],
        'odps' => [],
        'customers' => [],
        'poles' => []  // TAMBAHAN BARU
    ];

    // Format routers data
    foreach ($routers as $router) {
        $network_data['routers'][] = [
            'id' => $router['id'],
            'name' => $router['name'],
            'type' => 'router',
            'coordinates' => $router['coordinates'],
            'description' => $router['description'],
            'coverage' => $router['coverage'] ?? 1000,
            'enabled' => $router['enabled'],
            'popup_content' => "<strong>Router: " . $router['name'] . "</strong><br>" .
                "Description: " . $router['description'] . "<br>" .
                "<a href='javascript:void(0)' onclick='showRouterDetail(" . $router['id'] . ")'>Detail</a> | " .
                "<a href='https://www.google.com/maps/dir//" . $router['coordinates'] . "' target='_blank'>Direction</a>"
        ];
    }

    // Format ODCs data
    foreach ($odcs as $odc) {
        // Count ODPs connected to this ODC
        $connected_odps = ORM::for_table('tbl_odp')
            ->where('odc_id', $odc['id'])
            ->where('status', 'Active')
            ->count();

        // Count child ODCs connected to this ODC (ODCs that use this ODC as parent)
        $connected_child_odcs = ORM::for_table('tbl_odc')
            ->where('parent_odc_id', $odc['id'])
            ->where('status', 'Active')
            ->count();

        // Total used ports = ODPs + child ODCs
        $total_used_ports = $connected_odps + $connected_child_odcs;

        // Update database with actual count
        $update_odc = ORM::for_table('tbl_odc')->find_one($odc['id']);
        if ($update_odc) {
            $update_odc->used_ports = $total_used_ports;
            $update_odc->save();
        }

        $available_ports = $odc['total_ports'] - $total_used_ports;

        // Get connection info (router or parent ODC)
        $connection_info = '';
        if ($odc['router_id']) {
            $connected_router = ORM::for_table('tbl_routers')->find_one($odc['router_id']);
            if ($connected_router) {
                $connection_info = "<br>Uplink: <strong>" . $connected_router->name . " (Router)</strong>";
            }
        } elseif ($odc['parent_odc_id']) {
            $parent_odc = ORM::for_table('tbl_odc')->find_one($odc['parent_odc_id']);
            if ($parent_odc) {
                $connection_info = "<br>Uplink: <strong>" . $parent_odc->name . " (ODC)</strong>";
            }
        }

        // Get port status display
        $port_status = getPortStatusDisplay($odc['id']);
        $child_port_status = getChildConnectionPortDisplay($odc['id']);

        // Add unplug button if has connections
        $unplugBtn = $total_used_ports > 0 ?
            " | <a href='javascript:void(0)' onclick='showOdcDisconnectModal(" . $odc['id'] . ", \"" . $odc['name'] .
            "\", " . $total_used_ports . ")' style='color: #bc8d4bff;'>Unplug (" . $total_used_ports . ")</a>" : "";

        // Get port status display
        $port_status = getPortStatusDisplay($odc['id']);
        $child_port_status = getChildConnectionPortDisplay($odc['id']);

        $network_data['odcs'][] = [
            'id' => $odc['id'],
            'name' => $odc['name'],
            'type' => 'odc',
            'coordinates' => $odc['coordinates'],
            'description' => $odc['description'],
            'total_ports' => $odc['total_ports'],
            'used_ports' => $total_used_ports,
            'available_ports' => $available_ports,
            'router_id' => $odc['router_id'],
            'port_status' => $port_status,
            'child_port_status' => $child_port_status,
            'popup_content' => "<strong>ODC: " . $odc['name'] . "</strong><br>" .
                "Ports: " . $total_used_ports . "/" . $odc['total_ports'] . " (Available: " . $available_ports . ")<br>" .
                "Address: " . $odc['address'] . $connection_info . "<br>" .
                "<a href='javascript:void(0)' onclick='showOdcDetail(" . $odc['id'] . ")'>Detail</a> | " .
                "<a href='javascript:void(0)' onclick='editOdcFromMap(" . $odc['id'] . ")'>Edit</a>" . $unplugBtn . " | " .
                "<a href='javascript:void(0)' onclick='deleteOdcFromMap(" . $odc['id'] . ", \"" . $odc['name'] . "\")' style='color: #d9534f;'>Delete</a> | " .
                "<a href='https://www.google.com/maps/dir//" . $odc['coordinates'] . "' target='_blank'>Direction</a>"
        ];
    }

    // Format ODPs data
    foreach ($odps as $odp) {
        $available_ports = $odp['total_ports'] - $odp['used_ports'];
        // Get connected ODC info with port information
        $odc_info = '';
        $child_port_status = '';
        if ($odp['odc_id']) {
            $connected_odc = ORM::for_table('tbl_odc')->find_one($odp['odc_id']);
            if ($connected_odc) {
                $odc_info = "<br>Uplink: <strong>" . $connected_odc->name . "</strong>";

                // Get port connection info for ODP
                if ($odp['port_number']) {
                    $child_port_status = '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(23, 162, 184, 0.1); border-left: 3px solid #17a2b8; font-size: 11px;">';
                    $child_port_status .= '<i class="fa fa-link text-info"></i> <strong>Connected to Port:</strong><br>';
                    $child_port_status .= '• Port ' . $odp['port_number'] . ' (' . $connected_odc->name . ')';
                    $child_port_status .= '</div>';
                }
            }
        }

        // Add unplug button if has connections
        $unplugBtn = $odp['used_ports'] > 0 ?
            " | <a href='javascript:void(0)' onclick='showOdpDisconnectModal(" . $odp['id'] . ", \"" . $odp['name'] .
            "\", " . $odp['used_ports'] . ")' style='color: #bc8d4bff;'> Unplug (" . $odp['used_ports'] . ")</a>" : "";

        // Get port status display for ODP
        $odp_port_status = getOdpPortStatusDisplay($odp['id']);

        // Add port status to popup content
        $popupContent = $popupContent . '<br>' . $child_port_status . $odp_port_status;

        $network_data['odps'][] = [
            'id' => $odp['id'],
            'name' => $odp['name'],
            'type' => 'odp',
            'coordinates' => $odp['coordinates'],
            'description' => $odp['description'],
            'total_ports' => $odp['total_ports'],
            'used_ports' => $odp['used_ports'],
            'available_ports' => $available_ports,
            'odc_id' => $odp['odc_id'],
            'port_number' => $odp['port_number'],
            'port_status' => $odp_port_status,
            'popup_content' => "<strong>ODP: " . $odp['name'] . "</strong><br>" .
                "Ports: " . $odp['used_ports'] . "/" . $odp['total_ports'] . " (Available: " . $available_ports . ")<br>" .
                "Address: " . $odp['address'] . $odc_info . "<br>" .
                "<a href='javascript:void(0)' onclick='showOdpDetail(" . $odp['id'] . ")'>Detail</a> | " .
                "<a href='javascript:void(0)' onclick='editOdpFromMap(" . $odp['id'] . ")'>Edit</a>" . $unplugBtn . " | " .
                "<a href='javascript:void(0)' onclick='deleteOdpFromMap(" . $odp['id'] . ", \"" . $odp['name'] . "\")' style='color: #d9534f;'>Delete</a> | " .
                "<a href='https://www.google.com/maps/dir//" . $odp['coordinates'] . "' target='_blank'>Direction</a>"
        ];
    }

    // Format customers data
    foreach ($customers as $customer) {
        // Get ODP connection info
        $odp_info = '';
        if ($customer['odp_id']) {
            $connected_odp = ORM::for_table('tbl_odp')->find_one($customer['odp_id']);
            if ($connected_odp) {
                $odp_info = "<br>Connected to: <strong>" . $connected_odp->name . "</strong>";
            }
        }

        // ✅ PERBAIKAN: Process customer photo dengan auto-prefix system/uploads
        $photo_html = '';
        if (!empty($customer['photo']) && $customer['photo'] !== '/user.default.jpg' && strpos($customer['photo'], 'user.default.jpg') === false) {
            // Check if photo path starts with http/https (external URL)
            if (strpos($customer['photo'], 'http') === 0) {
                $photo_url = $customer['photo'];
            } else {
                // ✅ AUTO-PREFIX: Semua foto ada di /system/uploads
                $photo_url = '/system/uploads' . $customer['photo'];

                // Debug log
                error_log("Customer {$customer['id']} - Original path: {$customer['photo']}, Final URL: {$photo_url}");
            }

            // ✅ PERBAIKAN: HTML structure yang benar untuk photo/avatar switching
            $initials = '';
            $name_parts = explode(' ', trim($customer['fullname']));
            if (count($name_parts) >= 2) {
                $initials = strtoupper(substr($name_parts[0], 0, 1) . substr($name_parts[1], 0, 1));
            } else {
                $initials = strtoupper(substr($customer['fullname'], 0, 2));
            }

            $photo_html = '<div style="text-align: center; margin: 8px 0;">' .
                '<div class="customer-photo-container" style="width: 60px; height: 60px; margin: 0 auto; position: relative;">' .
                '<img src="' . $photo_url . '" alt="' . htmlspecialchars($customer['fullname']) . '" ' .
                'style="width: 60px; height: 60px; border-radius: 50%; object-fit: cover; border: 3px solid #17a2b8; box-shadow: 0 2px 8px rgba(0,0,0,0.2); display: block; cursor: pointer;" ' .
                'onclick="showCustomerPhotoModal(\'' . $photo_url . '\', \'' . addslashes($customer['fullname']) . '\', \'Username: ' . $customer['username'] . '<br>Balance: Rp ' . number_format($customer['balance'], 0, ',', '.') . '<br>Address: ' . addslashes($customer['address']) . '\')" ' .
                'onerror="handlePhotoError(this)">' .
                '<div class="customer-avatar-fallback" style="display: none; width: 60px; height: 60px; border-radius: 50%; background: linear-gradient(135deg, #17a2b8, #138496); color: white; align-items: center; justify-content: center; font-weight: bold; font-size: 18px; border: 3px solid #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.2); position: absolute; top: 0; left: 0;">' .
                $initials .
                '</div>' .
                '</div>' .
                '</div>';
        } else {
            // No photo or default photo - show avatar with initials
            $initials = '';
            $name_parts = explode(' ', trim($customer['fullname']));
            if (count($name_parts) >= 2) {
                $initials = strtoupper(substr($name_parts[0], 0, 1) . substr($name_parts[1], 0, 1));
            } else {
                $initials = strtoupper(substr($customer['fullname'], 0, 2));
            }

            $photo_html = '<div style="text-align: center; margin: 8px 0;">' .
                '<div style="width: 60px; height: 60px; margin: 0 auto; border-radius: 50%; background: linear-gradient(135deg, #17a2b8, #138496); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 18px; border: 3px solid #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">' .
                $initials .
                '</div>' .
                '</div>';
        }

        $network_data['customers'][] = [
            'id' => $customer['id'],
            'name' => $customer['fullname'],
            'type' => 'customer',
            'coordinates' => $customer['coordinates'],
            'username' => $customer['username'],
            'balance' => $customer['balance'],
            'address' => $customer['address'],
            'odp_id' => $customer['odp_id'],
            'port_number' => $customer['port_number'],
            'connection_status' => $customer['connection_status'],
            'photo' => $customer['photo'], // ✅ TAMBAH PHOTO DATA
            'popup_content' => $photo_html . // ✅ TAMBAH PHOTO DI AWAL POPUP
                "<strong>Customer: " . $customer['fullname'] . "</strong><br>" .
                "Username: " . $customer['username'] . "<br>" .
                "Balance: Rp " . number_format($customer['balance'], 0, ',', '.') . "<br>" .
                "Address: " . $customer['address'] . $odp_info . "<br>" .
                "<div id='customer-cable-status-" . $customer['id'] . "'></div>" .
                "<a href='" . U . "customers/view/" . $customer['id'] . "'>Detail</a> | " .
                "<a href='https://www.google.com/maps/dir//" . $customer['coordinates'] . "' target='_blank'>Direction</a>"
        ];
    }

    // Format Poles data
    foreach ($poles as $pole) {
        // Get multiple bridges info
        $bridges = getPoleBridges($pole['id']);
        $connection_info = '';

        if (!empty($bridges)) {
            $connection_info = "<br><strong>Bridges:</strong><br>";
            foreach ($bridges as $index => $bridge) {
                $bridge_num = $index + 1;

                // Create clickable from device
                $from_link = $bridge['from_name'];
                if ($bridge['from_coordinates'] && $bridge['from_type'] !== 'cust_all') {
                    $from_link = "<a href='javascript:void(0)' onclick=\"goToSearchResult('" .
                        $bridge['from_type'] . "', " . $bridge['from_id'] . ", '" .
                        $bridge['from_coordinates'] . "', '" . addslashes($bridge['from_name']) .
                        "')\" style='color: #007bff; text-decoration: none;'>" . $bridge['from_name'] . "</a>";
                }

                // Create clickable to device  
                $to_link = $bridge['to_name'];
                if ($bridge['to_coordinates'] && $bridge['to_type'] !== 'cust_all') {
                    $to_link = "<a href='javascript:void(0)' onclick=\"goToSearchResult('" .
                        $bridge['to_type'] . "', " . $bridge['to_id'] . ", '" .
                        $bridge['to_coordinates'] . "', '" . addslashes($bridge['to_name']) .
                        "')\" style='color: #007bff; text-decoration: none;'>" . $bridge['to_name'] . "</a>";
                }

                $connection_info .= "{$bridge_num}. <strong>{$from_link} → {$to_link}</strong><br>";
            }
            // Keep the last <br> for proper spacing
        }

        // Legacy support - check if old single bridge exists
        if (empty($bridges) && $pole['from_type'] && $pole['to_type']) {
            $from_name = '';
            $to_name = '';

            if ($pole['from_type'] === 'cust_all') {
                $from_name = 'CUSTOMER';
            } elseif ($pole['from_id']) {
                $from_name = getPoleConnectionName($pole['from_type'], $pole['from_id']);
            }

            if ($pole['to_type'] === 'cust_all') {
                $to_name = 'CUSTOMER';
            } elseif ($pole['to_id']) {
                $to_name = getPoleConnectionName($pole['to_type'], $pole['to_id']);
            }

            if ($from_name && $to_name) {
                $connection_info = "<br><strong>Bridge:</strong><br>" . $from_name . " → " . $to_name . "<br>";
            }
        }

        // Format the popup content with proper line breaks dan TAMBAH EDIT BUTTON
        $popup_content = "<strong>Tiang: " . $pole['name'] . "</strong><br>" .
            "Address: " . ($pole['address'] ?: 'No address') . $connection_info .
            "<a href='javascript:void(0)' onclick='showPoleDetail(" . $pole['id'] . ")'>Detail</a> | " .
            "<a href='javascript:void(0)' onclick='showEditPoleBridgesModal(" . $pole['id'] . ", \"" . $pole['name'] . "\")'>Edit</a> | " .
            "<a href='javascript:void(0)' onclick='deletePoleFromMap(" . $pole['id'] . ", \"" . $pole['name'] . "\")' style='color: #d9534f;'>Delete</a> | " .
            "<a href='https://www.google.com/maps/dir//" . $pole['coordinates'] . "' target='_blank'>Direction</a>";

        $network_data['poles'][] = [
            'id' => $pole['id'],
            'name' => $pole['name'],
            'type' => 'pole',
            'coordinates' => $pole['coordinates'],
            'description' => $pole['description'],
            'from_type' => $pole['from_type'],
            'from_id' => $pole['from_id'],
            'to_type' => $pole['to_type'],
            'to_id' => $pole['to_id'],
            'popup_content' => $popup_content
        ];
    }

    // Count statistics
    $stats = [
        'total_routers' => count($network_data['routers']),
        'total_odcs' => count($network_data['odcs']),
        'total_odps' => count($network_data['odps']),
        'total_customers' => count($network_data['customers']),
        'total_poles' => count($network_data['poles'])  // TAMBAHAN BARU
    ];

    $ui->assign('search', $search);
    $ui->assign('network_data', $network_data);
    $ui->assign('stats', $stats);
    $ui->assign('csrf_token', Csrf::generateAndStoreToken());
    // Remove xheader and xfooter - we'll load Leaflet directly in template
    $ui->display('network_mapping_main.tpl');
}

function network_mapping_odc()
{
    global $ui;

    $search = _req('search');
    $query = ORM::for_table('tbl_odc')
        ->select('tbl_odc.*')
        ->select('tbl_routers.name', 'router_name')
        ->left_outer_join('tbl_routers', array('tbl_odc.router_id', '=', 'tbl_routers.id'))
        ->order_by_desc('tbl_odc.id');

    if (!empty($search)) {
        $query->where_like('tbl_odc.name', '%' . $search . '%');
    }

    $d = Paginator::findMany($query, ['search' => $search], 25);

    $ui->assign('d', $d);
    $ui->assign('search', $search);
    $ui->assign('csrf_token', Csrf::generateAndStoreToken());
    $ui->display('network_mapping_odc_list.tpl');
}

function network_mapping_odp()
{
    global $ui;

    $search = _req('search');
    $query = ORM::for_table('tbl_odp')
        ->select('tbl_odp.*')
        ->select('tbl_odc.name', 'odc_name')
        ->left_outer_join('tbl_odc', array('tbl_odp.odc_id', '=', 'tbl_odc.id'))
        ->order_by_desc('tbl_odp.id');

    if (!empty($search)) {
        $query->where_like('tbl_odp.name', '%' . $search . '%');
    }

    $d = Paginator::findMany($query, ['search' => $search], 25);

    $ui->assign('d', $d);
    $ui->assign('search', $search);
    $ui->assign('csrf_token', Csrf::generateAndStoreToken());
    $ui->display('network_mapping_odp_list.tpl');
}



function network_mapping_delete_odc()
{
    $id = _req('id');
    $odc = ORM::for_table('tbl_odc')->find_one($id);

    if ($odc) {
        // Check if ODC has connected ODPs or child ODCs
        $connected_odps = ORM::for_table('tbl_odp')
            ->where('odc_id', $id)
            ->where('status', 'Active')
            ->count();

        $connected_child_odcs = ORM::for_table('tbl_odc')
            ->where('parent_odc_id', $id)
            ->where('status', 'Active')
            ->count();

        if ($connected_odps > 0) {
            r2(U . 'plugin/network_mapping/odc', 'e', 'Cannot delete ODC. ' . $connected_odps . ' ODPs are still connected.');
            return;
        }

        if ($connected_child_odcs > 0) {
            r2(U . 'plugin/network_mapping/odc', 'e', 'Cannot delete ODC. ' . $connected_child_odcs . ' child ODCs are still connected.');
            return;
        }

        // Delete related cable routes
        $deleted_cables = deleteRelatedCableRoutes('odc', $id);

        // TAMBAHAN: Auto-cleanup pole bridges for all deleted cables
        $cleanup_result = cleanupPoleBridgesForDeletedDevice('odc', $id);

        // Update parent ODC port count and remove port detail
        if ($odc->parent_odc_id && $odc->port_number) {
            updateOdcPortDetail($odc->parent_odc_id, $odc->port_number, 'odc', $id, $odc->name, 'remove');
            updateOdcPortCounts($odc->parent_odc_id, null);
        }

        $odc->delete();

        $message = 'ODC berhasil dihapus';
        if ($deleted_cables > 0) {
            $message .= ' beserta ' . $deleted_cables . ' cable routes';
        }
        if ($cleanup_result > 0) {
            $message .= ' dan ' . $cleanup_result . ' pole bridges';
        }

        $message = 'ODC berhasil dihapus';
        if ($deleted_cables > 0) {
            $message .= ' beserta ' . $deleted_cables . ' cable routes';
        }

        r2(U . 'plugin/network_mapping/odc', 's', $message);
    } else {
        r2(U . 'plugin/network_mapping/odc', 'e', 'ODC tidak ditemukan');
    }
}

function network_mapping_delete_odp()
{
    $id = _req('id');
    $odp = ORM::for_table('tbl_odp')->find_one($id);

    if ($odp) {
        // Check if ODP has connected customers
        $connected_customers = ORM::for_table('tbl_customers')
            ->where('odp_id', $id)
            ->where('connection_status', 'Active')
            ->count();

        if ($connected_customers > 0) {
            r2(U . 'plugin/network_mapping/odp', 'e', 'Cannot delete ODP. ' . $connected_customers . ' customers are still connected.');
            return;
        }

        // Delete related cable routes
        $deleted_cables = deleteRelatedCableRoutes('odp', $id);

        $old_odc_id = $odp->odc_id;
        $old_port_number = $odp->port_number;

        // Remove port detail before deletion
        if ($old_odc_id && $old_port_number) {
            updateOdcPortDetail($old_odc_id, $old_port_number, 'odp', $id, $odp->name, 'remove');
        }

        $odp->delete();

        // Update ODC port counts after deletion
        updateOdcPortCounts($old_odc_id, null);

        $message = 'ODP berhasil dihapus';
        if ($deleted_cables > 0) {
            $message .= ' beserta ' . $deleted_cables . ' cable routes';
        }

        r2(U . 'plugin/network_mapping/odp', 's', $message);
    } else {
        r2(U . 'plugin/network_mapping/odp', 'e', 'ODP tidak ditemukan');
    }
}



function network_mapping_api_router_name()
{
    $id = _req('id');
    $router = ORM::for_table('tbl_routers')->find_one($id);

    if ($router) {
        echo $router->name;
    } else {
        echo 'Unknown Router';
    }
    exit;
}

function network_mapping_api_odc_name()
{
    $id = _req('id');
    $odc = ORM::for_table('tbl_odc')->find_one($id);

    if ($odc) {
        echo $odc->name;
    } else {
        echo 'Unknown ODC';
    }
    exit;
}



function network_mapping_save_cable_route()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $from_type = _req('from_type');
    $from_id = _req('from_id');
    $to_type = _req('to_type');
    $to_id = _req('to_id');
    $waypoints = _req('waypoints'); // JSON string
    $cable_type = _req('cable_type') ?: 'fiber_optic';

    if (empty($from_type) || empty($from_id) || empty($to_type) || empty($to_id)) {
        echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
        exit;
    }

    // Validasi waypoints JSON
    $waypoints_array = json_decode($waypoints, true);
    if (!is_array($waypoints_array) || count($waypoints_array) < 2) {
        echo json_encode(['success' => false, 'message' => 'Minimal 2 waypoints diperlukan']);
        exit;
    }

    // Cek apakah sudah ada koneksi yang sama
    $existing = ORM::for_table('tbl_cable_waypoints')
        ->where('from_type', $from_type)
        ->where('from_id', $from_id)
        ->where('to_type', $to_type)
        ->where('to_id', $to_id)
        ->find_one();

    if ($existing) {
        // Update existing
        $cable = $existing;
        $message = 'Cable route berhasil diupdate';
    } else {
        // Create new
        $cable = ORM::for_table('tbl_cable_waypoints')->create();
        $cable->from_type = $from_type;
        $cable->from_id = $from_id;
        $cable->to_type = $to_type;
        $cable->to_id = $to_id;
        $cable->created_at = date('Y-m-d H:i:s');
        $message = 'Cable route berhasil dibuat';
    }

    $cable->waypoints = $waypoints;
    $cable->cable_type = $cable_type;

    try {
        $cable->save();
        // ===== TAMBAHAN BARU: Auto-record bridges through poles =====
        $poles_affected = autoRecordCableThroughPoles(
            $cable->id,
            $from_type,
            $from_id,
            $to_type,
            $to_id,
            json_decode($waypoints, true)
        );

        if ($poles_affected > 0) {
            error_log("Cable route {$cable->id} auto-recorded through {$poles_affected} poles");
        }
        echo json_encode([
            'success' => true,
            'message' => $message,
            'id' => $cable->id,
            'from_name' => getCablePointName($from_type, $from_id),
            'to_name' => getCablePointName($to_type, $to_id)
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_delete_cable_route()
{
    header('Content-Type: application/json');

    // Ambil ID dari parameter GET atau POST
    $id = _req('id');

    // Validasi CSRF untuk POST request
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!Csrf::check($_POST['csrf_token'])) {
            echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
            exit;
        }
    }

    if (empty($id)) {
        echo json_encode(['success' => false, 'message' => 'ID tidak valid']);
        exit;
    }

    try {
        $cable = ORM::for_table('tbl_cable_waypoints')->find_one($id);

        if ($cable) {
            // Remove associated pole bridges first
            removePoleBridgeByCableRoute($id);
            $cable->delete();
            echo json_encode(['success' => true, 'message' => 'Cable route berhasil dihapus']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Cable route tidak ditemukan']);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_api_cable_routes()
{
    header('Content-Type: application/json');

    try {
        // ✅ NEW: Add cache headers to prevent caching issues
        header('Cache-Control: no-cache, no-store, must-revalidate');
        header('Pragma: no-cache');
        header('Expires: 0');

        // Get all cable routes untuk ditampilkan di map
        $cables = ORM::for_table('tbl_cable_waypoints')
            ->order_by_desc('id') // ✅ NEW: Order by ID for consistent results
            ->find_array();

        $routes_data = [];
        $visible_count = 0;
        $hidden_count = 0;

        foreach ($cables as $cable) {
            $waypoints = json_decode($cable['waypoints'], true);
            if (!is_array($waypoints)) {
                $waypoints = [];
            }

            // Get from/to names
            $from_name = getCablePointName($cable['from_type'], $cable['from_id']);
            $to_name = getCablePointName($cable['to_type'], $cable['to_id']);

            // ✅ ENHANCED: Better visibility handling
            $visible = isset($cable['visible']) ? (int)$cable['visible'] : 1;

            if ($visible === 1) {
                $visible_count++;
            } else {
                $hidden_count++;
            }

            $routes_data[] = [
                'id' => $cable['id'],
                'from_type' => $cable['from_type'],
                'from_id' => $cable['from_id'],
                'from_name' => $from_name,
                'to_type' => $cable['to_type'],
                'to_id' => $cable['to_id'],
                'to_name' => $to_name,
                'waypoints' => $waypoints,
                'cable_type' => $cable['cable_type'],
                'visible' => $visible, // ✅ ENHANCED: Consistent integer value
                'created_at' => $cable['created_at'],
                'updated_at' => $cable['updated_at'] ?? null // ✅ NEW: Track updates
            ];
        }

        // ✅ NEW: Enhanced response with metadata
        $response = [
            'routes' => $routes_data,
            'meta' => [
                'total_routes' => count($routes_data),
                'visible_routes' => $visible_count,
                'hidden_routes' => $hidden_count,
                'timestamp' => date('Y-m-d H:i:s')
            ]
        ];

        error_log("API Cable Routes: Total={$response['meta']['total_routes']}, Visible={$visible_count}, Hidden={$hidden_count}");

        echo json_encode($response);
    } catch (Exception $e) {
        error_log('Error in network_mapping_api_cable_routes: ' . $e->getMessage());
        echo json_encode(['error' => $e->getMessage()]);
    }

    exit;
}

function getCablePointName($type, $id)
{
    try {
        switch ($type) {
            case 'router':
                $item = ORM::for_table('tbl_routers')->find_one($id);
                return $item ? $item->name : 'Unknown Router';
            case 'odc':
                $item = ORM::for_table('tbl_odc')->find_one($id);
                return $item ? $item->name : 'Unknown ODC';
            case 'odp':
                $item = ORM::for_table('tbl_odp')->find_one($id);
                return $item ? $item->name : 'Unknown ODP';
            case 'customer':
                $item = ORM::for_table('tbl_customers')->find_one($id);
                return $item ? $item->fullname : 'Unknown Customer';
            default:
                return 'Unknown';
        }
    } catch (Exception $e) {
        return 'Error: ' . $e->getMessage();
    }
}

function updateOdcPortCounts($old_odc_id, $new_odc_id)
{
    error_log('updateOdcPortCounts called - Old ODC: ' . $old_odc_id . ', New ODC: ' . $new_odc_id);

    try {
        // Update old ODC 
        if ($old_odc_id) {
            $old_odc = ORM::for_table('tbl_odc')->find_one($old_odc_id);
            if ($old_odc) {
                // Count ODPs + child ODCs
                $connected_odps = ORM::for_table('tbl_odp')
                    ->where('odc_id', $old_odc_id)
                    ->where('status', 'Active')
                    ->count();

                $connected_child_odcs = ORM::for_table('tbl_odc')
                    ->where('parent_odc_id', $old_odc_id)
                    ->where('status', 'Active')
                    ->count();

                $total_used = $connected_odps + $connected_child_odcs;
                $old_odc->used_ports = $total_used;
                $old_odc->save();

                error_log('Updated OLD ODC ' . $old_odc->name . ' - ODPs: ' . $connected_odps . ', Child ODCs: ' . $connected_child_odcs . ', Total: ' . $total_used);
            }
        }

        // Update new ODC
        if ($new_odc_id) {
            $new_odc = ORM::for_table('tbl_odc')->find_one($new_odc_id);
            if ($new_odc) {
                // Count ODPs + child ODCs
                $connected_odps = ORM::for_table('tbl_odp')
                    ->where('odc_id', $new_odc_id)
                    ->where('status', 'Active')
                    ->count();

                $connected_child_odcs = ORM::for_table('tbl_odc')
                    ->where('parent_odc_id', $new_odc_id)
                    ->where('status', 'Active')
                    ->count();

                $total_used = $connected_odps + $connected_child_odcs;
                $new_odc->used_ports = $total_used;
                $new_odc->save();

                error_log('Updated NEW ODC ' . $new_odc->name . ' - ODPs: ' . $connected_odps . ', Child ODCs: ' . $connected_child_odcs . ', Total: ' . $total_used);
            }
        }
    } catch (Exception $e) {
        error_log('Error updating ODC port counts: ' . $e->getMessage());
    }
}

function updateOdpPortCounts($odp_id)
{
    try {
        $odp = ORM::for_table('tbl_odp')->find_one($odp_id);
        if ($odp) {
            $connected_customers = ORM::for_table('tbl_customers')
                ->where('odp_id', $odp_id)
                ->where('connection_status', 'Active')
                ->count();

            $odp->used_ports = $connected_customers;
            $odp->save();

            error_log('Updated ODP ' . $odp->name . ' - Used ports: ' . $connected_customers);
        }
    } catch (Exception $e) {
        error_log('Error updating ODP port counts: ' . $e->getMessage());
    }
}

function updateOdpPortDetail($odp_id, $port_number, $connected_type, $connected_id, $connected_name, $action = 'add')
{
    try {
        $odp = ORM::for_table('tbl_odp')->find_one($odp_id);
        if (!$odp) return false;

        $used_ports_detail = json_decode($odp->used_ports_detail ?: '{}', true);

        if ($action === 'add') {
            $used_ports_detail[$port_number] = [
                'type' => $connected_type,
                'id' => $connected_id,
                'name' => $connected_name,
                'connected_at' => date('Y-m-d H:i:s')
            ];
        } elseif ($action === 'remove') {
            unset($used_ports_detail[$port_number]);
        }

        $odp->used_ports_detail = json_encode($used_ports_detail);
        $odp->save();

        error_log("Updated ODP {$odp_id} port {$port_number}: {$action} - {$connected_type} {$connected_name}");
        return true;
    } catch (Exception $e) {
        error_log('Error updating ODP port detail: ' . $e->getMessage());
        return false;
    }
}

function getAvailablePortsForOdp($odp_id)
{
    try {
        $odp = ORM::for_table('tbl_odp')->find_one($odp_id);
        if (!$odp) return [];

        $total_ports = $odp->total_ports;
        $used_ports_detail = json_decode($odp->used_ports_detail ?: '{}', true);

        $available_ports = [];
        for ($i = 1; $i <= $total_ports; $i++) {
            if (!isset($used_ports_detail[$i])) {
                $available_ports[] = $i;
            }
        }

        return $available_ports;
    } catch (Exception $e) {
        error_log('Error getting available ports for ODP: ' . $e->getMessage());
        return [];
    }
}

function getUsedPortsDetailForOdp($odp_id)
{
    try {
        $odp = ORM::for_table('tbl_odp')->find_one($odp_id);
        if (!$odp) return [];

        return json_decode($odp->used_ports_detail ?: '{}', true);
    } catch (Exception $e) {
        error_log('Error getting used ports detail for ODP: ' . $e->getMessage());
        return [];
    }
}

function getOdpPortStatusDisplay($odp_id)
{
    try {
        $odp = ORM::for_table('tbl_odp')->find_one($odp_id);
        if (!$odp) return '';

        $total_ports = $odp->total_ports;
        $used_ports_detail = getUsedPortsDetailForOdp($odp_id);
        $available_ports = getAvailablePortsForOdp($odp_id);

        $status_html = '';

        // Used ports display
        if (!empty($used_ports_detail)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(255, 7, 7, 0.1); border-left: 3px solid #ff0707ff; font-size: 11px;">';
            $status_html .= '<i class="fa fa-plug text-warning"></i> <strong>Used Ports:</strong><br>';

            foreach ($used_ports_detail as $port_num => $detail) {
                $status_html .= '• Port ' . $port_num . ': ' . $detail['name'] . ' (' . strtoupper($detail['type']) . ')<br>';
            }

            $status_html = rtrim($status_html, '<br>') . '</div>';
        }

        // Available ports display
        if (!empty($available_ports)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(40, 167, 69, 0.1); border-left: 3px solid #28a745; font-size: 11px;">';
            $status_html .= '<i class="fa fa-check-circle text-success"></i> <strong>Available Ports:</strong><br>';
            $status_html .= '• Port ' . implode(', Port ', $available_ports);
            $status_html .= '</div>';
        }

        return $status_html;
    } catch (Exception $e) {
        error_log('Error getting ODP port status display: ' . $e->getMessage());
        return '';
    }
}

function getCustomerPortConnectionDisplay($customer_id)
{
    try {
        $customer = ORM::for_table('tbl_customers')->find_one($customer_id);
        if (!$customer || !$customer->odp_id || !$customer->port_number) {
            return '';
        }

        $odp = ORM::for_table('tbl_odp')->find_one($customer->odp_id);
        if (!$odp) return '';

        $status_html = '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(23, 162, 184, 0.1); border-left: 3px solid #17a2b8; font-size: 11px;">';
        $status_html .= '<i class="fa fa-link text-info"></i> <strong>Connected to Port:</strong><br>';
        $status_html .= '• Port ' . $customer->port_number . ' (' . $odp->name . ')';
        $status_html .= '</div>';

        return $status_html;
    } catch (Exception $e) {
        error_log('Error getting customer port connection display: ' . $e->getMessage());
        return '';
    }
}


function updateCustomerOdpAssignments($odp_id, $selected_customers, $customer_ports = [])
{
    error_log('DEBUG updateCustomerOdpAssignments: ODP=' . $odp_id . ', Customers=' . print_r($selected_customers, true));

    try {
        // TAMBAH VALIDASI INI - Cek customer yang sudah connected ke ODP lain
        $conflicted_customers = [];
        foreach ($selected_customers as $customer_id) {
            $customer = ORM::for_table('tbl_customers')->find_one($customer_id);
            if ($customer && $customer->odp_id && $customer->odp_id != $odp_id && $customer->connection_status == 'Active') {
                $connected_odp = ORM::for_table('tbl_odp')->find_one($customer->odp_id);
                $conflicted_customers[] = $customer->fullname . ' (already connected to ' . ($connected_odp ? $connected_odp->name : 'ODP #' . $customer->odp_id) . ')';
            }
        }

        if (!empty($conflicted_customers)) {
            throw new Exception('These customers are already connected to other ODPs: ' . implode(', ', $conflicted_customers));
        }

        // Clear existing assignments for this ODP
        $existing_customers = ORM::for_table('tbl_customers')
            ->where('odp_id', $odp_id)
            ->find_many();

        error_log('DEBUG: Found ' . count($existing_customers) . ' existing customers');

        foreach ($existing_customers as $customer) {
            // Remove port detail from ODP
            if ($customer->port_number) {
                updateOdpPortDetail($odp_id, $customer->port_number, 'customer', $customer->id, $customer->fullname, 'remove');
            }

            $customer->odp_id = null;
            $customer->port_number = null;
            $customer->connection_status = 'Inactive';
            $customer->save();
        }

        // ✅ TAMBAHAN BARU: Get ODP total ports for auto-assign
        $odp = ORM::for_table('tbl_odp')->find_one($odp_id);
        if (!$odp) {
            throw new Exception('ODP not found');
        }

        // ✅ TAMBAHAN BARU: Auto-assign ports untuk customer yang tidak punya port
        $customer_ports = autoAssignPorts($selected_customers, $customer_ports, $odp->total_ports);

        error_log('DEBUG: Auto-assigned ports: ' . print_r($customer_ports, true));

        // Assign new customers with ports
        foreach ($selected_customers as $customer_id) {
            $customer = ORM::for_table('tbl_customers')->find_one($customer_id);
            if ($customer) {
                error_log('DEBUG: Processing customer ' . $customer_id . ' - ' . $customer->fullname);

                // Remove from previous ODP if any
                if ($customer->odp_id && $customer->port_number) {
                    updateOdpPortDetail($customer->odp_id, $customer->port_number, 'customer', $customer->id, $customer->fullname, 'remove');
                }

                $customer->odp_id = $odp_id;
                $customer->connection_status = 'Active';

                // ✅ PERBAIKAN: Set port number dengan validasi
                $port_number = isset($customer_ports[$customer_id]) ? $customer_ports[$customer_id] : null;

                // ✅ PERBAIKAN: Pastikan port_number adalah integer atau NULL
                if (empty($port_number) || $port_number === '') {
                    $customer->port_number = null;
                } else {
                    $customer->port_number = (int)$port_number;
                }

                $customer->save();

                error_log('DEBUG: Assigned customer ' . $customer_id . ' to ODP ' . $odp_id . ' port ' . $customer->port_number);

                // Add port detail to ODP
                if ($customer->port_number) {
                    updateOdpPortDetail($odp_id, $customer->port_number, 'customer', $customer->id, $customer->fullname, 'add');
                }
            }
        }

        // ... rest of existing code ...
    } catch (Exception $e) {
        error_log('ERROR in updateCustomerOdpAssignments: ' . $e->getMessage());
        throw $e; // Re-throw untuk ditangkap caller
    }
}





function network_mapping_quick_add_odc()
{
    // Set JSON header
    header('Content-Type: application/json');

    try {
        $lat = _req('lat');
        $lng = _req('lng');

        if (empty($lat) || empty($lng)) {
            echo json_encode(['success' => false, 'message' => 'Koordinat tidak valid']);
            exit;
        }

        // Get routers for dropdown
        $routers = ORM::for_table('tbl_routers')
            ->where('enabled', 1)
            ->order_by_asc('name')
            ->find_array();

        $response = [
            'success' => true,
            'coordinates' => $lat . ',' . $lng,
            'routers' => $routers
        ];

        echo json_encode($response);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_quick_add_odp()
{
    // Set JSON header
    header('Content-Type: application/json');

    try {
        $lat = _req('lat');
        $lng = _req('lng');

        if (empty($lat) || empty($lng)) {
            echo json_encode(['success' => false, 'message' => 'Koordinat tidak valid']);
            exit;
        }

        // Get ODCs for dropdown with port details
        $odcs = ORM::for_table('tbl_odc')
            ->where('status', 'Active')
            ->order_by_asc('name')
            ->find_array();

        // Add port details to each ODC for quick add
        foreach ($odcs as &$odc) {
            $odc['available_ports_detail'] = getAvailablePortsForOdc($odc['id']);
            $odc['used_ports_info'] = getUsedPortsDetail($odc['id']);
        }

        // Get all customers - SAMA SEPERTI DI EDIT FORM
        $all_customers = ORM::for_table('tbl_customers')
            ->where('status', 'Active')
            ->order_by_asc('fullname')
            ->find_array();

        $response = [
            'success' => true,
            'coordinates' => $lat . ',' . $lng,
            'odcs' => $odcs,
            'customers' => $all_customers
        ];

        echo json_encode($response);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_quick_save_odc()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $name = _req('name');
    $description = _req('description');
    $router_id = _req('router_id');
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_ports = _req('total_ports');
    $parent_odc_id = _req('parent_odc_id');
    $parent_port_number = _req('parent_port_number');

    // DEBUG
    error_log('Quick Save ODC - parent_odc_id: ' . $parent_odc_id . ', port: ' . $parent_port_number);

    if (empty($name)) {
        echo json_encode(['success' => false, 'message' => 'Nama ODC harus diisi']);
        exit;
    }

    if (empty($coordinates)) {
        echo json_encode(['success' => false, 'message' => 'Koordinat harus diisi']);
        exit;
    }

    // Validate parent ODC capacity (port will be auto-selected if empty)
    if (!empty($parent_odc_id)) {
        $target_parent_odc = ORM::for_table('tbl_odc')->find_one($parent_odc_id);
        if ($target_parent_odc) {
            // Only validate port if manually specified
            if (!empty($parent_port_number)) {
                // Validate port availability
                if (!validatePortAvailability($parent_odc_id, $parent_port_number)) {
                    echo json_encode([
                        'success' => false,
                        'message' => 'Port ' . $parent_port_number . ' is already in use! Please select another port.'
                    ]);
                    exit;
                }
            } else {
                // Check if parent ODC has available ports for auto-selection
                $current_connected_odps = ORM::for_table('tbl_odp')
                    ->where('odc_id', $parent_odc_id)
                    ->where('status', 'Active')
                    ->count();

                $current_child_odcs = ORM::for_table('tbl_odc')
                    ->where('parent_odc_id', $parent_odc_id)
                    ->where('status', 'Active')
                    ->count();

                $total_used = $current_connected_odps + $current_child_odcs;

                if ($total_used >= $target_parent_odc->total_ports) {
                    echo json_encode([
                        'success' => false,
                        'message' => 'Parent ODC sudah penuh! Used: ' . $total_used . '/' . $target_parent_odc->total_ports . ' ports. Cannot auto-select port.'
                    ]);
                    exit;
                }
            }
        }
    }

    try {
        $odc = ORM::for_table('tbl_odc')->create();
        $odc->name = $name;
        $odc->description = $description;
        $odc->router_id = empty($router_id) ? null : $router_id;
        $odc->parent_odc_id = empty($parent_odc_id) ? null : $parent_odc_id;
        // Auto-select port if not specified but parent ODC is selected
        if (!empty($parent_odc_id) && empty($parent_port_number)) {
            $auto_port = autoSelectAvailablePort($parent_odc_id);
            if ($auto_port) {
                $parent_port_number = $auto_port;
                error_log("Quick add: Auto-selected port {$auto_port} for ODC {$name}");
            }
        }

        $odc->port_number = empty($parent_port_number) ? null : $parent_port_number;
        $odc->coordinates = $coordinates;
        $odc->address = $address;
        $odc->total_ports = $total_ports ?: 16;
        $odc->used_ports = 0;
        $odc->status = 'Active';
        $odc->created_at = date('Y-m-d H:i:s');
        $odc->save();

        // Update parent ODC port count and detail if connected
        if (!empty($parent_odc_id) && !empty($parent_port_number)) {
            updateOdcPortCounts(null, $parent_odc_id);
            updateOdcPortDetail($parent_odc_id, $parent_port_number, 'odc', $odc->id, $odc->name, 'add');
        }

        echo json_encode([
            'success' => true,
            'message' => 'ODC berhasil ditambahkan',
            'odc' => [
                'id' => $odc->id,
                'name' => $odc->name,
                'coordinates' => $odc->coordinates,
                'description' => $odc->description,
                'total_ports' => $odc->total_ports,
                'used_ports' => $odc->used_ports,
                'available_ports' => $odc->total_ports - $odc->used_ports,
                'router_id' => $odc->router_id,
                'address' => $odc->address
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_quick_save_odp()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $name = _req('name');
    $description = _req('description');
    $odc_id = _req('odc_id');
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_ports = _req('total_ports');
    $port_number = _req('port_number');

    if (empty($name)) {
        echo json_encode(['success' => false, 'message' => 'Nama ODP harus diisi']);
        exit;
    }

    if (empty($coordinates)) {
        echo json_encode(['success' => false, 'message' => 'Koordinat harus diisi']);
        exit;
    }

    // Validate ODC capacity and port availability
    if (!empty($odc_id)) {
        $target_odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if ($target_odc) {
            if (!empty($port_number)) {
                if (!validatePortAvailability($odc_id, $port_number)) {
                    echo json_encode([
                        'success' => false,
                        'message' => 'Port ' . $port_number . ' is already in use! Please select another port.'
                    ]);
                    exit;
                }
            }
        }
    }

    try {
        $odp = ORM::for_table('tbl_odp')->create();
        $odp->name = $name;
        $odp->description = $description;
        $odp->odc_id = empty($odc_id) ? null : $odc_id;
        // Auto-select port if not specified but ODC is selected
        if (!empty($odc_id) && empty($port_number)) {
            $auto_port = autoSelectAvailablePort($odc_id);
            if ($auto_port) {
                $port_number = $auto_port;
                error_log("Quick add: Auto-selected port {$auto_port} for ODP {$name}");
            }
        }

        $odp->port_number = empty($port_number) ? null : $port_number;
        $odp->coordinates = $coordinates;
        $odp->address = $address;
        $odp->total_ports = $total_ports ?: 8;
        $odp->used_ports = 0;
        $odp->status = 'Active';
        $odp->created_at = date('Y-m-d H:i:s');
        $odp->save();

        // Handle customer assignments
        $selected_customers = isset($_POST['customers']) && is_array($_POST['customers']) ? $_POST['customers'] : [];
        $customer_ports = isset($_POST['customer_ports']) && is_array($_POST['customer_ports']) ? $_POST['customer_ports'] : [];

        if (!is_array($selected_customers)) {
            $selected_customers = [];
        }

        // ✅ PERBAIKAN: Clean customer_ports - remove empty values
        $cleaned_customer_ports = [];
        foreach ($customer_ports as $customer_id => $port) {
            if (!empty($port) && $port !== '') {
                $cleaned_customer_ports[$customer_id] = (int)$port;
            }
        }
        $customer_ports = $cleaned_customer_ports;

        error_log('DEBUG quick_save_odp: Cleaned customer ports: ' . print_r($customer_ports, true));

        error_log('Selected customers for ODP ' . $odp->id . ': ' . print_r($selected_customers, true));
        error_log('Customer ports for ODP ' . $odp->id . ': ' . print_r($customer_ports, true));

        // Validate customer count against available ports
        if (count($selected_customers) > $odp->total_ports) {
            echo json_encode(['success' => false, 'message' => 'Maksimal ' . $odp->total_ports . ' customers. Anda pilih ' . count($selected_customers)]);
            exit;
        }

        // Validate port assignments
        $used_ports = [];
        foreach ($selected_customers as $customer_id) {
            if (isset($customer_ports[$customer_id]) && $customer_ports[$customer_id]) {
                $port = $customer_ports[$customer_id];
                if (in_array($port, $used_ports)) {
                    echo json_encode(['success' => false, 'message' => 'Port ' . $port . ' sudah digunakan! Pilih port lain.']);
                    exit;
                }
                $used_ports[] = $port;
            }
        }

        // Update customer assignments with ports
        updateCustomerOdpAssignments($odp->id, $selected_customers, $customer_ports);

        // Update ODP used_ports
        $connected_count = count($selected_customers);
        $odp->used_ports = $connected_count;
        $odp->save();

        // Update ODC port detail if connected with specific port
        if (!empty($odc_id) && !empty($port_number)) {
            updateOdcPortDetail($odc_id, $port_number, 'odp', $odp->id, $odp->name, 'add');
        }

        // Update ODC port counts
        error_log('Quick save ODP - calling updateOdcPortCounts with ODC ID: ' . $odc_id);
        updateOdcPortCounts(null, $odc_id);

        echo json_encode([
            'success' => true,
            'message' => 'ODP berhasil ditambahkan dengan ' . $connected_count . ' customers',
            'odp' => [
                'id' => $odp->id,
                'name' => $odp->name,
                'coordinates' => $odp->coordinates,
                'description' => $odp->description,
                'total_ports' => $odp->total_ports,
                'used_ports' => $connected_count,
                'available_ports' => $odp->total_ports - $connected_count,
                'odc_id' => $odp->odc_id,
                'address' => $odp->address
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}


function network_mapping_ajax_delete_odc()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $id = _req('id');
    if (empty($id)) {
        echo json_encode(['success' => false, 'message' => 'ID ODC tidak valid']);
        exit;
    }

    try {
        $odc = ORM::for_table('tbl_odc')->find_one($id);
        if ($odc) {
            // Check if ODC has connected ODPs or child ODCs
            $connected_odps = ORM::for_table('tbl_odp')
                ->where('odc_id', $id)
                ->where('status', 'Active')
                ->count();

            $connected_child_odcs = ORM::for_table('tbl_odc')
                ->where('parent_odc_id', $id)
                ->where('status', 'Active')
                ->count();

            if ($connected_odps > 0) {
                echo json_encode(['success' => false, 'message' => 'Cannot delete ODC. ' . $connected_odps . ' ODPs are still connected.']);
                exit;
            }

            if ($connected_child_odcs > 0) {
                echo json_encode(['success' => false, 'message' => 'Cannot delete ODC. ' . $connected_child_odcs . ' child ODCs are still connected.']);
                exit;
            }

            // Delete related cable routes
            $deleted_cables = deleteRelatedCableRoutes('odc', $id);

            // Update parent ODC port count and remove port detail
            if ($odc->parent_odc_id && $odc->port_number) {
                updateOdcPortDetail($odc->parent_odc_id, $odc->port_number, 'odc', $id, $odc->name, 'remove');
                updateOdcPortCounts($odc->parent_odc_id, null);
            }

            $odc->delete();

            $message = 'ODC berhasil dihapus';
            if ($deleted_cables > 0) {
                $message .= ' beserta ' . $deleted_cables . ' cable routes';
            }

            echo json_encode(['success' => true, 'message' => $message]);
        } else {
            echo json_encode(['success' => false, 'message' => 'ODC tidak ditemukan']);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_ajax_delete_odp()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $id = _req('id');
    if (empty($id)) {
        echo json_encode(['success' => false, 'message' => 'ID ODP tidak valid']);
        exit;
    }

    try {
        $odp = ORM::for_table('tbl_odp')->find_one($id);
        if ($odp) {
            // Check if ODP has connected customers
            $connected_customers = ORM::for_table('tbl_customers')
                ->where('odp_id', $id)
                ->where('connection_status', 'Active')
                ->count();

            if ($connected_customers > 0) {
                echo json_encode(['success' => false, 'message' => 'Cannot delete ODP. ' . $connected_customers . ' customers are still connected.']);
                exit;
            }

            // Delete related cable routes
            $deleted_cables = deleteRelatedCableRoutes('odp', $id);

            $old_odc_id = $odp->odc_id;
            $old_port_number = $odp->port_number;

            // Remove port detail before deletion
            if ($old_odc_id && $old_port_number) {
                updateOdcPortDetail($old_odc_id, $old_port_number, 'odp', $id, $odp->name, 'remove');
            }

            $odp->delete();

            // Update ODC port counts after deletion
            updateOdcPortCounts($old_odc_id, null);

            $message = 'ODP berhasil dihapus';
            if ($deleted_cables > 0) {
                $message .= ' beserta ' . $deleted_cables . ' cable routes';
            }

            echo json_encode(['success' => true, 'message' => $message]);
        } else {
            echo json_encode(['success' => false, 'message' => 'ODP tidak ditemukan']);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}


function network_mapping_search_customers()
{
    header('Content-Type: application/json');

    $search = _req('q');
    $page = (int)_req('page') ?: 1;
    $limit = (int)_req('limit') ?: 5;
    $offset = ($page - 1) * $limit;

    try {
        $query = ORM::for_table('tbl_customers')
            ->select('*') // ✅ TAMBAHAN: Select all columns including photo
            ->where('status', 'Active');

        // Add search filter if provided
        if (!empty($search)) {
            $query->where_raw("(fullname LIKE '%$search%' OR username LIKE '%$search%' OR address LIKE '%$search%')");
        }

        // Get total count
        $total_count = $query->count();

        $customers = $query->order_by_asc('fullname')
            ->limit($limit)
            ->offset($offset)
            ->find_array();

        // ✅ PERBAIKAN: Auto-prefix system/uploads untuk search results
        foreach ($customers as &$customer) {
            if (!empty($customer['photo']) && $customer['photo'] !== '/user.default.jpg' && strpos($customer['photo'], 'user.default.jpg') === false) {
                if (strpos($customer['photo'], 'http') !== 0) {
                    // ✅ AUTO-PREFIX: Semua foto ada di /system/uploads
                    $customer['photo'] = '/system/uploads' . $customer['photo'];
                }
            }
        }

        $has_more = ($offset + $limit) < $total_count;
        $remaining = $total_count - ($offset + count($customers));

        echo json_encode([
            'success' => true,
            'customers' => $customers,
            'total_found' => $total_count,
            'page' => $page,
            'limit' => $limit,
            'has_more' => $has_more,
            'remaining' => max(0, $remaining)
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}



function deleteRelatedCableRoutes($type, $id)
{
    try {
        // Delete cables where this item is the source (from)
        $from_cables = ORM::for_table('tbl_cable_waypoints')
            ->where('from_type', $type)
            ->where('from_id', $id)
            ->find_many();

        foreach ($from_cables as $cable) {
            error_log("Deleting cable route: {$cable->id} (from {$type} {$id})");
            $cable->delete();
        }

        // Delete cables where this item is the destination (to)
        $to_cables = ORM::for_table('tbl_cable_waypoints')
            ->where('to_type', $type)
            ->where('to_id', $id)
            ->find_many();

        foreach ($to_cables as $cable) {
            error_log("Deleting cable route: {$cable->id} (to {$type} {$id})");
            $cable->delete();
        }

        $total_deleted = count($from_cables) + count($to_cables);
        error_log("Total {$total_deleted} cable routes deleted for {$type} {$id}");

        return $total_deleted;
    } catch (Exception $e) {
        error_log('Error deleting related cables: ' . $e->getMessage());
        return 0;
    }
}


// ===== DISCONNECT FUNCTIONS =====

function network_mapping_get_odc_connections()
{
    header('Content-Type: application/json');

    $odc_id = _req('odc_id');
    $search = _req('search', '');
    $page = (int)_req('page', 1);
    $limit = (int)_req('limit', 5);
    $offset = ($page - 1) * $limit;

    if (empty($odc_id)) {
        echo json_encode(['success' => false, 'message' => 'ODC ID required']);
        exit;
    }

    try {
        // Get connected ODPs
        $odp_query = ORM::for_table('tbl_odp')
            ->where('odc_id', $odc_id)
            ->where('status', 'Active');

        if (!empty($search)) {
            $odp_query->where_like('name', '%' . $search . '%');
        }

        $total_odps = $odp_query->count();

        $odps = $odp_query->order_by_asc('name')
            ->limit($limit)
            ->offset($offset)
            ->find_array();

        // Get connected child ODCs
        $child_odc_query = ORM::for_table('tbl_odc')
            ->where('parent_odc_id', $odc_id)
            ->where('status', 'Active');

        if (!empty($search)) {
            $child_odc_query->where_like('name', '%' . $search . '%');
        }

        $total_child_odcs = $child_odc_query->count();

        $child_odcs = $child_odc_query->order_by_asc('name')
            ->limit($limit)
            ->offset($offset)
            ->find_array();

        // Combine results
        $connections = [];

        foreach ($odps as $odp) {
            $connections[] = [
                'id' => $odp['id'],
                'name' => $odp['name'],
                'type' => 'odp',
                'description' => $odp['description'],
                'address' => $odp['address'],
                'ports' => $odp['used_ports'] . '/' . $odp['total_ports'],
                'coordinates' => $odp['coordinates']
            ];
        }

        foreach ($child_odcs as $child) {
            $connections[] = [
                'id' => $child['id'],
                'name' => $child['name'],
                'type' => 'odc',
                'description' => $child['description'],
                'address' => $child['address'],
                'ports' => $child['used_ports'] . '/' . $child['total_ports'],
                'coordinates' => $child['coordinates']
            ];
        }

        $total_connections = $total_odps + $total_child_odcs;
        $has_more = ($offset + count($connections)) < $total_connections;
        $remaining = max(0, $total_connections - ($offset + count($connections)));

        echo json_encode([
            'success' => true,
            'connections' => $connections,
            'total_found' => $total_connections,
            'page' => $page,
            'limit' => $limit,
            'has_more' => $has_more,
            'remaining' => $remaining
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_get_odp_connections()
{
    header('Content-Type: application/json');

    $odp_id = _req('odp_id');
    $search = _req('search', '');
    $page = (int)_req('page', 1);
    $limit = (int)_req('limit', 5);
    $offset = ($page - 1) * $limit;

    // DEBUG
    error_log('DEBUG: ODP ID = ' . $odp_id);
    error_log('DEBUG: Search = ' . $search);

    if (empty($odp_id)) {
        echo json_encode(['success' => false, 'message' => 'ODP ID required']);
        exit;
    }

    try {
        // Get connected customers
        $customer_query = ORM::for_table('tbl_customers')
            ->where('odp_id', $odp_id)
            ->where('connection_status', 'Active');

        if (!empty($search)) {
            $customer_query->where_raw("(fullname LIKE '%$search%' OR username LIKE '%$search%')");
        }

        $total_customers = $customer_query->count();
        error_log('DEBUG: Total customers found = ' . $total_customers);

        $customers = $customer_query->order_by_asc('fullname')
            ->limit($limit)
            ->offset($offset)
            ->find_array();

        error_log('DEBUG: Customers data = ' . print_r($customers, true));

        $connections = [];
        foreach ($customers as $customer) {
            $connections[] = [
                'id' => $customer['id'],
                'name' => $customer['fullname'],
                'type' => 'customer',
                'username' => $customer['username'],
                'address' => $customer['address'],
                'balance' => 'Rp ' . number_format($customer['balance'], 0, ',', '.'),
                'coordinates' => $customer['coordinates'],
                'port_number' => $customer['port_number']
            ];
        }

        $has_more = ($offset + count($connections)) < $total_customers;
        $remaining = max(0, $total_customers - ($offset + count($connections)));

        echo json_encode([
            'success' => true,
            'connections' => $connections,
            'total_found' => $total_customers,
            'page' => $page,
            'limit' => $limit,
            'has_more' => $has_more,
            'remaining' => $remaining
        ]);
    } catch (Exception $e) {
        error_log('ERROR in get_odp_connections: ' . $e->getMessage());
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_disconnect_from_odc()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $odc_id = _req('odc_id');
    $disconnect_type = _req('disconnect_type');

    // Handle array parameter correctly
    $disconnect_ids = isset($_POST['disconnect_ids']) ? $_POST['disconnect_ids'] : [];

    if (empty($odc_id) || empty($disconnect_ids) || !is_array($disconnect_ids)) {
        echo json_encode(['success' => false, 'message' => 'Invalid parameters']);
        exit;
    }

    try {
        $disconnected_count = 0;

        foreach ($disconnect_ids as $id) {
            if ($disconnect_type === 'odp') {
                $odp = ORM::for_table('tbl_odp')->find_one($id);
                if ($odp && $odp->odc_id == $odc_id) {
                    // DELETE AUTO CABLE BEFORE DISCONNECTING
                    deleteAutoCableRoute('odc', $odc_id, 'odp', $id);

                    $odp->odc_id = null;
                    // Remove port detail
                    if ($odp->port_number) {
                        updateOdcPortDetail($odc_id, $odp->port_number, 'odp', $id, $odp->name, 'remove');
                    }
                    $odp->port_number = null;
                    $odp->save();
                    $disconnected_count++;

                    // Update ODP's own port usage
                    updateOdpPortCounts($id);

                    error_log("Disconnected ODP {$id} from ODC {$odc_id} and deleted cable route");
                }
            } elseif ($disconnect_type === 'odc') {
                $child_odc = ORM::for_table('tbl_odc')->find_one($id);
                if ($child_odc && $child_odc->parent_odc_id == $odc_id) {
                    // DELETE AUTO CABLE BEFORE DISCONNECTING
                    deleteAutoCableRoute('odc', $odc_id, 'odc', $id);

                    $child_odc->parent_odc_id = null;
                    // Remove port detail
                    if ($child_odc->port_number) {
                        updateOdcPortDetail($odc_id, $child_odc->port_number, 'odc', $id, $child_odc->name, 'remove');
                    }
                    $child_odc->port_number = null;
                    $child_odc->save();
                    $disconnected_count++;

                    error_log("Disconnected child ODC {$id} from parent ODC {$odc_id} and deleted cable route");
                }
            }
        }

        // Update parent ODC port counts
        updateOdcPortCounts(null, $odc_id);

        echo json_encode([
            'success' => true,
            'message' => $disconnected_count . ' connections disconnected successfully',
            'disconnected_count' => $disconnected_count
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_disconnect_from_odp()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $odp_id = _req('odp_id');

    // Handle array parameter correctly
    $disconnect_ids = isset($_POST['disconnect_ids']) ? $_POST['disconnect_ids'] : [];

    if (empty($odp_id) || empty($disconnect_ids) || !is_array($disconnect_ids)) {
        echo json_encode(['success' => false, 'message' => 'Invalid parameters']);
        exit;
    }

    try {
        $disconnected_count = 0;

        foreach ($disconnect_ids as $customer_id) {
            $customer = ORM::for_table('tbl_customers')->find_one($customer_id);
            if ($customer && $customer->odp_id == $odp_id) {
                // DELETE AUTO CABLE BEFORE DISCONNECTING
                deleteAutoCableRoute('odp', $odp_id, 'customer', $customer_id);

                // Remove port detail from ODP
                if ($customer->port_number) {
                    updateOdpPortDetail($odp_id, $customer->port_number, 'customer', $customer_id, $customer->fullname, 'remove');
                }

                $customer->odp_id = null;
                $customer->port_number = null;
                $customer->connection_status = 'Inactive';
                $customer->save();
                $disconnected_count++;

                error_log("Disconnected customer {$customer_id} from ODP {$odp_id} and deleted cable route");
            }
        }

        // Update ODP port counts
        updateOdpPortCounts($odp_id);

        // Update parent ODC port counts if ODP is connected to ODC
        $odp = ORM::for_table('tbl_odp')->find_one($odp_id);
        if ($odp && $odp->odc_id) {
            updateOdcPortCounts(null, $odp->odc_id);
        }

        echo json_encode([
            'success' => true,
            'message' => $disconnected_count . ' customers disconnected successfully',
            'disconnected_count' => $disconnected_count
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}



// ===== AUTO CABLE MANAGEMENT FUNCTIONS =====


function deleteAutoCableRoute($from_type, $from_id, $to_type, $to_id)
{
    try {
        // Find and delete the cable route
        $cable = ORM::for_table('tbl_cable_waypoints')
            ->where('from_type', $from_type)
            ->where('from_id', $from_id)
            ->where('to_type', $to_type)
            ->where('to_id', $to_id)
            ->find_one();

        if ($cable) {
            $cable_id = $cable->id;
            $cable->delete();
            error_log("Auto-deleted cable route ID {$cable_id}: {$from_type}({$from_id}) -> {$to_type}({$to_id})");
            return true;
        } else {
            error_log("Cable route not found for deletion: {$from_type}({$from_id}) -> {$to_type}({$to_id})");
            return false;
        }
    } catch (Exception $e) {
        error_log("Error deleting auto cable route: " . $e->getMessage());
        return false;
    }
}

function getEntityCoordinates($type, $id)
{
    try {
        $table_map = [
            'router' => 'tbl_routers',
            'odc' => 'tbl_odc',
            'odp' => 'tbl_odp',
            'customer' => 'tbl_customers'
        ];

        if (!isset($table_map[$type])) {
            return false;
        }

        $entity = ORM::for_table($table_map[$type])->find_one($id);
        if ($entity && $entity->coordinates) {
            $coords = explode(',', $entity->coordinates);
            if (count($coords) == 2) {
                return [
                    'lat' => (float)trim($coords[0]),
                    'lng' => (float)trim($coords[1])
                ];
            }
        }

        return false;
    } catch (Exception $e) {
        error_log("Error getting entity coordinates: " . $e->getMessage());
        return false;
    }
}


// ===== PORT MANAGEMENT FUNCTIONS =====

function getAvailablePortsForOdc($odc_id)
{
    try {
        $odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if (!$odc) return [];

        $total_ports = $odc->total_ports;
        $used_ports_detail = json_decode($odc->used_ports_detail ?: '{}', true);

        $available_ports = [];
        for ($i = 1; $i <= $total_ports; $i++) {
            if (!isset($used_ports_detail[$i])) {
                $available_ports[] = $i;
            }
        }

        return $available_ports;
    } catch (Exception $e) {
        error_log('Error getting available ports: ' . $e->getMessage());
        return [];
    }
}

function getUsedPortsDetail($odc_id)
{
    try {
        $odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if (!$odc) return [];

        return json_decode($odc->used_ports_detail ?: '{}', true);
    } catch (Exception $e) {
        error_log('Error getting used ports detail: ' . $e->getMessage());
        return [];
    }
}

function updateOdcPortDetail($odc_id, $port_number, $connected_type, $connected_id, $connected_name, $action = 'add')
{
    try {
        $odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if (!$odc) return false;

        $used_ports_detail = json_decode($odc->used_ports_detail ?: '{}', true);

        if ($action === 'add') {
            $used_ports_detail[$port_number] = [
                'type' => $connected_type,
                'id' => $connected_id,
                'name' => $connected_name,
                'connected_at' => date('Y-m-d H:i:s')
            ];
        } elseif ($action === 'remove') {
            unset($used_ports_detail[$port_number]);
        }

        $odc->used_ports_detail = json_encode($used_ports_detail);
        $odc->save();

        error_log("Updated ODC {$odc_id} port {$port_number}: {$action} - {$connected_type} {$connected_name}");
        return true;
    } catch (Exception $e) {
        error_log('Error updating ODC port detail: ' . $e->getMessage());
        return false;
    }
}

function validatePortAvailability($odc_id, $port_number, $exclude_child_id = null)
{
    try {
        $used_ports_detail = getUsedPortsDetail($odc_id);

        // If port is not used, it's available
        if (!isset($used_ports_detail[$port_number])) {
            return true;
        }

        // If editing existing connection, allow current connection
        if (
            $exclude_child_id &&
            isset($used_ports_detail[$port_number]['id']) &&
            $used_ports_detail[$port_number]['id'] == $exclude_child_id
        ) {
            return true;
        }

        return false;
    } catch (Exception $e) {
        error_log('Error validating port availability: ' . $e->getMessage());
        return false;
    }
}
function autoSelectAvailablePort($odc_id, $exclude_child_id = null)
{
    try {
        $odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if (!$odc) return null;

        $total_ports = $odc->total_ports;
        $used_ports_detail = json_decode($odc->used_ports_detail ?: '{}', true);

        // Find the smallest available port
        for ($i = 1; $i <= $total_ports; $i++) {
            // Check if port is available
            if (!isset($used_ports_detail[$i])) {
                return $i; // Return first available port
            }

            // If editing existing connection, allow current connection port
            if (
                $exclude_child_id &&
                isset($used_ports_detail[$i]['id']) &&
                $used_ports_detail[$i]['id'] == $exclude_child_id
            ) {
                return $i;
            }
        }

        return null; // No available ports
    } catch (Exception $e) {
        error_log('Error auto-selecting port: ' . $e->getMessage());
        return null;
    }
}

function getPortStatusDisplay($odc_id)
{
    try {
        $odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if (!$odc) return '';

        $total_ports = $odc->total_ports;
        $used_ports_detail = getUsedPortsDetail($odc_id);
        $available_ports = getAvailablePortsForOdc($odc_id);

        $status_html = '';

        // Used ports display
        if (!empty($used_ports_detail)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(255, 7, 7, 0.1); border-left: 3px solid #ff0707ff; font-size: 11px;">';
            $status_html .= '<i class="fa fa-plug text-warning"></i> <strong>Used Ports:</strong><br>';

            foreach ($used_ports_detail as $port_num => $detail) {
                $status_html .= '• Port ' . $port_num . ': ' . $detail['name'] . ' (' . strtoupper($detail['type']) . ')<br>';
            }

            $status_html = rtrim($status_html, '<br>') . '</div>';
        }

        // Available ports display
        if (!empty($available_ports)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(40, 167, 69, 0.1); border-left: 3px solid #28a745; font-size: 11px;">';
            $status_html .= '<i class="fa fa-check-circle text-success"></i> <strong>Available Ports:</strong><br>';
            $status_html .= '• Port ' . implode(', Port ', $available_ports);
            $status_html .= '</div>';
        }

        return $status_html;
    } catch (Exception $e) {
        error_log('Error getting port status display: ' . $e->getMessage());
        return '';
    }
}

function getChildConnectionPortDisplay($child_odc_id)
{
    try {
        $child_odc = ORM::for_table('tbl_odc')->find_one($child_odc_id);
        if (!$child_odc || !$child_odc->parent_odc_id || !$child_odc->port_number) {
            return '';
        }

        $parent_odc = ORM::for_table('tbl_odc')->find_one($child_odc->parent_odc_id);
        if (!$parent_odc) return '';

        $status_html = '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(23, 162, 184, 0.1); border-left: 3px solid #17a2b8; font-size: 11px;">';
        $status_html .= '<i class="fa fa-link text-info"></i> <strong>Connected to Port:</strong><br>';
        $status_html .= '• Port ' . $child_odc->port_number . ' (' . $parent_odc->name . ')';
        $status_html .= '</div>';

        return $status_html;
    } catch (Exception $e) {
        error_log('Error getting child connection port display: ' . $e->getMessage());
        return '';
    }
}

// API endpoint untuk get available ports
function network_mapping_get_available_ports()
{
    header('Content-Type: application/json');

    $odc_id = _req('odc_id');

    if (empty($odc_id)) {
        echo json_encode(['success' => false, 'message' => 'ODC ID required']);
        exit;
    }

    try {
        $available_ports = getAvailablePortsForOdc($odc_id);
        $used_ports_detail = getUsedPortsDetail($odc_id);

        echo json_encode([
            'success' => true,
            'available_ports' => $available_ports,
            'used_ports_detail' => $used_ports_detail
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

// ===== END PORT MANAGEMENT FUNCTIONS =====


// API endpoint untuk get available ports ODP
function network_mapping_get_available_ports_odp()
{
    header('Content-Type: application/json');

    $odp_id = _req('odp_id');

    if (empty($odp_id)) {
        echo json_encode(['success' => false, 'message' => 'ODP ID required']);
        exit;
    }

    try {
        $available_ports = getAvailablePortsForOdp($odp_id);
        $used_ports_detail = getUsedPortsDetailForOdp($odp_id);

        echo json_encode([
            'success' => true,
            'available_ports' => $available_ports,
            'used_ports_detail' => $used_ports_detail
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}



// ===== AUTO PORT ASSIGNMENT FUNCTION =====

function autoAssignPorts($selected_customers, $customer_ports, $total_ports)
{
    try {
        // Collect ports yang sudah dipilih manually
        $manually_assigned_ports = [];
        foreach ($customer_ports as $customer_id => $port) {
            if (!empty($port) && $port !== '') {
                $manually_assigned_ports[] = (int)$port;
            }
        }

        error_log('DEBUG autoAssignPorts: Manually assigned ports: ' . print_r($manually_assigned_ports, true));

        // Generate list port yang available
        $available_ports = [];
        for ($i = 1; $i <= $total_ports; $i++) {
            if (!in_array($i, $manually_assigned_ports)) {
                $available_ports[] = $i;
            }
        }

        error_log('DEBUG autoAssignPorts: Available ports: ' . print_r($available_ports, true));

        // Auto-assign untuk customer yang belum punya port
        $port_index = 0;
        foreach ($selected_customers as $customer_id) {
            // Jika customer belum ada port assignment atau port kosong
            if (!isset($customer_ports[$customer_id]) || empty($customer_ports[$customer_id]) || $customer_ports[$customer_id] === '') {
                // Assign port available berikutnya
                if ($port_index < count($available_ports)) {
                    $customer_ports[$customer_id] = $available_ports[$port_index];
                    error_log('DEBUG autoAssignPorts: Auto-assigned customer ' . $customer_id . ' to port ' . $available_ports[$port_index]);
                    $port_index++;
                } else {
                    // Tidak ada port available lagi
                    error_log('WARNING: No more ports available for customer ' . $customer_id);
                    $customer_ports[$customer_id] = null;
                }
            }
        }

        return $customer_ports;
    } catch (Exception $e) {
        error_log('ERROR in autoAssignPorts: ' . $e->getMessage());
        return $customer_ports; // Return original jika error
    }
}
// ===== POLE MANAGEMENT FUNCTIONS =====

function getPoleConnectionName($type, $id)
{
    try {
        switch ($type) {
            case 'router':
                $item = ORM::for_table('tbl_routers')->find_one($id);
                return $item ? $item->name : 'Unknown Router';
            case 'odc':
                $item = ORM::for_table('tbl_odc')->find_one($id);
                return $item ? $item->name : 'Unknown ODC';
            case 'odp':
                $item = ORM::for_table('tbl_odp')->find_one($id);
                return $item ? $item->name : 'Unknown ODP';
            case 'customer':
                $item = ORM::for_table('tbl_customers')->find_one($id);
                return $item ? $item->fullname : 'Unknown Customer';
            case 'cust_all':  // TAMBAHAN INI
                return 'CUSTOMER';
            default:
                return 'Unknown';
        }
    } catch (Exception $e) {
        return 'Error: ' . $e->getMessage();
    }
}

function network_mapping_quick_add_pole()
{
    header('Content-Type: application/json');

    try {
        $lat = _req('lat');
        $lng = _req('lng');

        if (empty($lat) || empty($lng)) {
            echo json_encode(['success' => false, 'message' => 'Koordinat tidak valid']);
            exit;
        }

        $response = [
            'success' => true,
            'coordinates' => $lat . ',' . $lng
        ];

        echo json_encode($response);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_get_network_devices()
{
    header('Content-Type: application/json');

    try {
        $search = _req('search', '');
        $page = (int)_req('page', 1);
        $limit = (int)_req('limit', 10);
        $offset = ($page - 1) * $limit;

        $devices = [];

        // Get Routers
        $routers_query = ORM::for_table('tbl_routers')
            ->where('enabled', 1)
            ->order_by_asc('name');

        if (!empty($search)) {
            $routers_query->where_like('name', '%' . $search . '%');
        }

        $routers = $routers_query->find_array();
        foreach ($routers as $router) {
            $devices[] = [
                'id' => $router['id'],
                'type' => 'router',
                'name' => $router['name'],
                'description' => $router['description'] ?? '',
                'display_name' => $router['name'] . ' (Router)'
            ];
        }

        // Get ODCs
        $odcs_query = ORM::for_table('tbl_odc')
            ->where('status', 'Active')
            ->order_by_asc('name');

        if (!empty($search)) {
            $odcs_query->where_like('name', '%' . $search . '%');
        }

        $odcs = $odcs_query->find_array();
        foreach ($odcs as $odc) {
            $devices[] = [
                'id' => $odc['id'],
                'type' => 'odc',
                'name' => $odc['name'],
                'description' => $odc['description'] ?? '',
                'display_name' => $odc['name'] . ' (ODC)'
            ];
        }

        // Get ODPs
        $odps_query = ORM::for_table('tbl_odp')
            ->where('status', 'Active')
            ->order_by_asc('name');

        if (!empty($search)) {
            $odps_query->where_like('name', '%' . $search . '%');
        }

        $odps = $odps_query->find_array();
        foreach ($odps as $odp) {
            $devices[] = [
                'id' => $odp['id'],
                'type' => 'odp',
                'name' => $odp['name'],
                'description' => $odp['description'] ?? '',
                'display_name' => $odp['name'] . ' (ODP)'
            ];
        }

        // Get Customers
        $customers_query = ORM::for_table('tbl_customers')
            ->where('status', 'Active')
            ->order_by_asc('fullname');

        if (!empty($search)) {
            $customers_query->where_raw("(fullname LIKE '%$search%' OR username LIKE '%$search%')");
        }

        $customers = $customers_query->find_array();
        foreach ($customers as $customer) {
            $devices[] = [
                'id' => $customer['id'],
                'type' => 'customer',
                'name' => $customer['fullname'],
                'description' => $customer['username'],
                'display_name' => $customer['fullname'] . ' (' . $customer['username'] . ')'
            ];
        }

        // Apply search filter to combined results
        if (!empty($search)) {
            $devices = array_filter($devices, function ($device) use ($search) {
                return stripos($device['display_name'], $search) !== false;
            });
        }

        // Apply pagination
        $total_devices = count($devices);
        $paged_devices = array_slice($devices, $offset, $limit);

        echo json_encode([
            'success' => true,
            'devices' => $paged_devices,
            'total' => $total_devices,
            'page' => $page,
            'has_more' => ($offset + $limit) < $total_devices
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_quick_save_pole()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $name = _req('name');
    $description = _req('description');
    $coordinates = _req('coordinates');
    $address = _req('address');

    if (empty($name)) {
        echo json_encode(['success' => false, 'message' => 'Nama Pole harus diisi']);
        exit;
    }

    if (empty($coordinates)) {
        echo json_encode(['success' => false, 'message' => 'Koordinat harus diisi']);
        exit;
    }

    try {
        $pole = ORM::for_table('tbl_poles')->create();
        $pole->name = $name;
        $pole->description = $description;
        $pole->coordinates = $coordinates;
        $pole->address = $address;
        // HAPUS SEMUA ASSIGNMENT INI - JANGAN SET from_type, from_id, to_type, to_id
        $pole->status = 'Active';
        $pole->created_at = date('Y-m-d H:i:s');
        $pole->save();

        echo json_encode([
            'success' => true,
            'message' => 'Pole berhasil ditambahkan',
            'pole' => [
                'id' => $pole->id,
                'name' => $pole->name,
                'coordinates' => $pole->coordinates,
                'description' => $pole->description,
                'address' => $pole->address
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_ajax_delete_pole()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $id = _req('id');
    if (empty($id)) {
        echo json_encode(['success' => false, 'message' => 'ID Pole tidak valid']);
        exit;
    }

    try {
        $pole = ORM::for_table('tbl_poles')->find_one($id);
        if ($pole) {
            // ✅ FIXED: Check for ALL bridges (active + inactive) before deletion
            $all_bridges = ORM::for_table('tbl_pole_bridges')
                ->where('pole_id', $id)
                ->find_many();

            if (count($all_bridges) > 0) {
                // ✅ FIXED: Block deletion if ANY bridges exist (active OR inactive)
                $bridge_details = [];
                $active_count = 0;
                $inactive_count = 0;

                foreach ($all_bridges as $bridge) {
                    $from_name = getPoleConnectionName($bridge->from_type, $bridge->from_id);
                    $to_name = getPoleConnectionName($bridge->to_type, $bridge->to_id);
                    $status = $bridge->status ?? 'active';

                    if ($status === 'active') {
                        $active_count++;
                        $bridge_details[] = $from_name . ' → ' . $to_name . ' (Active)';
                    } else {
                        $inactive_count++;
                        $bridge_details[] = $from_name . ' → ' . $to_name . ' (Hidden)';
                    }
                }

                echo json_encode([
                    'success' => false,
                    'message' => 'Cannot delete pole with existing bridges',
                    'reason' => 'has_bridges',
                    'bridge_count' => count($all_bridges),
                    'active_bridges' => $active_count,
                    'inactive_bridges' => $inactive_count,
                    'bridge_details' => $bridge_details,
                    'pole_name' => $pole->name,
                    'pole_id' => $id,
                    'action_required' => 'remove_all_bridges'
                ]);
                exit;
            }

            // ✅ UPDATED: Only proceed if NO bridges exist at all
            // Delete related cable routes (cleanup for any leftover routes)
            $deleted_cables = deleteRelatedCableRoutes('pole', $id);

            $pole->delete();

            $message = 'Pole berhasil dihapus';
            if ($deleted_cables > 0) {
                $message .= ' beserta ' . $deleted_cables . ' cable routes';
            }

            echo json_encode(['success' => true, 'message' => $message]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Pole tidak ditemukan']);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
// ===== MULTIPLE BRIDGE FUNCTIONS =====

function addPoleBridge($pole_id, $from_type, $from_id, $to_type, $to_id, $cable_route_id = null)
{
    try {
        // Enhanced check: include cable_route_id to avoid duplicate bridges for same route
        $existing = ORM::for_table('tbl_pole_bridges')
            ->where('pole_id', $pole_id)
            ->where('from_type', $from_type)
            ->where('from_id', $from_id)
            ->where('to_type', $to_type)
            ->where('to_id', $to_id)
            ->where('cable_route_id', $cable_route_id)
            ->find_one();

        if ($existing) {
            error_log("Bridge already exists for pole {$pole_id}: {$from_type}({$from_id}) -> {$to_type}({$to_id}) route {$cable_route_id}");
            return $existing->id; // Already exists
        }

        $bridge = ORM::for_table('tbl_pole_bridges')->create();
        $bridge->pole_id = $pole_id;
        $bridge->from_type = $from_type;
        $bridge->from_id = $from_id;
        $bridge->to_type = $to_type;
        $bridge->to_id = $to_id;
        $bridge->cable_route_id = $cable_route_id;
        $bridge->created_at = date('Y-m-d H:i:s');
        $bridge->save();

        error_log("Added NEW bridge to pole {$pole_id}: {$from_type}({$from_id}) -> {$to_type}({$to_id}) route {$cable_route_id}");
        return $bridge->id;
    } catch (Exception $e) {
        error_log('Error adding pole bridge: ' . $e->getMessage());
        return false;
    }
}

function getPoleBridges($pole_id)
{
    try {
        $bridges = ORM::for_table('tbl_pole_bridges')
            ->where('pole_id', $pole_id)
            ->where('status', 'active')  // HANYA TAMPILKAN YANG ACTIVE
            ->order_by_asc('created_at')
            ->find_array();

        $formatted_bridges = [];
        foreach ($bridges as $bridge) {
            $from_name = getPoleConnectionName($bridge['from_type'], $bridge['from_id']);
            $to_name = getPoleConnectionName($bridge['to_type'], $bridge['to_id']);

            // Get coordinates for from and to devices
            $from_coordinates = getDeviceCoordinates($bridge['from_type'], $bridge['from_id']);
            $to_coordinates = getDeviceCoordinates($bridge['to_type'], $bridge['to_id']);

            $formatted_bridges[] = [
                'id' => $bridge['id'],
                'from_type' => $bridge['from_type'],
                'from_id' => $bridge['from_id'],
                'from_name' => $from_name,
                'from_coordinates' => $from_coordinates,
                'to_type' => $bridge['to_type'],
                'to_id' => $bridge['to_id'],
                'to_name' => $to_name,
                'to_coordinates' => $to_coordinates,
                'cable_route_id' => $bridge['cable_route_id'],
                'created_at' => $bridge['created_at']
            ];
        }

        return $formatted_bridges;
    } catch (Exception $e) {
        error_log('Error getting pole bridges: ' . $e->getMessage());
        return [];
    }
}
function getDeviceCoordinates($device_type, $device_id)
{
    try {
        if ($device_type === 'cust_all' || !$device_id) {
            return null;
        }

        $table_map = [
            'router' => 'tbl_routers',
            'odc' => 'tbl_odc',
            'odp' => 'tbl_odp',
            'customer' => 'tbl_customers'
        ];

        if (!isset($table_map[$device_type])) {
            return null;
        }

        $device = ORM::for_table($table_map[$device_type])
            ->where('id', $device_id)
            ->find_one();

        if ($device && $device->coordinates) {
            return $device->coordinates;
        }

        return null;
    } catch (Exception $e) {
        error_log('Error getting device coordinates: ' . $e->getMessage());
        return null;
    }
}
// ===== PORT CONNECTION BACKUP FUNCTIONS =====

function backupPortConnections($cableRouteId)
{
    try {
        // Get cable route details
        $cable = ORM::for_table('tbl_cable_waypoints')->find_one($cableRouteId);
        if (!$cable) return false;

        $backupData = [
            'cable_route_id' => $cableRouteId,
            'from_type' => $cable->from_type,
            'from_id' => $cable->from_id,
            'to_type' => $cable->to_type,
            'to_id' => $cable->to_id,
            'connections' => []
        ];

        // Backup ODC connections
        if ($cable->from_type === 'odc' || $cable->to_type === 'odc') {
            $odcId = ($cable->from_type === 'odc') ? $cable->from_id : $cable->to_id;
            $connectedId = ($cable->from_type === 'odc') ? $cable->to_id : $cable->from_id;
            $connectedType = ($cable->from_type === 'odc') ? $cable->to_type : $cable->from_type;

            $odc = ORM::for_table('tbl_odc')->find_one($odcId);
            if ($odc) {
                $usedPortsDetail = json_decode($odc->used_ports_detail ?: '{}', true);

                // Find the port number for this connection
                foreach ($usedPortsDetail as $portNum => $detail) {
                    if ($detail['type'] === $connectedType && $detail['id'] == $connectedId) {
                        $backupData['connections'][] = [
                            'device_type' => 'odc',
                            'device_id' => $odcId,
                            'port_number' => $portNum,
                            'connected_type' => $connectedType,
                            'connected_id' => $connectedId,
                            'connected_name' => $detail['name']
                        ];
                        break;
                    }
                }
            }

            // If connected device is ODP, backup its port connection to parent ODC
            if ($connectedType === 'odp') {
                $odp = ORM::for_table('tbl_odp')->find_one($connectedId);
                if ($odp && $odp->port_number) {
                    $backupData['connections'][] = [
                        'device_type' => 'odp',
                        'device_id' => $connectedId,
                        'parent_connection' => [
                            'odc_id' => $odp->odc_id,
                            'port_number' => $odp->port_number
                        ]
                    ];
                }
            }
        }

        // Backup ODP to Customer connections
        if ($cable->from_type === 'odp' && $cable->to_type === 'customer') {
            $odpId = $cable->from_id;
            $customerId = $cable->to_id;

            $customer = ORM::for_table('tbl_customers')->find_one($customerId);
            if ($customer && $customer->port_number && $customer->odp_id == $odpId) {
                $backupData['connections'][] = [
                    'device_type' => 'customer',
                    'device_id' => $customerId,
                    'odp_connection' => [
                        'odp_id' => $odpId,
                        'port_number' => $customer->port_number
                    ]
                ];

                // Also backup ODP port detail
                $odp = ORM::for_table('tbl_odp')->find_one($odpId);
                if ($odp) {
                    $usedPortsDetail = json_decode($odp->used_ports_detail ?: '{}', true);
                    if (isset($usedPortsDetail[$customer->port_number])) {
                        $backupData['connections'][] = [
                            'device_type' => 'odp',
                            'device_id' => $odpId,
                            'port_number' => $customer->port_number,
                            'connected_type' => 'customer',
                            'connected_id' => $customerId,
                            'connected_name' => $customer->fullname
                        ];
                    }
                }
            }
        }

        // Save backup to database
        $backup = ORM::for_table('tbl_port_connection_backups')->create();
        $backup->cable_route_id = $cableRouteId;
        $backup->backup_data = json_encode($backupData);
        $backup->created_at = date('Y-m-d H:i:s');
        $backup->save();

        error_log("Port connections backed up for cable route {$cableRouteId}");
        return true;
    } catch (Exception $e) {
        error_log('Error backing up port connections: ' . $e->getMessage());
        return false;
    }
}

function removePortConnections($cableRouteId)
{
    try {
        // Get cable route details
        $cable = ORM::for_table('tbl_cable_waypoints')->find_one($cableRouteId);
        if (!$cable) return false;

        // Remove ODC connections
        if ($cable->from_type === 'odc' || $cable->to_type === 'odc') {
            $odcId = ($cable->from_type === 'odc') ? $cable->from_id : $cable->to_id;
            $connectedId = ($cable->from_type === 'odc') ? $cable->to_id : $cable->from_id;
            $connectedType = ($cable->from_type === 'odc') ? $cable->to_type : $cable->from_type;

            // Remove from ODC port details
            $odc = ORM::for_table('tbl_odc')->find_one($odcId);
            if ($odc) {
                $usedPortsDetail = json_decode($odc->used_ports_detail ?: '{}', true);
                $portToRemove = null;

                foreach ($usedPortsDetail as $portNum => $detail) {
                    if ($detail['type'] === $connectedType && $detail['id'] == $connectedId) {
                        $portToRemove = $portNum;
                        break;
                    }
                }

                if ($portToRemove) {
                    unset($usedPortsDetail[$portToRemove]);
                    $odc->used_ports_detail = json_encode($usedPortsDetail);
                    $odc->used_ports = count($usedPortsDetail);
                    $odc->save();
                    error_log("Removed port {$portToRemove} from ODC {$odcId}");
                }
            }

            // If connected device is ODP, clear its parent connection
            if ($connectedType === 'odp') {
                $odp = ORM::for_table('tbl_odp')->find_one($connectedId);
                if ($odp) {
                    $odp->odc_id = null;
                    $odp->port_number = null;
                    $odp->save();
                    error_log("Cleared parent connection for ODP {$connectedId}");
                }
            }
        }

        // Remove ODP to Customer connections
        if ($cable->from_type === 'odp' && $cable->to_type === 'customer') {
            $odpId = $cable->from_id;
            $customerId = $cable->to_id;

            $customer = ORM::for_table('tbl_customers')->find_one($customerId);
            if ($customer) {
                $portNumber = $customer->port_number;

                // Clear customer connection
                $customer->odp_id = null;
                $customer->port_number = null;
                $customer->save();
                error_log("Cleared ODP connection for customer {$customerId}");

                // Remove from ODP port details
                if ($portNumber) {
                    $odp = ORM::for_table('tbl_odp')->find_one($odpId);
                    if ($odp) {
                        $usedPortsDetail = json_decode($odp->used_ports_detail ?: '{}', true);
                        unset($usedPortsDetail[$portNumber]);
                        $odp->used_ports_detail = json_encode($usedPortsDetail);
                        $odp->used_ports = count($usedPortsDetail);
                        $odp->save();
                        error_log("Removed port {$portNumber} from ODP {$odpId}");
                    }
                }
            }
        }

        return true;
    } catch (Exception $e) {
        error_log('Error removing port connections: ' . $e->getMessage());
        return false;
    }
}

function restorePortConnections($cableRouteId)
{
    try {
        // Get backup data
        $backup = ORM::for_table('tbl_port_connection_backups')
            ->where('cable_route_id', $cableRouteId)
            ->find_one();

        if (!$backup) {
            error_log("No backup found for cable route {$cableRouteId}");
            return false;
        }

        $backupData = json_decode($backup->backup_data, true);
        if (!$backupData || !isset($backupData['connections'])) {
            error_log("Invalid backup data for cable route {$cableRouteId}");
            return false;
        }

        // Restore connections
        foreach ($backupData['connections'] as $connection) {
            if ($connection['device_type'] === 'odc') {
                // Restore ODC port detail
                $odc = ORM::for_table('tbl_odc')->find_one($connection['device_id']);
                if ($odc) {
                    $usedPortsDetail = json_decode($odc->used_ports_detail ?: '{}', true);
                    $usedPortsDetail[$connection['port_number']] = [
                        'type' => $connection['connected_type'],
                        'id' => $connection['connected_id'],
                        'name' => $connection['connected_name'],
                        'connected_at' => date('Y-m-d H:i:s')
                    ];
                    $odc->used_ports_detail = json_encode($usedPortsDetail);
                    $odc->used_ports = count($usedPortsDetail);
                    $odc->save();
                    error_log("Restored port {$connection['port_number']} to ODC {$connection['device_id']}");
                }
            } elseif ($connection['device_type'] === 'odp' && isset($connection['parent_connection'])) {
                // Restore ODP parent connection
                $odp = ORM::for_table('tbl_odp')->find_one($connection['device_id']);
                if ($odp) {
                    $odp->odc_id = $connection['parent_connection']['odc_id'];
                    $odp->port_number = $connection['parent_connection']['port_number'];
                    $odp->save();
                    error_log("Restored parent connection for ODP {$connection['device_id']}");
                }
            } elseif ($connection['device_type'] === 'odp' && isset($connection['port_number'])) {
                // Restore ODP port detail
                $odp = ORM::for_table('tbl_odp')->find_one($connection['device_id']);
                if ($odp) {
                    $usedPortsDetail = json_decode($odp->used_ports_detail ?: '{}', true);
                    $usedPortsDetail[$connection['port_number']] = [
                        'type' => $connection['connected_type'],
                        'id' => $connection['connected_id'],
                        'name' => $connection['connected_name'],
                        'connected_at' => date('Y-m-d H:i:s')
                    ];
                    $odp->used_ports_detail = json_encode($usedPortsDetail);
                    $odp->used_ports = count($usedPortsDetail);
                    $odp->save();
                    error_log("Restored port {$connection['port_number']} to ODP {$connection['device_id']}");
                }
            } elseif ($connection['device_type'] === 'customer' && isset($connection['odp_connection'])) {
                // Restore customer connection
                $customer = ORM::for_table('tbl_customers')->find_one($connection['device_id']);
                if ($customer) {
                    $customer->odp_id = $connection['odp_connection']['odp_id'];
                    $customer->port_number = $connection['odp_connection']['port_number'];
                    $customer->save();
                    error_log("Restored ODP connection for customer {$connection['device_id']}");
                }
            }
        }

        return true;
    } catch (Exception $e) {
        error_log('Error restoring port connections: ' . $e->getMessage());
        return false;
    }
}

function autoRecordCableThroughPoles($cable_route_id, $from_type, $from_id, $to_type, $to_id, $waypoints)
{
    try {
        // Find poles that are EXACTLY used as waypoints in this cable route
        $poles_in_route = [];

        foreach ($waypoints as $index => $waypoint) {
            // Skip first and last waypoint (source and destination)
            if ($index === 0 || $index === count($waypoints) - 1) {
                continue;
            }

            // Find pole that EXACTLY matches this waypoint coordinate
            $exact_pole = findExactPoleByCoordinate($waypoint['lat'], $waypoint['lng']);

            if ($exact_pole) {
                // Only add if not already added (avoid duplicates)
                if (!in_array($exact_pole['id'], $poles_in_route)) {
                    $poles_in_route[] = $exact_pole['id'];
                    error_log("Cable route {$cable_route_id} passes EXACTLY through pole {$exact_pole['id']} ({$exact_pole['name']})");
                }
            }
        }

        // Add bridge record for each pole in route
        foreach ($poles_in_route as $pole_id) {
            addPoleBridge($pole_id, $from_type, $from_id, $to_type, $to_id, $cable_route_id);
        }

        return count($poles_in_route);
    } catch (Exception $e) {
        error_log('Error auto-recording cable through poles: ' . $e->getMessage());
        return 0;
    }
}
function findExactPoleByCoordinate($waypoint_lat, $waypoint_lng, $tolerance = 10)
{
    try {
        $poles = ORM::for_table('tbl_poles')
            ->where('status', 'Active')
            ->find_array();

        foreach ($poles as $pole) {
            if (!$pole['coordinates']) continue;

            $pole_coords = explode(',', $pole['coordinates']);
            if (count($pole_coords) !== 2) continue;

            $pole_lat = (float)trim($pole_coords[0]);
            $pole_lng = (float)trim($pole_coords[1]);

            // Calculate distance using Haversine formula
            $distance = calculateDistance($waypoint_lat, $waypoint_lng, $pole_lat, $pole_lng);

            // Use very small tolerance (10 meters) for exact matching
            if ($distance <= $tolerance) {
                return $pole;
            }
        }

        return null;
    } catch (Exception $e) {
        error_log('Error finding exact pole by coordinate: ' . $e->getMessage());
        return null;
    }
}

function calculateDistance($lat1, $lng1, $lat2, $lng2)
{
    $earth_radius = 6371000; // meters

    $lat1_rad = deg2rad($lat1);
    $lat2_rad = deg2rad($lat2);
    $delta_lat = deg2rad($lat2 - $lat1);
    $delta_lng = deg2rad($lng2 - $lng1);

    $a = sin($delta_lat / 2) * sin($delta_lat / 2) +
        cos($lat1_rad) * cos($lat2_rad) *
        sin($delta_lng / 2) * sin($delta_lng / 2);
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

    return $earth_radius * $c;
}

function removePoleBridgeByCableRoute($cable_route_id)
{
    try {
        $bridges = ORM::for_table('tbl_pole_bridges')
            ->where('cable_route_id', $cable_route_id)
            ->find_many();

        $removed_count = 0;
        foreach ($bridges as $bridge) {
            error_log("Removing bridge: pole {$bridge->pole_id} - {$bridge->from_type}({$bridge->from_id}) -> {$bridge->to_type}({$bridge->to_id})");
            $bridge->delete();
            $removed_count++;
        }

        error_log("Successfully removed {$removed_count} pole bridges for cable route {$cable_route_id}");
        return $removed_count;
    } catch (Exception $e) {
        error_log('Error removing pole bridges: ' . $e->getMessage());
        return 0;
    }
}
function cleanupPoleBridgesForDeletedDevice($device_type, $device_id)
{
    try {
        // Find all bridges that involve this device
        $bridges = ORM::for_table('tbl_pole_bridges')
            ->where_raw(
                "(from_type = ? AND from_id = ?) OR (to_type = ? AND to_id = ?)",
                [$device_type, $device_id, $device_type, $device_id]
            )
            ->find_many();

        $cleaned_count = 0;
        foreach ($bridges as $bridge) {
            error_log("Cleaning bridge: pole {$bridge->pole_id} - {$bridge->from_type}({$bridge->from_id}) -> {$bridge->to_type}({$bridge->to_id})");
            $bridge->delete();
            $cleaned_count++;
        }

        error_log("Cleaned {$cleaned_count} pole bridges for deleted {$device_type} {$device_id}");
        return $cleaned_count;
    } catch (Exception $e) {
        error_log('Error cleaning pole bridges for deleted device: ' . $e->getMessage());
        return 0;
    }
}
function network_mapping_get_pole_bridges()
{
    header('Content-Type: application/json');

    $pole_id = _req('pole_id');

    if (empty($pole_id)) {
        echo json_encode(['success' => false, 'message' => 'Pole ID required']);
        exit;
    }

    try {
        $bridges = getPoleBridges($pole_id);

        echo json_encode([
            'success' => true,
            'bridges' => $bridges,
            'total' => count($bridges),
            'pole_id' => $pole_id
        ]);
    } catch (Exception $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Error: ' . $e->getMessage()
        ]);
    }

    exit;
}
function network_mapping_edit_pole_bridges()
{
    header('Content-Type: application/json');

    $pole_id = _req('pole_id');

    if (empty($pole_id)) {
        echo json_encode(['success' => false, 'message' => 'Pole ID required']);
        exit;
    }

    try {
        // Get pole info
        $pole = ORM::for_table('tbl_poles')->find_one($pole_id);
        if (!$pole) {
            echo json_encode(['success' => false, 'message' => 'Pole not found']);
            exit;
        }

        // Get all bridges for this pole with detailed info
        $bridges = ORM::for_table('tbl_pole_bridges')
            ->where('pole_id', $pole_id)
            ->order_by_asc('created_at')
            ->find_array();

        $formatted_bridges = [];
        foreach ($bridges as $bridge) {
            $from_name = getPoleConnectionName($bridge['from_type'], $bridge['from_id']);
            $to_name = getPoleConnectionName($bridge['to_type'], $bridge['to_id']);

            // Get cable route info
            $cable_info = '';
            if ($bridge['cable_route_id']) {
                $cable = ORM::for_table('tbl_cable_waypoints')->find_one($bridge['cable_route_id']);
                if ($cable) {
                    $cable_info = [
                        'id' => $cable->id,
                        'visible' => $cable->visible,
                        'cable_type' => $cable->cable_type
                    ];
                }
            }

            $formatted_bridges[] = [
                'id' => $bridge['id'],
                'from_type' => $bridge['from_type'],
                'from_id' => $bridge['from_id'],
                'from_name' => $from_name,
                'to_type' => $bridge['to_type'],
                'to_id' => $bridge['to_id'],
                'to_name' => $to_name,
                'status' => $bridge['status'] ?? 'active',
                'cable_route_id' => $bridge['cable_route_id'],
                'cable_info' => $cable_info,
                'created_at' => $bridge['created_at']
            ];
        }

        echo json_encode([
            'success' => true,
            'pole' => [
                'id' => $pole->id,
                'name' => $pole->name,
                'address' => $pole->address ?? ''
            ],
            'bridges' => $formatted_bridges,
            'total' => count($formatted_bridges)
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_update_bridge_status()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $bridge_id = _req('bridge_id');
    $new_status = _req('status'); // 'active' or 'inactive'

    if (empty($bridge_id) || !in_array($new_status, ['active', 'inactive'])) {
        echo json_encode(['success' => false, 'message' => 'Invalid parameters']);
        exit;
    }

    try {
        // Update bridge status
        $bridge = ORM::for_table('tbl_pole_bridges')->find_one($bridge_id);
        if (!$bridge) {
            echo json_encode(['success' => false, 'message' => 'Bridge not found']);
            exit;
        }

        $old_status = $bridge->status;
        $bridge->status = $new_status;
        $bridge->save();

        // Handle port connections based on status change
        if ($bridge->cable_route_id) {
            if ($new_status === 'inactive' && $old_status === 'active') {
                // HIDE: Backup port connections then remove them
                backupPortConnections($bridge->cable_route_id);
                removePortConnections($bridge->cable_route_id);
                error_log("Port connections backed up and removed for cable route {$bridge->cable_route_id}");
            } elseif ($new_status === 'active' && $old_status === 'inactive') {
                // SHOW: Restore port connections from backup
                restorePortConnections($bridge->cable_route_id);
                error_log("Port connections restored for cable route {$bridge->cable_route_id}");
            }

            // Update cable visibility
            $cable = ORM::for_table('tbl_cable_waypoints')->find_one($bridge->cable_route_id);
            if ($cable) {
                $cable->visible = ($new_status === 'active') ? 1 : 0;
                $cable->save();

                // Update ALL bridges for this cable route to same status
                $all_bridges = ORM::for_table('tbl_pole_bridges')
                    ->where('cable_route_id', $bridge->cable_route_id)
                    ->find_many();

                foreach ($all_bridges as $other_bridge) {
                    $other_bridge->status = $new_status;
                    $other_bridge->save();
                }

                error_log("Updated cable {$bridge->cable_route_id} visibility to " . ($new_status === 'active' ? '1' : '0'));
                error_log("Updated " . count($all_bridges) . " bridges to status: {$new_status}");
            }
        }

        $action_text = ($new_status === 'active') ? 'shown' : 'hidden';
        echo json_encode([
            'success' => true,
            'message' => "Bridge and cable route successfully {$action_text}",
            'affected_bridges' => count($all_bridges ?? []),
            'cable_hidden' => ($new_status === 'inactive'),
            'port_connections_updated' => true,
            'requires_reload' => true // Signal frontend to reload map
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_delete_bridge_from_pole()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $bridge_id = _req('bridge_id');

    if (empty($bridge_id)) {
        echo json_encode(['success' => false, 'message' => 'Bridge ID required']);
        exit;
    }

    try {
        $bridge = ORM::for_table('tbl_pole_bridges')->find_one($bridge_id);
        if (!$bridge) {
            echo json_encode(['success' => false, 'message' => 'Bridge not found']);
            exit;
        }

        $cable_route_id = $bridge->cable_route_id;
        $from_name = getPoleConnectionName($bridge->from_type, $bridge->from_id);
        $to_name = getPoleConnectionName($bridge->to_type, $bridge->to_id);

        // Delete cable route if exists
        if ($cable_route_id) {
            // REMOVE: Permanently delete port connections
            removePortConnections($cable_route_id);
            error_log("Port connections permanently removed for cable route {$cable_route_id}");

            // Delete backup data (permanent removal)
            $backup = ORM::for_table('tbl_port_connection_backups')
                ->where('cable_route_id', $cable_route_id)
                ->find_one();
            if ($backup) {
                $backup->delete();
                error_log("Backup data deleted for cable route {$cable_route_id}");
            }

            $cable = ORM::for_table('tbl_cable_waypoints')->find_one($cable_route_id);
            if ($cable) {
                $cable->delete();
                error_log("Deleted cable route {$cable_route_id}: {$from_name} -> {$to_name}");
            }

            // Delete ALL bridges associated with this cable route
            $all_bridges = ORM::for_table('tbl_pole_bridges')
                ->where('cable_route_id', $cable_route_id)
                ->find_many();

            $deleted_bridges_count = 0;
            foreach ($all_bridges as $other_bridge) {
                $other_bridge->delete();
                $deleted_bridges_count++;
            }

            error_log("Deleted {$deleted_bridges_count} bridges associated with cable route {$cable_route_id}");

            echo json_encode([
                'success' => true,
                'message' => "Bridge and cable route deleted successfully",
                'deleted_bridges' => $deleted_bridges_count,
                'deleted_cable' => true,
                'port_connections_removed' => true
            ]);
        } else {
            // Just delete this bridge if no cable route
            $bridge->delete();

            echo json_encode([
                'success' => true,
                'message' => "Bridge deleted successfully",
                'deleted_bridges' => 1,
                'deleted_cable' => false
            ]);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_edit_odc_modal()
{
    header('Content-Type: application/json');

    $id = _req('id');
    if (empty($id)) {
        echo json_encode(['success' => false, 'message' => 'ID ODC tidak valid']);
        exit;
    }

    try {
        $odc = ORM::for_table('tbl_odc')->find_one($id);
        if (!$odc) {
            echo json_encode(['success' => false, 'message' => 'ODC tidak ditemukan']);
            exit;
        }

        // Get routers for dropdown
        $routers = ORM::for_table('tbl_routers')
            ->where('enabled', 1)
            ->order_by_asc('name')
            ->find_array();

        // Get parent ODCs (exclude current ODC)
        $parent_odcs = ORM::for_table('tbl_odc')
            ->where('status', 'Active')
            ->where_not_equal('id', $id)
            ->order_by_asc('name')
            ->find_array();

        // Add port details to each parent ODC
        foreach ($parent_odcs as &$parent_odc) {
            $parent_odc['available_ports_detail'] = getAvailablePortsForOdc($parent_odc['id']);
            $parent_odc['used_ports_info'] = getUsedPortsDetail($parent_odc['id']);

            // Calculate actual used ports
            $connected_odps = ORM::for_table('tbl_odp')
                ->where('odc_id', $parent_odc['id'])
                ->where('status', 'Active')
                ->count();

            $connected_child_odcs = ORM::for_table('tbl_odc')
                ->where('parent_odc_id', $parent_odc['id'])
                ->where('status', 'Active')
                ->count();

            $parent_odc['used_ports'] = $connected_odps + $connected_child_odcs;
        }

        echo json_encode([
            'success' => true,
            'odc' => [
                'id' => $odc->id,
                'name' => $odc->name,
                'description' => $odc->description,
                'router_id' => $odc->router_id,
                'parent_odc_id' => $odc->parent_odc_id,
                'port_number' => $odc->port_number,
                'coordinates' => $odc->coordinates,
                'address' => $odc->address,
                'total_ports' => $odc->total_ports,
                'status' => $odc->status
            ],
            'routers' => $routers,
            'parent_odcs' => $parent_odcs
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_update_odc_modal()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $id = _req('id');
    $name = _req('name');
    $description = _req('description');
    $router_id = _req('router_id');
    $parent_odc_id = _req('parent_odc_id');
    $parent_port_number = _req('parent_port_number');
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_ports = _req('total_ports');
    $status = _req('status');

    if (empty($id) || empty($name)) {
        echo json_encode(['success' => false, 'message' => 'ID dan Nama ODC harus diisi']);
        exit;
    }

    // Validate parent ODC capacity (sama seperti function save yang lama)
    if (!empty($parent_odc_id)) {
        $target_parent_odc = ORM::for_table('tbl_odc')->find_one($parent_odc_id);
        if ($target_parent_odc) {
            if (!empty($parent_port_number)) {
                if (!validatePortAvailability($parent_odc_id, $parent_port_number, $id)) {
                    echo json_encode([
                        'success' => false,
                        'message' => 'Port ' . $parent_port_number . ' is already in use! Please select another port.'
                    ]);
                    exit;
                }
            }
        }
    }

    try {
        $odc = ORM::for_table('tbl_odc')->find_one($id);
        if (!$odc) {
            echo json_encode(['success' => false, 'message' => 'ODC tidak ditemukan']);
            exit;
        }

        // Get old values for port detail update
        $old_parent_odc_id = $odc->parent_odc_id;
        $old_port_number = $odc->port_number;

        // Update ODC data
        $odc->name = $name;
        $odc->description = $description;
        $odc->router_id = empty($router_id) ? null : $router_id;
        $odc->parent_odc_id = empty($parent_odc_id) ? null : $parent_odc_id;

        // Auto-select port if not specified but parent ODC is selected
        if (!empty($parent_odc_id) && empty($parent_port_number)) {
            $auto_port = autoSelectAvailablePort($parent_odc_id, $id);
            if ($auto_port) {
                $parent_port_number = $auto_port;
            }
        }

        $odc->port_number = empty($parent_port_number) ? null : $parent_port_number;
        $odc->coordinates = $coordinates;
        $odc->address = $address;
        $odc->total_ports = $total_ports;
        $odc->status = $status;
        $odc->save();

        // Update port details for parent ODC connections
        if (!empty($parent_odc_id) && !empty($parent_port_number)) {
            updateOdcPortDetail($parent_odc_id, $parent_port_number, 'odc', $odc->id, $odc->name, 'add');
        }

        if (
            !empty($old_parent_odc_id) && !empty($old_port_number) &&
            ($old_parent_odc_id != $parent_odc_id || $old_port_number != $parent_port_number)
        ) {
            updateOdcPortDetail($old_parent_odc_id, $old_port_number, 'odc', $odc->id, $odc->name, 'remove');
        }

        // Update port counts
        if (!empty($parent_odc_id)) {
            updateOdcPortCounts(null, $parent_odc_id);
        }
        if (!empty($old_parent_odc_id) && $old_parent_odc_id != $parent_odc_id) {
            updateOdcPortCounts(null, $old_parent_odc_id);
        }
        updateOdcPortCounts(null, $odc->id);

        echo json_encode([
            'success' => true,
            'message' => 'ODC berhasil diupdate',
            'odc' => [
                'id' => $odc->id,
                'name' => $odc->name,
                'coordinates' => $odc->coordinates
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_edit_odp_modal()
{
    header('Content-Type: application/json');

    $id = _req('id');
    if (empty($id)) {
        echo json_encode(['success' => false, 'message' => 'ID ODP tidak valid']);
        exit;
    }

    try {
        $odp = ORM::for_table('tbl_odp')->find_one($id);
        if (!$odp) {
            echo json_encode(['success' => false, 'message' => 'ODP tidak ditemukan']);
            exit;
        }

        // Get ODCs for dropdown with port details
        $odcs = ORM::for_table('tbl_odc')
            ->where('status', 'Active')
            ->order_by_asc('name')
            ->find_array();

        // Add port details to each ODC
        foreach ($odcs as &$odc) {
            $odc['available_ports_detail'] = getAvailablePortsForOdc($odc['id']);
            $odc['used_ports_info'] = getUsedPortsDetail($odc['id']);

            // Calculate actual used ports
            $connected_odps = ORM::for_table('tbl_odp')
                ->where('odc_id', $odc['id'])
                ->where('status', 'Active')
                ->count();

            $connected_child_odcs = ORM::for_table('tbl_odc')
                ->where('parent_odc_id', $odc['id'])
                ->where('status', 'Active')
                ->count();

            $odc['used_ports'] = $connected_odps + $connected_child_odcs;
        }

        // Get all customers with photo data
        $all_customers = ORM::for_table('tbl_customers')
            ->select('*')
            ->where('status', 'Active')
            ->order_by_asc('fullname')
            ->find_array();

        // Auto-prefix system/uploads untuk semua foto
        foreach ($all_customers as &$customer) {
            if (!empty($customer['photo']) && $customer['photo'] !== '/user.default.jpg' && strpos($customer['photo'], 'user.default.jpg') === false) {
                if (strpos($customer['photo'], 'http') !== 0) {
                    $customer['photo'] = '/system/uploads' . $customer['photo'];
                }
            }
        }

        // Get customers already connected to this ODP
        $connected_customers = ORM::for_table('tbl_customers')
            ->where('odp_id', $id)
            ->where('connection_status', 'Active')
            ->find_array();

        // Auto-prefix photos for connected customers too
        foreach ($connected_customers as &$customer) {
            if (!empty($customer['photo']) && $customer['photo'] !== '/user.default.jpg' && strpos($customer['photo'], 'user.default.jpg') === false) {
                if (strpos($customer['photo'], 'http') !== 0) {
                    $customer['photo'] = '/system/uploads' . $customer['photo'];
                }
            }
        }

        $connected_customers_count = count($connected_customers);
        $available_ports_display = $odp->total_ports - $connected_customers_count;
        if ($available_ports_display < 0) {
            $available_ports_display = 0;
        }

        echo json_encode([
            'success' => true,
            'odp' => [
                'id' => $odp->id,
                'name' => $odp->name,
                'description' => $odp->description,
                'odc_id' => $odp->odc_id,
                'port_number' => $odp->port_number,
                'coordinates' => $odp->coordinates,
                'address' => $odp->address,
                'total_ports' => $odp->total_ports,
                'used_ports' => $odp->used_ports,
                'status' => $odp->status
            ],
            'odcs' => $odcs,
            'all_customers' => $all_customers,
            'connected_customers' => $connected_customers,
            'connected_customers_count' => $connected_customers_count,
            'available_ports_display' => $available_ports_display
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_update_odp_modal()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $id = _req('id');
    $name = _req('name');
    $description = _req('description');
    $odc_id = _req('odc_id');
    $port_number = _req('port_number');
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_ports = _req('total_ports');
    $status = _req('status');

    if (empty($id) || empty($name)) {
        echo json_encode(['success' => false, 'message' => 'ID dan Nama ODP harus diisi']);
        exit;
    }

    // Validate ODC capacity and port availability
    if (!empty($odc_id)) {
        $target_odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if ($target_odc) {
            if (!empty($port_number)) {
                if (!validatePortAvailability($odc_id, $port_number, $id)) {
                    echo json_encode([
                        'success' => false,
                        'message' => 'Port ' . $port_number . ' is already in use! Please select another port.'
                    ]);
                    exit;
                }
            }
        }
    }

    try {
        $odp = ORM::for_table('tbl_odp')->find_one($id);
        if (!$odp) {
            echo json_encode(['success' => false, 'message' => 'ODP tidak ditemukan']);
            exit;
        }

        // Get old ODC connection for port calculation
        $old_odc_id = $odp->odc_id;
        $old_port_number = $odp->port_number;

        // Update ODP data
        $odp->name = $name;
        $odp->description = $description;
        $odp->odc_id = empty($odc_id) ? null : $odc_id;

        // Auto-select port if not specified but ODC is selected
        if (!empty($odc_id) && empty($port_number)) {
            $auto_port = autoSelectAvailablePort($odc_id, $id);
            if ($auto_port) {
                $port_number = $auto_port;
            }
        }

        $odp->port_number = empty($port_number) ? null : $port_number;
        $odp->coordinates = $coordinates;
        $odp->address = $address;
        $odp->total_ports = $total_ports;
        $odp->status = $status;
        $odp->save();

        // Handle customer assignments
        $selected_customers = isset($_POST['customers']) && is_array($_POST['customers']) ? $_POST['customers'] : [];
        $customer_ports = isset($_POST['customer_ports']) && is_array($_POST['customer_ports']) ? $_POST['customer_ports'] : [];

        if (!is_array($selected_customers)) {
            $selected_customers = [];
        }

        // Clean customer_ports - remove empty values
        $cleaned_customer_ports = [];
        foreach ($customer_ports as $customer_id => $port) {
            if (!empty($port) && $port !== '') {
                $cleaned_customer_ports[$customer_id] = (int)$port;
            }
        }
        $customer_ports = $cleaned_customer_ports;

        // Validate customer count against available ports
        if (count($selected_customers) > $odp->total_ports) {
            echo json_encode(['success' => false, 'message' => 'Maksimal ' . $odp->total_ports . ' customers. Anda pilih ' . count($selected_customers)]);
            exit;
        }

        // Validate port assignments
        $used_ports = [];
        foreach ($selected_customers as $customer_id) {
            if (isset($customer_ports[$customer_id]) && $customer_ports[$customer_id]) {
                $port = $customer_ports[$customer_id];
                if (in_array($port, $used_ports)) {
                    echo json_encode(['success' => false, 'message' => 'Port ' . $port . ' sudah digunakan! Pilih port lain.']);
                    exit;
                }
                $used_ports[] = $port;
            }
        }

        // Update customer assignments
        updateCustomerOdpAssignments($odp->id, $selected_customers, $customer_ports);

        // Update ODP used_ports count after customer assignment
        $connected_customers_count = ORM::for_table('tbl_customers')
            ->where('odp_id', $odp->id)
            ->where('connection_status', 'Active')
            ->count();

        $odp->used_ports = $connected_customers_count;
        $odp->save();

        // Update ODC port counts and port details
        if (!empty($odc_id) && !empty($port_number)) {
            updateOdcPortDetail($odc_id, $port_number, 'odp', $odp->id, $odp->name, 'add');
        }

        if (!empty($old_odc_id) && !empty($old_port_number) && ($old_odc_id != $odc_id || $old_port_number != $port_number)) {
            updateOdcPortDetail($old_odc_id, $old_port_number, 'odp', $odp->id, $odp->name, 'remove');
        }

        // Update ODC port counts
        updateOdcPortCounts($old_odc_id, $odc_id);

        echo json_encode([
            'success' => true,
            'message' => 'ODP berhasil diupdate dengan ' . $connected_customers_count . ' customers',
            'odp' => [
                'id' => $odp->id,
                'name' => $odp->name,
                'coordinates' => $odp->coordinates,
                'used_ports' => $connected_customers_count,
                'total_ports' => $odp->total_ports
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_list_odc_modal()
{
    header('Content-Type: application/json');

    $search = _req('search', '');
    $page = (int)_req('page', 1);
    $limit = (int)_req('limit', 10);
    $offset = ($page - 1) * $limit;

    try {
        $query = ORM::for_table('tbl_odc')
            ->select('tbl_odc.*')
            ->select('tbl_routers.name', 'router_name')
            ->left_outer_join('tbl_routers', array('tbl_odc.router_id', '=', 'tbl_routers.id'))
            ->where('tbl_odc.status', 'Active')
            ->order_by_desc('tbl_odc.id');

        if (!empty($search)) {
            $query->where_raw("(tbl_odc.name LIKE '%$search%' OR tbl_odc.description LIKE '%$search%' OR tbl_odc.address LIKE '%$search%')");
        }

        // Get total count
        $total_count = $query->count();

        $odcs = $query->limit($limit)
            ->offset($offset)
            ->find_array();

        // Process ODC data - update port counts
        foreach ($odcs as &$odc) {
            $connected_odps = ORM::for_table('tbl_odp')
                ->where('odc_id', $odc['id'])
                ->where('status', 'Active')
                ->count();

            $connected_child_odcs = ORM::for_table('tbl_odc')
                ->where('parent_odc_id', $odc['id'])
                ->where('status', 'Active')
                ->count();

            $total_used_ports = $connected_odps + $connected_child_odcs;

            // Update database
            $update_odc = ORM::for_table('tbl_odc')->find_one($odc['id']);
            if ($update_odc) {
                $update_odc->used_ports = $total_used_ports;
                $update_odc->save();
            }

            $odc['used_ports'] = $total_used_ports;
            $odc['available_ports'] = $odc['total_ports'] - $total_used_ports;
        }

        $has_more = ($offset + count($odcs)) < $total_count;
        $remaining = max(0, $total_count - ($offset + count($odcs)));

        echo json_encode([
            'success' => true,
            'odcs' => $odcs,
            'total_found' => $total_count,
            'page' => $page,
            'limit' => $limit,
            'has_more' => $has_more,
            'remaining' => $remaining
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
function network_mapping_list_odp_modal()
{
    header('Content-Type: application/json');
    
    $search = _req('search', '');
    $page = (int)_req('page', 1);
    $limit = (int)_req('limit', 10);
    $offset = ($page - 1) * $limit;

    try {
        $query = ORM::for_table('tbl_odp')
            ->select('tbl_odp.*')
            ->select('tbl_odc.name', 'odc_name')
            ->left_outer_join('tbl_odc', array('tbl_odp.odc_id', '=', 'tbl_odc.id'))
            ->where('tbl_odp.status', 'Active')
            ->order_by_desc('tbl_odp.id');

        if (!empty($search)) {
            $query->where_raw("(tbl_odp.name LIKE '%$search%' OR tbl_odp.description LIKE '%$search%' OR tbl_odp.address LIKE '%$search%')");
        }

        // Get total count
        $total_count = $query->count();

        $odps = $query->limit($limit)
            ->offset($offset)
            ->find_array();

        // Process ODP data - update port counts
        foreach ($odps as &$odp) {
            $connected_customers = ORM::for_table('tbl_customers')
                ->where('odp_id', $odp['id'])
                ->where('connection_status', 'Active')
                ->count();
            
            // Update database
            $update_odp = ORM::for_table('tbl_odp')->find_one($odp['id']);
            if ($update_odp) {
                $update_odp->used_ports = $connected_customers;
                $update_odp->save();
            }

            $odp['used_ports'] = $connected_customers;
            $odp['available_ports'] = $odp['total_ports'] - $connected_customers;
        }

        $has_more = ($offset + count($odps)) < $total_count;
        $remaining = max(0, $total_count - ($offset + count($odps)));

        echo json_encode([
            'success' => true,
            'odps' => $odps,
            'total_found' => $total_count,
            'page' => $page,
            'limit' => $limit,
            'has_more' => $has_more,
            'remaining' => $remaining
        ]);

    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}