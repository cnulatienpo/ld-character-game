/// obj_feedback_panel : Step Event
// Debug hotkey: run native grader self-test and surface result in the panel.
if (keyboard_check_pressed(vk_f9)) {
    if (function_exists("scr_character_grader_native_selftest")) {
        var _selftest = scr_character_grader_native_selftest();
        var _summary = "Self-test failed to run.";
        if (is_struct(_selftest)) {
            _summary = "Native grader self-test: " + string(_selftest.passed) + "/" + string(_selftest.total) + " passed";
            if (_selftest.ok) {
                _summary += " (OK)";
            } else {
                _summary += " (CHECK LOG)";
            }
        }

        global.grader_feedback = _summary;
        global.grader_feedback_compact = _summary;
        global.lesson_feedback = _summary;
        global.grader_pending = false;
    } else {
        global.grader_feedback = "Native self-test script not found.";
        global.grader_feedback_compact = global.grader_feedback;
        global.lesson_feedback = global.grader_feedback;
    }
}

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
