/// obj_chain_button_submit : Left Pressed Event
// Checks the current option selection.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var option_count = array_length(global.cr_layout_options);
    if (option_count <= 0) {
        global.cr_feedback_line = "Load options before picking a middle.";
        return;
    }
    var idx = clamp(global.cr_current_idx, 0, option_count - 1);
    var result = scr_chain_submit(idx);
    global.cr_feedback_line = result.note;
}
