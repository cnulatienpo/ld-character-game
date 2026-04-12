/// obj_db_symmetry_passage : Draw Event
// Draws the paragraph block and fold line.
var layout = global.db_symmetry_layout;
if (!is_struct(layout)) {
    return;
}

var x0 = global.db_symmetry_origin_x;
var y0 = global.db_symmetry_origin_y;
var visible_h = global.db_symmetry_visible_h;
var panel_width = layout.width + layout.margin * 2;

draw_set_colour(make_colour_rgb(60, 70, 90));
draw_rectangle(x0 - 24, y0 - 24, x0 + panel_width + 24, y0 + visible_h + 24, false);

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(200, 100, "Slide the fold until both sides feel balanced.\n\nCheck how the weight changes.");

scr_draw_longtext(layout, x0, y0, visible_h);

draw_set_colour(make_colour_rgb(200, 220, 240));
draw_line(global.db_symmetry_fold_x, y0 - 12, global.db_symmetry_fold_x, y0 + visible_h + 12);
