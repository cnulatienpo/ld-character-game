/// obj_arch_button_continue : Left Pressed Event
// Returns to the gate when possible.
if (point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    if (variable_global_exists("gate_room") && global.gate_room != undefined) {
        room_goto(global.gate_room);
    } else if (function_exists("scr_gateNext")) {
        var next_room = scr_gateNext(global.current_mode);
        if (next_room != -1) {
            room_goto(next_room);
        }
    } else {
        show_debug_message("Architecture Studio continue pressed; gate room not set.");
    }
}
