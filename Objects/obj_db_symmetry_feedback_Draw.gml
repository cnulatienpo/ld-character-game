/// obj_db_symmetry_feedback : Draw Event
if (string(global.db_symmetry_note) == "") {
    exit;
}

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(200, 480, global.db_symmetry_note);

if (is_struct(global.db_symmetry_diff)) {
    var diff = global.db_symmetry_diff;
    var details = "Left chars: " + string(diff.left) + " | Right chars: " + string(diff.right);
    draw_text(200, 520, details);
}
