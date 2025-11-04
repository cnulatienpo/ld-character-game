/// obj_db_balance_feedback : Draw Event
if (string(global.db_balance_note) == "") {
    exit;
}

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(200, 520, global.db_balance_note);
