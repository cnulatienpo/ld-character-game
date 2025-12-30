/// obj_reading_question : Draw Event
// Shows the prompt for the highlight activity.
if (is_undefined(global.reading_item)) {
    return;
}

var stem = is_struct(global.reading_item) ? global.reading_item.stem : ds_map_find_value(global.reading_item, "stem");
draw_set_color(c_black);
draw_text(48, 32, string(stem));
