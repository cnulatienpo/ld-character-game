/// obj_sl_write_feedback : Draw Event
// Displays cadence feedback for the custom line.
if (string(global.sl_write_feedback) == "") {
    exit;
}

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);

draw_text(x, y, global.sl_write_feedback);
