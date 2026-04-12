/// @function scr_friction_load()
/// @description Loads a friction lab scene based on vocabulary access.
function scr_friction_load() {
    var items = scr_jsonl_read("dataset/quizzes/friction_check.jsonl");
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
        show_debug_message("scr_friction_load: no items match vocabulary");
        return false;
    }

    global.fc_item = available[irandom(array_length(available) - 1)];
    global.fc_layout = scr_longtext_layout_create(global.fc_item.passage, 660, 24);
    global.fc_force_options = ["character", "society", "nature", "self"];
    global.fc_stake_options = ["personal", "external"];

    if (variable_global_exists("fc_force_selected")) {
        if (ds_exists(global.fc_force_selected, ds_type_map)) {
            ds_map_destroy(global.fc_force_selected);
        }
    }
    if (variable_global_exists("fc_stakes_selected")) {
        if (ds_exists(global.fc_stakes_selected, ds_type_map)) {
            ds_map_destroy(global.fc_stakes_selected);
        }
    }

    global.fc_force_selected = ds_map_create();
    global.fc_stakes_selected = ds_map_create();
    global.fc_result = undefined;

    return true;
}
