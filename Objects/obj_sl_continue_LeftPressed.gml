/// obj_sl_continue : Left Pressed Event
// Returns to the gate room when available.
if (!global.sl_submitted) {
    exit;
}

var dest = noone;
if (variable_global_exists("gate_room")) {
    dest = global.gate_room;
} else if (variable_global_exists("room_gate")) {
    dest = global.room_gate;
}

if (is_real(dest)) {
    room_goto(dest);
} else {
    show_debug_message("obj_sl_continue: gate room not set");
}
