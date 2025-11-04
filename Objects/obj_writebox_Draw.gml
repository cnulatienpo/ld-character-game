/// obj_writebox : Draw Event
// Renders the writing surface with a blinking caret.
var left = x;
var top = y;
var right = x + box_width;
var bottom = y + box_height;

var bg = make_colour_rgb(250, 250, 250);
draw_set_color(bg);
draw_rectangle(left, top, right, bottom, false);

var prompt = is_undefined(global.lesson_prompt) ? "Write what you notice." : string(global.lesson_prompt);
draw_set_color(c_black);
draw_text_ext(left, top - 52, prompt, 18, box_width);
draw_text(left, top - 28, "Write here.");

draw_set_color(c_black);
draw_text_ext(left + padding, top + padding, buffer_string, 18, box_width - padding * 2);

if (caret_timer < caret_interval / 2) {
    var caret_x = left + padding + string_width_ext(buffer_string, 18, box_width - padding * 2);
    var caret_y = top + padding + string_height_ext(buffer_string, 18, box_width - padding * 2);
    draw_rectangle(caret_x, caret_y - 18, caret_x + 2, caret_y + 4, false);
}
