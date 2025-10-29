/// High-level API helpers for the Character Game online MVP.

function api__full_url(_path) {
    return string(api_base()) + _path;
}

function api_status(_on_ok, _on_err) {
    var url = api__full_url("/status");
    var headers = api_headers();
    var async_id = http_json_get(url, headers, "status", _on_ok, _on_err);
    if (ds_exists(headers, ds_type_map)) ds_map_destroy(headers);
    return async_id;
}

function api_features(_on_ok, _on_err) {
    var url = api__full_url("/features");
    var headers = api_headers();
    var async_id = http_json_get(url, headers, "features", _on_ok, _on_err);
    if (ds_exists(headers, ds_type_map)) ds_map_destroy(headers);
    return async_id;
}

function api_submit_attempt(_userId, _card, _text, _on_ok, _on_err) {
    var url = api__full_url("/api/attempt");
    var headers = api_headers();
    var body = ds_map_create();
    ds_map_add(body, "userId", _userId);
    var itemId = is_struct(_card) && variable_struct_exists(_card, "id") ? _card.id : "";
    ds_map_add(body, "itemId", itemId);
    var mode = "character";
    if (is_struct(_card) && variable_struct_exists(_card, "mode")) {
        var m = _card.mode;
        if (is_string(m) && string_length(m) > 0) {
            mode = m;
        }
    }
    ds_map_add(body, "mode", mode);
    ds_map_add(body, "answer", _text);
    var async_id = http_json_post(url, body, headers, "attempt", _on_ok, _on_err);
    if (ds_exists(headers, ds_type_map)) ds_map_destroy(headers);
    if (ds_exists(body, ds_type_map)) ds_map_destroy(body);
    return async_id;
}

function api_get_progress(_userId, _on_ok, _on_err) {
    var query = "?userId=" + string(_userId);
    var url = api__full_url("/api/progress/state" + query);
    var headers = api_headers();
    var async_id = http_json_get(url, headers, "progress", _on_ok, _on_err);
    if (ds_exists(headers, ds_type_map)) ds_map_destroy(headers);
    return async_id;
}

function api_get_next(_userId, _on_ok, _on_err) {
    var query = "?userId=" + string(_userId);
    var url = api__full_url("/api/next" + query);
    var headers = api_headers();
    var async_id = http_json_get(url, headers, "next", _on_ok, _on_err);
    if (ds_exists(headers, ds_type_map)) ds_map_destroy(headers);
    return async_id;
}

function api_skip(_userId, _itemId, _reason, _on_ok, _on_err) {
    var url = api__full_url("/api/skip");
    var headers = api_headers();
    var body = ds_map_create();
    ds_map_add(body, "userId", _userId);
    ds_map_add(body, "itemId", _itemId);
    if (is_string(_reason) && string_length(_reason) > 0) {
        ds_map_add(body, "reason", _reason);
    }
    var async_id = http_json_post(url, body, headers, "skip", _on_ok, _on_err);
    if (ds_exists(headers, ds_type_map)) ds_map_destroy(headers);
    if (ds_exists(body, ds_type_map)) ds_map_destroy(body);
    return async_id;
}

function api_post_telemetry(_userId, _event, _meta, _on_ok, _on_err) {
    var url = api__full_url("/api/telemetry");
    var headers = api_headers();
    var body = ds_map_create();

    var user_id_val = is_string(_userId) ? _userId : string(_userId);
    ds_map_add(body, "userId", user_id_val);
    ds_map_add(body, "event", _event);

    if (variable_global_exists("game_version")) {
        var version_val = global.game_version;
        if (is_string(version_val) && string_length(version_val) > 0) {
            ds_map_add(body, "version", version_val);
        }
    }

    var ts = current_time div 1000;
    if (function_exists("time_epoch")) {
        ts = time_epoch();
    }
    ds_map_add(body, "timestamp", ts);

    var meta_payload = _meta;
    if (is_undefined(meta_payload)) {
        meta_payload = {};
    }
    if (is_struct(meta_payload) || ds_exists(meta_payload, ds_type_map) || is_array(meta_payload)) {
        ds_map_add(body, "meta", meta_payload);
    }

    var async_id = http_json_post(url, body, headers, "telemetry", _on_ok, _on_err);
    if (ds_exists(headers, ds_type_map)) ds_map_destroy(headers);
    if (ds_exists(body, ds_type_map)) ds_map_destroy(body);
    return async_id;
}
