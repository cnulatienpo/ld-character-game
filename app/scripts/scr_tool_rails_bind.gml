/// scr_tool_rails_bind.gml
// Glue helpers bridging the runtime unlocks with the rail renderer
// -----------------------------------------------------------------------------

function rails_bind_from_unlocks(_newly_unlocked) {
    if (!is_array(_newly_unlocked)) {
        return;
    }
    if (!tool_registry_initialized) {
        tools_init();
    }
    tool_rails_init();
    for (var i = 0; i < array_length(_newly_unlocked); ++i) {
        var tool_id = _newly_unlocked[i];
        if (is_string(tool_id)) {
            tool_rails_unlock(tool_id);
        }
    }
}

function rails_catalog_all() {
    if (!tool_registry_initialized) {
        tools_init();
    }
    var listing = [];
    var keys = ds_map_keys(tool_catalog_map);
    for (var i = 0; i < ds_list_size(keys); ++i) {
        var tool_id = ds_list_find_value(keys, i);
        var info = ds_map_find_value(tool_catalog_map, tool_id);
        var entry = {
            id: tool_id,
            name: info.name,
            side: info.side,
            icon: info.icon,
        };
        array_push(listing, entry);
    }
    ds_list_destroy(keys);
    return listing;
}
