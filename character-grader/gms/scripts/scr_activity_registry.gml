/// Activity registry for routing between UI modes.

function activity_registry() {
    if (!variable_global_exists("__activity_registry") || !is_struct(global.__activity_registry)) {
        global.__activity_registry = {
            mode: "writing",
            cards: [],
            card_index: 0,
            current_card: undefined,
            pending_next: false,
            last_result: undefined
        };
    }
    return global.__activity_registry;
}

function activity_set_cards(_cards) {
    var reg = activity_registry();
    if (is_array(_cards)) {
        reg.cards = _cards;
    } else {
        reg.cards = [];
    }
    reg.card_index = 0;
}

function activity_get_cards() {
    return activity_registry().cards;
}

function activity_mode_get() {
    var reg = activity_registry();
    if (!is_string(reg.mode) || string_length(reg.mode) <= 0) {
        reg.mode = "writing";
    }
    return reg.mode;
}

function set_mode(_m) {
    var reg = activity_registry();
    if (is_string(_m) && string_length(_m) > 0) {
        reg.mode = _m;
    }
    return reg.mode;
}

function act_bind_card(_card) {
    var reg = activity_registry();
    reg.current_card = _card;
    if (is_struct(_card)) {
        var mode = undefined;
        if (variable_struct_exists(_card, "activity_mode")) {
            mode = _card.activity_mode;
        } else if (variable_struct_exists(_card, "mode")) {
            mode = _card.mode;
        }
        if (is_string(mode) && string_length(mode) > 0) {
            set_mode(mode);
        } else {
            set_mode("writing");
        }
        if (variable_struct_exists(_card, "id")) {
            reg.last_card_id = _card.id;
            var cards = reg.cards;
            if (is_array(cards)) {
                for (var i = 0; i < array_length(cards); ++i) {
                    var c = cards[i];
                    if (c == _card) {
                        reg.card_index = i;
                        break;
                    }
                    if (is_struct(c) && variable_struct_exists(c, "id") && c.id == _card.id) {
                        reg.card_index = i;
                        break;
                    }
                }
            }
        }
    } else {
        reg.current_card = undefined;
        set_mode("writing");
    }
    return reg.current_card;
}

function act_current_card() {
    return activity_registry().current_card;
}

function activity_record_result(_result) {
    activity_registry().last_result = _result;
}

function activity_last_result() {
    return activity_registry().last_result;
}

function act_next_card(_on_ok, _on_err) {
    var reg = activity_registry();
    if (reg.pending_next) {
        return;
    }

    var ok_cb = _on_ok;
    var err_cb = _on_err;

    var function emit_ok(_payload) {
        reg.pending_next = false;
        if (is_method(ok_cb) || is_function(ok_cb)) {
            ok_cb(_payload);
        }
    };

    var function emit_err(_message) {
        reg.pending_next = false;
        if (is_method(err_cb) || is_function(err_cb)) {
            err_cb(_message);
        }
    };

    var function accept_card(_card_struct, _payload) {
        if (is_struct(_card_struct)) {
            act_bind_card(_card_struct);
            emit_ok(_payload);
            return true;
        }
        return false;
    };

    if (function_exists("api_get_next") && variable_global_exists("user_id")) {
        reg.pending_next = true;
        var function handle_ok(_data) {
            var next_card = undefined;
            if (is_struct(_data)) {
                if (variable_struct_exists(_data, "card") && is_struct(_data.card)) {
                    next_card = _data.card;
                } else if (variable_struct_exists(_data, "next") && is_struct(_data.next)) {
                    next_card = _data.next;
                }
            }
            if (!accept_card(next_card, _data)) {
                var cards_local = reg.cards;
                if (is_array(cards_local) && array_length(cards_local) > 0) {
                    reg.card_index = (reg.card_index + 1) mod array_length(cards_local);
                    var fallback_card = cards_local[reg.card_index];
                    accept_card(fallback_card, fallback_card);
                } else {
                    emit_err("No next card available");
                }
            }
        };
        var function handle_err(_msg) {
            emit_err(_msg);
        };
        api_get_next(global.user_id, handle_ok, handle_err);
        return;
    }

    var cards = reg.cards;
    if (is_array(cards) && array_length(cards) > 0) {
        reg.card_index = (reg.card_index + 1) mod array_length(cards);
        var card = cards[reg.card_index];
        if (accept_card(card, card)) {
            return;
        }
    }
    emit_err("No additional cards");
}
