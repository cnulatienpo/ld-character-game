/// obj_fc_question : Left Pressed Event
if (is_undefined(global.fc_force_selected)) {
    exit;
}

var options = global.fc_force_options;
if (!is_array(options)) {
    options = ["character", "society", "nature", "self"];
}

for (var i = 0; i < array_length(options); i++) {
    var opt = options[i];
    var top = y + i * (option_height + option_spacing);
    var bottom = top + option_height;
    if (point_in_rectangle(mouse_x, mouse_y, x, top, x + option_width, bottom)) {
        if (ds_map_exists(global.fc_force_selected, opt)) {
            ds_map_delete(global.fc_force_selected, opt);
        } else {
            ds_map_set(global.fc_force_selected, opt, true);
        }
        break;
    }
}
