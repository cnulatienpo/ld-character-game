/// @function scr_vocab_allows(item_map, vocab_array)
/// @description Returns true if the item requires no special vocabulary or the player has all required words.
/// @param item_map Struct or map representing a quiz entry.
/// @param vocab_array Array of vocabulary strings available to the player.
function scr_vocab_allows(item_map, vocab_array) {
    // Pull the requires_vocabulary field from the item. Missing data is treated as empty.
    var required = undefined;
    if (is_struct(item_map)) {
        required = item_map.requires_vocabulary;
    } else if (ds_exists(item_map, ds_type_map)) {
        required = ds_map_find_value(item_map, "requires_vocabulary");
    }

    if (is_undefined(required)) {
        return true;
    }

    // Normalize a single string into an array for safety. Most items provide an array already.
    if (!is_array(required)) {
        required = [string(required)];
    }

    // Empty requirement arrays automatically pass.
    if (array_length(required) == 0) {
        return true;
    }

    // Build a quick lookup of the player's vocabulary to allow O(1) membership tests.
    var lookup = ds_map_create();
    for (var i = 0; i < array_length(vocab_array); i++) {
        var word = string(vocab_array[i]);
        ds_map_set(lookup, word, true);
    }

    // Verify every required word exists in the player's vocabulary list.
    var allowed = true;
    for (var j = 0; j < array_length(required); j++) {
        var req_word = string(required[j]);
        if (!ds_map_exists(lookup, req_word)) {
            allowed = false;
            break;
        }
    }

    ds_map_destroy(lookup);
    return allowed;
}
