/// obj_kitch_button_taste : Draw Event
// Draws the taste button.
var col = hover ? make_colour_rgb(220, 240, 250) : make_colour_rgb(235, 235, 235);
draw_set_color(col);
draw_rectangle(x, y, x + button_width, y + button_height, false);
draw_set_color(c_black);
draw_text(x + 16, y + 12, button_label);
