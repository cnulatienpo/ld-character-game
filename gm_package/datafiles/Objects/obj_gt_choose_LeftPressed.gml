/// obj_gt_choose : Left Pressed Event
// Submits the player's choice and records feedback.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var result = scr_gravity_submit(global.gt_choice);
    global.gt_result = result;
}
