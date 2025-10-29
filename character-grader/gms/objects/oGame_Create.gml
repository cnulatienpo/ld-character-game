/// oGame Create Event

cards = jsonl_read_included("character_master_min.jsonl");
if (!is_array(cards)) {
    cards = [];
}

state = progress_load();
state.level = level_for_xp(state.xp);

card_index = 0;
current = undefined;
phase = "show";
text_buffer = "";
keyboard_string = "";
preview_stats = { wc: 0, caps_ratio: 0, gates: undefined };
has_preview_function = function_exists("grade_preview");
collection_complete = false;

net_waiting = false;
net_msg = "";
net_last_score = -1;
pending_submission_text = "";
net_badges_latest = [];

if (!variable_global_exists("user_id")) {
    if (function_exists("ensure_user_id")) {
        global.user_id = ensure_user_id();
    } else {
        var fallback_uid = ((get_timer() div 1000) mod 900000) + 100000;
        global.user_id = "u-" + string(fallback_uid);
    }
}

user_id = global.user_id;

var function has_card_passed(_card_id) {
    if (!is_struct(state.cards)) {
        return false;
    }
    if (variable_struct_exists(state.cards, _card_id)) {
        var entry = state.cards[$ _card_id];
        return is_struct(entry) && entry.passed;
    }
    return false;
};

var function pick_next_uncompleted_card(_start_index) {
    var total = array_length(cards);
    if (total <= 0) {
        collection_complete = true;
        return undefined;
    }
    for (var i = 0; i < total; ++i) {
        var idx = (_start_index + i) mod total;
        var candidate = cards[idx];
        if (is_struct(candidate)) {
            var cid = candidate.id;
            if (!has_card_passed(cid)) {
                card_index = idx;
                collection_complete = false;
                return candidate;
            }
        }
    }
    collection_complete = true;
    return undefined;
};

var function refresh_preview_stats() {
    preview_stats.wc = 0;
    preview_stats.caps_ratio = 0;
    preview_stats.gates = undefined;
    if (!is_struct(current)) {
        return;
    }
    var text = text_buffer;
    if (has_preview_function) {
        var preview_result = grade_preview(text, current.gate_rules);
        if (is_struct(preview_result)) {
            if (is_real(preview_result.wc)) {
                preview_stats.wc = preview_result.wc;
            }
            if (is_real(preview_result.caps_ratio)) {
                preview_stats.caps_ratio = preview_result.caps_ratio;
            }
            if (is_struct(preview_result.gates)) {
                preview_stats.gates = preview_result.gates;
            }
        }
    } else {
        preview_stats.wc = preview_word_count(text);
        preview_stats.caps_ratio = preview_caps_ratio(text);
    }
};

current = pick_next_uncompleted_card(card_index);
if (is_undefined(current)) {
    collection_complete = true;
}
refresh_preview_stats();

if (!instance_exists(oCardUI)) {
    var ui = instance_create_depth(0, 0, -10, oCardUI);
    ui.controller = id;
} else {
    with (oCardUI) {
        controller = other.id;
    }
}

function card_completed_count() {
    if (!is_struct(state.cards)) {
        return 0;
    }
    var total = 0;
    var keys = variable_struct_get_names(state.cards);
    if (is_array(keys)) {
        for (var i = 0; i < array_length(keys); ++i) {
            var entry = state.cards[$ keys[i]];
            if (is_struct(entry) && entry.passed) {
                total += 1;
            }
        }
    }
    return total;
}

card_pass_count = card_completed_count();
function update_pass_count() {
    card_pass_count = card_completed_count();
}

function shorten_note(_text, _limit) {
    if (!is_string(_text)) {
        return "";
    }
    if (string_length(_text) <= _limit) {
        return _text;
    }
    return string_copy(_text, 1, _limit - 3) + "...";
}

function apply_progress_snapshot(_snapshot) {
    if (!is_struct(_snapshot)) {
        return;
    }
    var new_state = progress_default_state();
    if (is_struct(_snapshot.cards)) {
        new_state.cards = _snapshot.cards;
    }
    if (is_real(_snapshot.xp)) {
        new_state.xp = _snapshot.xp;
    }
    if (is_real(_snapshot.level)) {
        new_state.level = _snapshot.level;
    }
    if (is_array(_snapshot.badges)) {
        new_state.badges = _snapshot.badges;
    }
    if (is_real(_snapshot.streak)) {
        new_state.streak = _snapshot.streak;
    }
    if (is_real(_snapshot.attempt_count)) {
        new_state.attempt_count = _snapshot.attempt_count;
    }
    state = new_state;
    if (!is_struct(state.cards)) {
        state.cards = {};
    }
    if (!is_array(state.badges)) {
        state.badges = [];
    }
    if (!is_real(state.level)) {
        state.level = level_for_xp(state.xp);
    }
}

function apply_attempt_delta(_data) {
    if (!is_struct(state)) {
        state = progress_default_state();
    }
    if (!is_struct(state.cards)) {
        state.cards = {};
    }
    if (!is_array(state.badges)) {
        state.badges = [];
    }
    var xp_delta = 0;
    if (variable_struct_exists(_data, "xpDelta") && is_real(_data.xpDelta)) {
        xp_delta = _data.xpDelta;
    }
    state.xp += xp_delta;
    if (variable_struct_exists(_data, "level") && is_real(_data.level)) {
        state.level = _data.level;
    } else {
        state.level = level_for_xp(state.xp);
    }

    if (variable_struct_exists(_data, "badgesAwarded") && is_array(_data.badgesAwarded)) {
        for (var b = 0; b < array_length(_data.badgesAwarded); ++b) {
            var badge = _data.badgesAwarded[b];
            if (is_string(badge)) {
                var exists = false;
                for (var i = 0; i < array_length(state.badges); ++i) {
                    if (state.badges[i] == badge) {
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    array_push(state.badges, badge);
                }
            }
        }
    }

    var result_struct = {
        score: (variable_struct_exists(_data, "score") && is_real(_data.score)) ? _data.score : 0,
        passed: (variable_struct_exists(_data, "passed") && is_bool(_data.passed)) ? _data.passed : false
    };
    if (is_struct(current) && variable_struct_exists(current, "id")) {
        progress_mark_card(state, current.id, result_struct, pending_submission_text);
    }
    state.level = level_for_xp(state.xp);
}

function toast_message(_text, _success) {
    var toast = instance_create_depth(0, 0, -100000, oToast);
    toast.message = _text;
    toast.is_success = _success;
}

function reset_typing_state() {
    text_buffer = "";
    keyboard_string = "";
    phase = "show";
    refresh_preview_stats();
}

function advance_to_next_card_local() {
    var total_cards = array_length(cards);
    if (total_cards > 0) {
        var next_index = (card_index + 1) mod total_cards;
        current = pick_next_card(next_index);
    } else {
        current = undefined;
    }
    if (is_undefined(current)) {
        collection_complete = true;
    } else {
        collection_complete = false;
    }
    reset_typing_state();
}

function on_next_ok(_data) {
    net_waiting = false;
    var next_id = "";
    if (is_struct(_data) && variable_struct_exists(_data, "id")) {
        next_id = _data.id;
    } else if (is_struct(_data) && variable_struct_exists(_data, "next")) {
        var next_struct = _data.next;
        if (is_struct(next_struct) && variable_struct_exists(next_struct, "id")) {
            next_id = next_struct.id;
        }
    }

    var found = false;
    if (is_string(next_id) && string_length(next_id) > 0) {
        for (var i = 0; i < array_length(cards); ++i) {
            var candidate = cards[i];
            if (is_struct(candidate) && candidate.id == next_id) {
                card_index = i;
                current = candidate;
                found = true;
                break;
            }
        }
    }

    if (!found) {
        current = pick_next_card(card_index);
    }

    if (is_undefined(current)) {
        collection_complete = true;
    }

    reset_typing_state();
}

function on_next_err(_message) {
    net_waiting = false;
    if (!is_string(_message) || string_length(_message) <= 0) {
        _message = "Unable to fetch next card";
    }
    net_msg = _message;
    toast_message(_message, false);
    advance_to_next_card_local();
}

function request_next_card() {
    if (global.net_online && function_exists("api_get_next")) {
        net_waiting = true;
        net_msg = "Loading next card...";
        api_get_next(global.user_id, method(self, on_next_ok), method(self, on_next_err));
    } else {
        advance_to_next_card_local();
    }
}

function on_progress_ok(_data) {
    net_waiting = false;
    if (is_struct(_data)) {
        apply_progress_snapshot(_data);
        progress_save(state);
        update_pass_count();
        current = pick_next_uncompleted_card(card_index);
        if (is_undefined(current)) {
            collection_complete = true;
        }
        reset_typing_state();
        net_msg = "Progress synced";
    }
}

function on_progress_err(_message) {
    net_waiting = false;
    if (!is_string(_message) || string_length(_message) <= 0) {
        _message = "Progress sync failed";
    }
    net_msg = _message;
    toast_message(_message, false);
}

function on_attempt_ok(_data) {
    net_waiting = false;
    net_badges_latest = [];
    if (is_struct(_data)) {
        if (variable_struct_exists(_data, "progress") && is_struct(_data.progress)) {
            apply_progress_snapshot(_data.progress);
        } else {
            apply_attempt_delta(_data);
        }
        progress_save(state);
        update_pass_count();
        net_last_score = (variable_struct_exists(_data, "score") && is_real(_data.score)) ? _data.score : -1;
        if (variable_struct_exists(_data, "badgesAwarded") && is_array(_data.badgesAwarded)) {
            net_badges_latest = _data.badgesAwarded;
        }
        var score_text = (net_last_score >= 0) ? string_format(net_last_score, 0, 2) : "--";
        var xp_text = "";
        if (variable_struct_exists(_data, "xpDelta") && is_real(_data.xpDelta)) {
            xp_text = "  (+" + string(_data.xpDelta) + " XP)";
        }
        var passed = variable_struct_exists(_data, "passed") && is_bool(_data.passed) ? _data.passed : false;
        var summary = passed ? "Passed" : "Attempt recorded";
        net_msg = summary + " — score " + score_text + xp_text;
        var notes_text = "";
        if (variable_struct_exists(_data, "notes") && is_string(_data.notes)) {
            notes_text = shorten_note(_data.notes, 160);
        }

        var toast_text = net_msg;
        if (string_length(notes_text) > 0) {
            toast_text += "\n" + notes_text;
        }
        if (array_length(net_badges_latest) > 0) {
            toast_text += "\nBadges: ";
            for (var b = 0; b < array_length(net_badges_latest); ++b) {
                if (b > 0) {
                    toast_text += ", ";
                }
                toast_text += net_badges_latest[b];
            }
        }
        toast_message(toast_text, passed);
    }

    pending_submission_text = "";
    request_next_card();
}

function on_attempt_err(_message) {
    if (!is_string(_message) || string_length(_message) <= 0) {
        _message = "Submission failed";
    }
    net_waiting = false;
    net_msg = _message;
    toast_message(_message, false);
    text_buffer = pending_submission_text;
    keyboard_string = pending_submission_text;
    refresh_preview_stats();
}

function clean_submission_text(_text) {
    var send_text = _text;
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

function submit_attempt() {
    if (!is_struct(current)) {
        return;
    }
    if (!function_exists("api_submit_attempt")) {
        on_attempt_err("API unavailable");
        return;
    }
    var submission_text = keyboard_string;
    var send_text = clean_submission_text(submission_text);
    pending_submission_text = submission_text;
    net_waiting = true;
    net_msg = "Submitting...";
    api_submit_attempt(global.user_id, current, send_text, method(self, on_attempt_ok), method(self, on_attempt_err));
}

refresh_preview = refresh_preview_stats;
pick_next_card = pick_next_uncompleted_card;
has_passed_card = has_card_passed;

if (function_exists("api_get_progress")) {
    net_waiting = true;
    net_msg = "Syncing progress...";
    api_get_progress(global.user_id, method(self, on_progress_ok), method(self, on_progress_err));
}

global.character_game = id;
