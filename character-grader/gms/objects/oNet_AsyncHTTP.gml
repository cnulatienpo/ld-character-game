/// oNet Async HTTP Event

if (!variable_global_exists("net_requests") || !ds_exists(global.net_requests, ds_type_map)) {
    return;
}

var async_id = async_load[? "id"];
if (is_undefined(async_id)) {
    return;
}

if (!ds_map_exists(global.net_requests, async_id)) {
    return;
}

var req = global.net_requests[? async_id];
ds_map_delete(global.net_requests, async_id);

function net__call(_fn, _arg) {
    if (is_method(_fn) || is_function(_fn)) {
        _fn(_arg);
    }
}

function net__cleanup_request(_info) {
    if (is_struct(_info) && variable_struct_exists(_info, "headers")) {
        var header_map = _info.headers;
        if (ds_exists(header_map, ds_type_map)) {
            ds_map_destroy(header_map);
        }
        _info.headers = undefined;
    }
}

var request_info = undefined;
if (is_struct(req) && variable_struct_exists(req, "request")) {
    request_info = req.request;
}
var req_kind = is_struct(req) && variable_struct_exists(req, "kind") ? req.kind : "";
var telemetry_request = is_string(req_kind) && req_kind == "telemetry";
var already_retried = is_struct(req) && variable_struct_exists(req, "retried") ? req.retried : false;

var status = async_load[? "status"];
if (status == 0) {
    if (telemetry_request && !already_retried && is_struct(request_info)) {
        var retry_body = request_info.body;
        if (!is_string(retry_body)) {
            retry_body = json_stringify(retry_body);
        }
        var retry_length = is_string(retry_body) ? string_length(retry_body) : 0;
        var retry_headers = request_info.headers;
        var retry_async = http_request(request_info.url, request_info.method, retry_headers, retry_body, retry_length);
        http__store_request(retry_async, req_kind, req.on_ok, req.on_err, request_info, true);
        return;
    }
    net__call(req.on_err, "Network error");
    net__cleanup_request(request_info);
    return;
}

var raw_result = async_load[? "result"];
var data = undefined;
if (is_string(raw_result)) {
    if (string_length(raw_result) > 0) {
        data = json_parse(raw_result);
    }
} else if (is_struct(raw_result)) {
    data = raw_result;
}

if (!is_struct(data)) {
    net__call(req.on_err, "Invalid response");
    net__cleanup_request(request_info);
    return;
}

var ok_flag = false;
if (variable_struct_exists(data, "ok")) {
    var ok_value = data.ok;
    ok_flag = is_bool(ok_value) ? ok_value : (ok_value == 1);
}

if (!ok_flag) {
    var message = "Unknown error";
    if (variable_struct_exists(data, "error")) {
        var err_val = data.error;
        if (is_string(err_val) && string_length(err_val) > 0) {
            message = err_val;
        }
    }
    if (!telemetry_request) {
        net__call(req.on_err, message);
    } else {
        net__call(req.on_err, message);
    }
    net__cleanup_request(request_info);
    return;
}

global.net_online = true;
net__call(req.on_ok, data);
net__cleanup_request(request_info);
