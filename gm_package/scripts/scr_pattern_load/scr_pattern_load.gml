/// @function scr_pattern_load()
/// @description Loads a pattern & break item respecting the player's vocabulary.
function scr_pattern_load() {
    var items = scr_jsonl_read("dataset/quizzes/pattern_and_break.jsonl");
    if (ds_list_size(items) == 0) {
        return false;
    }

    var available = [];
    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    for (var i = 0; i < ds_list_size(items); i++) {
        var entry = ds_list_find_value(items, i);
        if (scr_vocab_allows(entry, vocab)) {
            array_push(available, entry);
        }
    }

    ds_list_destroy(items);

    if (array_length(available) == 0) {
        show_debug_message("scr_pattern_load: no items match vocabulary");
        return false;
    }

    global.pb_item = available[irandom(array_length(available) - 1)];
    global.pb_layout = scr_longtext_layout_create(global.pb_item.passage, 660, 24);
    global.pb_mode = 0;
    global.pb_pick_pattern = -1;
    global.pb_pick_break = -1;
    global.pb_result = undefined;

    return true;
}
