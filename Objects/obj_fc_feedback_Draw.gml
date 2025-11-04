/// obj_fc_feedback : Draw Event
if (is_undefined(global.fc_result)) {
    exit;
}

var result = global.fc_result;
var force_line = result.ok_force ? "Force picks line up." : "Adjust which forces press back.";
var stake_line = result.ok_stakes ? "Stakes feel right." : "Name the stakes that climb.";

draw_set_color(c_black);
draw_text(x, y, force_line);
draw_text(x, y + 20, stake_line);
draw_text(x, y + 40, "Design reason: " + string(result.explain));

var btn_top = y + 80;
var btn_bottom = btn_top + button_height;
var btn_right = x + button_width;
var bg = hover ? make_colour_rgb(220, 235, 245) : make_colour_rgb(235, 235, 235);
draw_set_color(bg);
draw_rectangle(x, btn_top, btn_right, btn_bottom, false);

draw_set_color(c_black);
draw_text(x + 12, btn_top + 10, button_label);
