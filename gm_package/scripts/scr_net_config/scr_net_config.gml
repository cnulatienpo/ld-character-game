/**
 * Networking configuration bridge for root GameMaker runtime.
 *
 * Update this URL for your deployed backend when needed.
 */

function api_base() {
    if (variable_global_exists("api_base_url")) {
        var override_url = string(global.api_base_url);
        if (string_length(override_url) > 0) {
            return override_url;
        }
    }
    return "http://localhost:8000";
}

function api_headers() {
    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/json");
    return headers;
}
