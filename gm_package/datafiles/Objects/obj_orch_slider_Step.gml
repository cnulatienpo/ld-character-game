/// obj_orch_slider : Step Event
// Handles dragging interaction for the vertical fader.
var rect_left = x - 8;
var rect_right = x + 8;
var rect_top = y;
var rect_bottom = y + range_height;

hover = point_in_rectangle(mouse_x, mouse_y, rect_left, rect_top, rect_right, rect_bottom);

if (mouse_check_button(mb_left) && hover) {
    var t = clamp((mouse_y - rect_top) / range_height, 0, 1);
    var val = 1 - t;
    if (string_length(label) > 0) {
        switch (label) {
            case "emotion":
                global.orch_mix.emotion = val;
                break;
            case "stakes":
                global.orch_mix.stakes = val;
                break;
            case "pacing":
                global.orch_mix.pacing = val;
                break;
        }
    }
}

if (string_length(label) > 0) {
    value = variable_struct_get(global.orch_mix, label, value);
}
