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

refresh_preview = refresh_preview_stats;
pick_next_card = pick_next_uncompleted_card;
has_passed_card = has_card_passed;

global.character_game = id;
