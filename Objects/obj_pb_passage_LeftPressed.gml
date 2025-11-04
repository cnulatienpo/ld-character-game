/// obj_pb_passage : Left Pressed Event
// Mark the selected line as pattern or break depending on the active mode.
if (is_undefined(global.pb_layout)) {
    exit;
}

var layout = global.pb_layout;
var box_width = layout.width + layout.margin * 2;
var box_height = visible_height;

if (!point_in_rectangle(mouse_x, mouse_y, x, y, x + box_width, y + box_height)) {
    exit;
}

var line = floor((mouse_y - y + layout.scroll) / layout.line_height);
if (line < 0 || line >= array_length(layout.lines)) {
    exit;
}

if (global.pb_mode == 0) {
    global.pb_pick_pattern = line;
} else {
    global.pb_pick_break = line;
}
