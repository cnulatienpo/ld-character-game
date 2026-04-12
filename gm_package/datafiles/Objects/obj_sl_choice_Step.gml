/// obj_sl_choice : Step Event
// Tracks hover state for visual feedback.
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var width = 520;
var height = 100;
var rect_x = x;
var rect_y = y;
hover = (mx >= rect_x && mx <= rect_x + width && my >= rect_y && my <= rect_y + height);

if (global.sl_submitted && global.sl_selection == choice_id) {
    selected = true;
}
