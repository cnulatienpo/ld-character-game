/// obj_reading_submit : Draw Event
// Draws the submit button and, when applicable, the feedback overlay.
var hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height);
var btn_col = hover ? make_colour_rgb(210, 230, 250) : make_colour_rgb(230, 230, 230);
draw_set_color(btn_col);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 16, y + 10, "check highlight");

if (!is_undefined(global.reading_feedback)) {
    var panel_w = 560;
    var panel_h = 160;
    var px = (room_width - panel_w) * 0.5;
    var py = room_height - panel_h - 48;
    draw_set_color(make_colour_rgb(250, 246, 236));
    draw_rectangle(px, py, px + panel_w, py + panel_h, false);

    draw_set_color(c_black);
    var info = global.reading_feedback;
    var ratio_text = "match: " + string_format(info.match_ratio, 0, 2);
    draw_text(px + 24, py + 24, ratio_text);
    draw_text_ext(px + 24, py + 64, string(info.explain), 18, panel_w - 48);
}
