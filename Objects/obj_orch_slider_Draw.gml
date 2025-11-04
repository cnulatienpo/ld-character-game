/// obj_orch_slider : Draw Event
// Renders the vertical fader and its label.
var track_x = x;
var track_top = y;
var track_bottom = y + range_height;
var knob_y = track_top + (1 - value) * range_height;

var track_col = hover ? make_colour_rgb(210, 210, 230) : make_colour_rgb(200, 200, 210);
draw_set_color(track_col);
draw_rectangle(track_x - 4, track_top, track_x + 4, track_bottom, false);

draw_set_color(make_colour_rgb(90, 90, 120));
draw_circle(track_x, knob_y, knob_radius, false);

if (string_length(label) > 0) {
    draw_set_color(c_black);
    draw_text(track_x - 28, track_bottom + 24, label);
}
