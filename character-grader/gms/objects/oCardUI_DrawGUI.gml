/// oCardUI Draw GUI Event

var ctrl = controller;
if (!instance_exists(ctrl)) {
    ctrl = instance_find(oGame, 0);
    controller = ctrl;
}
if (!instance_exists(ctrl)) {
    exit;
}

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
if (gui_w <= 0) gui_w = room_width;
if (gui_h <= 0) gui_h = room_height;

var margin = 32;
var panel_w = gui_w - margin * 2;
var prompt_y = 120;
var prompt_h = 200;
var input_y = prompt_y + prompt_h + 32;
var input_h = gui_h - input_y - 96;
if (input_h < 160) {
    input_h = 160;
}

var bg_top = make_color_rgb(38, 44, 62);
var bg_bottom = make_color_rgb(28, 32, 48);

// Prompt panel background
var prompt_x1 = margin;
var prompt_x2 = margin + panel_w;
var prompt_y2 = prompt_y + prompt_h;
draw_set_alpha(0.85);
draw_rectangle_color(prompt_x1, prompt_y, prompt_x2, prompt_y2, bg_top, bg_top, bg_bottom, bg_bottom, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(70, 80, 110));
draw_rectangle(prompt_x1, prompt_y, prompt_x2, prompt_y2, false);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (is_struct(ctrl.current)) {
    var card = ctrl.current;
    var title = is_string(card.title) ? card.title : "Untitled";
    var npc = is_string(card.npc) ? card.npc : "";
    var prompt_text = is_string(card.prompt) ? card.prompt : "";

    draw_text(prompt_x1 + 16, prompt_y + 16, title);
    draw_text(prompt_x1 + 16, prompt_y + 48, "NPC: " + npc);
    draw_text_ext(prompt_x1 + 16, prompt_y + 80, prompt_text, 12, panel_w - 32);

    if (is_array(card.examples_positive) && array_length(card.examples_positive) > 0) {
        draw_set_color(make_color_rgb(180, 220, 255));
        draw_text(prompt_x1 + 16, prompt_y2 - 48, "Example: " + card.examples_positive[0]);
        draw_set_color(c_white);
    }
} else {
    draw_text(prompt_x1 + 16, prompt_y + 16, "All cards completed. Great work!");
}

// Input panel
var input_x1 = margin;
var input_x2 = margin + panel_w;
var input_y2 = input_y + input_h;
draw_set_alpha(0.9);
draw_rectangle_color(input_x1, input_y, input_x2, input_y2, bg_bottom, bg_bottom, bg_top, bg_top, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(90, 100, 140));
draw_rectangle(input_x1, input_y, input_x2, input_y2, false);

draw_set_color(c_white);
var instructions_y = input_y + 12;
draw_text(input_x1 + 16, instructions_y, "Type your response below. Ctrl+Enter to submit.");

var text_start_y = instructions_y + 28;
var text_display = ctrl.text_buffer;
if (!is_string(text_display)) {
    text_display = "";
}
var caret_text = text_display;
if (ctrl.phase == "typing") {
    caret_text += "|";
}
draw_text_ext(input_x1 + 16, text_start_y, caret_text, 12, panel_w - 32);
