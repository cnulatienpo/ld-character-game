/// obj_orch_button_check : Draw Event
// Draws the check button.
var col = hover ? make_colour_rgb(220, 235, 250) : make_colour_rgb(235, 235, 235);
draw_set_color(col);
draw_rectangle(x, y, x + button_width, y + button_height, false);
draw_set_color(c_black);
draw_text(x + 18, y + 14, button_label);
