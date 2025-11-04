/// obj_pb_toggle : Left Pressed Event
// Switch between marking the habit and the break.
var left1 = x;
var top1 = y;
var right1 = left1 + button_width;
var bottom1 = top1 + button_height;
var left2 = right1 + spacing;
var right2 = left2 + button_width;

if (point_in_rectangle(mouse_x, mouse_y, left1, top1, right1, bottom1)) {
    global.pb_mode = 0;
} else if (point_in_rectangle(mouse_x, mouse_y, left2, top1, right2, bottom1)) {
    global.pb_mode = 1;
}
