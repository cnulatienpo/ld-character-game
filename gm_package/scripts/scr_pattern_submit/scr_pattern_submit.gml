/// @function scr_pattern_submit(pattern_idx, break_idx)
/// @description Checks the player's selected pattern and break lines with tolerance.
/// @param pattern_idx The line index the player marked as the habit.
/// @param break_idx The line index the player marked as the break.
function scr_pattern_submit(pattern_idx, break_idx) {
    if (is_undefined(global.pb_item)) {
        return { pattern_ok: false, break_ok: false, explain: "" };
    }

    var target_pattern = global.pb_item.pattern_line_idx;
    var target_break = global.pb_item.break_line_idx;

    var pattern_ok = (abs(pattern_idx - target_pattern) <= 1);
    var break_ok = (abs(break_idx - target_break) <= 1);

    var note = global.pb_item.design_note;
    var result = { pattern_ok: pattern_ok, break_ok: break_ok, explain: note };
    global.pb_result = result;

    return result;
}
