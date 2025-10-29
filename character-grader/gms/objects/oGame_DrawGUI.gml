/// oGame Draw GUI Event

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
if (gui_w <= 0) gui_w = room_width;
if (gui_h <= 0) gui_h = room_height;

var margin = 24;
var top_y = margin;
var info_x = margin;

var total_cards = array_length(cards);
var badge_count = is_array(state.badges) ? array_length(state.badges) : 0;
var progress_text = "Cards: " + string(card_pass_count) + "/" + string(total_cards);
var xp_text = "XP: " + string(state.xp);
var level_text = "Level: " + string(state.level);
var attempts_text = "Attempts: " + string(state.attempt_count);

var header = xp_text + "  |  " + level_text + "  |  " + attempts_text + "  |  Badges: " + string(badge_count) + "  |  " + progress_text;

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(info_x, top_y, header);

var instructions_y = top_y + 32;
var instructions = "Press Enter to begin typing. Submit with Ctrl+Enter.";
if (collection_complete) {
    instructions = "Character Slice Cleared — keep reviewing or press Enter to revisit.";
}

draw_text(info_x, instructions_y, instructions);

var status_y = instructions_y + 24;
if (string_length(net_msg) > 0) {
    var status_label = net_waiting ? "Server (pending): " : "Server: ";
    draw_text(info_x, status_y, status_label + net_msg);
}

var preview_y = gui_h - margin - 48;
var wc = preview_stats.wc;
var caps_ratio = preview_stats.caps_ratio * 100;
var preview_line = "Preview: " + string(wc) + " words  |  Caps: " + string_format(caps_ratio, 0, 1) + "%";

draw_text(info_x, preview_y, preview_line);

if (has_preview_function && is_struct(preview_stats.gates)) {
    var gates = preview_stats.gates;
    var gate_text = "Gates: ";
    if (variable_struct_exists(gates, "min_words")) {
        gate_text += "Words " + (gates.min_words ? "✓" : "✗");
    }
    if (variable_struct_exists(gates, "tokens")) {
        gate_text += "  Tokens " + (gates.tokens ? "✓" : "✗");
    }
    if (variable_struct_exists(gates, "caps")) {
        gate_text += "  Caps " + (gates.caps ? "✓" : "✗");
    }
    draw_text(info_x, preview_y + 24, gate_text);
}

if (collection_complete) {
    var summary_y = gui_h * 0.5 - 80;
    var summary_x = gui_w * 0.5;
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(summary_x, summary_y, "Character Slice Cleared!");
    draw_text(summary_x, summary_y + 28, "Total XP: " + string(state.xp));
    draw_text(summary_x, summary_y + 56, "Badges: " + string(badge_count));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (net_waiting) {
    draw_set_alpha(0.4);
    draw_set_color(c_black);
    draw_rectangle_colour(0, 0, gui_w, gui_h, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var overlay_text = string_length(net_msg) > 0 ? net_msg : "Submitting...";
    draw_text(gui_w * 0.5, gui_h * 0.5, overlay_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
