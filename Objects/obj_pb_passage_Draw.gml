/// obj_pb_passage : Draw Event
// Draw the long passage with interactive highlights.
if (is_undefined(global.pb_layout)) {
    exit;
}

var layout = global.pb_layout;
var box_width = layout.width + layout.margin * 2;
var box_height = visible_height;
var left = x;
var top = y;
var right = left + box_width;
var bottom = top + box_height;

// Panel background.
draw_set_color(make_colour_rgb(250, 250, 250));
draw_rectangle(left, top, right, bottom, false);

var line_height = layout.line_height;
var first_line = floor(layout.scroll / line_height);
var last_line = ceil((layout.scroll + box_height) / line_height);
last_line = clamp(last_line, 0, array_length(layout.lines));

for (var i = first_line; i < last_line; i++) {
    var line_top = top + (i * line_height) - layout.scroll;
    var line_bottom = line_top + line_height;
    var rect_left = left;
    var rect_right = right;

    draw_set_alpha(0.35);
    if (is_undefined(global.pb_result)) {
        if (global.pb_pick_pattern == i) {
            draw_set_color(make_colour_rgb(210, 230, 255));
            draw_rectangle(rect_left, line_top, rect_right, line_bottom, false);
        }
        if (global.pb_pick_break == i) {
            draw_set_color(make_colour_rgb(255, 225, 210));
            draw_rectangle(rect_left, line_top, rect_right, line_bottom, false);
        }
    } else {
        var target_pattern = global.pb_item.pattern_line_idx;
        var target_break = global.pb_item.break_line_idx;
        if (i == target_pattern) {
            draw_set_color(make_colour_rgb(210, 245, 210));
            draw_rectangle(rect_left, line_top, rect_right, line_bottom, false);
        }
        if (i == target_break) {
            draw_set_color(make_colour_rgb(210, 245, 210));
            draw_rectangle(rect_left, line_top, rect_right, line_bottom, false);
        }
        if (!global.pb_result.pattern_ok && global.pb_pick_pattern == i) {
            draw_set_color(make_colour_rgb(245, 210, 210));
            draw_rectangle(rect_left, line_top, rect_right, line_bottom, false);
        }
        if (!global.pb_result.break_ok && global.pb_pick_break == i) {
            draw_set_color(make_colour_rgb(245, 210, 210));
            draw_rectangle(rect_left, line_top, rect_right, line_bottom, false);
        }
    }
    draw_set_alpha(1);
}

draw_set_alpha(1);

scr_draw_longtext(layout, left, top, box_height);
