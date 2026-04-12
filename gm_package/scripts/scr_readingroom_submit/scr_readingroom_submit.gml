/// @function scr_readingroom_submit(selected_ranges)
/// @description Compares user highlight selections with the key ranges and returns feedback data.
/// @param selected_ranges Array of [start,end] ranges chosen by the player.
function scr_readingroom_submit(selected_ranges) {
    if (!is_array(selected_ranges)) {
        selected_ranges = [];
    }

    if (!is_array(global.reading_key_ranges) || array_length(global.reading_key_ranges) == 0) {
        return {
            match_ratio: 1,
            explain: "The key lines are all about the shift in weight."
        };
    }

    var matches = 0;
    for (var i = 0; i < array_length(global.reading_key_ranges); i++) {
        var key_range = global.reading_key_ranges[i];
        if (!is_array(key_range) || array_length(key_range) < 2) {
            continue;
        }

        var key_start = key_range[0];
        var key_end = key_range[1];
        var found = false;

        for (var j = 0; j < array_length(selected_ranges); j++) {
            var sel_range = selected_ranges[j];
            if (!is_array(sel_range) || array_length(sel_range) < 2) {
                continue;
            }

            var sel_start = sel_range[0];
            var sel_end = sel_range[1];

            if (sel_end < key_start) continue;
            if (sel_start > key_end) continue;

            found = true;
            break;
        }

        if (found) {
            matches += 1;
        }
    }

    var total_keys = max(1, array_length(global.reading_key_ranges));
    var ratio = matches / total_keys;

    var design_note;
    if (is_struct(global.reading_item)) {
        design_note = global.reading_item.design_note;
    } else if (ds_exists(global.reading_item, ds_type_map)) {
        design_note = ds_map_find_value(global.reading_item, "design_note");
    }

    if (is_undefined(design_note) || design_note == "") {
        design_note = "The key lines press on how the room shifts.";
    }

    return {
        match_ratio: ratio,
        explain: string(design_note)
    };
}
