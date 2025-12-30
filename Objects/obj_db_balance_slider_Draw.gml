/// obj_db_balance_slider : Draw Event
var radius = 12;
var colour = dragging ? make_colour_rgb(160, 200, 180) : make_colour_rgb(130, 160, 150);
draw_set_colour(colour);
draw_circle(x, y, radius, false);
