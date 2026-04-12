/// obj_chain_controller : Draw Event
// Renders the three-panel Chain Reaction layout.
draw_set_color(c_black);
var prompt_x = 200;
var prompt_y = 80;
for (var i = 0; i < array_length(prompt_layout.lines); i++) {
    draw_text(prompt_x, prompt_y + i * prompt_layout.line_height, prompt_layout.lines[i]);
}

var panel_w = 360;
var panel_h = 420;
var start_x = 80;
var option_x = 480;
var end_x = 880;
var panel_y = 140;

draw_set_color(make_colour_rgb(240, 240, 242));
draw_rectangle(start_x, panel_y, start_x + panel_w, panel_y + panel_h, false);
draw_rectangle(option_x, panel_y, option_x + panel_w, panel_y + panel_h, false);
draw_rectangle(end_x, panel_y, end_x + panel_w, panel_y + panel_h, false);

draw_set_color(c_black);
scr_draw_longtext(start_layout, start_x, panel_y, panel_h);
if (array_length(option_layouts) > 0) {
    var opt_layout = option_layouts[current_index];
    if (is_struct(opt_layout)) {
        scr_draw_longtext(opt_layout, option_x, panel_y, panel_h);
    }
}
scr_draw_longtext(end_layout, end_x, panel_y, panel_h);

var option_letter = chr(ord("A") + current_index);
draw_text(option_x + 16, panel_y - 32, "Option " + option_letter);
draw_text(option_x + 16, panel_y + panel_h + 12, "Use Prev/Next to scan the beats.");

var note_x = option_x;
var note_y = panel_y + panel_h + 60;
draw_set_color(make_colour_rgb(245, 245, 245));
draw_rectangle(note_x, note_y - 12, note_x + panel_w, note_y + 72, false);
draw_set_color(c_black);
for (var n = 0; n < array_length(feedback_layout.lines); n++) {
    draw_text(note_x + feedback_layout.margin, note_y + n * feedback_layout.line_height, feedback_layout.lines[n]);
}
