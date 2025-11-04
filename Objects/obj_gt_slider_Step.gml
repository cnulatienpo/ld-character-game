/// obj_gt_slider : Step Event
// Handles mouse interaction for the tilt slider.
var rect_left = x;
var rect_right = x + slider_width;
var rect_top = y - 8;
var rect_bottom = y + 8;

hover = point_in_rectangle(mouse_x, mouse_y, rect_left, rect_top, rect_right, rect_bottom);

if (mouse_check_button(mb_left) && hover) {
    var t = clamp((mouse_x - rect_left) / slider_width, 0, 1);
    value = t;
    global.gt_choice = (t < 0.5) ? "left" : "right";
    global.gt_result = undefined;
}

var target_value = (string(global.gt_choice) == "right") ? 0.75 : 0.25;
if (!mouse_check_button(mb_left)) {
    value = lerp(value, target_value, 0.2);
}
