/// obj_reading_continue : Left Pressed Event
// Send the player to the next stage via the gate router.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    if (instance_exists(obj_gate)) {
        with (obj_gate) {
            scr_gate_next("reading");
        }
    }
}
