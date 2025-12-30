/// obj_sl_pulse : Draw Event
// Draws a pulsing circle that syncs to the beat.
draw_set_colour(make_colour_rgb(240, 220, 180));
draw_set_alpha(0.9);
var r = base_radius * pulse_scale;
draw_circle_color(x, y, r, make_colour_rgb(240, 220, 180), make_colour_rgb(200, 180, 140), false);
draw_set_alpha(1);
