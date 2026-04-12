/// obj_rg_choice : Draw Event
// Renders the palette choice button.
var w = 520;
var h = 90;
var bg = make_colour_rgb(70, 70, 90);
if (hover) {
    bg = make_colour_rgb(90, 90, 110);
}
if (used) {
    bg = make_colour_rgb(100, 130, 100);
}

draw_set_colour(bg);
draw_rectangle(x, y, x + w, y + h, false);

draw_set_colour(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text_ext(x + 12, y + 12, choice_text, -1, w - 24);
