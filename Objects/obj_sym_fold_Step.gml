/// obj_sym_fold : Step Event
// Handles dragging of the fold line and scoring on release.
var panel_left = global.sym_panel_left;
var panel_width = global.sym_panel_width;
var panel_right = panel_left + panel_width;

if (mouse_check_button(mb_left) && abs(mouse_x - x) < 10) {
    dragging = true;
}

if (dragging) {
    x = clamp(mouse_x, panel_left + 32, panel_right - 32);
    global.sym_fold_x = x;
}

if (dragging && mouse_check_button_released(mb_left)) {
    dragging = false;
    var res = scr_sym_score(x);
    global.sym_feedback = res.note;
}
