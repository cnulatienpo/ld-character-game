/// obj_strength_med : Draw Event
var selected = (global.strength_choice == target_strength);
var base_col = selected ? make_colour_rgb(245, 225, 200) : make_colour_rgb(235, 230, 220);
if (hover) {
    base_col = make_colour_rgb(245, 235, 210);
}
draw_set_color(base_col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 16, y + 12, label);
