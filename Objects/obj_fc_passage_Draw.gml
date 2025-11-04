/// obj_fc_passage : Draw Event
if (is_undefined(global.fc_layout)) {
    exit;
}

draw_set_color(make_colour_rgb(250, 250, 250));
var width = global.fc_layout.width + global.fc_layout.margin * 2;
draw_rectangle(x, y, x + width, y + visible_height, false);

scr_draw_longtext(global.fc_layout, x, y, visible_height);
