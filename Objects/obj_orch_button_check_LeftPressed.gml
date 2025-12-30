/// obj_orch_button_check : Left Pressed Event
// Evaluates the current mix and updates feedback.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var result = scr_orch_score();
    global.orch_feedback_line = result.note;
}
