/// Progress persistence utilities for the Character Game MVP.

function progress_default_state() {
    return {
        cards: {},
        xp: 0,
        level: 1,
        badges: [],
        streak: 0,
        attempt_count: 0
    };
}

function progress_load() {
    var path = working_directory + "character_progress.json";
    if (!file_exists(path)) {
        path = "character_progress.json";
    }

    var state = progress_default_state();

    if (file_exists(path)) {
        var raw = string_load(path);
        if (!is_undefined(raw) && string_length(raw) > 0) {
            var parsed = json_parse(raw);
            if (is_struct(parsed)) {
                if (is_struct(parsed.cards)) {
                    state.cards = parsed.cards;
                }
                if (is_real(parsed.xp)) {
                    state.xp = parsed.xp;
                }
                if (is_real(parsed.level)) {
                    state.level = parsed.level;
                }
                if (is_array(parsed.badges)) {
                    state.badges = parsed.badges;
                }
                if (is_real(parsed.streak)) {
                    state.streak = parsed.streak;
                }
                if (is_real(parsed.attempt_count)) {
                    state.attempt_count = parsed.attempt_count;
                }
            }
        }
    }

    state.level = floor(state.xp / 100) + 1;
    if (!is_array(state.badges)) {
        state.badges = [];
    }
    if (!is_struct(state.cards)) {
        state.cards = {};
    }

    return state;
}

function progress_save(_state) {
    if (!is_struct(_state)) {
        return;
    }
    var path = working_directory + "character_progress.json";
    var json = json_stringify(_state);
    string_save(path, json);
}

function progress_mark_card(_state, _card_id, _result, _text) {
    if (!is_struct(_state)) {
        return;
    }

    if (!is_struct(_state.cards)) {
        _state.cards = {};
    }

    var entry = undefined;
    if (variable_struct_exists(_state.cards, _card_id)) {
        entry = _state.cards[$ _card_id];
    }
    if (!is_struct(entry)) {
        entry = {
            passed: false,
            score: 0,
            attempts: 0,
            last_text: "",
            ts: ""
        };
    }

    entry.attempts += 1;
    entry.last_text = _text;
    if (is_struct(_result)) {
        if (is_real(_result.score)) {
            entry.score = _result.score;
        }
        if (is_bool(_result.passed)) {
            if (_result.passed) {
                entry.passed = true;
            }
        }
    }
    entry.ts = date_time_string(date_current_datetime());

    _state.cards[$ _card_id] = entry;
    _state.attempt_count += 1;
}
