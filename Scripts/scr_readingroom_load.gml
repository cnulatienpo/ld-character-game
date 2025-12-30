/// @function scr_readingroom_load(item_map)
/// @description Prepares global state for the reading room using a quiz item as the source.
/// @param item_map Struct or map for the selected reading item.
function scr_readingroom_load(item_map) {
    global.reading_item = item_map;

    if (is_struct(item_map)) {
        global.reading_passage = item_map.passage;
        global.reading_answers = item_map.choices;
        global.reading_key_ranges = item_map.key_ranges;
        if (is_undefined(global.reading_key_ranges)) {
            global.reading_key_ranges = item_map.reading_key_ranges;
        }
    } else {
        global.reading_passage = ds_map_find_value(item_map, "passage");
        global.reading_answers = ds_map_find_value(item_map, "choices");
        global.reading_key_ranges = ds_map_find_value(item_map, "key_ranges");
        if (is_undefined(global.reading_key_ranges)) {
            global.reading_key_ranges = ds_map_find_value(item_map, "reading_key_ranges");
        }
    }

    if (!is_array(global.reading_key_ranges)) {
        global.reading_key_ranges = [];
    }

    global.reading_layout = scr_longtext_layout_create(global.reading_passage, 640, 32);
    global.reading_selected = scr_highlight_ranges_init();
    global.reading_feedback = undefined;
}
