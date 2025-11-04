/// obj_fc_question : Draw Event
if (is_undefined(global.fc_item)) {
    exit;
}

var options = global.fc_force_options;
if (!is_array(options)) {
    options = ["character", "society", "nature", "self"];
}

draw_set_color(c_black);
draw_text(x, y - 36, question_text);

for (var i = 0; i < array_length(options); i++) {
    var opt = options[i];
    var top = y + i * (option_height + option_spacing);
    var bottom = top + option_height;
    var hover = point_in_rectangle(mouse_x, mouse_y, x, top, x + option_width, bottom);
    var selected = ds_map_exists(global.fc_force_selected, opt);
    var box_colour = selected ? make_colour_rgb(210, 235, 255) : make_colour_rgb(235, 235, 235);
    if (hover) {
        box_colour = make_colour_rgb(220, 235, 245);
    }

    if (!is_undefined(global.fc_result)) {
        var is_target = false;
        for (var t = 0; t < array_length(global.fc_item.forces); t++) {
            if (global.fc_item.forces[t] == opt) {
                is_target = true;
                break;
            }
        }
        if (is_target) {
            box_colour = make_colour_rgb(210, 245, 210);
        } else if (selected) {
            box_colour = make_colour_rgb(245, 210, 210);
        }
    }

    draw_set_color(box_colour);
    draw_rectangle(x, top, x + option_width, bottom, false);
    draw_set_color(c_black);
    draw_text(x + 12, top + 12, opt);
}
