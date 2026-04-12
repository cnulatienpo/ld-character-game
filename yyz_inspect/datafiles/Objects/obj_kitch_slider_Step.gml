/// obj_kitch_slider : Step Event
// Handles mouse interaction for the slider.
var rect_left = x;
var rect_right = x + slider_width;
var rect_top = y - 8;
var rect_bottom = y + 8;
hover = point_in_rectangle(mouse_x, mouse_y, rect_left, rect_top, rect_right, rect_bottom);

if (mouse_check_button(mb_left) && hover && string_length(label) > 0) {
    var t = clamp((mouse_x - rect_left) / slider_width, 0, 1);
    switch (label) {
        case "salt":
            global.kit_mix.salt = t;
            break;
        case "acid":
            global.kit_mix.acid = t;
            break;
        case "sugar":
            global.kit_mix.sugar = t;
            break;
        case "fat":
            global.kit_mix.fat = t;
            break;
    }
}

if (string_length(label) > 0) {
    value = variable_struct_get(global.kit_mix, label, value);
}
