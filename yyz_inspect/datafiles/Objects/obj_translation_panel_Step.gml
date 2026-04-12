/// obj_translation_panel : Step Event
// Detects clicks on the header to toggle visibility.
var left = x;
var top = y;
var right = x + panel_width;
var bottom = y + header_height;

hover = point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom);

if (hover && mouse_check_button_pressed(mb_left)) {
    is_open = !is_open;
}
