/// oGame Step Event

if (!is_array(cards)) {
    cards = [];
}

if (phase == "show") {
    if (!net_waiting && is_struct(current) && keyboard_check_pressed(vk_enter)) {
        phase = "typing";
        keyboard_string = text_buffer;
    }
} else if (phase == "typing") {
    if (!net_waiting) {
        text_buffer = keyboard_string;
        if (keyboard_check(vk_control) && keyboard_check_pressed(vk_enter)) {
            submit_attempt();
        }
    } else {
        keyboard_string = text_buffer;
    }
} else {
    phase = "show";
}

if (phase != "typing") {
    keyboard_string = text_buffer;
}

if (!is_struct(current) && !collection_complete) {
    current = pick_next_card(card_index);
}

if (collection_complete && array_length(cards) > 0) {
    var unpassed_found = false;
    for (var i = 0; i < array_length(cards); ++i) {
        var candidate = cards[i];
        if (is_struct(candidate)) {
            if (!has_passed_card(candidate.id)) {
                unpassed_found = true;
                break;
            }
        }
    }
    collection_complete = !unpassed_found;
}

if (!net_waiting) {
    refresh_preview();
}

if (!telemetry_session_closed) {
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
        telemetry_session_end();
    }
}
