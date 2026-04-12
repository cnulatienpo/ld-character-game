/// obj_continue_button : Draw Event
var base_col = hover ? make_colour_rgb(220, 240, 220) : make_colour_rgb(230, 230, 230);
draw_set_color(base_col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 20, y + 14, label);
