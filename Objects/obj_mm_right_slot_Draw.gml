/// obj_mm_right_slot : Draw Event
// Renders the example text and highlights correctness after submission.
var left = x;
var top = y;
var right = x + slot_width;
var bottom = y + slot_height;

var box_colour = make_colour_rgb(245, 245, 245);
if (point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom)) {
    box_colour = make_colour_rgb(230, 240, 250);
}

var expected_label = "";
var origin_index = slot_index;
if (is_array(global.mm_right_order) && slot_index < array_length(global.mm_right_order)) {
    origin_index = global.mm_right_order[slot_index];
}
if (is_array(global.mm_left)) {
    for (var i = 0; i < array_length(global.mm_left); i++) {
        var label = global.mm_left[i];
        if (variable_struct_get(global.mm_answer_map, label, -1) == origin_index) {
            expected_label = label;
            break;
        }
    }
}

if (!is_undefined(global.mm_result)) {
    if (occupant != noone) {
        if (occupant.token_label == expected_label) {
            box_colour = make_colour_rgb(210, 245, 210);
        } else {
            box_colour = make_colour_rgb(245, 210, 210);
        }
    } else {
        box_colour = make_colour_rgb(250, 235, 200);
    }
}

draw_set_color(box_colour);
draw_rectangle(left, top, right, bottom, false);

draw_set_color(c_black);
draw_text(left + 12, top + 12, slot_text);
