/// obj_museum_check : Draw Event
// Draws the check button.
var base_col = hover ? make_colour_rgb(235, 230, 245) : make_colour_rgb(240, 240, 240);
draw_set_color(base_col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 36, y + 12, button_label);
