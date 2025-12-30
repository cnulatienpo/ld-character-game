/// obj_orch_controller : Draw Event
// Renders goal text, fader preview, and feedback for The Orchestra.
draw_set_color(c_black);
var left_x = 120;
var top_y = 80;
var line_y = top_y;

for (var i = 0; i < array_length(label_layout.lines); i++) {
    draw_text(left_x, line_y, label_layout.lines[i]);
    line_y += label_layout.line_height;
}

line_y += 12;
for (var g = 0; g < array_length(goal_layout.lines); g++) {
    draw_text(left_x, line_y, goal_layout.lines[g]);
    line_y += goal_layout.line_height;
}

line_y += 8;
for (var t = 0; t < array_length(tips_layout.lines); t++) {
    draw_text(left_x, line_y, tips_layout.lines[t]);
    line_y += tips_layout.line_height;
}

var preview_x = 520;
var preview_y = 120;
var panel_w = preview_layout.width + preview_layout.margin * 2;

draw_set_color(make_colour_rgb(236, 240, 244));
draw_rectangle(preview_x - 8, preview_y - 12, preview_x - 8 + panel_w, preview_y - 12 + panel_height, false);
draw_set_color(c_black);
scr_draw_longtext(preview_layout, preview_x - 8, preview_y - 12, panel_height);

var feedback_y = preview_y + panel_height + 24;
draw_set_color(make_colour_rgb(245, 245, 245));
draw_rectangle(preview_x - 8, feedback_y - 12, preview_x - 8 + panel_w, feedback_y + 48, false);
draw_set_color(c_black);
for (var f = 0; f < array_length(feedback_layout.lines); f++) {
    draw_text(preview_x + feedback_layout.margin - 8, feedback_y + f * feedback_layout.line_height, feedback_layout.lines[f]);
}

draw_text(preview_x - 8, feedback_y - 32, "Check the mix, then continue.");
