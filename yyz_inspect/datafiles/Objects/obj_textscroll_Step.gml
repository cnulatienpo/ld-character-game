/// obj_textscroll : Step Event
// Updates scroll offset based on keyboard and mouse input.
var text_body = is_undefined(global.lesson_text) ? "" : string(global.lesson_text);
var usable_width = panel_width - padding * 2;
var line_sep = 24;
var usable_height = panel_height - padding * 2;
var total_height = string_height_ext(text_body, line_sep, usable_width);
var max_scroll = max(0, total_height - usable_height);

if (keyboard_check(vk_up)) {
    scroll_offset -= scroll_speed;
}
if (keyboard_check(vk_down)) {
    scroll_offset += scroll_speed;
}
if (mouse_wheel_up()) {
    scroll_offset -= scroll_speed * 4;
}
if (mouse_wheel_down()) {
    scroll_offset += scroll_speed * 4;
}

scroll_offset = clamp(scroll_offset, 0, max_scroll);
