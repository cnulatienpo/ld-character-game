/// obj_gt_slider : Draw Event
// Draws the tilt slider that represents gravity toward an ending.
var center_y = y;
var left_x = x;
var right_x = x + slider_width;

draw_set_color(make_colour_rgb(210, 210, 210));
draw_line(left_x, center_y, right_x, center_y);

draw_set_color(c_black);
draw_text(left_x - 20, center_y - 20, "A");
draw_text(right_x + 8, center_y - 20, "B");

var knob_x = left_x + value * slider_width;
var knob_color = hover ? make_colour_rgb(80, 110, 180) : make_colour_rgb(110, 140, 200);
draw_set_color(knob_color);
draw_circle(knob_x, center_y, 10, false);
