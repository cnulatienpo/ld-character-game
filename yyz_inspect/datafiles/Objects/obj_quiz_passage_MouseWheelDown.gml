/// obj_quiz_passage : Mouse Wheel Down Event
if (is_undefined(global.quiz_layout)) {
    return;
}

var layout = global.quiz_layout;
var visible_h = room_height - 160;
var max_scroll = max(0, layout.height - visible_h);
layout.scroll = min(max_scroll, layout.scroll + layout.line_height * 2);
global.quiz_layout = layout;
