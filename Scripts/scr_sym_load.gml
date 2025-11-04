/// @function scr_sym_load()
/// @description Loads a Symmetry Lab round and initialises shared state.
function scr_sym_load() {
    var data = scr_json_read("dataset/symmetry_rounds.json");
    if (!is_struct(data) || !is_array(data.rounds)) {
        show_debug_message("scr_sym_load: dataset missing or malformed");
        return false;
    }

    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    var rounds = data.rounds;
    var candidates = [];
    for (var i = 0; i < array_length(rounds); i++) {
        var entry = rounds[i];
        if (scr_vocab_allows(entry, vocab)) {
            array_push(candidates, entry);
        }
    }

    if (array_length(candidates) == 0) {
        show_debug_message("scr_sym_load: no eligible rounds for player vocab");
        return false;
    }

    var pick = candidates[irandom(array_length(candidates) - 1)];

    global.sym_round = pick;
    global.sym_mode = string(variable_struct_get(pick, "mode", "text"));
    global.sym_fold_x = room_width * 0.5;
    global.sym_feedback = "Slide the fold until it feels settled.";

    if (global.sym_mode == "text") {
        var passage = string(variable_struct_get(pick, "passage", ""));
        global.sym_text_layout = scr_longtext_layout_create(passage, 640, 32);
    } else {
        global.sym_text_layout = undefined;
    }

    global.sym_panel_left = 160;
    global.sym_panel_width = 640;

    return true;
}
