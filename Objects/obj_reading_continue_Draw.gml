/// obj_reading_continue : Draw Event
// Draws the continue button below the reading overlay.
var hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height);
var btn_col = hover ? make_colour_rgb(220, 240, 220) : make_colour_rgb(230, 230, 230);
draw_set_color(btn_col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 16, y + 10, "continue");
