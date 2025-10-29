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

var status = async_load[? "status"];
if (status == 0) {
    net__call(req.on_err, "Network error");
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
    net__call(req.on_err, message);
    return;
}

global.net_online = true;
net__call(req.on_ok, data);
