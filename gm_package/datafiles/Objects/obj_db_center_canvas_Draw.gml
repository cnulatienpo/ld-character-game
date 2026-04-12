/// obj_db_center_canvas : Draw Event
// Renders the composition and interaction area.
draw_set_colour(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(160, 100, global.db_center_prompt);

var shapes = global.db_center_shapes;
if (is_array(shapes)) {
    for (var i = 0; i < array_length(shapes); i++) {
        var shape = shapes[i];
        draw_set_colour(shape.col);
        draw_rectangle(shape.x, shape.y, shape.x + shape.w, shape.y + shape.h, false);
    }
}

if (is_struct(global.db_center_mark)) {
    draw_set_colour(make_colour_rgb(80, 80, 120));
    draw_circle(global.db_center_anchor.x, global.db_center_anchor.y, 6, false);
    draw_set_colour(make_colour_rgb(200, 240, 180));
    draw_circle(global.db_center_mark.x, global.db_center_mark.y, 6, false);
}
