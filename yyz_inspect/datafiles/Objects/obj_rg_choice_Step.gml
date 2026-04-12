/// obj_rg_choice : Step Event
// Tracks hover state and whether the choice has been applied.
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var w = 520;
var h = 90;
hover = (mx >= x && mx <= x + w && my >= y && my <= y + h);

used = false;
if (is_array(global.rg_applied_ids)) {
    for (var i = 0; i < array_length(global.rg_applied_ids); i++) {
        if (string(global.rg_applied_ids[i]) == choice_id) {
            used = true;
            break;
        }
    }
}
