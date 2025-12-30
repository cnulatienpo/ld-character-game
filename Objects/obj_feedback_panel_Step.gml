/// obj_feedback_panel : Step Event
// Poll for grader output and condense it to a single sentence.
if (global.grader_pending) {
    scr_showFeedback();
    message = "Give the grader a breath.";
    return;
}

var grader_text = is_undefined(global.grader_feedback) ? "" : string(global.grader_feedback);
if (string_length(grader_text) > 0) {
    message = grader_text;
    return;
}

var lesson_note = is_undefined(global.lesson_feedback) ? "" : string(global.lesson_feedback);
if (string_length(lesson_note) > 0) {
    message = lesson_note;
    return;
}

message = "Waiting for your move.";
