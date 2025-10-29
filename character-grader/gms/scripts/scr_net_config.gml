/**
 * Networking configuration for the Character Game MVP.
 *
 * Ensure your backend enables CORS during development:
 *   Access-Control-Allow-Origin: *
 *   Access-Control-Allow-Headers: Content-Type
 * and accepts application/json payloads.
 */

function api_base() {
    return "http://localhost:8000";
}

function api_headers() {
    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/json");
    return headers;
}
