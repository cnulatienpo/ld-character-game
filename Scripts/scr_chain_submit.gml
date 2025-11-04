/// @function scr_chain_submit(idx)
/// @description Checks the selected middle beat against the answer index.
/// @param idx Index of the chosen option.
function scr_chain_submit(idx) {
    if (!is_struct(global.cr_item)) {
        return { ok: false, note: "Pick the beat that keeps momentum." };
    }

    var answer = real(variable_struct_get(global.cr_item, "answer_idx", -1));
    var note = string(variable_struct_get(global.cr_item, "design_note", "This keeps momentum; the other picks stall."));
    var success = (idx == answer);

    global.cr_feedback_line = note;
    global.cr_last_correct = success;

    return { ok: success, note: note };
}
