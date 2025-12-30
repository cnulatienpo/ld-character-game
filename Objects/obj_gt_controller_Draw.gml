/// obj_gt_controller : Draw Event
// Draws prompt text and feedback for the Gravity Test.
if (!is_struct(global.gt_item)) {
    exit;
}

draw_set_color(c_black);
draw_text_ext(64, 64, question_text, 28, 420);

draw_set_color(make_colour_rgb(245, 245, 245));
draw_rectangle(56, 120, 600, 520, false);

draw_set_color(c_black);
draw_text(64, 520, "Let the page lean toward the ending that lands cleanly.");

if (is_struct(global.gt_result)) {
    var note_text = string(global.gt_result.note);
    draw_text(64, 552, note_text);
}
