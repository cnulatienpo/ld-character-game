/// obj_garden_check : Draw Event
// Draws the check button.
var col = hover ? make_colour_rgb(235, 225, 240) : make_colour_rgb(240, 240, 240);
draw_set_color(col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 28, y + 12, button_label);
