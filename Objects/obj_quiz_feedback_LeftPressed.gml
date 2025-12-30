/// obj_quiz_feedback : Global Left Pressed Event
// Handles clicks on the continue button.
if (is_undefined(global.quiz_feedback)) {
    return;
}

var bx1 = button_rect[0];
var by1 = button_rect[1];
var bx2 = button_rect[2];
var by2 = button_rect[3];

if (point_in_rectangle(mouse_x, mouse_y, bx1, by1, bx2, by2)) {
    if (!scr_quiz_next()) {
        // No more quiz items remain. In a full integration this could return to the lesson hub.
        show_debug_message("Quiz queue empty.");
    }
    global.quiz_feedback = undefined;
}
