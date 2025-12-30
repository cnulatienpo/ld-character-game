/// obj_mm_left_token : Draw Event
// Draws the draggable label token.
var token_w = 144;
var token_h = 40;
var left = x - token_w * 0.5;
var top = y - token_h * 0.5;
var right = left + token_w;
var bottom = top + token_h;

var base_colour = make_colour_rgb(235, 235, 235);
if (drag) {
    base_colour = make_colour_rgb(220, 235, 245);
}

draw_set_color(base_colour);
draw_rectangle(left, top, right, bottom, false);

draw_set_color(c_black);
draw_text(left + 8, top + 10, token_label);
