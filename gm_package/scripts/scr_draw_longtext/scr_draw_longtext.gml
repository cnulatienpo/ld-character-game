/// @function scr_draw_longtext(layout, x0, y0, visible_h)
/// @description Renders long-form text using a layout struct with scroll support.
/// @param layout Struct created by scr_longtext_layout_create.
/// @param x0 Left edge of the drawing region.
/// @param y0 Top edge of the drawing region.
/// @param visible_h Height of the visible viewport in pixels.
function scr_draw_longtext(layout, x0, y0, visible_h) {
    if (is_undefined(layout) || !is_struct(layout)) {
        return;
    }

    var line_height = layout.line_height;
    var max_scroll = max(0, layout.height - visible_h);

    // Adjust scroll using the mouse wheel when the cursor is over the panel.
    var panel_width = layout.width + layout.margin * 2;
    if (point_in_rectangle(mouse_x, mouse_y, x0, y0, x0 + panel_width, y0 + visible_h)) {
        if (mouse_wheel_up()) {
            layout.scroll = max(0, layout.scroll - line_height);
        }
        if (mouse_wheel_down()) {
            layout.scroll = min(max_scroll, layout.scroll + line_height);
        }
    }

    layout.scroll = clamp(layout.scroll, 0, max_scroll);

    var first_line = floor(layout.scroll / line_height);
    var last_line = ceil((layout.scroll + visible_h) / line_height);
    last_line = clamp(last_line, 0, array_length(layout.lines));

    for (var i = first_line; i < last_line; i++) {
        var line_y = y0 + (i * line_height) - layout.scroll;
        draw_text(x0 + layout.margin, line_y, layout.lines[i]);
    }
}
