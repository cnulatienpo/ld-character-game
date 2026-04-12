/// obj_gt_ending_panel : Step Event
// Tracks hover state and allows clicking to choose an ending.
var x1 = x;
var y1 = y;
var x2 = x + panel_width;
var y2 = y + panel_height;

hover = point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y2);

if (hover && mouse_check_button_pressed(mb_left)) {
    global.gt_choice = side;
    global.gt_result = undefined;
}
