/// @function scr_quiz_load(pool_paths_array, vocab_array)
/// @description Loads quiz items from the provided JSONL files, filters by vocabulary, and stores them globally.
/// @param pool_paths_array Array of file path strings pointing to JSONL datasets.
/// @param vocab_array Array of strings representing the player's known vocabulary.
function scr_quiz_load(pool_paths_array, vocab_array) {
    // Ensure we start with a clean queue every time the loader runs.
    if (ds_exists(global.quiz_items, ds_type_list)) {
        ds_list_destroy(global.quiz_items);
    }
    global.quiz_items = ds_list_create();

    // Iterate over every file path supplied in the pool list.
    for (var i = 0; i < array_length(pool_paths_array); i++) {
        var path = pool_paths_array[i];
        var entries = scr_jsonl_read(path);

        // Merge allowed items into the global quiz queue.
        for (var j = 0; j < ds_list_size(entries); j++) {
            var item = ds_list_find_value(entries, j);
            if (scr_vocab_allows(item, vocab_array)) {
                ds_list_add(global.quiz_items, item);
            }
        }

        // Clean up the temporary list created by scr_jsonl_read.
        ds_list_destroy(entries);
    }

    // Shuffle the queue to keep the quiz experience fresh.
    if (ds_list_size(global.quiz_items) > 1) {
        ds_list_shuffle(global.quiz_items);
    }

    // Reset per-question globals so the UI can update cleanly when the first item appears.
    global.quiz_current = undefined;
    global.quiz_feedback = undefined;
    global.quiz_layout = undefined;
    global.quiz_correct = undefined;
    global.quiz_choice = undefined;
}
