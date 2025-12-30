/// obj_reading_passage : Mouse Wheel Up Event
if (is_undefined(global.reading_layout)) {
    return;
}

var layout = global.reading_layout;
layout.scroll = max(0, layout.scroll - layout.line_height * 2);
global.reading_layout = layout;
