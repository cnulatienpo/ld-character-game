/// oUIStack Draw GUI Event

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var R = ui_center_rects();

tool_rails_draw(R.rail_left, R.rail_right, self);

var hud_x = R.content.x;
var hud_y = R.content.y;
var hud_w = R.content.w;
var hud_h = top_hud_height;

draw_set_color(make_color_rgb(30, 30, 38));
draw_roundrect(hud_x, hud_y, hud_x + hud_w, hud_y + hud_h, 12, 12, false);
draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.08);
draw_roundrect(hud_x, hud_y, hud_x + hud_w, hud_y + hud_h, 12, 12, false);
draw_set_alpha(1);

var xp_val = 0;
var level_val = 1;
if (is_struct(state)) {
    if (variable_struct_exists(state, "xp") && is_real(state.xp)) {
        xp_val = state.xp;
    }
    if (variable_struct_exists(state, "level") && is_real(state.level)) {
        level_val = state.level;
    }
}
draw_set_color(make_color_rgb(220, 228, 245));
var hud_text = "XP: " + string(xp_val) + "  Level: " + string(level_val);
draw_text(hud_x + UI_PADDING, hud_y + hud_h * 0.5 - 8, hud_text);

if (is_struct(current)) {
    draw_set_color(make_color_rgb(160, 200, 255));
    draw_set_halign(fa_center);
    draw_text(hud_x + hud_w * 0.5, hud_y + hud_h * 0.5 - 8, string(current.id) + " – " + string(current.title));
    draw_set_halign(fa_left);
}

draw_set_color(make_color_rgb(200, 200, 220));
var net_display = net_msg;
if (submitting) {
    net_display = "Submitting...";
}
draw_text(hud_x + hud_w - UI_PADDING - string_width(net_display), hud_y + hud_h * 0.5 - 8, net_display);

var y = hud_y + hud_h + UI_GAP;

var theory_text = "";
var prompt_text = "";
if (is_struct(current)) {
    if (variable_struct_exists(current, "theory") && is_string(current.theory)) {
        theory_text = current.theory;
    }
    if (variable_struct_exists(current, "prompt") && is_string(current.prompt)) {
        prompt_text = current.prompt;
    }
}

if (string_length(theory_text) > 0) {
    var t1 = ui_box_autogrow(hud_x, y, UI_CONTENT_W, theory_text, UI_CONTENT_W, true);
    y += t1.h + UI_GAP;
}

if (string_length(prompt_text) > 0) {
    var t2 = ui_box_autogrow(hud_x, y, UI_CONTENT_W, prompt_text, UI_CONTENT_W, true);
    y += t2.h + UI_GAP;
}

var editor_y = y;
ui_box_editor(hud_x, editor_y, UI_CONTENT_W, UI_EDITOR_H, self);
editor_rect = { x : hud_x, y : editor_y, w : UI_CONTENT_W, h : UI_EDITOR_H };

y += UI_EDITOR_H;

var action_y = y + UI_GAP * 0.5;
var clicked = ui_action_strip(hud_x, action_y, UI_CONTENT_W, undefined);
if (string_length(clicked) > 0) {
    action_clicked = clicked;
}

var tray_y = action_y + 44 + UI_GAP;
var tray_metrics = tray_draw(hud_x, tray_y, UI_CONTENT_W, tray);

draw_set_color(make_color_rgb(255, 160, 160));
if (string_length(last_error) > 0) {
    draw_text(hud_x, tray_y + tray_metrics.h + UI_GAP, last_error);
}
