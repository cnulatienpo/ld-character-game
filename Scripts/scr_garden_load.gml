/// @function scr_garden_load()
/// @description Loads a Word Garden round and prepares draggable word data.
function scr_garden_load() {
    var data = scr_json_read("dataset/word_garden_rounds.json");
    if (!is_struct(data) || !is_array(data.rounds)) {
        show_debug_message("scr_garden_load: dataset missing or malformed");
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
        show_debug_message("scr_garden_load: no eligible rounds");
        return false;
    }

    var pick = pool[irandom(array_length(pool) - 1)];
    global.garden_round = pick;

    if (variable_global_exists("garden_words")) {
        if (ds_exists(global.garden_words, ds_type_list)) {
            ds_list_destroy(global.garden_words);
        }
    }

    var words_list = ds_list_create();
    var word_array = pick.words;
    var start_x = 160;
    var start_y = 200;
    var column_width = 160;
    var row_height = 60;

    for (var w = 0; w < array_length(word_array); w++) {
        var word_label = string(word_array[w]);
        var col = w mod 2;
        var row = w div 2;
        var wx = start_x + col * column_width;
        var wy = start_y + row * row_height;
        var word_struct = {
            label: word_label,
            x: wx,
            y: wy,
            tier: "low"
        };
        ds_list_add(words_list, word_struct);
    }

    global.garden_words = words_list;

    global.garden_beds = [
        { tier: "tall", rect: { x1: 520, y1: 120, x2: 760, y2: 220 }, label: "tall" },
        { tier: "mid", rect: { x1: 520, y1: 240, x2: 760, y2: 340 }, label: "mid" },
        { tier: "low", rect: { x1: 520, y1: 360, x2: 760, y2: 460 }, label: "low" }
    ];

    global.garden_result = undefined;
    global.garden_feedback_note = "Leader is clear; support is visible; background is quiet.";
    global.garden_hover_tier = undefined;

    return true;
}
