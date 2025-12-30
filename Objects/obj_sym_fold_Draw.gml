/// obj_sym_fold : Draw Event
// Draws the draggable fold line.
var col = dragging ? make_colour_rgb(180, 60, 60) : make_colour_rgb(120, 120, 140);
draw_set_color(col);
var top_y = global.sym_panel_top;
var bottom_y = global.sym_panel_top + global.sym_panel_height;
draw_line_width(x, top_y, x, bottom_y, 3);
