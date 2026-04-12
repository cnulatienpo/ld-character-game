/// @function scr_garden_score()
/// @description Compares player tiers against the target arrangement and returns a simple report.
function scr_garden_score() {
    var note_text = global.garden_feedback_note;
    if (!is_string(note_text) || string_length(note_text) == 0) {
        note_text = "Leader is clear; support is visible; background is quiet.";
    }

    if (!is_struct(global.garden_round) || !ds_exists(global.garden_words, ds_type_list)) {
        return { score: 0, note: note_text };
    }

    var target = global.garden_round.target;
    if (!is_struct(target)) {
        return { score: 0, note: note_text };
    }

    var total = ds_list_size(global.garden_words);
    if (total <= 0) {
        return { score: 0, note: note_text };
    }

    var correct = 0;
    for (var i = 0; i < total; i++) {
        var word_struct = ds_list_find_value(global.garden_words, i);
        if (!is_struct(word_struct)) {
            continue;
        }

        var tier = word_struct.tier;
        var label = word_struct.label;
        if (!is_string(tier) || !is_string(label)) {
            continue;
        }

        var goal_array;
        switch (tier) {
            case "tall":
                goal_array = target.tall;
                break;
            case "mid":
                goal_array = target.mid;
                break;
            default:
                goal_array = target.low;
                break;
        }

        if (!is_array(goal_array)) {
            continue;
        }

        for (var j = 0; j < array_length(goal_array); j++) {
            if (string(goal_array[j]) == label) {
                correct += 1;
                break;
            }
        }
    }

    var score_value = correct / total;
    return { score: score_value, note: note_text };
}
