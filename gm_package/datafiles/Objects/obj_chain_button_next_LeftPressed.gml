/// obj_chain_button_next : Left Pressed Event
// Moves to the next middle option.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var option_count = array_length(global.cr_layout_options);
    if (option_count > 0) {
        var next_idx = min(option_count - 1, global.cr_current_idx + 1);
        global.cr_current_idx = next_idx;
    }
}
