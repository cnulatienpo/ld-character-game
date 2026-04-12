/// @function scr_soundlab_submit(choice_id)
/// @param choice_id The id string of the selected choice.
/// @description Compares the selected choice to the answer and returns feedback.
function scr_soundlab_submit(choice_id) {
    var round = global.sl_current;
    var answer = "";
    var note = "Feel the clipped beat lining up with the short strokes.";

    if (is_struct(round)) {
        answer = string(round.answer);
        if (is_string(round.design_note)) {
            note = round.design_note;
        }
    }

    var ok = (string(choice_id) == answer);

    global.sl_selection = choice_id;
    global.sl_feedback_note = note;
    global.sl_submitted = true;

    return { ok: ok, note: note };
}
