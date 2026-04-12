/// obj_db_balance_slider : Step Event
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var track_range = track_x2 - track_x1;

if (dragging) {
    var t = clamp((mx - track_x1) / track_range, 0, 1);
    global.db_balance_value = t;
    if (!mouse_check_button(mb_left)) {
        dragging = false;
    }
} else if (!mouse_check_button(mb_left)) {
    // no-op
} else {
    var knob_x = lerp(track_x1, track_x2, clamp(global.db_balance_value, 0, 1));
    var knob_y = track_y;
    if (point_distance(mx, my, knob_x, knob_y) <= 16) {
        dragging = true;
    }
}

x = lerp(track_x1, track_x2, clamp(global.db_balance_value, 0, 1));
y = track_y;
