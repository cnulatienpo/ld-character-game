/// obj_sl_writebox : Draw Event
// Draws the writing prompt and entry field.
var w = 520;
var h = 80;
var bg = has_focus ? make_colour_rgb(80, 90, 110) : make_colour_rgb(60, 70, 90);

draw_set_colour(bg);
draw_rectangle(x, y, x + w, y + h, false);

draw_set_colour(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text_ext(x, y - 60, global.sl_write_prompt, -1, w);
draw_text_ext(x + 12, y + 12, string(global.sl_custom_text), -1, w - 24);
