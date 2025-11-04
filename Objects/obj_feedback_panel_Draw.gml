/// obj_feedback_panel : Draw Event
var left = x;
var top = y;
var right = x + panel_width;
var bottom = y + panel_height;

var bg = make_colour_rgb(240, 245, 240);
draw_set_color(bg);
draw_rectangle(left, top, right, bottom, false);

draw_set_color(c_black);
draw_text_ext(left + padding, top + padding, message, 18, panel_width - padding * 2);
