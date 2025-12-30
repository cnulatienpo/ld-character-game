/// obj_fc_submit : Left Pressed Event
if (!hover) {
    exit;
}

var forces = [];
var force_options = global.fc_force_options;
if (!is_array(force_options)) {
    force_options = ["character", "society", "nature", "self"];
}
for (var i = 0; i < array_length(force_options); i++) {
    var opt = force_options[i];
    if (ds_map_exists(global.fc_force_selected, opt)) {
        array_push(forces, opt);
    }
}

var stakes = [];
var stake_options = global.fc_stake_options;
if (!is_array(stake_options)) {
    stake_options = ["personal", "external"];
}
for (var j = 0; j < array_length(stake_options); j++) {
    var opt2 = stake_options[j];
    if (ds_map_exists(global.fc_stakes_selected, opt2)) {
        array_push(stakes, opt2);
    }
}

scr_friction_submit(forces, stakes);
