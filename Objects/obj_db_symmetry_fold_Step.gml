/// obj_db_symmetry_fold : Step Event
// Updates fold position when dragging.
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var x0 = global.db_symmetry_origin_x;
var x1 = x0 + global.db_symmetry_layout.width;

if (dragging) {
    global.db_symmetry_fold_x = clamp(mx, x0, x1);
    if (!mouse_check_button(mb_left)) {
        dragging = false;
    }
} else if (mouse_check_button_pressed(mb_left)) {
    var dist = abs(mx - global.db_symmetry_fold_x);
    if (dist <= 16 && my >= global.db_symmetry_origin_y && my <= global.db_symmetry_origin_y + global.db_symmetry_visible_h) {
        dragging = true;
    }
}
