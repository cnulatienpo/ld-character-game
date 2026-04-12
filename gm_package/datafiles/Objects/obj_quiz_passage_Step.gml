/// obj_quiz_passage : Step Event
// Handles keyboard scroll input for the quiz passage viewport.
if (is_undefined(global.quiz_layout)) {
    return;
}

var layout = global.quiz_layout;
var visible_h = room_height - 160;
var max_scroll = max(0, layout.height - visible_h);
var scroll_speed = layout.line_height * 2;

var delta = 0;
if (keyboard_check(vk_up)) {
    delta -= scroll_speed * 0.5;
}
if (keyboard_check(vk_down)) {
    delta += scroll_speed * 0.5;
}

layout.scroll = clamp(layout.scroll + delta, 0, max_scroll);
global.quiz_layout = layout;
