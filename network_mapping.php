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
        case 'odc':
            network_mapping_odc();
            break;
        case 'odp':
            network_mapping_odp();
            break;
        case 'add-odc':
            network_mapping_add_odc();
            break;
        case 'add-odp':
            network_mapping_add_odp();
            break;
        case 'edit-odc':
            network_mapping_edit_odc();
            break;
        case 'edit-odp':
            network_mapping_edit_odp();
            break;
        case 'save-odc':
            network_mapping_save_odc();
            break;
        case 'save-odp':
            network_mapping_save_odp();
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

        // TAMBAHAN BARU UNTUK OLT
        case 'quick-add-olt':
            network_mapping_quick_add_olt();
            break;
        case 'quick-save-olt':
            network_mapping_quick_save_olt();
            break;
        case 'ajax-delete-olt':
            network_mapping_ajax_delete_olt();
            break;
        case 'get-available-uplink-ports':
            network_mapping_get_available_uplink_ports();
            break;
        case 'get-available-pon-ports':
            network_mapping_get_available_pon_ports();
            break;
        case 'get-olt-connections':
            network_mapping_get_olt_connections();
            break;
        case 'disconnect-from-olt':
            network_mapping_disconnect_from_olt();
            break;
        case 'get-olt-details':
            network_mapping_get_olt_details();
            break;
        case 'update-olt':
            network_mapping_update_olt();
            break;
        case 'get-olt-port-usage':
            network_mapping_get_olt_port_usage();
            break;
        case 'get-olt-pon-usage':
            network_mapping_get_olt_pon_usage();
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

    // Get all active OLTs with coordinates
    $olts_query = ORM::for_table('tbl_olt')
        ->where_not_equal('coordinates', '')
        ->where('status', 'Active')
        ->order_by_asc('name');

    if (!empty($search)) {
        $olts_query->where_like('name', '%' . $search . '%');
    }

    $olts = $olts_query->find_array();

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
        'olts' => [], // TAMBAHAN BARU
        'odcs' => [],
        'odps' => [],
        'customers' => [],
        'poles' => []
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

    // Format OLTs data
    foreach ($olts as $olt) {

        // DEBUG: Check port data
        debugOltPortData($olt['id']);
        // Count ODCs connected to this OLT via PON
        $connected_odcs = ORM::for_table('tbl_odc')
            ->where('olt_id', $olt['id'])
            ->where('status', 'Active')
            ->count();

        // Count child OLTs connected to this OLT via PON (BUKAN uplink)
        $connected_child_olts = ORM::for_table('tbl_olt')
            ->where('parent_olt_id', $olt['id'])
            ->where('status', 'Active')
            ->count();

        // ✅ BENAR: Total used uplink hanya dari router/parent OLT
        $total_used_uplink = 0;

        // ✅ BENAR: Router connection menggunakan 1 uplink port
        if (!empty($olt['router_id'])) {
            $total_used_uplink += 1; // Router connection menggunakan 1 uplink port
        }

        // ✅ BENAR: Parent OLT connection menggunakan 1 uplink port (child side)
        if (!empty($olt['parent_olt_id'])) {
            $total_used_uplink += 1; // Child OLT selalu pakai 1 uplink untuk connect ke parent
        }

        // PERBAIKAN: Cleanup dan sync port detail
        cleanupOltUplinkPorts($olt['id']); // Cleanup dulu

        if (!empty($olt['router_id'])) {
            syncOltRouterPortDetail($olt['id']); // Lalu sync
        }

        // ✅ BENAR: Total used PON = ODCs + Child OLTs
        $total_used_pon = $connected_odcs + $connected_child_olts;

        // Update database dengan actual count
        $update_olt = ORM::for_table('tbl_olt')->find_one($olt['id']);
        if ($update_olt) {
            $update_olt->used_uplink_ports = $total_used_uplink;
            $update_olt->used_pon_ports = $total_used_pon;
            $update_olt->save();
        }

        $available_uplink = $olt['total_uplink_ports'] - $total_used_uplink;
        $available_pon = $olt['total_pon_ports'] - $total_used_pon;

        // Get connection info (router or parent OLT)
        $connection_info = '';
        $uplink_connection_info = '';
        if ($olt['router_id']) {
            $connected_router = ORM::for_table('tbl_routers')->find_one($olt['router_id']);
            if ($connected_router) {
                $connection_info = "<br>Uplink: <strong>" . $connected_router->name . " (Router)</strong>";
                $uplink_connection_info = "Router: " . $connected_router->name;
            }
        } elseif ($olt['parent_olt_id']) {
            $parent_olt = ORM::for_table('tbl_olt')->find_one($olt['parent_olt_id']);
            if ($parent_olt) {
                $connection_info = "<br>Uplink: <strong>" . $parent_olt->name . " (PON " . $olt['uplink_port_number'] . ")</strong>";
                $uplink_connection_info = "OLT: " . $parent_olt->name . " (PON " . $olt['uplink_port_number'] . ")";
            }
        }

        // Get port status display
        $uplink_port_status = getOltUplinkPortStatusDisplay($olt['id']);
        $pon_port_status = getOltPonPortStatusDisplay($olt['id']);

        // Add unplug button if has connections
        $total_connections = $total_used_uplink + $total_used_pon;
        $unplugBtn = $total_connections > 0 ?
            " | <a href='javascript:void(0)' onclick='showOltDisconnectModal(" . $olt['id'] . ", \"" . $olt['name'] .
            "\", " . $total_connections . ")' style='color: #bc8d4bff;'>Unplug (" . $total_connections . ")</a>" : "";

        $network_data['olts'][] = [
            'id' => $olt['id'],
            'name' => $olt['name'],
            'type' => 'olt',
            'coordinates' => $olt['coordinates'],
            'description' => $olt['description'],
            'total_uplink_ports' => $olt['total_uplink_ports'],
            'total_pon_ports' => $olt['total_pon_ports'],
            'used_uplink_ports' => $total_used_uplink,
            'used_pon_ports' => $total_used_pon,
            'available_uplink_ports' => $available_uplink,
            'available_pon_ports' => $available_pon,
            'router_id' => $olt['router_id'],
            'parent_olt_id' => $olt['parent_olt_id'],
            'uplink_port_number' => $olt['uplink_port_number'],
            'uplink_connection_info' => $uplink_connection_info,
            'uplink_port_status' => $uplink_port_status,
            'pon_port_status' => $pon_port_status,
            'popup_content' => "<strong>OLT: " . $olt['name'] . "</strong><br>" .
                "Uplink: " . $total_used_uplink . "/" . $olt['total_uplink_ports'] . " | PON: " . $total_used_pon . "/" . $olt['total_pon_ports'] . "<br>" .
                "Address: " . $olt['address'] . $connection_info . "<br>" .
                "<a href='javascript:void(0)' onclick='showOltDetail(" . $olt['id'] . ")'>Detail</a> | " .
                "<a href='javascript:void(0)' onclick='editOltFromMap(" . $olt['id'] . ")'>Edit</a>" . $unplugBtn . " | " .
                "<a href='javascript:void(0)' onclick='deleteOltFromMap(" . $olt['id'] . ", \"" . $olt['name'] . "\")' style='color: #d9534f;'>Delete</a> | " .
                "<a href='https://www.google.com/maps/dir//" . $olt['coordinates'] . "' target='_blank'>Direction</a>"
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

        // ✅ Get connection info (OLT, router, or parent ODC)
        $connection_info = '';
        $uplink_connection_info = '';

        if ($odc['olt_id']) {
            $connected_olt = ORM::for_table('tbl_olt')->find_one($odc['olt_id']);
            if ($connected_olt) {
                $pon_info = $odc['pon_port_number'] ? " (PON " . $odc['pon_port_number'] . ")" : "";
                $connection_info = "<br>Uplink: <strong>" . $connected_olt->name . " (OLT)" . $pon_info . "</strong>";
                $uplink_connection_info = "OLT: " . $connected_olt->name . $pon_info;
            }
        } elseif ($odc['router_id']) {
            $connected_router = ORM::for_table('tbl_routers')->find_one($odc['router_id']);
            if ($connected_router) {
                $connection_info = "<br>Uplink: <strong>" . $connected_router->name . " (Router)</strong>";
                $uplink_connection_info = "Router: " . $connected_router->name;
            }
        } elseif ($odc['parent_odc_id']) {
            $parent_odc = ORM::for_table('tbl_odc')->find_one($odc['parent_odc_id']);
            if ($parent_odc) {
                $port_info = $odc['port_number'] ? " (Port " . $odc['port_number'] . ")" : "";
                $connection_info = "<br>Uplink: <strong>" . $parent_odc->name . " (ODC)" . $port_info . "</strong>";
                $uplink_connection_info = "ODC: " . $parent_odc->name . $port_info;
            }
        }

        // Add unplug button if has connections
        $unplugBtn = $total_used_ports > 0 ?
            " | <a href='javascript:void(0)' onclick='showOdcDisconnectModal(" . $odc['id'] . ", \"" . $odc['name'] .
            "\", " . $total_used_ports . ")' style='color: #bc8d4bff;'>Unplug (" . $total_used_ports . ")</a>" : "";

        // ✅ PERBAIKAN: Get ONLY used ports (tidak semua port status)
        $used_ports_detail = getUsedPortsDetail($odc['id']);
        $used_ports_status = '';
        if (!empty($used_ports_detail)) {
            $used_ports_status = '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(255, 7, 7, 0.1); border-left: 3px solid #ff0707ff; font-size: 11px;">';
            $used_ports_status .= '<i class="fa fa-plug text-warning"></i> <strong>Used Ports:</strong><br>';

            foreach ($used_ports_detail as $port_num => $detail) {
                $used_ports_status .= '• Port ' . $port_num . ': ' . $detail['name'] . ' (' . strtoupper($detail['type']) . ')<br>';
            }

            $used_ports_status = rtrim($used_ports_status, '<br>') . '</div>';
        }

        // ✅ PERBAIKAN: Get child connection status (untuk ODC yang jadi parent)
        $child_connection_status = '';
        if ($odc['parent_odc_id'] && $odc['port_number']) {
            $parent_odc = ORM::for_table('tbl_odc')->find_one($odc['parent_odc_id']);
            if ($parent_odc) {
                $child_connection_status = '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(23, 162, 184, 0.1); border-left: 3px solid #17a2b8; font-size: 11px;">';
                $child_connection_status .= '<i class="fa fa-link text-info"></i> <strong>Connected to Port:</strong><br>';
                $child_connection_status .= '• Port ' . $odc['port_number'] . ' (' . $parent_odc->name . ')';
                $child_connection_status .= '</div>';
            }
        }

        // ✅ PERBAIKAN: OLT connection status
        $olt_connection_status = '';
        if ($odc['olt_id'] && $odc['pon_port_number']) {
            $connected_olt = ORM::for_table('tbl_olt')->find_one($odc['olt_id']);
            if ($connected_olt) {
                $olt_connection_status = '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(23, 162, 184, 0.1); border-left: 3px solid #17a2b8; font-size: 11px;">';
                $olt_connection_status .= '<i class="fa fa-link text-info"></i> <strong>OLT Connection:</strong><br>';
                $olt_connection_status .= '• ' . $connected_olt->name . ' (PON ' . $odc['pon_port_number'] . ')';
                $olt_connection_status .= '</div>';
            }
        }

        // ✅ PERBAIKAN: Available ports - hanya tampilkan 1x
        $available_ports_status = '';
        if ($available_ports > 0) {
            // Get actual available ports from database
            $available_ports_list = getAvailablePortsForOdc($odc['id']);

            if (!empty($available_ports_list)) {
                $available_ports_status = '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(40, 167, 69, 0.1); border-left: 3px solid #28a745; font-size: 11px;">';
                $available_ports_status .= '<i class="fa fa-check-circle text-success"></i> <strong>Available Ports:</strong><br>';
                $available_ports_status .= '• Port ' . implode(', Port ', $available_ports_list);
                $available_ports_status .= '</div>';
            }
        }

        // ✅ PERBAIKAN: Gabungkan status dengan line breaks yang benar
        $status_sections = [];

        if (!empty($olt_connection_status)) {
            $status_sections[] = $olt_connection_status;
        }

        if (!empty($child_connection_status)) {
            $status_sections[] = $child_connection_status;
        }

        if (!empty($used_ports_status)) {
            $status_sections[] = $used_ports_status;
        }

        if (!empty($available_ports_status)) {
            $status_sections[] = $available_ports_status;
        }

        // Join dengan line break
        $additional_status = !empty($status_sections) ? '<br>' . implode('', $status_sections) : '';

        $network_data['odcs'][] = [
            'id' => $odc['id'],
            'name' => $odc['name'],
            'type' => 'odc',
            'coordinates' => $odc['coordinates'],
            'description' => $odc['description'],
            'total_ports' => $odc['total_ports'],
            'used_ports' => $total_used_ports,
            'available_ports' => $available_ports,
            'olt_id' => $odc['olt_id'],
            'pon_port_number' => $odc['pon_port_number'],
            'router_id' => $odc['router_id'],
            'parent_odc_id' => $odc['parent_odc_id'],
            'port_number' => $odc['port_number'],
            'uplink_connection_info' => $uplink_connection_info,
            'popup_content' => "<strong>ODC: " . $odc['name'] . "</strong><br>" .
                "Ports: " . $total_used_ports . "/" . $odc['total_ports'] . " (Available: " . $available_ports . ")<br>" .
                "Address: " . ($odc['address'] ?: 'No address') . $connection_info . "<br>" .
                "<a href='javascript:void(0)' onclick='showOdcDetail(" . $odc['id'] . ")'>Detail</a> | " .
                "<a href='javascript:void(0)' onclick='editOdcFromMap(" . $odc['id'] . ")'>Edit</a>" . $unplugBtn . " | " .
                "<a href='javascript:void(0)' onclick='deleteOdcFromMap(" . $odc['id'] . ", \"" . $odc['name'] . "\")' style='color: #d9534f;'>Delete</a> | " .
                "<a href='https://www.google.com/maps/dir//" . $odc['coordinates'] . "' target='_blank'>Direction</a>" .
                $additional_status // ✅ Status sections dengan proper line breaks
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
        'total_olts' => count($network_data['olts']), // TAMBAHAN BARU
        'total_odcs' => count($network_data['odcs']),
        'total_odps' => count($network_data['odps']),
        'total_customers' => count($network_data['customers']),
        'total_poles' => count($network_data['poles'])
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

function network_mapping_add_odc()
{
    global $ui;

    // Get OLTs for dropdown (CHANGED: routers -> olts)
    $olts = ORM::for_table('tbl_olt')
        ->where('status', 'Active')
        ->order_by_asc('name')
        ->find_array();

    // Add port details to each OLT
    foreach ($olts as &$olt) {
        $olt['available_pon_ports_detail'] = getAvailablePonPortsForOlt($olt['id']);
        $olt['used_pon_ports_info'] = getUsedPonPortsDetail($olt['id']);

        $connected_odcs = ORM::for_table('tbl_odc')
            ->where('olt_id', $olt['id'])
            ->where('status', 'Active')
            ->count();

        $olt['used_pon_ports'] = $connected_odcs;
    }

    // Get ODCs for ODC-to-ODC connection (optional) with port details
    $parent_odcs = ORM::for_table('tbl_odc')
        ->where('status', 'Active')
        ->order_by_asc('name')
        ->find_array();

    // ✅ TAMBAHAN: Add port details to each ODC (SAMA SEPERTI QUICKADD)
    foreach ($parent_odcs as &$odc) {
        $odc['available_ports_detail'] = getAvailablePortsForOdc($odc['id']);
        $odc['used_ports_info'] = getUsedPortsDetail($odc['id']);

        // ✅ TAMBAHAN: Calculate actual used ports
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

    $ui->assign('olts', $olts); // CHANGED: routers -> olts
    $ui->assign('parent_odcs', $parent_odcs);
    $ui->assign('csrf_token', Csrf::generateAndStoreToken());
    $ui->display('network_mapping_odc_form.tpl');
}

function network_mapping_add_odp()
{
    global $ui;

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

    // ✅ MODIFIKASI: Get all customers with photo data
    $all_customers = ORM::for_table('tbl_customers')
        ->select('*') // Select all columns including photo
        ->where('status', 'Active')
        ->order_by_asc('fullname')
        ->find_array();

    // ✅ PERBAIKAN: Auto-prefix system/uploads untuk semua foto
    foreach ($all_customers as &$customer) {
        if (!empty($customer['photo']) && $customer['photo'] !== '/user.default.jpg' && strpos($customer['photo'], 'user.default.jpg') === false) {
            // Check if already a full URL
            if (strpos($customer['photo'], 'http') !== 0) {
                // ✅ AUTO-PREFIX: Semua foto ada di /system/uploads
                $customer['photo'] = '/system/uploads' . $customer['photo'];
            }
        }
    }

    // For new ODP, no connected customers
    $connected_customers = [];
    $connected_customers_count = 0;

    // Initialize $d with default values for new ODP
    $d = [
        'id' => '',
        'name' => '',
        'description' => '',
        'odc_id' => '',
        'port_number' => '',
        'coordinates' => '',
        'address' => '',
        'total_ports' => 8, // Default 8 ports
        'status' => 'Active',
        'used_ports' => 0,
    ];

    // Calculate available_ports
    $available_ports_display = $d['total_ports'] - $connected_customers_count;
    if ($available_ports_display < 0) {
        $available_ports_display = 0;
    }

    $ui->assign('d', $d);
    $ui->assign('odcs', $odcs);
    $ui->assign('all_customers', $all_customers);
    $ui->assign('connected_customers', $connected_customers);
    $ui->assign('connected_customers_count', $connected_customers_count);
    $ui->assign('available_ports_display', $available_ports_display);
    $ui->assign('csrf_token', Csrf::generateAndStoreToken());
    $ui->display('network_mapping_odp_form.tpl');
}

// Perbaikan untuk network_mapping_save_odc() function
function network_mapping_save_odc()
{
    if (!Csrf::check($_POST['csrf_token'])) {
        r2(U . 'plugin/network_mapping/odc', 'e', 'CSRF Token tidak valid');
    }

    $name = _req('name');
    $description = _req('description');
    $olt_id = _req('olt_id'); // CHANGED: router_id -> olt_id
    $pon_port_number = _req('pon_port_number'); // ADDED: PON port
    $parent_odc_id = _req('parent_odc_id');
    $parent_port_number = _req('parent_port_number');
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_ports = _req('total_ports');
    $status = _req('status');
    $id = _req('id');

    if (empty($name)) {
        $redirect_url = $id ? U . 'plugin/network_mapping/edit-odc?id=' . $id : U . 'plugin/network_mapping/add-odc';
        r2($redirect_url, 'e', 'Nama ODC harus diisi');
    }

    // ✅ TAMBAHAN: Validate OLT capacity and PON port availability
    if (!empty($olt_id)) {
        $target_olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if ($target_olt) {
            if (!empty($pon_port_number)) {
                if (!validatePonPortAvailability($olt_id, $pon_port_number, $id)) {
                    $redirect_url = $id ? U . 'plugin/network_mapping/edit-odc?id=' . $id : U . 'plugin/network_mapping/add-odc';
                    r2($redirect_url, 'e', 'PON Port ' . $pon_port_number . ' is already in use! Please select another port.');
                }
            } else {
                // Check if OLT has available PON ports for auto-selection
                $current_connected_odcs = ORM::for_table('tbl_odc')
                    ->where('olt_id', $olt_id)
                    ->where('status', 'Active')
                    ->count();

                // If editing, exclude current ODC from count
                if ($id) {
                    $current_odc = ORM::for_table('tbl_odc')->find_one($id);
                    if ($current_odc && $current_odc->olt_id == $olt_id) {
                        $current_connected_odcs--;
                    }
                }

                if ($current_connected_odcs >= $target_olt->total_pon_ports) {
                    $redirect_url = $id ? U . 'plugin/network_mapping/edit-odc?id=' . $id : U . 'plugin/network_mapping/add-odc';
                    r2($redirect_url, 'e', 'OLT sudah penuh! Used: ' . $current_connected_odcs . '/' . $target_olt->total_pon_ports . ' PON ports');
                }
            }
        }
    }

    // Validate parent ODC capacity
    if (!empty($parent_odc_id)) {
        $target_parent_odc = ORM::for_table('tbl_odc')->find_one($parent_odc_id);
        if ($target_parent_odc) {
            // Count current connections to parent ODC (ODPs + child ODCs)
            $current_odps = ORM::for_table('tbl_odp')
                ->where('odc_id', $parent_odc_id)
                ->where('status', 'Active')
                ->count();

            $current_child_odcs = ORM::for_table('tbl_odc')
                ->where('parent_odc_id', $parent_odc_id)
                ->where('status', 'Active')
                ->count();

            // If editing, exclude current ODC from count
            if ($id) {
                $current_odc = ORM::for_table('tbl_odc')->find_one($id);
                if ($current_odc && $current_odc->parent_odc_id == $parent_odc_id) {
                    $current_child_odcs--;
                }
            }

            $total_used = $current_odps + $current_child_odcs;

            if ($total_used >= $target_parent_odc->total_ports) {
                $redirect_url = $id ? U . 'plugin/network_mapping/edit-odc?id=' . $id : U . 'plugin/network_mapping/add-odc';
                r2($redirect_url, 'e', 'Parent ODC sudah penuh! Used: ' . $total_used . '/' . $target_parent_odc->total_ports . ' ports');
            }
        }
    }

    if ($id) {
        // Update
        $odc = ORM::for_table('tbl_odc')->find_one($id);
        if (!$odc) {
            r2(U . 'plugin/network_mapping/odc', 'e', 'ODC tidak ditemukan');
        }
    } else {
        // Create new
        $odc = ORM::for_table('tbl_odc')->create();
        $odc->used_ports = 0;
    }

    $odc->name = $name;
    $odc->description = $description;
    $odc->olt_id = empty($olt_id) ? null : $olt_id; // CHANGED: router_id -> olt_id

    // ✅ PERBAIKAN: Auto-select PON port if not specified but OLT is selected
    if (!empty($olt_id) && empty($pon_port_number)) {
        $auto_port = autoSelectAvailablePonPort($olt_id, $id);
        if ($auto_port) {
            $pon_port_number = $auto_port;
            error_log("Auto-selected PON port {$auto_port} for ODC {$name} connecting to OLT {$olt_id}");
        }
    }

    $odc->pon_port_number = empty($pon_port_number) ? null : $pon_port_number; // ADDED
    $odc->parent_odc_id = empty($parent_odc_id) ? null : $parent_odc_id;

    // Auto-select port if not specified but parent ODC is selected
    if (!empty($parent_odc_id) && empty($parent_port_number)) {
        $auto_port = autoSelectAvailablePort($parent_odc_id, $id);
        if ($auto_port) {
            $parent_port_number = $auto_port;
            error_log("Auto-selected port {$auto_port} for ODC {$name} connecting to parent ODC {$parent_odc_id}");
        }
    }

    $odc->port_number = empty($parent_port_number) ? null : $parent_port_number;
    $odc->coordinates = $coordinates;
    $odc->address = $address;
    $odc->total_ports = $total_ports;
    $odc->status = $status;

    // ✅ PERBAIKAN: Get old values for port detail update (TAMBAH OLT TRACKING)
    $old_olt_id = null;
    $old_pon_port_number = null;
    $old_parent_odc_id = null;
    $old_port_number = null;

    if ($id) {
        $old_odc = ORM::for_table('tbl_odc')->find_one($id);
        if ($old_odc) {
            $old_olt_id = $old_odc->olt_id;
            $old_pon_port_number = $old_odc->pon_port_number;
            $old_parent_odc_id = $old_odc->parent_odc_id;
            $old_port_number = $old_odc->port_number;
        }
    }

    $odc->save();

    // ✅ PERBAIKAN: Update OLT PON port details and counts
    if (!empty($olt_id) && !empty($pon_port_number)) {
        // Update new OLT PON port detail
        updateOltPonPortDetail($olt_id, $pon_port_number, 'odc', $odc->id, $odc->name, 'add');
    }

    if (
        !empty($old_olt_id) && !empty($old_pon_port_number) &&
        ($old_olt_id != $olt_id || $old_pon_port_number != $pon_port_number)
    ) {
        // Remove old OLT PON port detail
        updateOltPonPortDetail($old_olt_id, $old_pon_port_number, 'odc', $odc->id, $odc->name, 'remove');
    }

    // Update port details for parent ODC connections
    if (!empty($parent_odc_id) && !empty($parent_port_number)) {
        // Update new parent ODC port detail
        updateOdcPortDetail($parent_odc_id, $parent_port_number, 'odc', $odc->id, $odc->name, 'add');
    }

    if (
        !empty($old_parent_odc_id) && !empty($old_port_number) &&
        ($old_parent_odc_id != $parent_odc_id || $old_port_number != $parent_port_number)
    ) {
        // Remove old parent ODC port detail
        updateOdcPortDetail($old_parent_odc_id, $old_port_number, 'odc', $odc->id, $odc->name, 'remove');
    }

    // ✅ PERBAIKAN: Update port counts after saving ODC
    if (!empty($olt_id)) {
        // If this ODC connects to an OLT, update OLT's port count
        updateOltPortCounts(null, $olt_id);
    }

    if (!empty($old_olt_id) && $old_olt_id != $olt_id) {
        // Update old OLT if changed
        updateOltPortCounts(null, $old_olt_id);
    }

    if (!empty($parent_odc_id)) {
        // If this ODC connects to a parent ODC, update parent's port count
        updateOdcPortCounts(null, $parent_odc_id);
    }

    if (!empty($old_parent_odc_id) && $old_parent_odc_id != $parent_odc_id) {
        // Update old parent ODC if changed
        updateOdcPortCounts(null, $old_parent_odc_id);
    }

    // Also recalculate this ODC's own ports
    updateOdcPortCounts(null, $odc->id);

    // Check if request came from map (add parameter to identify)
    $from_map = _req('from_map');
    if ($from_map == '1') {
        r2(U . 'plugin/network_mapping', 's', 'ODC berhasil disimpan');
    } else {
        r2(U . 'plugin/network_mapping/odc', 's', 'ODC berhasil disimpan');
    }
}

function network_mapping_save_odp()
{
    if (!Csrf::check($_POST['csrf_token'])) {
        r2(U . 'plugin/network_mapping/odp', 'e', 'CSRF Token tidak valid');
    }

    $name = _req('name');
    $description = _req('description');
    $odc_id = _req('odc_id');
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_ports = _req('total_ports');
    $status = _req('status');
    $id = _req('id');

    if (empty($name)) {
        $redirect_url = $id ? U . 'plugin/network_mapping/edit-odp?id=' . $id : U . 'plugin/network_mapping/add-odp';
        r2($redirect_url, 'e', 'Nama ODP harus diisi');
    }

    // Validate ODC capacity and port availability
    $port_number = _req('port_number');
    if (!empty($odc_id)) {
        $target_odc = ORM::for_table('tbl_odc')->find_one($odc_id);
        if ($target_odc) {
            // Check port availability if port number is specified
            if (!empty($port_number)) {
                if (!validatePortAvailability($odc_id, $port_number, $id)) {
                    $redirect_url = $id ? U . 'plugin/network_mapping/edit-odp?id=' . $id : U . 'plugin/network_mapping/add-odp';
                    r2($redirect_url, 'e', 'Port ' . $port_number . ' is already in use! Please select another port.');
                }
            } else {
                // Old validation logic for backward compatibility
                $current_connected = ORM::for_table('tbl_odp')
                    ->where('odc_id', $odc_id)
                    ->where('status', 'Active')
                    ->count();

                // Count child ODCs connected to this ODC
                $current_child_odcs = ORM::for_table('tbl_odc')
                    ->where('parent_odc_id', $odc_id)
                    ->where('status', 'Active')
                    ->count();

                $total_used = $current_connected + $current_child_odcs;

                // If editing, exclude current ODP from count
                if ($id) {
                    $current_odp = ORM::for_table('tbl_odp')->find_one($id);
                    if ($current_odp && $current_odp->odc_id == $odc_id) {
                        $total_used--;
                    }
                }

                if ($total_used >= $target_odc->total_ports) {
                    $redirect_url = $id ? U . 'plugin/network_mapping/edit-odp?id=' . $id : U . 'plugin/network_mapping/add-odp';
                    r2($redirect_url, 'e', 'ODC sudah penuh! Used: ' . $total_used . '/' . $target_odc->total_ports . ' ports');
                }
            }
        }
    }

    if ($id) {
        // Update
        $odp = ORM::for_table('tbl_odp')->find_one($id);
        if (!$odp) {
            r2(U . 'plugin/network_mapping/odp', 'e', 'ODP tidak ditemukan');
        }
    } else {
        // Create new
        $odp = ORM::for_table('tbl_odp')->create();
        $odp->used_ports = 0;
    }

    $odp->name = $name;
    $odp->description = $description;
    $odp->odc_id = empty($odc_id) ? null : $odc_id;
    // Auto-select port if not specified but ODC is selected
    if (!empty($odc_id) && empty($port_number)) {
        $auto_port = autoSelectAvailablePort($odc_id, $id);
        if ($auto_port) {
            $port_number = $auto_port;
            error_log("Auto-selected port {$auto_port} for ODP {$name} connecting to ODC {$odc_id}");
        }
    }

    $odp->port_number = empty($port_number) ? null : $port_number;
    $odp->coordinates = $coordinates;
    $odp->address = $address;
    $odp->total_ports = $total_ports;
    $odp->status = $status;
    // Get old ODC connection for port calculation
    $old_odc_id = null;
    if ($id) {
        $old_odp = ORM::for_table('tbl_odp')->find_one($id);
        if ($old_odp) {
            $old_odc_id = $old_odp->odc_id;
        }
    }

    // Get old ODC connection for port calculation
    $old_odc_id = null;
    $old_port_number = null;
    if ($id) {
        $old_odp = ORM::for_table('tbl_odp')->find_one($id);
        if ($old_odp) {
            $old_odc_id = $old_odp->odc_id;
            $old_port_number = $old_odp->port_number;
        }
    }

    $odp->port_number = empty($port_number) ? null : $port_number;
    $odp->save();

    // Handle customer assignments
    $selected_customers = isset($_POST['customers']) && is_array($_POST['customers']) ? $_POST['customers'] : [];
    $customer_ports = isset($_POST['customer_ports']) && is_array($_POST['customer_ports']) ? $_POST['customer_ports'] : [];

    if (!is_array($selected_customers)) {
        $selected_customers = [];
    }

    // Validate customer count against available ports
    if (count($selected_customers) > $odp->total_ports) {
        $redirect_url = U . 'plugin/network_mapping/edit-odp?id=' . $odp->id;
        r2($redirect_url, 'e', 'Maksimal ' . $odp->total_ports . ' customers. Anda pilih ' . count($selected_customers));
    }

    // Validate port assignments
    $used_ports = [];
    foreach ($selected_customers as $customer_id) {
        if (isset($customer_ports[$customer_id]) && $customer_ports[$customer_id]) {
            $port = $customer_ports[$customer_id];
            if (in_array($port, $used_ports)) {
                $redirect_url = U . 'plugin/network_mapping/edit-odp?id=' . $odp->id;
                r2($redirect_url, 'e', 'Port ' . $port . ' sudah digunakan! Pilih port lain.');
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
        // Update new ODC port detail
        updateOdcPortDetail($odc_id, $port_number, 'odp', $odp->id, $odp->name, 'add');
    }

    if (!empty($old_odc_id) && !empty($old_port_number) && ($old_odc_id != $odc_id || $old_port_number != $port_number)) {
        // Remove old ODC port detail
        updateOdcPortDetail($old_odc_id, $old_port_number, 'odp', $odp->id, $odp->name, 'remove');
    }

    // Update ODC port counts
    updateOdcPortCounts($old_odc_id, $odc_id);

    $from_map = _req('from_map');
    if ($from_map == '1') {
        r2(U . 'plugin/network_mapping', 's', 'ODP berhasil disimpan');
    } else {
        r2(U . 'plugin/network_mapping/odp', 's', 'ODP berhasil disimpan');
    }
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

function network_mapping_edit_odc()
{
    global $ui, $routes;

    $id = _req('id');
    if (!$id) {
        r2(U . 'plugin/network_mapping/odc', 'e', 'ID ODC tidak valid');
    }

    $d = ORM::for_table('tbl_odc')->find_one($id);

    if (!$d) {
        r2(U . 'plugin/network_mapping/odc', 'e', 'ODC tidak ditemukan');
    }

    // Get routers for dropdown
    $routers = ORM::for_table('tbl_routers')
        ->where('enabled', 1)
        ->order_by_asc('name')
        ->find_array();

    // Get ODCs for parent selection (exclude current ODC)
    $parent_odcs = ORM::for_table('tbl_odc')
        ->where('status', 'Active')
        ->where_not_equal('id', $id)  // Exclude current ODC
        ->order_by_asc('name')
        ->find_array();

    $ui->assign('d', $d);
    $ui->assign('routers', $routers);
    $ui->assign('parent_odcs', $parent_odcs);
    $ui->assign('csrf_token', Csrf::generateAndStoreToken());
    $ui->display('network_mapping_odc_form.tpl');  // ← DISPLAY DI AKHIR!
}

function network_mapping_edit_odp()
{
    global $ui, $routes;

    $id = _req('id');
    if (!$id) {
        r2(U . 'plugin/network_mapping/odp', 'e', 'ID ODP tidak valid');
    }

    $d = ORM::for_table('tbl_odp')->find_one($id);

    if (!$d) {
        r2(U . 'plugin/network_mapping/odp', 'e', 'ODP tidak ditemukan');
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
    }

    // Get all customers
    $all_customers = ORM::for_table('tbl_customers')
        ->where('status', 'Active')
        ->order_by_asc('fullname')
        ->find_array();

    // Get customers already connected to this ODP
    $connected_customers = ORM::for_table('tbl_customers')
        ->where('odp_id', $id)
        ->where('connection_status', 'Active')
        ->find_array();

    // Hitung jumlah pelanggan yang terhubung di PHP
    $connected_customers_count = 0;
    if (!empty($connected_customers) && is_array($connected_customers)) {
        $connected_customers_count = count($connected_customers);
    }

    // Hitung available_ports di PHP
    $available_ports_display = $d['total_ports'] - $connected_customers_count;
    // Pastikan tidak negatif
    if ($available_ports_display < 0) {
        $available_ports_display = 0;
    }


    // Assign semua variabel ke Smarty
    $ui->assign('d', $d);
    $ui->assign('odcs', $odcs);
    $ui->assign('all_customers', $all_customers);
    $ui->assign('connected_customers', $connected_customers); // Tetap kirim connected_customers jika masih diperlukan di template
    $ui->assign('connected_customers_count', $connected_customers_count); // Kirim jumlahnya
    $ui->assign('available_ports_display', $available_ports_display); // Kirim hasil perhitungan
    $ui->assign('csrf_token', Csrf::generateAndStoreToken());
    $ui->display('network_mapping_odp_form.tpl');
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
            case 'olt':  // ✅ TAMBAH INI
                $item = ORM::for_table('tbl_olt')->find_one($id);
                return $item ? $item->name : 'Unknown OLT';
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
    header('Content-Type: application/json');

    try {
        $lat = _req('lat');
        $lng = _req('lng');

        if (empty($lat) || empty($lng)) {
            echo json_encode(['success' => false, 'message' => 'Koordinat tidak valid']);
            exit;
        }

        // Get OLTs for dropdown (CHANGED: routers -> olts)
        $olts = ORM::for_table('tbl_olt')
            ->where('status', 'Active')
            ->order_by_asc('name')
            ->find_array();

        // Add port details to each OLT
        foreach ($olts as &$olt) {
            $olt['available_pon_ports_detail'] = getAvailablePonPortsForOlt($olt['id']);
            $olt['used_pon_ports_info'] = getUsedPonPortsDetail($olt['id']);

            $connected_odcs = ORM::for_table('tbl_odc')
                ->where('olt_id', $olt['id'])
                ->where('status', 'Active')
                ->count();

            $olt['used_pon_ports'] = $connected_odcs;
        }

        $response = [
            'success' => true,
            'coordinates' => $lat . ',' . $lng,
            'olts' => $olts // CHANGED: routers -> olts
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

/// ✅ PERBAIKAN: Update network_mapping_quick_save_odc() function
function network_mapping_quick_save_odc()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $name = _req('name');
    $description = _req('description');
    $olt_id = _req('olt_id'); // CHANGED: router_id -> olt_id
    $pon_port_number = _req('pon_port_number'); // ADDED: PON port
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_ports = _req('total_ports');
    $parent_odc_id = _req('parent_odc_id');
    $parent_port_number = _req('parent_port_number');

    // DEBUG
    error_log('Quick Save ODC - OLT ID: ' . $olt_id . ', PON port: ' . $pon_port_number);

    if (empty($name)) {
        echo json_encode(['success' => false, 'message' => 'Nama ODC harus diisi']);
        exit;
    }

    if (empty($coordinates)) {
        echo json_encode(['success' => false, 'message' => 'Koordinat harus diisi']);
        exit;
    }

    // ✅ PERBAIKAN: Validate OLT capacity and PON port availability
    if (!empty($olt_id)) {
        $target_olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if ($target_olt) {
            if (!empty($pon_port_number)) {
                if (!validatePonPortAvailability($olt_id, $pon_port_number)) {
                    echo json_encode([
                        'success' => false,
                        'message' => 'PON Port ' . $pon_port_number . ' is already in use! Please select another port.'
                    ]);
                    exit;
                }
            }
        }
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
        $odc->olt_id = empty($olt_id) ? null : $olt_id; // CHANGED: router_id -> olt_id

        // ✅ PERBAIKAN: Auto-select PON port if not specified but OLT is selected
        if (!empty($olt_id) && empty($pon_port_number)) {
            $auto_port = autoSelectAvailablePonPort($olt_id);
            if ($auto_port) {
                $pon_port_number = $auto_port;
                error_log("Quick add: Auto-selected PON port {$auto_port} for ODC {$name}");
            }
        }

        $odc->pon_port_number = empty($pon_port_number) ? null : $pon_port_number; // ADDED
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

        // ✅ PERBAIKAN: Update OLT port count and detail if connected
        if (!empty($olt_id) && !empty($pon_port_number)) {
            updateOltPortCounts(null, $olt_id);
            updateOltPonPortDetail($olt_id, $pon_port_number, 'odc', $odc->id, $odc->name, 'add');
            error_log("Updated OLT {$olt_id} PON port {$pon_port_number} with ODC {$odc->id}");
        }

        // Update parent ODC port detail if connected with specific port
        if (!empty($parent_odc_id) && !empty($parent_port_number)) {
            updateOdcPortDetail($parent_odc_id, $parent_port_number, 'odc', $odc->id, $odc->name, 'add');
        }

        // Update parent ODC port counts
        if (!empty($parent_odc_id)) {
            updateOdcPortCounts(null, $parent_odc_id);
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
                'olt_id' => $odc->olt_id, // CHANGED: router_id -> olt_id
                'pon_port_number' => $odc->pon_port_number, // ADDED
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
            case 'olt':  // ✅ TAMBAH INI
                $item = ORM::for_table('tbl_olt')->find_one($id);
                return $item ? $item->name : 'Unknown OLT';
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
            'olt' => 'tbl_olt',      // ← TAMBAH INI
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
// ===== OLT MANAGEMENT FUNCTIONS =====

function network_mapping_quick_add_olt()
{
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

        // Get OLTs for dropdown
        $olts = ORM::for_table('tbl_olt')
            ->where('status', 'Active')
            ->order_by_asc('name')
            ->find_array();

        $available_olts = [];
        foreach ($olts as $olt) {
            // ✅ UPLINK PORTS (untuk OLT-to-OLT connection)
            $olt['available_uplink_ports_detail'] = getAvailableUplinkPortsForOlt($olt['id']);
            $olt['used_uplink_ports_info'] = getUsedUplinkPortsDetail($olt['id']);

            $connected_child_olts = ORM::for_table('tbl_olt')
                ->where('parent_olt_id', $olt['id'])
                ->where('status', 'Active')
                ->count();

            $olt['used_uplink_ports'] = $connected_child_olts;

            if (!empty($olt['router_id'])) {
                $olt['used_uplink_ports'] += 1;
            }
            if (!empty($olt['parent_olt_id']) && !empty($olt['uplink_port_number'])) {
                $olt['used_uplink_ports'] += 1;
            }

            // ✅ PON PORTS (untuk ODC connection)
            $olt['available_pon_ports_detail'] = getAvailablePonPortsForOlt($olt['id']);
            $olt['used_pon_ports_info'] = getUsedPonPortsDetail($olt['id']);
            $olt['available_pon_count'] = count($olt['available_pon_ports_detail']);

            // ✅ Filter berdasarkan available ports (uplink OR pon)
            $uplink_available = count($olt['available_uplink_ports_detail']);
            $pon_available = $olt['available_pon_count'];

            if ($uplink_available > 0 || $pon_available > 0) {
                $available_olts[] = $olt;
            }

            error_log("OLT {$olt['name']}: Uplink={$uplink_available}/{$olt['total_uplink_ports']}, PON={$pon_available}/{$olt['total_pon_ports']}");
        }

        $response = [
            'success' => true,
            'coordinates' => $lat . ',' . $lng,
            'routers' => $routers,
            'parent_olts' => $available_olts
        ];

        echo json_encode($response);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_quick_save_olt()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $name = _req('name');
    $description = _req('description');
    $router_id = _req('router_id');
    $router_uplink_port = _req('router_uplink_port');
    $parent_olt_id = _req('parent_olt_id');
    $uplink_port_number = _req('uplink_port_number'); // Port di parent OLT
    $my_uplink_port = _req('my_uplink_port'); // NEW: Port di OLT yang sedang dibuat
    $coordinates = _req('coordinates');
    $address = _req('address');
    $total_uplink_ports = _req('total_uplink_ports');
    $total_pon_ports = _req('total_pon_ports');

    // Debug log
    error_log("Quick save OLT - Name: $name, Parent OLT: $parent_olt_id, Parent Port: $uplink_port_number, My Port: $my_uplink_port");

    if (empty($name)) {
        echo json_encode(['success' => false, 'message' => 'Nama OLT harus diisi']);
        exit;
    }

    if (empty($coordinates)) {
        echo json_encode(['success' => false, 'message' => 'Koordinat harus diisi']);
        exit;
    }
    // TAMBAHAN: Validasi parent OLT PON capacity
    if (!empty($parent_olt_id)) {
        $parent_olt = ORM::for_table('tbl_olt')->find_one($parent_olt_id);
        if (!$parent_olt) {
            echo json_encode(['success' => false, 'message' => 'Parent OLT tidak ditemukan']);
            exit;
        }

        // ✅ Cek apakah parent OLT masih memiliki PON yang tersedia
        $available_pon_ports = getAvailablePonPortsForOlt($parent_olt_id);
        if (empty($available_pon_ports)) {
            echo json_encode([
                'success' => false,
                'message' => 'Parent OLT "' . $parent_olt->name . '" sudah tidak memiliki PON yang tersedia! Semua PON sudah terpakai.'
            ]);
            exit;
        }

        // ✅ Validasi PON yang dipilih user
        if (!empty($uplink_port_number)) {
            if (!in_array($uplink_port_number, $available_pon_ports)) {
                echo json_encode([
                    'success' => false,
                    'message' => 'PON ' . $uplink_port_number . ' di parent OLT "' . $parent_olt->name . '" sudah digunakan! PON yang tersedia: ' . implode(', ', $available_pon_ports)
                ]);
                exit;
            }
        }

        // ✅ Validasi uplink port OLT baru (tetap uplink untuk OLT sendiri)
        if (!empty($my_uplink_port)) {
            $total_ports_new_olt = $total_uplink_ports ?: 4;
            if ($my_uplink_port > $total_ports_new_olt || $my_uplink_port < 1) {
                echo json_encode([
                    'success' => false,
                    'message' => 'Port ' . $my_uplink_port . ' tidak valid untuk OLT dengan ' . $total_ports_new_olt . ' uplink ports!'
                ]);
                exit;
            }
        }
    }

    try {
        $olt = ORM::for_table('tbl_olt')->create();
        $olt->name = $name;
        $olt->description = $description;
        $olt->router_id = empty($router_id) ? null : $router_id;
        $olt->parent_olt_id = empty($parent_olt_id) ? null : $parent_olt_id;

        // Auto-select parent uplink port if not specified but parent OLT is selected
        if (!empty($parent_olt_id) && empty($uplink_port_number)) {
            $auto_port = autoSelectAvailableUplinkPort($parent_olt_id);
            if ($auto_port) {
                $uplink_port_number = $auto_port;
                error_log("Quick add: Auto-selected parent uplink port {$auto_port} for OLT {$name}");
            }
        }

        $olt->uplink_port_number = empty($uplink_port_number) ? null : $uplink_port_number;
        $olt->coordinates = $coordinates;
        $olt->address = $address;

        // PERBAIKAN: Ambil total uplink ports dari router section atau OLT section
        if (!empty($router_id)) {
            // Dari router connection
            $total_uplink_ports = $total_uplink_ports ?: 4;
        } else {
            // Dari OLT connection, ambil dari uplinkPortsCount
            $total_uplink_ports = $total_uplink_ports ?: 4;
        }

        $olt->total_uplink_ports = $total_uplink_ports;
        $olt->total_pon_ports = $total_pon_ports ?: 4;
        $olt->used_uplink_ports = 0;
        $olt->used_pon_ports = 0;
        $olt->status = 'Active';
        $olt->created_at = date('Y-m-d H:i:s');
        $olt->save();

        // Update router port detail dengan port yang dipilih
        // SETELAH $olt->save() pertama, TAMBAH:

        // ✅ Set my_uplink_port untuk router connection
        if (!empty($router_id) && !empty($router_uplink_port)) {
            $olt->my_uplink_port = $router_uplink_port;
            $olt->save();
            error_log("Set my_uplink_port to {$router_uplink_port} for router connection on OLT {$olt->id}");
        }

        // ✅ Set my_uplink_port untuk OLT connection (sudah ada, pastikan tidak overwrite)
        if (!empty($parent_olt_id) && !empty($my_uplink_port)) {
            $olt->my_uplink_port = $my_uplink_port;
            $olt->save();
            error_log("Set my_uplink_port to {$my_uplink_port} for OLT connection on OLT {$olt->id}");
        }

        // NEW: Update OLT connection dengan my_uplink_port
        // ✅ FIX: Update OLT connection dengan PON port
        if (!empty($parent_olt_id) && !empty($uplink_port_number) && !empty($my_uplink_port)) {
            $parent_olt = ORM::for_table('tbl_olt')->find_one($parent_olt_id);
            if ($parent_olt) {
                // ✅ BENAR: Update parent OLT PON port detail (bukan uplink)
                updateOltPonPortDetail($parent_olt_id, $uplink_port_number, 'olt', $olt->id, $olt->name, 'add');

                // ✅ BENAR: Update this OLT uplink port detail
                updateOltUplinkPortDetail($olt->id, $my_uplink_port, 'olt', $parent_olt_id, $parent_olt->name, 'add');

                error_log("Connected OLT {$olt->id} uplink port {$my_uplink_port} to parent OLT {$parent_olt_id} PON {$uplink_port_number}");
            }
        }

        // Update port counts
        if (!empty($parent_olt_id)) {
            updateOltPortCounts(null, $parent_olt_id);
        }
        updateOltPortCounts(null, $olt->id);

        // ✅ TAMBAH BARIS INI:
        updateOltPortDetails($olt->id);

        echo json_encode([
            'success' => true,
            'message' => 'OLT berhasil ditambahkan',
            'olt' => [
                'id' => $olt->id,
                'name' => $olt->name,
                'coordinates' => $olt->coordinates,
                'description' => $olt->description,
                'total_uplink_ports' => $olt->total_uplink_ports,
                'total_pon_ports' => $olt->total_pon_ports,
                'used_uplink_ports' => $olt->used_uplink_ports,
                'used_pon_ports' => $olt->used_pon_ports,
                'router_id' => $olt->router_id,
                'router_uplink_port' => $router_uplink_port,
                'parent_olt_id' => $olt->parent_olt_id,
                'uplink_port_number' => $uplink_port_number,
                'my_uplink_port' => $my_uplink_port,
                'address' => $olt->address
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

function network_mapping_ajax_delete_olt()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $id = _req('id');
    if (empty($id)) {
        echo json_encode(['success' => false, 'message' => 'ID OLT tidak valid']);
        exit;
    }

    try {
        $olt = ORM::for_table('tbl_olt')->find_one($id);
        if ($olt) {
            // Check if OLT has connected ODCs or child OLTs
            $connected_odcs = ORM::for_table('tbl_odc')
                ->where('olt_id', $id)
                ->where('status', 'Active')
                ->count();

            $connected_child_olts = ORM::for_table('tbl_olt')
                ->where('parent_olt_id', $id)
                ->where('status', 'Active')
                ->count();

            if ($connected_odcs > 0) {
                echo json_encode(['success' => false, 'message' => 'Cannot delete OLT. ' . $connected_odcs . ' ODCs are still connected.']);
                exit;
            }

            if ($connected_child_olts > 0) {
                echo json_encode(['success' => false, 'message' => 'Cannot delete OLT. ' . $connected_child_olts . ' child OLTs are still connected.']);
                exit;
            }

            // Delete related cable routes
            $deleted_cables = deleteRelatedCableRoutes('olt', $id);

            // Update parent OLT port count and remove port detail
            if ($olt->parent_olt_id && $olt->uplink_port_number) {
                updateOltUplinkPortDetail($olt->parent_olt_id, $olt->uplink_port_number, 'olt', $id, $olt->name, 'remove');
                updateOltPortCounts($olt->parent_olt_id, null);
            }

            $olt->delete();

            $message = 'OLT berhasil dihapus';
            if ($deleted_cables > 0) {
                $message .= ' beserta ' . $deleted_cables . ' cable routes';
            }

            echo json_encode(['success' => true, 'message' => $message]);
        } else {
            echo json_encode(['success' => false, 'message' => 'OLT tidak ditemukan']);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}

// ===== OLT PORT MANAGEMENT FUNCTIONS =====

function getAvailableUplinkPortsForOlt($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return [];

        $total_ports = $olt->total_uplink_ports;
        $used_ports_detail = json_decode($olt->uplink_ports_detail ?: '{}', true);

        $available_ports = [];

        // PERBAIKAN: Loop semua port dan cek mana yang tidak digunakan
        for ($i = 1; $i <= $total_ports; $i++) {
            if (!isset($used_ports_detail[$i])) {
                $available_ports[] = $i;
            }
        }

        error_log("OLT {$olt_id}: Total ports: {$total_ports}, Used ports: " . json_encode(array_keys($used_ports_detail)) . ", Available: " . json_encode($available_ports));

        return array_values($available_ports);
    } catch (Exception $e) {
        error_log('Error getting available uplink ports: ' . $e->getMessage());
        return [];
    }
}

function getAvailablePonPortsForOlt($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return [];

        $total_ports = $olt->total_pon_ports;
        $used_ports_detail = json_decode($olt->pon_ports_detail ?: '{}', true);

        $available_ports = [];
        for ($i = 1; $i <= $total_ports; $i++) {
            if (!isset($used_ports_detail[$i])) {
                $available_ports[] = $i;
            }
        }

        return $available_ports;
    } catch (Exception $e) {
        error_log('Error getting available PON ports: ' . $e->getMessage());
        return [];
    }
}

function getUsedUplinkPortsDetail($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return [];

        return json_decode($olt->uplink_ports_detail ?: '{}', true);
    } catch (Exception $e) {
        error_log('Error getting used uplink ports detail: ' . $e->getMessage());
        return [];
    }
}

function getUsedPonPortsDetail($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return [];

        return json_decode($olt->pon_ports_detail ?: '{}', true);
    } catch (Exception $e) {
        error_log('Error getting used PON ports detail: ' . $e->getMessage());
        return [];
    }
}

function updateOltUplinkPortDetail($olt_id, $port_number, $connected_type, $connected_id, $connected_name, $action = 'add')
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return false;

        $used_ports_detail = json_decode($olt->uplink_ports_detail ?: '{}', true);

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

        $olt->uplink_ports_detail = json_encode($used_ports_detail);
        $olt->save();

        error_log("Updated OLT {$olt_id} uplink port {$port_number}: {$action} - {$connected_type} {$connected_name}");
        return true;
    } catch (Exception $e) {
        error_log('Error updating OLT uplink port detail: ' . $e->getMessage());
        return false;
    }
}

function updateOltPonPortDetail($olt_id, $port_number, $connected_type, $connected_id, $connected_name, $action = 'add')
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return false;

        $used_ports_detail = json_decode($olt->pon_ports_detail ?: '{}', true);

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

        $olt->pon_ports_detail = json_encode($used_ports_detail);
        $olt->save();

        error_log("Updated OLT {$olt_id} PON port {$port_number}: {$action} - {$connected_type} {$connected_name}");
        return true;
    } catch (Exception $e) {
        error_log('Error updating OLT PON port detail: ' . $e->getMessage());
        return false;
    }
}

function validateUplinkPortAvailability($olt_id, $port_number, $exclude_child_id = null)
{
    try {
        $used_ports_detail = getUsedUplinkPortsDetail($olt_id);

        if (!isset($used_ports_detail[$port_number])) {
            return true;
        }

        if (
            $exclude_child_id &&
            isset($used_ports_detail[$port_number]['id']) &&
            $used_ports_detail[$port_number]['id'] == $exclude_child_id
        ) {
            return true;
        }

        return false;
    } catch (Exception $e) {
        error_log('Error validating uplink port availability: ' . $e->getMessage());
        return false;
    }
}

function validatePonPortAvailability($olt_id, $port_number, $exclude_child_id = null)
{
    try {
        $used_ports_detail = getUsedPonPortsDetail($olt_id);

        if (!isset($used_ports_detail[$port_number])) {
            return true;
        }

        if (
            $exclude_child_id &&
            isset($used_ports_detail[$port_number]['id']) &&
            $used_ports_detail[$port_number]['id'] == $exclude_child_id
        ) {
            return true;
        }

        return false;
    } catch (Exception $e) {
        error_log('Error validating PON port availability: ' . $e->getMessage());
        return false;
    }
}

function autoSelectAvailableUplinkPort($olt_id, $exclude_child_id = null)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return null;

        $total_ports = $olt->total_uplink_ports;
        $used_ports_detail = json_decode($olt->uplink_ports_detail ?: '{}', true);

        for ($i = 1; $i <= $total_ports; $i++) {
            if (!isset($used_ports_detail[$i])) {
                return $i;
            }

            if (
                $exclude_child_id &&
                isset($used_ports_detail[$i]['id']) &&
                $used_ports_detail[$i]['id'] == $exclude_child_id
            ) {
                return $i;
            }
        }

        return null;
    } catch (Exception $e) {
        error_log('Error auto-selecting uplink port: ' . $e->getMessage());
        return null;
    }
}

function autoSelectAvailablePonPort($olt_id, $exclude_child_id = null)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return null;

        $total_ports = $olt->total_pon_ports;
        $used_ports_detail = json_decode($olt->pon_ports_detail ?: '{}', true);

        for ($i = 1; $i <= $total_ports; $i++) {
            if (!isset($used_ports_detail[$i])) {
                return $i;
            }

            if (
                $exclude_child_id &&
                isset($used_ports_detail[$i]['id']) &&
                $used_ports_detail[$i]['id'] == $exclude_child_id
            ) {
                return $i;
            }
        }

        return null;
    } catch (Exception $e) {
        error_log('Error auto-selecting PON port: ' . $e->getMessage());
        return null;
    }
}

function getOltUplinkPortStatusDisplay($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return '';

        $status_html = '';

        // Cek koneksi router
        if ($olt->router_id) {
            $connected_router = ORM::for_table('tbl_routers')->find_one($olt->router_id);
            if ($connected_router) {
                $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(0, 123, 255, 0.1); border-left: 3px solid #007bff; font-size: 11px;">';
                $status_html .= '<i class="fa fa-server text-primary"></i> <strong>Router Connection:</strong><br>';
                $status_html .= '• Connected to: ' . $connected_router->name . ' (ROUTER)<br>';
                $status_html .= '</div>';
            }
        }

        // Cek koneksi parent OLT
        if ($olt->parent_olt_id && $olt->uplink_port_number) {
            $parent_olt = ORM::for_table('tbl_olt')->find_one($olt->parent_olt_id);
            if ($parent_olt) {
                $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(255, 7, 7, 0.1); border-left: 3px solid #ff0707ff; font-size: 11px;">';
                $status_html .= '<i class="fa fa-plug text-danger"></i> <strong>PON Connection:</strong><br>';
                $status_html .= '• PON ' . $olt->uplink_port_number . ': ' . $parent_olt->name . ' (OLT)<br>';
                $status_html .= '</div>';
            }
        }

        // Tampilkan used uplink ports dari uplink_ports_detail
        $used_ports_detail = getUsedUplinkPortsDetail($olt_id);
        if (!empty($used_ports_detail)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(255, 193, 7, 0.1); border-left: 3px solid #ffc107; font-size: 11px;">';
            $status_html .= '<i class="fa fa-plug text-warning"></i> <strong>Used Uplink Ports:</strong><br>';

            ksort($used_ports_detail); // Sort by port number
            foreach ($used_ports_detail as $port_num => $detail) {
                if ($port_num > 0) {
                    $status_html .= '• Port ' . $port_num . ': ' . $detail['name'] . ' (' . strtoupper($detail['type']) . ')<br>';
                }
            }

            $status_html = rtrim($status_html, '<br>') . '</div>';
        }

        // PERBAIKAN: Available uplink ports
        $available_ports = getAvailableUplinkPortsForOlt($olt_id);
        if (!empty($available_ports)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(40, 167, 69, 0.1); border-left: 3px solid #28a745; font-size: 11px;">';
            $status_html .= '<i class="fa fa-check-circle text-success"></i> <strong>Available Uplink:</strong><br>';
            $status_html .= '• Port ' . implode(', Port ', $available_ports);
            $status_html .= '</div>';
        } else {
            // PERBAIKAN: Hanya tampilkan "All Uplink Ports Used" jika memang semua port terpakai
            $total_ports = $olt->total_uplink_ports;
            $used_ports_count = count($used_ports_detail);

            if ($used_ports_count >= $total_ports) {
                $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(108, 117, 125, 0.1); border-left: 3px solid #6c757d; font-size: 11px;">';
                $status_html .= '<i class="fa fa-info-circle text-muted"></i> <strong>All Uplink Ports Used</strong>';
                $status_html .= '</div>';
            }
        }

        return $status_html;
    } catch (Exception $e) {
        error_log('Error getting OLT uplink port status display: ' . $e->getMessage());
        return '';
    }
}
function debugOltPortData($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return;

        error_log("=== DEBUG OLT {$olt_id} PORT DATA ===");
        error_log("Name: " . $olt->name);
        error_log("Total uplink ports: " . $olt->total_uplink_ports);
        error_log("Used uplink ports: " . $olt->used_uplink_ports);
        error_log("Uplink ports detail: " . ($olt->uplink_ports_detail ?: 'NULL'));

        $used_ports_detail = json_decode($olt->uplink_ports_detail ?: '{}', true);
        error_log("Parsed uplink ports detail: " . json_encode($used_ports_detail));

        $available_ports = getAvailableUplinkPortsForOlt($olt_id);
        error_log("Available ports: " . json_encode($available_ports));
        error_log("=== END DEBUG ===");
    } catch (Exception $e) {
        error_log('Error debugging OLT port data: ' . $e->getMessage());
    }
}
function cleanupOltUplinkPorts($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return false;

        $existing_ports = json_decode($olt->uplink_ports_detail ?: '{}', true);
        $cleaned_ports = [];

        foreach ($existing_ports as $port => $detail) {
            // Skip port 0 atau port invalid
            if ($port > 0 && $port <= $olt->total_uplink_ports) {
                // Cek duplikasi berdasarkan type dan id
                $key = $detail['type'] . '_' . $detail['id'];

                if (!isset($cleaned_ports[$port])) {
                    $cleaned_ports[$port] = $detail;
                } else {
                    // Jika ada duplikasi, keep yang lebih valid
                    error_log("Duplicate port found: Port {$port}, keeping existing");
                }
            } else {
                error_log("Invalid port removed: Port {$port}");
            }
        }

        // Update database dengan cleaned ports
        $olt->uplink_ports_detail = json_encode($cleaned_ports);
        $olt->save();

        error_log("Cleaned uplink ports for OLT {$olt_id}: " . json_encode($cleaned_ports));
        return true;
    } catch (Exception $e) {
        error_log('Error cleaning OLT uplink ports: ' . $e->getMessage());
        return false;
    }
}
function syncOltRouterPortDetail($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return false;

        // Jika ada router connection, pastikan tercatat di uplink_ports_detail
        if ($olt->router_id) {
            $connected_router = ORM::for_table('tbl_routers')->find_one($olt->router_id);
            if ($connected_router) {
                // PERBAIKAN: Cek dulu apakah sudah ada router detail
                $existing_ports = json_decode($olt->uplink_ports_detail ?: '{}', true);

                // Cari apakah sudah ada router connection
                $router_exists = false;
                foreach ($existing_ports as $port => $detail) {
                    if ($detail['type'] === 'router' && $detail['id'] == $olt->router_id) {
                        $router_exists = true;
                        break;
                    }
                }

                // Hanya tambahkan jika belum ada
                if (!$router_exists) {
                    // PERBAIKAN: Gunakan port 1 sebagai default jika tidak ada data spesifik
                    $router_port = 1; // Default, akan di-override jika ada data dari form
                    updateOltUplinkPortDetail($olt_id, $router_port, 'router', $olt->router_id, $connected_router->name, 'add');
                    error_log("Added router port detail for OLT {$olt_id}: Port {$router_port} -> {$connected_router->name}");
                }
            }
        }

        return true;
    } catch (Exception $e) {
        error_log('Error syncing OLT router port detail: ' . $e->getMessage());
        return false;
    }
}
function getOltPonPortStatusDisplay($olt_id)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) return '';

        $status_html = '';

        // Get used PON ports from connected ODCs
        $used_ports_detail = getUsedPonPortsDetail($olt_id);
        if (!empty($used_ports_detail)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(255, 193, 7, 0.1); border-left: 3px solid #ffc107; font-size: 11px;">';
            $status_html .= '<i class="fa fa-sitemap text-warning"></i> <strong>Used PON:</strong><br>';

            foreach ($used_ports_detail as $port_num => $detail) {
                $status_html .= '• PON ' . $port_num . ': ' . $detail['name'] . ' (' . strtoupper($detail['type']) . ')<br>';
            }

            $status_html = rtrim($status_html, '<br>') . '</div>';
        }

        // Available PON ports
        $available_ports = getAvailablePonPortsForOlt($olt_id);
        if (!empty($available_ports)) {
            $status_html .= '<div style="margin: 5px 0; padding: 3px 6px; background: rgba(40, 167, 69, 0.1); border-left: 3px solid #28a745; font-size: 11px;">';
            $status_html .= '<i class="fa fa-check-circle text-success"></i> <strong>Available PON:</strong><br>';
            $status_html .= '• PON ' . implode(', PON ', $available_ports);
            $status_html .= '</div>';
        }

        return $status_html;
    } catch (Exception $e) {
        error_log('Error getting OLT PON port status display: ' . $e->getMessage());
        return '';
    }
}

function updateOltPortCounts($old_olt_id, $new_olt_id)
{
    error_log('updateOltPortCounts called - Old OLT: ' . $old_olt_id . ', New OLT: ' . $new_olt_id);

    try {
        // Update old OLT
        if ($old_olt_id) {
            $old_olt = ORM::for_table('tbl_olt')->find_one($old_olt_id);
            if ($old_olt) {
                // Count ODCs + child OLTs
                $connected_odcs = ORM::for_table('tbl_odc')
                    ->where('olt_id', $old_olt_id)
                    ->where('status', 'Active')
                    ->count();

                $connected_child_olts = ORM::for_table('tbl_olt')
                    ->where('parent_olt_id', $old_olt_id)
                    ->where('status', 'Active')
                    ->count();

                // PERBAIKAN: Tambah router connection ke uplink count
                $uplink_used = $connected_child_olts;
                if (!empty($old_olt->router_id)) {
                    $uplink_used += 1; // Router connection uses 1 uplink
                }
                if (!empty($old_olt->parent_olt_id) && !empty($old_olt->uplink_port_number)) {
                    $uplink_used += 1; // Parent OLT connection uses 1 uplink
                }

                $old_olt->used_pon_ports = $connected_odcs;
                $old_olt->used_uplink_ports = $uplink_used;
                $old_olt->save();

                error_log('Updated OLD OLT ' . $old_olt->name . ' - ODCs: ' . $connected_odcs . ', Child OLTs: ' . $connected_child_olts . ', Total Uplink Used: ' . $uplink_used);
            }
        }

        // Update new OLT
        if ($new_olt_id) {
            $new_olt = ORM::for_table('tbl_olt')->find_one($new_olt_id);
            if ($new_olt) {
                // Count ODCs + child OLTs
                $connected_odcs = ORM::for_table('tbl_odc')
                    ->where('olt_id', $new_olt_id)
                    ->where('status', 'Active')
                    ->count();

                $connected_child_olts = ORM::for_table('tbl_olt')
                    ->where('parent_olt_id', $new_olt_id)
                    ->where('status', 'Active')
                    ->count();

                // PERBAIKAN: Tambah router connection ke uplink count
                $uplink_used = $connected_child_olts;
                if (!empty($new_olt->router_id)) {
                    $uplink_used += 1; // Router connection uses 1 uplink
                }
                if (!empty($new_olt->parent_olt_id) && !empty($new_olt->uplink_port_number)) {
                    $uplink_used += 1; // Parent OLT connection uses 1 uplink
                }

                $new_olt->used_pon_ports = $connected_odcs;
                $new_olt->used_uplink_ports = $uplink_used;
                $new_olt->save();

                error_log('Updated NEW OLT ' . $new_olt->name . ' - ODCs: ' . $connected_odcs . ', Child OLTs: ' . $connected_child_olts . ', Total Uplink Used: ' . $uplink_used);
            }
        }
    } catch (Exception $e) {
        error_log('Error updating OLT port counts: ' . $e->getMessage());
    }
}

function network_mapping_get_available_uplink_ports()
{
    header('Content-Type: application/json');

    $olt_id = _req('olt_id');

    if (empty($olt_id)) {
        echo json_encode(['success' => false, 'message' => 'OLT ID required']);
        exit;
    }

    try {
        $available_ports = getAvailableUplinkPortsForOlt($olt_id);
        $used_ports_detail = getUsedUplinkPortsDetail($olt_id);

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

function network_mapping_get_available_pon_ports()
{
    header('Content-Type: application/json');

    $olt_id = _req('olt_id');

    if (empty($olt_id)) {
        echo json_encode(['success' => false, 'message' => 'OLT ID required']);
        exit;
    }

    try {
        $available_ports = getAvailablePonPortsForOlt($olt_id);
        $used_ports_detail = getUsedPonPortsDetail($olt_id);

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

function network_mapping_get_olt_connections()
{
    header('Content-Type: application/json');

    $olt_id = _req('olt_id');
    $search = _req('search', '');
    $page = (int)_req('page', 1);
    $limit = (int)_req('limit', 5);
    $offset = ($page - 1) * $limit;

    if (empty($olt_id)) {
        echo json_encode(['success' => false, 'message' => 'OLT ID required']);
        exit;
    }

    try {
        // Get connected ODCs
        $odc_query = ORM::for_table('tbl_odc')
            ->where('olt_id', $olt_id)
            ->where('status', 'Active');

        if (!empty($search)) {
            $odc_query->where_like('name', '%' . $search . '%');
        }

        $total_odcs = $odc_query->count();

        $odcs = $odc_query->order_by_asc('name')
            ->limit($limit)
            ->offset($offset)
            ->find_array();

        // Get connected child OLTs
        $child_olt_query = ORM::for_table('tbl_olt')
            ->where('parent_olt_id', $olt_id)
            ->where('status', 'Active');

        if (!empty($search)) {
            $child_olt_query->where_like('name', '%' . $search . '%');
        }

        $total_child_olts = $child_olt_query->count();

        $child_olts = $child_olt_query->order_by_asc('name')
            ->limit($limit)
            ->offset($offset)
            ->find_array();

        // Combine results
        $connections = [];

        foreach ($odcs as $odc) {
            $connections[] = [
                'id' => $odc['id'],
                'name' => $odc['name'],
                'type' => 'odc',
                'description' => $odc['description'],
                'address' => $odc['address'],
                'ports' => $odc['used_ports'] . '/' . $odc['total_ports'],
                'coordinates' => $odc['coordinates']
            ];
        }

        foreach ($child_olts as $child) {
            $connections[] = [
                'id' => $child['id'],
                'name' => $child['name'],
                'type' => 'olt',
                'description' => $child['description'],
                'address' => $child['address'],
                'ports' => $child['used_uplink_ports'] . '/' . $child['total_uplink_ports'] . ' (U) | ' . $child['used_pon_ports'] . '/' . $child['total_pon_ports'] . ' (PON)',
                'coordinates' => $child['coordinates']
            ];
        }

        $total_connections = $total_odcs + $total_child_olts;
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

function network_mapping_disconnect_from_olt()
{
    header('Content-Type: application/json');

    if (!Csrf::check($_POST['csrf_token'])) {
        echo json_encode(['success' => false, 'message' => 'CSRF Token tidak valid']);
        exit;
    }

    $olt_id = _req('olt_id');
    $disconnect_type = _req('disconnect_type');
    $disconnect_ids = isset($_POST['disconnect_ids']) ? $_POST['disconnect_ids'] : [];

    if (empty($olt_id) || empty($disconnect_ids) || !is_array($disconnect_ids)) {
        echo json_encode(['success' => false, 'message' => 'Invalid parameters']);
        exit;
    }

    try {
        $disconnected_count = 0;

        foreach ($disconnect_ids as $id) {
            if ($disconnect_type === 'odc') {
                $odc = ORM::for_table('tbl_odc')->find_one($id);
                if ($odc && $odc->olt_id == $olt_id) {
                    deleteAutoCableRoute('olt', $olt_id, 'odc', $id);

                    $odc->olt_id = null;
                    if ($odc->pon_port_number) {
                        updateOltPonPortDetail($olt_id, $odc->pon_port_number, 'odc', $id, $odc->name, 'remove');
                    }
                    $odc->pon_port_number = null;
                    $odc->save();
                    $disconnected_count++;

                    updateOdcPortCounts($id, null);
                    error_log("Disconnected ODC {$id} from OLT {$olt_id} and deleted cable route");
                }
            } elseif ($disconnect_type === 'olt') {
                $child_olt = ORM::for_table('tbl_olt')->find_one($id);
                if ($child_olt && $child_olt->parent_olt_id == $olt_id) {
                    deleteAutoCableRoute('olt', $olt_id, 'olt', $id);

                    $child_olt->parent_olt_id = null;
                    if ($child_olt->uplink_port_number) {
                        updateOltUplinkPortDetail($olt_id, $child_olt->uplink_port_number, 'olt', $id, $child_olt->name, 'remove');
                    }
                    $child_olt->uplink_port_number = null;
                    $child_olt->save();
                    $disconnected_count++;

                    error_log("Disconnected child OLT {$id} from parent OLT {$olt_id} and deleted cable route");
                }
            }
        }

        // Update parent OLT port counts
        updateOltPortCounts(null, $olt_id);

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

// ===== END OLT MANAGEMENT FUNCTIONS =====
function network_mapping_get_olt_details()
{
    global $admin;

    // Check admin access
    if (!$admin) {
        http_response_code(403);
        echo json_encode(['success' => false, 'message' => 'Access denied']);
        exit;
    }

    $id = _post('id') ?: _get('id');

    if (!$id) {
        echo json_encode(['success' => false, 'message' => 'OLT ID is required']);
        exit;
    }

    try {
        // Get OLT data
        $olt = ORM::for_table('tbl_olt')->find_one($id);

        if (!$olt) {
            echo json_encode(['success' => false, 'message' => 'OLT not found']);
            exit;
        }

        // Get connected router info
        $router_info = null;
        if ($olt->router_id) {
            $router = ORM::for_table('tbl_routers')->find_one($olt->router_id);
            if ($router) {
                $router_info = [
                    'id' => $router->id,
                    'name' => $router->name,
                    'description' => $router->description
                ];
            }
        }

        // Get parent OLT info
        $parent_olt_info = null;
        if ($olt->parent_olt_id) {
            $parent_olt = ORM::for_table('tbl_olt')->find_one($olt->parent_olt_id);
            if ($parent_olt) {
                $parent_olt_info = [
                    'id' => $parent_olt->id,
                    'name' => $parent_olt->name,
                    'available_uplink_ports' => $parent_olt->available_uplink_ports
                ];
            }
        }

        // Prepare response data
        $olt_data = [
            'id' => $olt->id,
            'name' => $olt->name,
            'description' => $olt->description,
            'address' => $olt->address,
            'coordinates' => $olt->coordinates,
            'total_uplink_ports' => $olt->total_uplink_ports,
            'total_pon_ports' => $olt->total_pon_ports,
            'used_uplink_ports' => $olt->used_uplink_ports,
            'used_pon_ports' => $olt->used_pon_ports,
            'available_uplink_ports' => $olt->available_uplink_ports,
            'available_pon_ports' => $olt->available_pon_ports,
            'router_id' => $olt->router_id,
            'router_uplink_port' => $olt->router_uplink_port,
            'parent_olt_id' => $olt->parent_olt_id,
            'my_uplink_port' => $olt->my_uplink_port,
            'uplink_port_number' => $olt->uplink_port_number,
            'status' => $olt->status,
            'created_at' => $olt->created_at,
            'router_info' => $router_info,
            'parent_olt_info' => $parent_olt_info
        ];

        echo json_encode([
            'success' => true,
            'olt' => $olt_data,
            'message' => 'OLT details loaded successfully'
        ]);
    } catch (Exception $e) {
        error_log("Error in get_olt_details: " . $e->getMessage());
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }

    exit;
}
function network_mapping_update_olt()
{
    global $admin;

    if (!$admin) {
        http_response_code(403);
        echo json_encode(['success' => false, 'message' => 'Access denied']);
        exit;
    }

    $id = _post('id');
    $name = _post('name');
    $description = _post('description');
    $address = _post('address');
    $total_uplink_ports = _post('total_uplink_ports');
    $total_pon_ports = _post('total_pon_ports');
    $connection_type = _post('connection_type');

    if (!$id || !$name) {
        echo json_encode(['success' => false, 'message' => 'OLT ID and name are required']);
        exit;
    }

    try {
        $olt = ORM::for_table('tbl_olt')->find_one($id);

        if (!$olt) {
            echo json_encode(['success' => false, 'message' => 'OLT not found']);
            exit;
        }

        // ✅ Update basic info
        $olt->name = $name;
        $olt->description = $description ?: '';
        $olt->address = $address ?: '';
        $olt->total_uplink_ports = $total_uplink_ports;
        $olt->total_pon_ports = $total_pon_ports;

        $olt->save();

        // ✅ UPDATE SEMUA CONNECTION TYPES yang ada data

        // 1. Update Router connection (jika ada data)
        $router_id = _post('router_id');
        $router_uplink_port = _post('router_uplink_port');
        if ($router_id && $router_uplink_port) {
            // Update router connection
            $olt_refresh = ORM::for_table('tbl_olt')->find_one($id);
            $olt_refresh->router_id = $router_id;
            $olt_refresh->my_uplink_port = $router_uplink_port;
            $olt_refresh->save();

            error_log("Updated router connection: Router {$router_id} on port {$router_uplink_port}");
        }

        // 2. Update PON connection (jika ada data)
        $child_odc_id = _post('child_odc_id');
        $new_pon_port = _post('pon_port_number');
        if ($child_odc_id && $new_pon_port) {
            updateOdcPonConnection($child_odc_id, $id, $new_pon_port);
            usleep(500000); // Wait for ODC save

            error_log("Updated PON connection: ODC {$child_odc_id} to PON {$new_pon_port}");
        }

        // 3. Update OLT cascade connection (jika ada data)
        $parent_olt_id = _post('parent_olt_id');
        if ($parent_olt_id) {
            $olt_refresh = ORM::for_table('tbl_olt')->find_one($id);
            $olt_refresh->parent_olt_id = $parent_olt_id;
            $olt_refresh->my_uplink_port = _post('my_uplink_port') ?: 1;
            $olt_refresh->uplink_port_number = _post('uplink_port_number');
            $olt_refresh->save();

            error_log("Updated OLT cascade connection");
        }

        // ✅ Update port details setelah SEMUA connection di-update
        updateOltPortDetails($id);

        echo json_encode([
            'success' => true,
            'message' => 'OLT updated successfully',
            'olt_id' => $id
        ]);
    } catch (Exception $e) {
        error_log("Error updating OLT: " . $e->getMessage());
        echo json_encode([
            'success' => false,
            'message' => 'Failed to update OLT: ' . $e->getMessage()
        ]);
    }

    exit;
}

// ✅ TAMBAH FUNCTION BARU INI SETELAH FUNCTION DI ATAS
function updateOltPortDetails($oltId)
{
    try {
        $olt = ORM::for_table('tbl_olt')->find_one($oltId);
        if (!$olt) return false;

        error_log("=== UPDATE OLT PORT DETAILS START: OLT {$oltId} ===");

        // ✅ RESET: Clear semua port details dulu, rebuild dari 0
        $olt->uplink_ports_detail = '{}';
        $olt->pon_ports_detail = '{}';
        $olt->save();

        error_log("Cleared all port details for OLT {$oltId}");

        // ✅ REBUILD: Router connection
        if ($olt->router_id) {
            $router = ORM::for_table('tbl_routers')->find_one($olt->router_id);
            if ($router) {
                // Cari router port dari field my_uplink_port atau default ke 1
                $router_port = $olt->my_uplink_port ?: 1;

                error_log("Adding router connection: OLT {$oltId} port {$router_port} -> Router {$router->id} ({$router->name})");

                // Gunakan function yang sudah ada dan teruji
                updateOltUplinkPortDetail($oltId, $router_port, 'router', $router->id, $router->name, 'add');
            }
        }

        // ✅ REBUILD: Parent OLT connection  
        // ✅ REBUILD: Parent OLT connection  
        if ($olt->parent_olt_id && $olt->uplink_port_number) {
            $parent_olt = ORM::for_table('tbl_olt')->find_one($olt->parent_olt_id);
            if ($parent_olt) {
                // ✅ FIX: Add to parent OLT PON (bukan uplink!)
                updateOltPonPortDetail($olt->parent_olt_id, $olt->uplink_port_number, 'olt', $oltId, $olt->name, 'add');

                // ✅ BENAR: Add to my OLT (my uplink port)
                $my_uplink_port = $olt->my_uplink_port ?: 1;
                updateOltUplinkPortDetail($oltId, $my_uplink_port, 'olt', $olt->parent_olt_id, $parent_olt->name, 'add');

                error_log("Added parent OLT connection: OLT {$oltId} port {$my_uplink_port} -> Parent OLT PON {$olt->uplink_port_number}");
            }
        }

        // ✅ REBUILD: PON connections (ODCs)
        $connected_odcs = ORM::for_table('tbl_odc')
            ->where('olt_id', $oltId)
            ->where('status', 'Active')
            ->find_many();

        foreach ($connected_odcs as $odc) {
            if ($odc->pon_port_number) {
                updateOltPonPortDetail($oltId, $odc->pon_port_number, 'odc', $odc->id, $odc->name, 'add');
                error_log("Added PON connection: OLT {$oltId} PON {$odc->pon_port_number} -> ODC {$odc->id} ({$odc->name})");
            }
        }

        // ✅ RECALCULATE: Port counts
        updateOltPortCounts(null, $oltId);

        error_log("=== UPDATE OLT PORT DETAILS COMPLETE: OLT {$oltId} ===");
        return true;
    } catch (Exception $e) {
        error_log('Error in updateOltPortDetails: ' . $e->getMessage());
        return false;
    }
}

// ✅ TAMBAH FUNCTION BARU INI JUGA
function updateOdcPonConnection($odcId, $oltId, $newPonPort)
{
    $odc = ORM::for_table('tbl_odc')->find_one($odcId);
    if ($odc && $odc->olt_id == $oltId) {
        $odc->pon_port_number = $newPonPort;
        $odc->save();
    }
}
function network_mapping_get_olt_port_usage()
{
    global $admin;

    if (!$admin) {
        http_response_code(403);
        echo json_encode(['success' => false, 'message' => 'Access denied']);
        exit;
    }

    $olt_id = _post('olt_id') ?: _get('olt_id');

    if (!$olt_id) {
        echo json_encode(['success' => false, 'message' => 'OLT ID is required']);
        exit;
    }

    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);

        if (!$olt) {
            echo json_encode(['success' => false, 'message' => 'OLT not found']);
            exit;
        }

        // Parse port details
        $uplink_details = json_decode($olt->uplink_ports_detail, true) ?: [];
        $pon_details = json_decode($olt->pon_ports_detail, true) ?: [];

        // Get used uplink ports
        $used_uplink_ports = [];
        $router_connection = null;

        foreach ($uplink_details as $port_key => $detail) {
            $port_num = str_replace('port_', '', $port_key);
            $used_uplink_ports[] = (int)$port_num;

            if ($detail['type'] === 'router') {
                $router_connection = [
                    'my_uplink_port' => (int)$port_num,
                    'router_id' => $detail['device_id'],
                    'router_name' => $detail['device_name']
                ];
            }
        }

        // Get used PON ports
        $used_pon_ports = [];
        $odc_connections = [];

        foreach ($pon_details as $pon_key => $detail) {
            $pon_num = str_replace('pon_', '', $pon_key);
            $used_pon_ports[] = (int)$pon_num;

            $odc_connections[] = [
                'pon_number' => (int)$pon_num,
                'odc_id' => $detail['device_id'],
                'odc_name' => $detail['device_name']
            ];
        }

        echo json_encode([
            'success' => true,
            'used_uplink_ports' => $used_uplink_ports,
            'used_pon_ports' => $used_pon_ports,
            'router_connection' => $router_connection,
            'odc_connections' => $odc_connections,
            'total_uplink_ports' => $olt->total_uplink_ports,
            'total_pon_ports' => $olt->total_pon_ports
        ]);
    } catch (Exception $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Error: ' . $e->getMessage()
        ]);
    }

    exit;
}
// ===== GET OLT PON USAGE FUNCTION =====
function network_mapping_get_olt_pon_usage()
{
    header('Content-Type: application/json');

    $olt_id = _req('olt_id');

    if (empty($olt_id)) {
        echo json_encode(['success' => false, 'message' => 'OLT ID required']);
        exit;
    }

    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);

        if (!$olt) {
            echo json_encode(['success' => false, 'message' => 'OLT not found']);
            exit;
        }

        // Get total PON ports
        $total_pon_ports = $olt->total_pon_ports;

        // Get used PON ports detail
        $used_pon_ports_detail = json_decode($olt->pon_ports_detail ?: '{}', true);
        
        // Extract used port numbers
        $used_pon_ports = [];
        $used_pon_details = [];

        foreach ($used_pon_ports_detail as $port_num => $detail) {
            $used_pon_ports[] = (int)$port_num;
            $used_pon_details[] = [
                'port' => (int)$port_num,
                'device_type' => $detail['type'],
                'device_id' => $detail['device_id'] ?? $detail['id'],
                'device_name' => $detail['device_name'] ?? $detail['name'],
                'connected_at' => $detail['connected_at'] ?? 'Unknown'
            ];
        }

        // Get available PON ports
        $available_pon_ports = [];
        for ($i = 1; $i <= $total_pon_ports; $i++) {
            if (!in_array($i, $used_pon_ports)) {
                $available_pon_ports[] = $i;
            }
        }

        // Get connected devices for additional info
        $connected_devices = [];
        
        // Get ODCs connected to this OLT
        $connected_odcs = ORM::for_table('tbl_odc')
            ->where('olt_id', $olt_id)
            ->where('status', 'Active')
            ->find_array();

        foreach ($connected_odcs as $odc) {
            if ($odc['pon_port_number']) {
                $connected_devices[] = [
                    'type' => 'odc',
                    'id' => $odc['id'],
                    'name' => $odc['name'],
                    'pon_port' => (int)$odc['pon_port_number'],
                    'description' => $odc['description'] ?? ''
                ];
            }
        }

        // Get child OLTs connected to this OLT
        $connected_child_olts = ORM::for_table('tbl_olt')
            ->where('parent_olt_id', $olt_id)
            ->where('status', 'Active')
            ->find_array();

        foreach ($connected_child_olts as $child_olt) {
            if ($child_olt['pon_port_number']) {
                $connected_devices[] = [
                    'type' => 'olt',
                    'id' => $child_olt['id'],
                    'name' => $child_olt['name'],
                    'pon_port' => (int)$child_olt['pon_port_number'],
                    'description' => $child_olt['description'] ?? ''
                ];
            }
        }

        echo json_encode([
            'success' => true,
            'olt_id' => (int)$olt_id,
            'olt_name' => $olt->name,
            'total_pon_ports' => (int)$total_pon_ports,
            'used_pon_ports' => $used_pon_ports,
            'available_pon_ports' => $available_pon_ports,
            'used_pon_details' => $used_pon_details,
            'connected_devices' => $connected_devices,
            'summary' => [
                'total' => (int)$total_pon_ports,
                'used' => count($used_pon_ports),
                'available' => count($available_pon_ports)
            ]
        ]);

    } catch (Exception $e) {
        error_log('Error getting OLT PON usage: ' . $e->getMessage());
        echo json_encode([
            'success' => false, 
            'message' => 'Error: ' . $e->getMessage()
        ]);
    }

    exit;
}

// ===== HELPER FUNCTION (Optional - untuk debugging) =====
function network_mapping_debug_olt_ports()
{
    header('Content-Type: application/json');

    $olt_id = _req('olt_id');

    if (empty($olt_id)) {
        echo json_encode(['success' => false, 'message' => 'OLT ID required']);
        exit;
    }

    try {
        $olt = ORM::for_table('tbl_olt')->find_one($olt_id);
        if (!$olt) {
            echo json_encode(['success' => false, 'message' => 'OLT not found']);
            exit;
        }

        echo json_encode([
            'success' => true,
            'olt_data' => [
                'id' => $olt->id,
                'name' => $olt->name,
                'total_uplink_ports' => $olt->total_uplink_ports,
                'total_pon_ports' => $olt->total_pon_ports,
                'used_uplink_ports' => $olt->used_uplink_ports,
                'used_pon_ports' => $olt->used_pon_ports,
                'uplink_ports_detail' => $olt->uplink_ports_detail,
                'pon_ports_detail' => $olt->pon_ports_detail
            ]
        ]);

    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }

    exit;
}
