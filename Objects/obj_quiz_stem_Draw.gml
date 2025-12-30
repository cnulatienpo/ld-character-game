/// obj_quiz_stem : Draw Event
// Displays the current question stem plainly above the passage.
if (is_undefined(global.quiz_current)) {
    return;
}

draw_set_color(c_black);
var stem = is_struct(global.quiz_current) ? global.quiz_current.stem : ds_map_find_value(global.quiz_current, "stem");
draw_text(48, 32, string(stem));
