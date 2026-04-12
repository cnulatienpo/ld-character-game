// find the typing box
var box = instance_find(obj_the_box_you_type_in, 0);

if (box != noone) {

    // button bounds (GUI space)
    if (device_mouse_x_to_gui(0) > 20 &&
        device_mouse_x_to_gui(0) < 200 &&
        device_mouse_y_to_gui(0) > 320 &&
        device_mouse_y_to_gui(0) < 360) {

        global.submitted_text = box.typed_text;
        room_goto(room_submit_result);
    }
}

