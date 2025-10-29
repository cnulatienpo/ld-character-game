/// oUIRouter Create Event

mode = "writing";
subview = "theory";
left_view = "theory";
nav_cycle = ["theory", "prompt", "editor", "feedback"];
nav_index = 0;
scroll_left = 0;
scroll_right = 0;
left_content_height = 0;
right_content_height = 0;
paused = false;
submitting = false;
skip_pending = false;
loading_next = false;
net_status = "Ready";
pending_text = "";
last_result = undefined;
editor_stats = { words: 0, caps: 0, chars: 0 };
progress_state = progress_default_state();
cards = [];
current_card = undefined;
text_input = noone;
activity_picker = noone;
tray = tray_init();
game_ref = noone;

if (!variable_global_exists("net_online")) {
    global.net_online = true;
}

var loaded_state = progress_load();
if (is_struct(loaded_state)) {
    progress_state = loaded_state;
}

if (!variable_global_exists("user_id")) {
    if (function_exists("ensure_user_id")) {
        global.user_id = ensure_user_id();
    } else {
        var fallback_uid = ((get_timer() div 1000) mod 900000) + 100000;
        global.user_id = "u-" + string(fallback_uid);
    }
}

if (variable_global_exists("character_game") && instance_exists(global.character_game)) {
    game_ref = global.character_game;
} else if (instance_number(oGame) > 0) {
    game_ref = instance_find(oGame, 0);
}

if (instance_exists(game_ref)) {
    if (is_array(game_ref.cards)) {
        cards = game_ref.cards;
    }
    if (is_struct(game_ref.state)) {
        progress_state = game_ref.state;
    }
}

if (!is_array(cards) || array_length(cards) <= 0) {
    if (function_exists("jsonl_read_included")) {
        cards = jsonl_read_included("character_master_min.jsonl");
    }
    if (!is_array(cards)) {
        cards = [];
    }
}
if (!is_struct(progress_state)) {
    progress_state = progress_default_state();
}
if (!is_struct(progress_state.cards)) {
    progress_state.cards = {};
}
if (!is_array(progress_state.badges)) {
    progress_state.badges = [];
}
if (!is_real(progress_state.level)) {
    progress_state.level = level_for_xp(progress_state.xp);
}

activity_set_cards(cards);
set_mode("writing");

function has_card_passed_local(_card_id) {
    if (!is_struct(progress_state.cards)) {
        return false;
    }
    if (variable_struct_exists(progress_state.cards, _card_id)) {
        var entry = progress_state.cards[$ _card_id];
        if (is_struct(entry) && variable_struct_exists(entry, "passed")) {
            return entry.passed;
        }
    }
    return false;
}

function pick_first_unpassed() {
    if (!is_array(cards) || array_length(cards) <= 0) {
        return undefined;
    }
    for (var i = 0; i < array_length(cards); ++i) {
        var c = cards[i];
        if (is_struct(c) && variable_struct_exists(c, "id")) {
            var cid = c.id;
            if (!has_card_passed_local(cid)) {
                nav_index = 0;
                return c;
            }
        }
    }
    return cards[0];
}

current_card = pick_first_unpassed();
if (is_struct(current_card)) {
    act_bind_card(current_card);
} else if (is_array(cards) && array_length(cards) > 0) {
    act_bind_card(cards[0]);
}
current_card = act_current_card();

text_input = instance_create_depth(0, 0, -50, oUITextInput);
if (instance_exists(text_input)) {
    with (text_input) {
        owner = other.id;
        ui_text_init(5000);
    }
}

activity_picker = instance_create_depth(0, 0, -60, oUIActivityPicker);
if (instance_exists(activity_picker)) {
    activity_picker.controller = id;
}

function ensure_toast(_text, _success) {
    var toast = instance_create_depth(0, 0, -100000, oToast);
    toast.message = _text;
    toast.is_success = _success;
}

function apply_progress_snapshot_local(_snapshot) {
    if (!is_struct(_snapshot)) {
        return;
    }
    var new_state = progress_default_state();
    if (is_struct(_snapshot.cards)) new_state.cards = _snapshot.cards;
    if (is_real(_snapshot.xp)) new_state.xp = _snapshot.xp;
    if (is_real(_snapshot.level)) new_state.level = _snapshot.level;
    if (is_array(_snapshot.badges)) new_state.badges = _snapshot.badges;
    if (is_real(_snapshot.streak)) new_state.streak = _snapshot.streak;
    if (is_real(_snapshot.attempt_count)) new_state.attempt_count = _snapshot.attempt_count;
    progress_state = new_state;
    if (!is_struct(progress_state.cards)) progress_state.cards = {};
    if (!is_array(progress_state.badges)) progress_state.badges = [];
    if (!is_real(progress_state.level)) progress_state.level = level_for_xp(progress_state.xp);
}

function apply_attempt_delta_local(_data) {
    if (!is_struct(progress_state)) {
        progress_state = progress_default_state();
    }
    if (!is_struct(progress_state.cards)) progress_state.cards = {};
    if (!is_array(progress_state.badges)) progress_state.badges = [];
    var xp_delta = 0;
    if (variable_struct_exists(_data, "xpDelta") && is_real(_data.xpDelta)) {
        xp_delta = _data.xpDelta;
    }
    progress_state.xp += xp_delta;
    if (variable_struct_exists(_data, "level") && is_real(_data.level)) {
        progress_state.level = _data.level;
    } else {
        progress_state.level = level_for_xp(progress_state.xp);
    }
    if (variable_struct_exists(_data, "badgesAwarded") && is_array(_data.badgesAwarded)) {
        for (var b = 0; b < array_length(_data.badgesAwarded); ++b) {
            var badge = _data.badgesAwarded[b];
            var exists = false;
            for (var i = 0; i < array_length(progress_state.badges); ++i) {
                if (progress_state.badges[i] == badge) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                array_push(progress_state.badges, badge);
            }
        }
    }
    if (is_struct(current_card) && variable_struct_exists(current_card, "id")) {
        var result_struct = {
            score: (variable_struct_exists(_data, "score") && is_real(_data.score)) ? _data.score : 0,
            passed: (variable_struct_exists(_data, "passed") && is_bool(_data.passed)) ? _data.passed : false
        };
        progress_mark_card(progress_state, current_card.id, result_struct, pending_text);
    }
    progress_state.level = level_for_xp(progress_state.xp);
}

function update_current_card(_card) {
    if (is_struct(_card)) {
        act_bind_card(_card);
        current_card = act_current_card();
    } else {
        current_card = act_current_card();
    }
    scroll_left = 0;
    scroll_right = 0;
    if (instance_exists(text_input)) {
        with (text_input) {
            ui_text_set("");
            has_focus = (activity_mode_get() == "writing");
        }
    }
}

function clean_submission_text(_text) {
    var send_text = is_string(_text) ? _text : "";
    while (string_length(send_text) > 0) {
        var last_char = string_char_at(send_text, string_length(send_text));
        if (last_char == "\n" || last_char == "\r") {
            send_text = string_delete(send_text, string_length(send_text), 1);
        } else {
            break;
        }
    }
    return send_text;
}

function submit_editor_text() {
    if (submitting) return;
    if (activity_mode_get() != "writing") return;
    var text_value = "";
    if (instance_exists(text_input)) {
        with (text_input) {
            text_value = ui_text_get();
        }
    }
    if (!is_struct(current_card)) {
        ensure_toast("No active card", false);
        return;
    }
    if (!function_exists("api_submit_attempt")) {
        ensure_toast("API unavailable", false);
        return;
    }
    pending_text = text_value;
    var send_text = clean_submission_text(text_value);
    submitting = true;
    net_status = "Submitting...";
    api_submit_attempt(global.user_id, current_card, send_text, method(self, on_attempt_ok), method(self, on_attempt_err));
}

function request_next_card() {
    if (loading_next) {
        return;
    }
    loading_next = true;
    net_status = "Loading next card...";
    act_next_card(method(self, on_next_ok), method(self, on_next_err));
}

function skip_current_card() {
    if (skip_pending) return;
    if (!is_struct(current_card) || !variable_struct_exists(current_card, "id")) {
        request_next_card();
        return;
    }
    if (!function_exists("api_skip")) {
        request_next_card();
        return;
    }
    skip_pending = true;
    net_status = "Skipping...";
    api_skip(global.user_id, current_card.id, "user_skip", method(self, on_skip_ok), method(self, on_skip_err));
}

function handle_picker_choice(_choice_label) {
    var result = {
        score: 1,
        notes: "Selected: " + string(_choice_label),
        xpDelta: 0,
        badgesAwarded: []
    };
    tray_push(result);
    activity_record_result(result);
    ensure_toast("Choice submitted", true);
    set_mode("writing");
    request_next_card();
}

function on_attempt_ok(_data) {
    submitting = false;
    net_status = "Feedback ready";
    global.net_online = true;
    last_result = _data;
    tray_push(_data);
    activity_record_result(_data);
    subview = "feedback";
    pending_text = "";
    if (variable_struct_exists(_data, "progress") && is_struct(_data.progress)) {
        apply_progress_snapshot_local(_data.progress);
    } else {
        apply_attempt_delta_local(_data);
    }
    progress_save(progress_state);
    if (instance_exists(text_input)) {
        with (text_input) {
            ui_text_set("");
            has_focus = false;
        }
    }
}

function on_attempt_err(_msg) {
    submitting = false;
    if (!is_string(_msg) || string_length(_msg) <= 0) {
        _msg = "Submission failed";
    }
    net_status = _msg;
    ensure_toast(_msg, false);
    if (instance_exists(text_input)) {
        with (text_input) {
            ui_text_set(pending_text);
        }
    }
}

function on_skip_ok(_data) {
    skip_pending = false;
    net_status = "Card skipped";
    request_next_card();
}

function on_skip_err(_msg) {
    skip_pending = false;
    if (!is_string(_msg) || string_length(_msg) <= 0) {
        _msg = "Skip failed";
    }
    net_status = _msg;
    ensure_toast(_msg, false);
}

function on_next_ok(_data) {
    loading_next = false;
    var card_struct = undefined;
    if (is_struct(_data)) {
        if (variable_struct_exists(_data, "card") && is_struct(_data.card)) {
            card_struct = _data.card;
        } else if (variable_struct_exists(_data, "next") && is_struct(_data.next)) {
            card_struct = _data.next;
        }
    }
    if (!is_struct(card_struct)) {
        card_struct = act_current_card();
    }
    if (is_struct(card_struct)) {
        if (is_array(cards)) {
            var known = false;
            if (variable_struct_exists(card_struct, "id")) {
                var cid = card_struct.id;
                for (var cc = 0; cc < array_length(cards); ++cc) {
                    var existing = cards[cc];
                    if (is_struct(existing) && variable_struct_exists(existing, "id") && existing.id == cid) {
                        known = true;
                        break;
                    }
                }
                if (!known) {
                    array_push(cards, card_struct);
                    activity_set_cards(cards);
                }
            }
        }
    }
    update_current_card(card_struct);
    net_status = "Card ready";
    subview = "prompt";
    left_view = "prompt";
}

function on_next_err(_msg) {
    loading_next = false;
    if (!is_string(_msg) || string_length(_msg) <= 0) {
        _msg = "Next card unavailable";
    }
    net_status = _msg;
    ensure_toast(_msg, false);
    var cards_local = activity_get_cards();
    if (is_array(cards_local) && array_length(cards_local) > 0) {
        var reg = activity_registry();
        reg.card_index = (reg.card_index + 1) mod array_length(cards_local);
        update_current_card(cards_local[reg.card_index]);
    }
}

function on_progress_ok(_data) {
    if (is_struct(_data) && variable_struct_exists(_data, "progress")) {
        apply_progress_snapshot_local(_data.progress);
    } else if (is_struct(_data)) {
        apply_progress_snapshot_local(_data);
    }
    progress_save(progress_state);
    net_status = "Progress synced";
    current_card = pick_first_unpassed();
    update_current_card(current_card);
}

function on_progress_err(_msg) {
    if (!is_string(_msg) || string_length(_msg) <= 0) {
        _msg = "Progress sync failed";
    }
    net_status = _msg;
}

if (function_exists("api_get_progress")) {
    net_status = "Syncing progress...";
    api_get_progress(global.user_id, method(self, on_progress_ok), method(self, on_progress_err));
} else {
    net_status = "Offline";
}
