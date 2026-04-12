/// obj_chain_button_prev : Left Pressed Event
// Moves to the previous middle option.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var next_idx = max(0, global.cr_current_idx - 1);
    global.cr_current_idx = next_idx;
}
