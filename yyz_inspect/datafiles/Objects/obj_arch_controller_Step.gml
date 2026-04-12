/// obj_arch_controller : Step Event
// Manages wobble timing and wraps feedback text.
if (is_string(global.arch_feedback_note)) {
    if (!is_struct(feedback_wrap) || feedback_wrap.source_text != global.arch_feedback_note) {
        feedback_wrap = scr_quiz_text_wrap(global.arch_feedback_note, 360, 8);
        feedback_wrap.source_text = global.arch_feedback_note;
    }
}

if (global.arch_wobble_timer > 0) {
    global.arch_wobble_timer -= 1;
    global.arch_wobble_phase += 0.12;
    if (global.arch_wobble_timer <= 0) {
        global.arch_wobble_amp = 0;
        global.arch_wobble_state = "idle";
    }
} else {
    global.arch_wobble_phase += 0.04;
}
