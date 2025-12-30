/// obj_museum_continue : Step Event
// Enables the continue button after checking answers.
active = is_struct(global.museum_result);
hover = active && point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height);
