/// obj_db_symmetry_submit : Draw Event
var w = 180;
var h = 48;
var bg = hover ? make_colour_rgb(120, 150, 150) : make_colour_rgb(90, 120, 130);
draw_set_colour(bg);
draw_rectangle(x, y, x + w, y + h, false);

draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + w * 0.5, y + h * 0.5, "Check fold");
