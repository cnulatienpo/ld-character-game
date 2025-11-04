/// @function scr_museum_load()
/// @description Loads a Museum Game round and prepares player pick storage.
function scr_museum_load() {
    var data = scr_json_read("dataset/museum_rounds.json");
    if (!is_struct(data) || !is_array(data.rounds)) {
        show_debug_message("scr_museum_load: dataset missing or malformed");
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
        show_debug_message("scr_museum_load: no eligible rounds for player vocab");
        return false;
    }

    var pick = candidates[irandom(array_length(candidates) - 1)];
    global.museum_round = pick;
    global.m_items = pick.items;
    global.m_choices = pick.choices;
    global.m_answers = pick.answers;

    var count = array_length(global.m_items);
    global.museum_picks = array_create(count, "");
    global.museum_matches = array_create(count, "");
    global.museum_result = undefined;
    global.museum_feedback_sentence = undefined;

    return true;
}
