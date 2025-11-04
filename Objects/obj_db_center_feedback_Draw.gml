/// obj_db_center_feedback : Draw Event
if (string(global.db_center_feedback) == "") {
    exit;
}

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(160, 520, global.db_center_feedback);
