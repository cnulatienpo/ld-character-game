/// obj_behavior_hide : Draw Event
var selected = (global.behavior_choice == target_mode);
var base_col = selected ? make_colour_rgb(210, 240, 210) : make_colour_rgb(230, 230, 230);
if (hover) {
    base_col = make_colour_rgb(220, 240, 220);
}
draw_set_color(base_col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 16, y + 12, label);
