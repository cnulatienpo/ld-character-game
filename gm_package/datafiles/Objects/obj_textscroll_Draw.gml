/// obj_textscroll : Draw Event
// Renders the lesson text in a generous scrolling panel.
var text_body = is_undefined(global.lesson_text) ? "" : string(global.lesson_text);
var usable_width = panel_width - padding * 2;
var x0 = x;
var y0 = y;
var line_sep = 24;

// Panel background
var bg = make_colour_rgb(245, 244, 240);
draw_set_color(bg);
draw_rectangle(x0, y0, x0 + panel_width, y0 + panel_height, false);

draw_set_color(c_black);
draw_text(x0 + padding, y0 - 28, "Read this.");

draw_set_clip(x0 + padding, y0 + padding, x0 + panel_width - padding, y0 + panel_height - padding);
draw_text_ext(x0 + padding, y0 + padding - scroll_offset, text_body, line_sep, usable_width);
draw_set_clip(0, 0, room_width, room_height);
