/// obj_fc_feedback : Left Pressed Event
if (!is_undefined(global.fc_result)) {
    var btn_top = y + 80;
    var btn_bottom = btn_top + button_height;
    if (point_in_rectangle(mouse_x, mouse_y, x, btn_top, x + button_width, btn_bottom)) {
        room_goto_previous();
    }
}
