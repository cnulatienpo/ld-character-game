/// Lightweight helpers around http_request() for JSON APIs.

if (!function_exists("time_epoch")) {
    function time_epoch() {
        var seconds = floor(date_current_datetime() / 1000);
        if (!is_real(seconds) || seconds <= 0) {
            seconds = current_time div 1000;
        }
        return seconds;
    }
}

function http__ensure_request_map() {
    if (!variable_global_exists("net_requests") || !ds_exists(global.net_requests, ds_type_map)) {
        global.net_requests = ds_map_create();
    }
}

function http__store_request(_async_id, _kind, _on_ok, _on_err, _request_info, _retried) {
    http__ensure_request_map();
    var record = {
        kind: _kind,
        on_ok: _on_ok,
        on_err: _on_err,
        retried: _retried,
        request: _request_info
    };
    if (ds_map_exists(global.net_requests, _async_id)) {
        ds_map_replace(global.net_requests, _async_id, record);
    } else {
        ds_map_add(global.net_requests, _async_id, record);
    }
}

function http_json_get(_url, _headers, _kind, _on_ok, _on_err) {
    http__ensure_request_map();
    var async_id = http_request(_url, "GET", _headers, "", 0);
    http__store_request(async_id, _kind, _on_ok, _on_err, undefined, false);
    return async_id;
}

function http_json_post(_url, _body, _headers, _kind, _on_ok, _on_err) {
    http__ensure_request_map();
    var payload = "{}";
    if (is_string(_body)) {
        payload = _body;
    } else if (is_struct(_body) || ds_exists(_body, ds_type_map)) {
        payload = json_stringify(_body);
    }
    var async_id = http_request(_url, "POST", _headers, payload, string_length(payload));
    var request_info = undefined;
    if (is_string(_kind) && _kind == "telemetry") {
        var header_copy = undefined;
        if (ds_exists(_headers, ds_type_map)) {
            header_copy = ds_map_create();
            ds_map_copy(header_copy, _headers);
        }
        request_info = {
            method: "POST",
            url: _url,
            headers: header_copy,
            body: payload
        };
    }
    http__store_request(async_id, _kind, _on_ok, _on_err, request_info, false);
    return async_id;
}
