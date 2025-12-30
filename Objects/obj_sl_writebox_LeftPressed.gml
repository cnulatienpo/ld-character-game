/// obj_sl_writebox : Left Pressed Event
// Toggles focus for typing the custom line.
var w = 520;
var h = 80;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
if (mx >= x && mx <= x + w && my >= y && my <= y + h) {
    has_focus = true;
    keyboard_string = global.sl_custom_text;
} else {
    has_focus = false;
}
