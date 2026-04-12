/// obj_db_balance_submit : Draw Event
var w = 180;
var h = 48;
var bg = hover ? make_colour_rgb(110, 150, 130) : make_colour_rgb(90, 120, 110);
draw_set_colour(bg);
draw_rectangle(x, y, x + w, y + h, false);

draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + w * 0.5, y + h * 0.5, "That feels right");
