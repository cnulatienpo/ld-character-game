/// obj_garden_word : Draw Event
// Draws the draggable word tile with tier-based accent.
var word_width = string_width(label) + word_padding * 2;
var left = x - word_width * 0.5;
var top = y - word_height * 0.5;
var right = x + word_width * 0.5;
var bottom = y + word_height * 0.5;

var base_col = make_colour_rgb(250, 250, 250);
if (tier == "mid") base_col = make_colour_rgb(220, 235, 245);
if (tier == "tall") base_col = make_colour_rgb(205, 215, 245);
if (hover) {
    base_col = merge_colour(base_col, c_white, 0.6);
}
draw_set_color(base_col);
draw_rectangle(left, top, right, bottom, false);

draw_set_color(c_black);
draw_text(x - string_width(label) * 0.5, y - 12, label);
