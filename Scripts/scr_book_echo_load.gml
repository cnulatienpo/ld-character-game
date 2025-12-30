/// @function scr_book_echo_load()
/// @description Loads a generous passage for the echo spotting activity.
function scr_book_echo_load() {
    var list = scr_jsonl_read("dataset/quizzes/spot_the_pressure.jsonl");
    if (!ds_exists(list, ds_type_list) || ds_list_size(list) == 0) {
        show_debug_message("scr_book_echo_load: dataset unavailable");
        return false;
    }

    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    var pool = [];
    var size = ds_list_size(list);
    for (var i = 0; i < size; i++) {
        var entry = list[| i];
        if (is_struct(entry)) {
            if (scr_vocab_allows(entry, vocab)) {
                array_push(pool, entry);
            }
        }
    }

    if (array_length(pool) == 0) {
        for (var j = 0; j < size; j++) {
            var fallback = list[| j];
            if (is_struct(fallback)) {
                array_push(pool, fallback);
            }
        }
    }

    ds_list_destroy(list);

    if (array_length(pool) == 0) {
        show_debug_message("scr_book_echo_load: no entries found");
        return false;
    }

    var pick = pool[irandom(array_length(pool) - 1)];
    var passage = string(pick.passage);
    var title = string(pick.stem);

    global.db_echo_item = pick;
    global.db_echo_passage_text = passage;
    global.db_echo_prompt_text = title;

    var layout = scr_longtext_layout_create(passage, 640, 40);
    global.db_echo_layout = layout;

    if (ds_exists(global.db_echo_hits, ds_type_list)) {
        ds_list_clear(global.db_echo_hits);
    } else {
        global.db_echo_hits = ds_list_create();
    }

    var scan_text = string_lower(passage);
    scan_text = string_replace_all(scan_text, "\n", " ");
    scan_text = string_replace_all(scan_text, ",", "");
    scan_text = string_replace_all(scan_text, ".", "");
    scan_text = string_replace_all(scan_text, ";", "");
    scan_text = string_replace_all(scan_text, ":", "");

    var raw_tokens = string_split(scan_text, " ");
    var tokens = [];
    for (var t = 0; t < array_length(raw_tokens); t++) {
        var token = string_trim(raw_tokens[t]);
        if (token != "") {
            array_push(tokens, token);
        }
    }

    var counts = ds_map_create();
    for (var k = 0; k <= array_length(tokens) - 3; k++) {
        var phrase = tokens[k] + " " + tokens[k + 1] + " " + tokens[k + 2];
        if (ds_map_exists(counts, phrase)) {
            counts[? phrase] = counts[? phrase] + 1;
        } else {
            counts[? phrase] = 1;
        }
    }

    var echoes = [];
    var keys = ds_map_keys(counts);
    for (var m = 0; m < array_length(keys); m++) {
        var key = keys[m];
        if (counts[? key] > 1) {
            array_push(echoes, key);
        }
    }
    ds_list_destroy(keys);
    ds_map_destroy(counts);

    var lines = layout.lines;
    var flags = array_create(array_length(lines), false);
    for (var n = 0; n < array_length(lines); n++) {
        var line_text = string_lower(string(lines[n]));
        for (var e = 0; e < array_length(echoes); e++) {
            var phrase_key = echoes[e];
            if (phrase_key != "" && string_pos(phrase_key, line_text) > 0) {
                flags[n] = true;
                break;
            }
        }
    }

    global.db_echo_targets = flags;
    global.db_echo_reveal = [];

    return true;
}
