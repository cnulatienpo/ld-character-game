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

var unlock_debug = is_undefined(global.grader_unlocks_debug) ? "" : string(global.grader_unlocks_debug);
if (string_length(unlock_debug) > 0) {
	draw_set_color(make_colour_rgb(35, 90, 35));
	draw_text_ext(left + padding, bottom - 52, unlock_debug, 14, panel_width - padding * 2);
}
