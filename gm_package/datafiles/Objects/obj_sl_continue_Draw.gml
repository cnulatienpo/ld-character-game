/// obj_sl_continue : Draw Event
// Draws the continue button once the round is complete.
if (!global.sl_submitted) {
    exit;
}

var w = 160;
var h = 48;
var bg = hover ? make_colour_rgb(90, 120, 100) : make_colour_rgb(70, 90, 80);

draw_set_colour(bg);
draw_rectangle(x, y, x + w, y + h, false);

draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + w * 0.5, y + h * 0.5, "Continue");
