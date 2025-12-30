/// @function scr_gravity_load()
/// @description Loads a Gravity Test passage and prepares layout data.
function scr_gravity_load() {
    var list = scr_jsonl_read("dataset/outcome_pairs.jsonl");
    if (!ds_exists(list, ds_type_list) || ds_list_size(list) == 0) {
        show_debug_message("scr_gravity_load: no passages found");
        return false;
    }

    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    var candidates = [];
    for (var i = 0; i < ds_list_size(list); i++) {
        var entry = ds_list_find_value(list, i);
        if (scr_vocab_allows(entry, vocab)) {
            array_push(candidates, entry);
        }
    }

    ds_list_destroy(list);

    if (array_length(candidates) == 0) {
        show_debug_message("scr_gravity_load: no entries matched vocabulary");
        return false;
    }

    var pick = candidates[irandom(array_length(candidates) - 1)];
    global.gt_item = pick;
    global.gt_choice = "left";
    global.gt_result = undefined;
    global.gt_feedback = undefined;

    var layout_width = 520;
    global.gt_layout = scr_longtext_layout_create(pick.passage, layout_width, 24);

    return true;
}
