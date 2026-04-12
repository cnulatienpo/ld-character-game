/// obj_arch_button_check : Left Pressed Event
// Runs the balance check and triggers wobble.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    var result = scr_arch_check();
    global.arch_feedback_note = result.note;
    global.arch_last_result = result;
    if (result.stable) {
        global.arch_wobble_amp = 1.5;
        global.arch_wobble_timer = room_speed;
        global.arch_wobble_state = "settle";
    } else {
        global.arch_wobble_amp = 4;
        global.arch_wobble_timer = room_speed * 2;
        global.arch_wobble_state = "wobble";
    }
}
