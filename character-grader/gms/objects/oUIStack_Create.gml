/// oUIStack Create Event

cards = jsonl_read_included("character_master_min.jsonl");
if (!is_array(cards)) {
    cards = [];
}

state = progress_load();
if (!is_struct(state)) {
    state = { cards: {} };
}

current_index = 0;
current = undefined;
collection_complete = false;

function card_has_passed(_card_id) {
    if (!is_struct(state) || !variable_struct_exists(state, "cards")) {
        return false;
    }
    var cards_struct = state.cards;
    if (!is_struct(cards_struct)) {
        return false;
    }
    if (!variable_struct_exists(cards_struct, _card_id)) {
        return false;
    }
    var entry = cards_struct[$ _card_id];
    return is_struct(entry) && entry.passed;
}

function pick_next_available(_start) {
    var total = array_length(cards);
    if (total <= 0) {
        collection_complete = true;
        return undefined;
    }
    for (var i = 0; i < total; ++i) {
        var idx = (_start + i) mod total;
        var candidate = cards[idx];
        if (is_struct(candidate)) {
            var cid = candidate.id;
            if (!card_has_passed(cid)) {
                current_index = idx;
                collection_complete = false;
                return candidate;
            }
        }
    }
    collection_complete = true;
    return cards[_start mod total];
}

function bind_card(_card) {
    current = _card;
    editor_text = "";
    editor_scroll = 0;
    editor_focus = false;
    editor_caret = 1;
}

current = pick_next_available(current_index);
if (is_undefined(current) && array_length(cards) > 0) {
    current = cards[0];
}
if (!is_undefined(current)) {
    bind_card(current);
}

tray = tray_init();
submitting = false;
net_msg = "";
net_spinner = 0;
action_clicked = "";
editor_rect = undefined;
rail_scroll_left = 0;
rail_scroll_right = 0;
last_error = "";
editor_max_chars = 5000;

if (!variable_global_exists("user_id")) {
    global.user_id = "guest" + string((current_time div 1000) mod 1000000);
}

tool_rails_init();

if (!instance_exists(oUITextInput)) {
    editor_input = instance_create_depth(0, 0, -16000, oUITextInput);
    editor_input.owner = id;
} else {
    with (oUITextInput) {
        owner = other.id;
    }
}

function request_next_card() {
    if (!function_exists("api_get_next")) {
        return;
    }
    net_msg = "Fetching next";
    api_get_next(global.user_id, method(self, oUIStack.on_next_ok), method(self, oUIStack.on_attempt_err));
}

function skip_current_card() {
    if (!function_exists("api_skip")) {
        request_next_card();
        return;
    }
    var cid = is_struct(current) && variable_struct_exists(current, "id") ? current.id : "";
    net_msg = "Skipping";
    api_skip(global.user_id, cid, "ui_skip", method(self, oUIStack.on_next_ok), method(self, oUIStack.on_attempt_err));
}

function submit_current_attempt() {
    if (submitting || !is_struct(current)) {
        return;
    }
    submitting = true;
    net_msg = "Submitting";
    api_submit_attempt(global.user_id, current, editor_text, method(self, oUIStack.on_attempt_ok), method(self, oUIStack.on_attempt_err));
}

function apply_progress(_progress) {
    if (is_struct(_progress)) {
        state = _progress;
    }
}

top_hud_height = 48;

function oUIStack::on_attempt_ok(_data) {
    submitting = false;
    net_msg = "Submitted";
    last_error = "";
    tray_push(tray, _data);
    if (is_struct(_data) && variable_struct_exists(_data, "progress")) {
        apply_progress(_data.progress);
    }
    if (is_struct(_data) && variable_struct_exists(_data, "passed") && _data.passed) {
        tool_rails_unlock("history");
        tool_rails_unlock("badges");
    }
}

function oUIStack::on_attempt_err(_msg) {
    submitting = false;
    last_error = is_string(_msg) ? _msg : "Network error";
    net_msg = last_error;
}

function oUIStack::on_next_ok(_data) {
    last_error = "";
    net_msg = "";
    if (is_struct(_data)) {
        bind_card(_data);
    }
}
