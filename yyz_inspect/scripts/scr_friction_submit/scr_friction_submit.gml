/// @function scr_friction_submit(force_choice, stakes_choice)
/// @description Evaluates the selected forces and stakes for the current scene.
/// @param force_choice Array of selected forces (strings).
/// @param stakes_choice Array of selected stakes (strings).
function scr_friction_submit(force_choice, stakes_choice) {
    if (is_undefined(global.fc_item)) {
        return { ok_force: false, ok_stakes: false, explain: "" };
    }

    var target_forces = global.fc_item.forces;
    var target_stakes = global.fc_item.stakes;

    var ok_force = false;
    var ok_stakes = false;

    if (is_array(force_choice) && is_array(target_forces)) {
        if (array_length(force_choice) == array_length(target_forces)) {
            var force_map = ds_map_create();
            for (var i = 0; i < array_length(force_choice); i++) {
                ds_map_set(force_map, string(force_choice[i]), true);
            }
            ok_force = true;
            for (var j = 0; j < array_length(target_forces); j++) {
                var key = string(target_forces[j]);
                if (!ds_map_exists(force_map, key)) {
                    ok_force = false;
                    break;
                }
            }
            ds_map_destroy(force_map);
        }
    }

    if (is_array(stakes_choice) && is_array(target_stakes)) {
        if (array_length(stakes_choice) == array_length(target_stakes)) {
            var stake_map = ds_map_create();
            for (var s = 0; s < array_length(stakes_choice); s++) {
                ds_map_set(stake_map, string(stakes_choice[s]), true);
            }
            ok_stakes = true;
            for (var t = 0; t < array_length(target_stakes); t++) {
                var skey = string(target_stakes[t]);
                if (!ds_map_exists(stake_map, skey)) {
                    ok_stakes = false;
                    break;
                }
            }
            ds_map_destroy(stake_map);
        }
    }

    var note = global.fc_item.design_note;
    var result = { ok_force: ok_force, ok_stakes: ok_stakes, explain: note };
    global.fc_result = result;

    return result;
}
