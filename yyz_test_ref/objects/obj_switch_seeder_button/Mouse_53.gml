if (device_mouse_x_to_gui(0) > 400 &&
    device_mouse_x_to_gui(0) < 650 &&
    device_mouse_y_to_gui(0) > 420 &&
    device_mouse_y_to_gui(0) < 470) {

    if (global.active_seeder == global.seeder_demo) {
        global.active_seeder = global.seeder_demo_2;
    } else {
        global.active_seeder = global.seeder_demo;
    }
}
