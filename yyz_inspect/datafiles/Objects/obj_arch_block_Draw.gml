/// obj_arch_block : Draw Event
// Draws the block with a gentle wobble when appropriate.
var colour;
switch (block_label) {
    case "pattern": colour = make_colour_rgb(200, 220, 255); break;
    case "contrast": colour = make_colour_rgb(255, 205, 205); break;
    case "tension": colour = make_colour_rgb(255, 230, 190); break;
    case "rest": colour = make_colour_rgb(210, 240, 210); break;
    default: colour = make_colour_rgb(230, 230, 230); break;
}

var wobble = 0;
if (global.arch_wobble_amp > 0) {
    wobble = sin(global.arch_wobble_phase + wobble_phase) * global.arch_wobble_amp;
}

var left = x - block_width / 2 + wobble;
var right = x + block_width / 2 + wobble;
var top = y - 20;
var bottom = y + 20;

draw_set_color(colour);
draw_rectangle(left, top, right, bottom, false);
draw_set_color(c_black);
draw_text(left + 12, y - 6, block_label);
var weight_text = string_format(block_weight, 0, 1);
var pull_text = string_format(block_pull, 0, 1);
draw_text(left + 12, y + 10, "w " + weight_text + " p " + pull_text);
