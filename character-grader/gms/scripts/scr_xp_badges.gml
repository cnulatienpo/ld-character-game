/// XP and badge helpers for the Character Game MVP.

function xp_award(_state, _score) {
    var amount = round(10 * max(0, _score));
    return amount;
}

function level_for_xp(_xp) {
    return floor(max(0, _xp) / 100) + 1;
}

function badge_check_all(_state, _card, _result) {
    if (!is_struct(_state)) {
        return [];
    }

    if (!is_array(_state.badges)) {
        _state.badges = [];
    }

    if (!is_real(_state.streak)) {
        _state.streak = 0;
    }

    var newly = [];

    var function has_badge(_badge_id) {
        for (var i = 0; i < array_length(_state.badges); ++i) {
            if (_state.badges[i] == _badge_id) {
                return true;
            }
        }
        return false;
    };

    var function push_badge(_badge_id) {
        if (!has_badge(_badge_id)) {
            array_push(_state.badges, _badge_id);
            array_push(newly, _badge_id);
        }
    };

    var passed = is_struct(_result) && is_bool(_result.passed) ? _result.passed : false;

    if (passed) {
        _state.streak += 1;
    } else {
        _state.streak = 0;
    }

    if (passed && !has_badge("FIRST_WRITE")) {
        var has_previous_pass = false;
        if (is_struct(_state.cards)) {
            var keys = variable_struct_get_names(_state.cards);
            if (is_array(keys)) {
                for (var k = 0; k < array_length(keys); ++k) {
                    var key = keys[k];
                    var entry = _state.cards[$ key];
                    if (is_struct(entry) && entry.passed) {
                        has_previous_pass = true;
                        break;
                    }
                }
            }
        }
        if (!has_previous_pass) {
            push_badge("FIRST_WRITE");
        }
    }

    if (passed && _state.streak >= 3) {
        push_badge("CONSISTENT_3");
    }

    if (passed) {
        var gate_rules = is_struct(_card) ? _card.gate_rules : undefined;
        var has_detail_token = false;
        if (is_struct(gate_rules)) {
            if (variable_struct_exists(gate_rules, "must_include_any")) {
                var include_any = gate_rules.must_include_any;
                if (is_array(include_any)) {
                    for (var j = 0; j < array_length(include_any); ++j) {
                        var token = include_any[j];
                        if (is_string(token) && string_lower(token) == "detail") {
                            has_detail_token = true;
                            break;
                        }
                    }
                }
            }
            if (!has_detail_token && variable_struct_exists(gate_rules, "must_include_all")) {
                var include_all = gate_rules.must_include_all;
                if (is_array(include_all)) {
                    for (var jj = 0; jj < array_length(include_all); ++jj) {
                        var t2 = include_all[jj];
                        if (is_string(t2) && string_lower(t2) == "detail") {
                            has_detail_token = true;
                            break;
                        }
                    }
                }
            }
        }
        if (has_detail_token) {
            push_badge("DETAIL_DEVIL");
        }
    }

    var future_attempts = is_real(_state.attempt_count) ? _state.attempt_count + 1 : 1;
    if (future_attempts >= 5) {
        push_badge("MARATHON_5");
    }

    return newly;
}
