/// obj_sym_controller : Draw Event
// Renders the symmetry scene and current feedback.
draw_set_color(c_black);
var info_x = 160;
var info_y = 80;
for (var i = 0; i < array_length(instruction_layout.lines); i++) {
    draw_text(info_x, info_y + i * instruction_layout.line_height, instruction_layout.lines[i]);
}

var panel_x = panel_left;
var panel_y = panel_top;
var panel_w = panel_width;
var panel_h = panel_height;

draw_set_color(make_colour_rgb(238, 240, 242));
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);

draw_set_color(c_black);
if (global.sym_mode == "text" && is_struct(text_layout)) {
    scr_draw_longtext(text_layout, panel_x, panel_y, panel_h);
} else {
    var center_x = panel_x + panel_w * 0.5;
    draw_rectangle(panel_x + 40, panel_y + 60, center_x - 20, panel_y + panel_h - 80, false);
    draw_rectangle(center_x + 20, panel_y + 80, panel_x + panel_w - 40, panel_y + panel_h - 60, false);
    draw_circle(panel_x + 120, panel_y + 160, 30, false);
    draw_circle(panel_x + panel_w - 120, panel_y + 200, 40, false);
}

draw_set_color(make_colour_rgb(245, 245, 245));
var note_y = panel_y + panel_h + 32;
draw_rectangle(panel_x, note_y - 12, panel_x + panel_w, note_y + 60, false);
draw_set_color(c_black);
for (var n = 0; n < array_length(feedback_layout.lines); n++) {
    draw_text(panel_x + feedback_layout.margin, note_y + n * feedback_layout.line_height, feedback_layout.lines[n]);
}
