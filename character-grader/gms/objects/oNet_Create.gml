/// oNet Create Event

if (!variable_global_exists("user_id")) {
    if (function_exists("ensure_user_id")) {
        global.user_id = ensure_user_id();
    } else {
        var fallback_id = ((get_timer() div 1000) mod 900000) + 100000;
        global.user_id = "u-" + string(fallback_id);
    }
}

global.net_online = false;
http__ensure_request_map();

status_request_id = -1;

function on_status_ok(_data) {
    global.net_online = true;
};

function on_status_err(_error) {
    // stay offline until requests succeed
};

if (function_exists("api_status")) {
    status_request_id = api_status(method(self, on_status_ok), method(self, on_status_err));
}
