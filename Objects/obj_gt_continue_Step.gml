/// obj_gt_continue : Step Event
// Enables once the player has submitted a choice.
active = is_struct(global.gt_result);
hover = active && point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height);
