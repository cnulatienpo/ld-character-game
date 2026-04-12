/// obj_rg_passage : Draw Event
// Shows the evolving passage with scroll support.
var layout = global.rg_layout;
if (!is_struct(layout)) {
    return;
}

var x0 = 140;
var y0 = 140;
var visible_h = 320;
var panel_width = layout.width + layout.margin * 2;

draw_set_colour(make_colour_rgb(50, 60, 80));
draw_rectangle(x0 - 24, y0 - 24, x0 + panel_width + 24, y0 + visible_h + 24, false);

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(140, 80, "Layer concrete details to bring the scene back.\n\nPick the ones that shift the field.");

scr_draw_longtext(layout, x0, y0, visible_h);
