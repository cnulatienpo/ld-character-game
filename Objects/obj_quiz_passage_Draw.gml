/// obj_quiz_passage : Draw Event
// Renders the current quiz passage using the layout prepared by scr_longtext_layout_create.
if (is_undefined(global.quiz_layout)) {
    return;
}

var layout = global.quiz_layout;
var x0 = 48;
var y0 = 96;
var visible_h = room_height - 160;
var scroll = clamp(layout.scroll, 0, max(0, layout.height - visible_h));
var line_height = layout.line_height;

// Background panel for readability.
draw_set_color(make_colour_rgb(245, 245, 245));
draw_rectangle(x0 - 16, y0 - 24, x0 + layout.width + 16, y0 + visible_h + 24, false);

draw_set_color(c_black);
for (var i = 0; i < array_length(layout.lines); i++) {
    var line_y = y0 + i * line_height - scroll;
    if (line_y + line_height < y0 - 24 || line_y > y0 + visible_h + 24) {
        continue;
    }
    draw_text(x0, line_y, layout.lines[i]);
}
