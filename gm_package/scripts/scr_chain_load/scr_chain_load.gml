/// @function scr_chain_load()
/// @description Loads a Chain Reaction prompt and prepares layouts for each passage segment.
function scr_chain_load() {
    var items = scr_jsonl_read("dataset/chain_reaction.jsonl");
    if (!ds_exists(items, ds_type_list) || ds_list_size(items) == 0) {
        show_debug_message("scr_chain_load: dataset missing or empty");
        return false;
    }

    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    var candidates = [];
    for (var i = 0; i < ds_list_size(items); i++) {
        var entry = ds_list_find_value(items, i);
        if (scr_vocab_allows(entry, vocab)) {
            array_push(candidates, entry);
        }
    }

    ds_list_destroy(items);

    if (array_length(candidates) == 0) {
        show_debug_message("scr_chain_load: no entries matched vocabulary");
        return false;
    }

    var pick = candidates[irandom(array_length(candidates) - 1)];

    global.cr_item = pick;
    global.cr_current_idx = 0;
    global.cr_feedback_line = "Which middle keeps it moving?";

    var start_text = string(variable_struct_get(pick, "start", ""));
    var end_text = string(variable_struct_get(pick, "end", ""));
    var options_array = variable_struct_get(pick, "options", []);

    global.cr_layout_start = scr_longtext_layout_create(start_text, 360, 24);
    global.cr_layout_end = scr_longtext_layout_create(end_text, 360, 24);

    var option_layouts = [];
    if (is_array(options_array)) {
        for (var j = 0; j < array_length(options_array); j++) {
            var opt_text = string(options_array[j]);
            option_layouts[j] = scr_longtext_layout_create(opt_text, 360, 24);
        }
    }
    global.cr_layout_options = option_layouts;

    return true;
}
