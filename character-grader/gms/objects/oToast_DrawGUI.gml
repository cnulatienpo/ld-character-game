/// oToast Draw GUI Event

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
if (gui_w <= 0) gui_w = room_width;
if (gui_h <= 0) gui_h = room_height;

var alpha = 1;
if (lifetime < fade_out) {
    alpha = max(0, lifetime / max(1, fade_out));
}

draw_set_alpha(alpha * 0.85);
var width = clamp(gui_w * 0.6, 320, gui_w - 40);
var x1 = (gui_w - width) * 0.5;
var y1 = 40;
var x2 = x1 + width;
var y2 = y1 + 96;
var bg_color = is_success ? make_color_rgb(40, 80, 40) : make_color_rgb(80, 40, 40);
draw_rectangle_color(x1, y1, x2, y2, bg_color, bg_color, bg_color, bg_color, false);

draw_set_alpha(alpha);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text((x1 + x2) * 0.5, (y1 + y2) * 0.5, message);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
