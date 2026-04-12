/// obj_quiz_passage : Mouse Wheel Up Event
if (is_undefined(global.quiz_layout)) {
    return;
}

var layout = global.quiz_layout;
layout.scroll = max(0, layout.scroll - layout.line_height * 2);
global.quiz_layout = layout;
