/// obj_gt_passage : Draw Event
// Renders the scrollable passage leading into the endings.
if (is_undefined(global.gt_layout)) {
    exit;
}

var layout = global.gt_layout;
var x0 = x;
var y0 = y;
var visible_h = visible_height;
var bg_col = make_colour_rgb(250, 248, 244);
draw_set_color(bg_col);
draw_rectangle(x0 - padding, y0 - padding, x0 + layout.width + padding, y0 + visible_h + padding, false);

scr_draw_longtext(layout, x0, y0, visible_h);
