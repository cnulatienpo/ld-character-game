/// obj_sl_writebox : Step Event
// Tracks hover state and syncs the keyboard string when focused.
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var w = 520;
var h = 80;
hover = (mx >= x && mx <= x + w && my >= y && my <= y + h);

if (has_focus) {
    global.sl_custom_text = keyboard_string;
} else {
    keyboard_string = global.sl_custom_text;
}
