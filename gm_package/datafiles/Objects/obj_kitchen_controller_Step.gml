/// obj_kitchen_controller : Step Event
// Updates wrapped feedback text when notes change.
if (is_string(global.kit_feedback)) {
    if (!is_struct(feedback_wrap) || feedback_wrap.source_text != global.kit_feedback) {
        feedback_wrap = scr_quiz_text_wrap(global.kit_feedback, 360, 8);
        feedback_wrap.source_text = global.kit_feedback;
    }
}

// Pulse the feedback note a little when fresh.
if (note_alpha > 0.2) {
    note_alpha = max(0.2, note_alpha - 0.01);
}
