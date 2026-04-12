/// @function scr_mixmatch_load()
/// @description Loads mix & match data and prepares the current round state.
function scr_mixmatch_load() {
    var data = scr_json_read("dataset/match_items.json");
    if (is_undefined(data)) {
        show_debug_message("scr_mixmatch_load: dataset missing");
        return false;
    }

    global.mm_rounds = data.rounds;
    if (!is_array(global.mm_rounds) || array_length(global.mm_rounds) == 0) {
        show_debug_message("scr_mixmatch_load: no rounds available");
        return false;
    }

    global.mm_index = irandom(array_length(global.mm_rounds) - 1);
    global.mm_current = global.mm_rounds[global.mm_index];

    global.mm_left = global.mm_current.left;
    var right_data = global.mm_current.right;
    var order = [];
    for (var i = 0; i < array_length(right_data); i++) {
        array_push(order, i);
    }
    for (var j = array_length(order) - 1; j >= 1; j--) {
        var swap_index = irandom(j);
        var tmp = order[j];
        order[j] = order[swap_index];
        order[swap_index] = tmp;
    }
    global.mm_right_order = order;
    global.mm_right = [];
    for (var k = 0; k < array_length(order); k++) {
        array_push(global.mm_right, right_data[order[k]]);
    }
    global.mm_answer_map = global.mm_current.answer;

    if (variable_global_exists("mm_pairs_user")) {
        if (ds_exists(global.mm_pairs_user, ds_type_map)) {
            ds_map_destroy(global.mm_pairs_user);
        }
    }
    global.mm_pairs_user = ds_map_create();

    global.mm_result = undefined;

    return true;
}
