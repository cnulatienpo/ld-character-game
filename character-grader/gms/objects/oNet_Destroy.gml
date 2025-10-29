/// oNet Destroy Event

if (variable_global_exists("net_requests") && ds_exists(global.net_requests, ds_type_map)) {
    ds_map_destroy(global.net_requests);
    global.net_requests = undefined;
}
