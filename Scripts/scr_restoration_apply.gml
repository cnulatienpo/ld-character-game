/// @function scr_restoration_apply(choice_id)
/// @description Applies a chosen detail to the current restoration passage.
function scr_restoration_apply(choice_id) {
    var round = global.rg_round;
    if (!is_struct(round)) {
        return { ok: false, note: "Round not ready." };
    }

    var palette = round.palette;
    if (!is_array(palette)) {
        return { ok: false, note: "Palette missing." };
    }

    var target_choice = undefined;
    for (var i = 0; i < array_length(palette); i++) {
        var entry = palette[i];
        if (string(entry.id) == string(choice_id)) {
            target_choice = entry;
            break;
        }
    }

    if (is_undefined(target_choice)) {
        return { ok: false, note: "Choice not found." };
    }

    if (!is_array(global.rg_applied_ids)) {
        global.rg_applied_ids = [];
    }
    if (!is_array(global.rg_applied_tags)) {
        global.rg_applied_tags = [];
    }

    // Prevent duplicate application.
    for (var j = 0; j < array_length(global.rg_applied_ids); j++) {
        if (string(global.rg_applied_ids[j]) == string(choice_id)) {
            return { ok: false, note: "That detail is already in place." };
        }
    }

    global.rg_current_text = string(global.rg_current_text) + "\n\n" + string(target_choice.text);
    array_push(global.rg_applied_ids, target_choice.id);

    if (is_array(target_choice.tags)) {
        for (var t = 0; t < array_length(target_choice.tags); t++) {
            array_push(global.rg_applied_tags, string(target_choice.tags[t]));
        }
    }

    global.rg_layout = scr_longtext_layout_create(global.rg_current_text, 520, 24);
    global.rg_layout.scroll = 0;
    global.rg_feedback_note = "Detail added; feel how the room shifts.";

    return { ok: true, note: global.rg_feedback_note };
}
