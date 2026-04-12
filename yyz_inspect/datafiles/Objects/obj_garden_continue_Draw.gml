/// obj_garden_continue : Draw Event
// Draws the continue button, dimmed until active.
var base_col = active ? make_colour_rgb(235, 245, 235) : make_colour_rgb(220, 220, 220);
if (hover) {
    base_col = merge_colour(base_col, c_white, 0.5);
}
draw_set_color(base_col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 28, y + 12, button_label);
