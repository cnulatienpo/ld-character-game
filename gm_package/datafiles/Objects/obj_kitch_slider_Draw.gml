/// obj_kitch_slider : Draw Event
// Renders the slider track and knob.
var track_y = y;
draw_set_color(make_colour_rgb(220, 220, 220));
draw_rectangle(x, track_y - slider_height / 2, x + slider_width, track_y + slider_height / 2, false);

var knob_x = x + value * slider_width;
var knob_color = hover ? make_colour_rgb(120, 170, 220) : make_colour_rgb(150, 150, 150);
draw_set_color(knob_color);
draw_circle(knob_x, track_y, knob_radius, false);

draw_set_color(c_black);
if (string_length(label) > 0) {
    draw_text(x - 80, track_y - 8, label + " " + string_format(value, 1, 2));
}
