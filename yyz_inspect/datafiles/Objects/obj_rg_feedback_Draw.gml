/// obj_rg_feedback : Draw Event
if (string(global.rg_note) == "") {
    exit;
}

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(140, 480, global.rg_note);
