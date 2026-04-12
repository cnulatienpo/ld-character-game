/// obj_reading_submit : Left Pressed Event
// Evaluates the player's highlighted ranges.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    global.reading_feedback = scr_readingroom_submit(global.reading_selected);
}
