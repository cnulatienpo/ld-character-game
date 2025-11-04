/// obj_sl_continue : Step Event
// Updates hover state when feedback is visible.
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var w = 160;
var h = 48;
hover = (mx >= x && mx <= x + w && my >= y && my <= y + h);
