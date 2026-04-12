/// obj_reading_passage : Step Event
// Manages keyboard scrolling and click-drag selection for the reading passage.
if (is_undefined(global.reading_layout)) {
    return;
}

var layout = global.reading_layout;
var visible_h = room_height - 160;
var max_scroll = max(0, layout.height - visible_h);
var scroll_step = layout.line_height * 2;
var delta = 0;

if (keyboard_check(vk_up)) delta -= scroll_step * 0.5;
if (keyboard_check(vk_down)) delta += scroll_step * 0.5;

layout.scroll = clamp(layout.scroll + delta, 0, max_scroll);

var x0 = 48;
var y0 = 96;
var line_index = floor((mouse_y - y0 + layout.scroll) / layout.line_height);
line_index = clamp(line_index, 0, max(0, array_length(layout.lines) - 1));

if (mouse_check_button_pressed(mb_left)) {
    select_anchor = line_index;
    global.reading_preview_range = [select_anchor, select_anchor];
}

if (mouse_check_button(mb_left) && select_anchor >= 0) {
    global.reading_preview_range = [select_anchor, line_index];
}

if (mouse_check_button_released(mb_left) && select_anchor >= 0) {
    scr_highlight_ranges_add(global.reading_selected, select_anchor, line_index);
    select_anchor = -1;
    global.reading_preview_range = undefined;
}

global.reading_layout = layout;
