/// obj_kitch_button_taste : Left Pressed Event
// Evaluates the current mix.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var result = scr_kitchen_score();
    global.kit_feedback = result.note;
    global.kit_last_score = result.score;
    with (instance_find(obj_kitchen_controller, 0)) {
        note_alpha = 1;
    }
}
