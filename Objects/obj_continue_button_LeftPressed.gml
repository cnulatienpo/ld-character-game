/// obj_continue_button : Left Pressed Event
if (hover) {
    if (instance_exists(obj_gate)) {
        with (obj_gate) {
            scr_gate_next(other.next_stage);
        }
    }
}
