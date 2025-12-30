/// obj_fc_feedback : Step Event
if (is_undefined(global.fc_result)) {
    hover = false;
    exit;
}

hover = point_in_rectangle(mouse_x, mouse_y, x, y + 80, x + button_width, y + 80 + button_height);
