/// obj_db_echo_passage : Left Pressed Event
// Records a tap on a line to mark an echo.
var layout = global.db_echo_layout;
if (!is_struct(layout)) {
    exit;
}

var panel_width = layout.width + layout.margin * 2;
if (!point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x0, y0, x0 + panel_width, y0 + visible_h)) {
    exit;
}

var line_height = layout.line_height;
var my = device_mouse_y_to_gui(0);
var line_index = floor((my - y0 + layout.scroll) / line_height);
if (line_index < 0 || line_index >= array_length(layout.lines)) {
    exit;
}

if (!ds_exists(global.db_echo_hits, ds_type_list)) {
    global.db_echo_hits = ds_list_create();
}

var found = false;
for (var i = 0; i < ds_list_size(global.db_echo_hits); i++) {
    if (global.db_echo_hits[| i] == line_index) {
        ds_list_delete(global.db_echo_hits, i);
        found = true;
        break;
    }
}

if (!found) {
    ds_list_add(global.db_echo_hits, line_index);
}
