/// obj_pb_toggle : Draw Event
// Renders the toggle buttons for selecting which line to mark.
var left1 = x;
var top1 = y;
var right1 = left1 + button_width;
var bottom1 = top1 + button_height;
var left2 = right1 + spacing;
var right2 = left2 + button_width;
var bottom2 = bottom1;

var hover1 = point_in_rectangle(mouse_x, mouse_y, left1, top1, right1, bottom1);
var hover2 = point_in_rectangle(mouse_x, mouse_y, left2, top1, right2, bottom2);

var colour1 = (global.pb_mode == 0) ? make_colour_rgb(210, 235, 255) : make_colour_rgb(235, 235, 235);
var colour2 = (global.pb_mode == 1) ? make_colour_rgb(255, 230, 210) : make_colour_rgb(235, 235, 235);

if (hover1) colour1 = make_colour_rgb(200, 225, 250);
if (hover2) colour2 = make_colour_rgb(250, 220, 200);

draw_set_color(colour1);
draw_rectangle(left1, top1, right1, bottom1, false);

draw_set_color(colour2);
draw_rectangle(left2, top1, right2, bottom2, false);

draw_set_color(c_black);
draw_text(left1 + 12, top1 + 12, "mark the habit");
draw_text(left2 + 12, top1 + 12, "mark the break");
