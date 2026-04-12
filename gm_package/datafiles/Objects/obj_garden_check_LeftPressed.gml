/// obj_garden_check : Left Pressed Event
// Scores the current arrangement and stores the feedback.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var result = scr_garden_score();
    global.garden_result = result;
}
