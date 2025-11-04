/// obj_mm_feedback : Draw Event
// Displays feedback note after submission.
if (is_undefined(global.mm_result)) {
    exit;
}

draw_set_color(c_black);
draw_text(x, y, "Why it lands: " + string(global.mm_result.explain));
