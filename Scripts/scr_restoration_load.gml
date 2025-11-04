/// @function scr_restoration_load()
/// @description Loads a restoration round and prepares working state.
function scr_restoration_load() {
    var data = scr_json_read("dataset/restoration_rounds.json");
    if (!is_struct(data) || !is_array(data.rounds)) {
        show_debug_message("scr_restoration_load: dataset missing or malformed");
        return false;
    }

    var rounds = data.rounds;
    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    var pool = [];
    for (var i = 0; i < array_length(rounds); i++) {
        var entry = rounds[i];
        if (scr_vocab_allows(entry, vocab)) {
            array_push(pool, entry);
        }
    }

    if (array_length(pool) == 0) {
        pool = rounds;
    }

    if (array_length(pool) == 0) {
        show_debug_message("scr_restoration_load: no rounds ready");
        return false;
    }

    var pick = pool[irandom(array_length(pool) - 1)];

    global.rg_round = pick;
    global.rg_current_text = string(pick.base);
    global.rg_palette = pick.palette;
    global.rg_applied_ids = [];
    global.rg_applied_tags = [];
    global.rg_feedback_note = "";
    global.rg_layout = scr_longtext_layout_create(global.rg_current_text, 520, 24);
    global.rg_layout.scroll = 0;

    return true;
}
