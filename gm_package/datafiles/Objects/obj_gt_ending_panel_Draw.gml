/// obj_gt_ending_panel : Draw Event
// Draws one of the possible endings with selection tint.
if (!is_struct(global.gt_item)) {
    exit;
}

var x1 = x;
var y1 = y;
var x2 = x + panel_width;
var y2 = y + panel_height;
var selected = (string(global.gt_choice) == side);
var base_col = selected ? make_colour_rgb(220, 235, 250) : make_colour_rgb(240, 240, 240);
if (hover) {
    base_col = merge_colour(base_col, c_white, 0.5);
}
draw_set_color(base_col);
draw_rectangle(x1, y1, x2, y2, false);

var label_text = (side == "right") ? "Ending B" : "Ending A";
draw_set_color(c_black);
draw_text(x1 + 12, y1 + 8, label_text);

var ending_text = (side == "right") ? global.gt_item.right_end : global.gt_item.left_end;
draw_text_ext(x1 + 12, y1 + 36, ending_text, 24, panel_width - 24);
