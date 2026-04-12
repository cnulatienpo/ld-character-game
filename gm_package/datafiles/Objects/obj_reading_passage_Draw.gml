/// obj_reading_passage : Draw Event
// Draws the reading passage with selectable line highlights and optional key reveal.
if (is_undefined(global.reading_layout)) {
    return;
}

var layout = global.reading_layout;
var x0 = 48;
var y0 = 96;
var visible_h = room_height - 160;
var scroll = clamp(layout.scroll, 0, max(0, layout.height - visible_h));
var line_height = layout.line_height;

// Base panel
var bg = make_colour_rgb(245, 244, 240);
draw_set_color(bg);
draw_rectangle(x0 - 24, y0 - 32, x0 + layout.width + 24, y0 + visible_h + 32, false);

draw_set_color(c_black);

// Selected highlights
scr_highlight_ranges_draw(global.reading_selected, layout, x0, y0, visible_h, make_colour_rgb(200, 230, 255), 0.45);

// Drag preview highlight
if (is_array(global.reading_preview_range)) {
    var preview_array = [global.reading_preview_range];
    scr_highlight_ranges_draw(preview_array, layout, x0, y0, visible_h, make_colour_rgb(210, 240, 210), 0.35);
}

// Reveal key ranges after submission
if (!is_undefined(global.reading_feedback) && is_array(global.reading_key_ranges)) {
    scr_highlight_ranges_draw(global.reading_key_ranges, layout, x0, y0, visible_h, make_colour_rgb(255, 210, 180), 0.25);
}

// Draw each line with its index for reference.
for (var i = 0; i < array_length(layout.lines); i++) {
    var line_y = y0 + i * line_height - scroll;
    if (line_y + line_height < y0 - 32 || line_y > y0 + visible_h + 32) {
        continue;
    }

    draw_text(x0 - 36, line_y, string(i + 1));
    draw_text(x0, line_y, layout.lines[i]);
}
