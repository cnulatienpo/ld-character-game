/// oGame Step Event

if (!is_array(cards)) {
    cards = [];
}

if (phase == "show") {
    if (is_struct(current) && keyboard_check_pressed(vk_enter)) {
        phase = "typing";
        keyboard_string = text_buffer;
    }
} else if (phase == "typing") {
    text_buffer = keyboard_string;
    refresh_preview();

    if (keyboard_check(vk_control) && keyboard_check_pressed(vk_enter)) {
        if (is_struct(current)) {
            var submission_text = keyboard_string;
            var send_text = submission_text;
            while (string_length(send_text) > 0) {
                var last_char = string_char_at(send_text, string_length(send_text));
                if (last_char == "\n" || last_char == "\r") {
                    send_text = string_delete(send_text, string_length(send_text), 1);
                } else {
                    break;
                }
            }

            var gate_rules = current.gate_rules;
            var result = grade_submission(send_text, gate_rules);
            if (!is_struct(result)) {
                result = { passed: false, score: 0, notes: "", fails: [] };
            }

            var score_value = is_real(result.score) ? result.score : 0;
            var xp_gain = xp_award(state, score_value);
            state.xp += xp_gain;
            state.level = level_for_xp(state.xp);

            var new_badges = badge_check_all(state, current, result);
            if (!is_array(new_badges)) {
                new_badges = [];
            }
            progress_mark_card(state, current.id, result, submission_text);
            update_pass_count();
            progress_save(state);

            var summary = result.passed ? "Passed" : "Failed";
            var score_text = string_format(score_value, 0, 2);
            var message = summary + ": " + score_text + " — +" + string(xp_gain) + " XP";
            if (is_string(result.notes) && string_length(result.notes) > 0) {
                message += "\n" + result.notes;
            }
            if (array_length(new_badges) > 0) {
                message += "\nBadges: ";
                for (var b = 0; b < array_length(new_badges); ++b) {
                    if (b > 0) {
                        message += ", ";
                    }
                    message += new_badges[b];
                }
            }

            var toast = instance_create_depth(0, 0, -100000, oToast);
            toast.message = message;
            toast.is_success = result.passed;

            var total_cards = array_length(cards);
            if (total_cards > 0) {
                var next_index = (card_index + 1) mod total_cards;
                current = pick_next_card(next_index);
            } else {
                current = undefined;
                collection_complete = true;
            }

            if (is_undefined(current)) {
                collection_complete = true;
                phase = "show";
            } else {
                phase = "show";
            }

            text_buffer = "";
            keyboard_string = "";
            refresh_preview();
        }
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

refresh_preview();
