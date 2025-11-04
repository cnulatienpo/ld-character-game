/// @function scr_mixmatch_submit()
/// @description Evaluates the player's pairings for the current mix & match round.
function scr_mixmatch_submit() {
    if (!is_array(global.mm_left)) {
        return { score: 0, explain: "" };
    }

    var total = array_length(global.mm_left);
    var correct = 0;

    for (var i = 0; i < total; i++) {
        var label = global.mm_left[i];
        var expected = variable_struct_get(global.mm_answer_map, label, -1);
        var actual = -1;
        if (ds_map_exists(global.mm_pairs_user, label)) {
            actual = ds_map_find_value(global.mm_pairs_user, label);
            if (is_array(global.mm_right_order) && actual >= 0 && actual < array_length(global.mm_right_order)) {
                actual = global.mm_right_order[actual];
            }
        }
        if (expected == actual) {
            correct += 1;
        }
    }

    var score = 0;
    if (total > 0) {
        score = correct / total;
    }

    var note = "";
    if (is_struct(global.mm_current)) {
        note = global.mm_current.design_note;
    }

    var result = { score: score, explain: note };
    global.mm_result = result;

    return result;
}
