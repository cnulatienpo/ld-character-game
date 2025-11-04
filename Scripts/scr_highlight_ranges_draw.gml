/// @function scr_highlight_ranges_draw(ranges_array, layout, x0, y0, visible_h, colour, alpha)
/// @description Draws semi-transparent highlight bands for each [start,end] range.
function scr_highlight_ranges_draw(ranges_array, layout, x0, y0, visible_h, colour, alpha) {
    if (!is_array(ranges_array) || is_undefined(layout)) {
        return;
    }

    var line_height = layout.line_height;
    var scroll = clamp(layout.scroll, 0, max(0, layout.height - visible_h));

    draw_set_alpha(alpha);
    draw_set_color(colour);

    for (var i = 0; i < array_length(ranges_array); i++) {
        var range = ranges_array[i];
        if (!is_array(range) || array_length(range) < 2) {
            continue;
        }

        var start_idx = range[0];
        var end_idx = range[1];

        var top = y0 + start_idx * line_height - scroll;
        var bottom = y0 + (end_idx + 1) * line_height - scroll;
        draw_rectangle_color(x0, top, x0 + layout.width, bottom, colour, colour, colour, colour, false);
    }

    draw_set_alpha(1);
}
