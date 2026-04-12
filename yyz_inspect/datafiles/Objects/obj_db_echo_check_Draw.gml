/// obj_db_echo_check : Draw Event
var w = 180;
var h = 48;
var bg = hover ? make_colour_rgb(120, 120, 90) : make_colour_rgb(100, 100, 80);
draw_set_colour(bg);
draw_rectangle(x, y, x + w, y + h, false);

draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + w * 0.5, y + h * 0.5, "Check");
