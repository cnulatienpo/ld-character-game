/// obj_garden_continue : Step Event
// Enables the button once a result exists and updates hover state.
active = is_struct(global.garden_result);
hover = active && point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height);
