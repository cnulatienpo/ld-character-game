/// obj_translation_panel : Draw Event
// Draws the translation header and body when expanded.
var left = x;
var top = y;
var right = x + panel_width;
var header_bottom = y + header_height;

var bg_header = hover ? make_colour_rgb(220, 230, 240) : make_colour_rgb(235, 235, 235);
draw_set_color(bg_header);
draw_rectangle(left, top, right, header_bottom, false);

draw_set_color(c_black);
var header_text = is_open ? "Hide translation" : "Show translation";
draw_text(left + padding, top + 12, header_text);

if (!is_open) {
    return;
}

var body_bottom = y + panel_height;
var bg_body = make_colour_rgb(250, 249, 245);
draw_set_color(bg_body);
draw_rectangle(left, header_bottom, right, body_bottom, false);

draw_set_color(c_black);
draw_text(left + padding, header_bottom + padding - 20, "Plain actions.");

var translation_text = is_undefined(global.design_translation) ? "No translation yet." : string(global.design_translation);
draw_set_clip(left + padding, header_bottom + padding, right - padding, body_bottom - padding);
draw_text_ext(left + padding, header_bottom + padding, translation_text, 20, panel_width - padding * 2);
draw_set_clip(0, 0, room_width, room_height);
