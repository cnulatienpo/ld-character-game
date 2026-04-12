/// obj_quiz_feedback : Draw Event
// Renders the feedback overlay once a choice has been submitted.
if (is_undefined(global.quiz_feedback)) {
    return;
}

var overlay = global.quiz_feedback;
var x0 = (room_width - panel_width) * 0.5;
var y0 = room_height - panel_height - 32;

// Panel background
var bg = make_colour_rgb(250, 248, 240);
draw_set_color(bg);
draw_rectangle(x0, y0, x0 + panel_width, y0 + panel_height, false);

draw_set_color(c_black);
var verdict = overlay.correct ? "That lines up." : "That misses the weight.";
draw_text(x0 + 24, y0 + 24, verdict);
draw_text_ext(x0 + 24, y0 + 64, string(overlay.explain), 18, panel_width - 48);

// Continue button
var btn_x1 = x0 + panel_width - 180;
var btn_y1 = y0 + panel_height - 56;
var btn_x2 = btn_x1 + 140;
var btn_y2 = btn_y1 + 32;
button_rect = [btn_x1, btn_y1, btn_x2, btn_y2];

var btn_col = make_colour_rgb(210, 230, 245);
draw_set_color(btn_col);
draw_rectangle(btn_x1, btn_y1, btn_x2, btn_y2, false);

draw_set_color(c_black);
draw_text(btn_x1 + 12, btn_y1 + 8, "continue");
