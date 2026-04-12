var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (mx > 20 && mx < 260 && my > 120 && my < 170) {
        room_goto(room_next_screen);
    }
}
