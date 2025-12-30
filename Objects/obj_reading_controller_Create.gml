/// obj_reading_controller : Create Event
// Loads a generous reading selection and prepares highlight helpers.

var reading_list = scr_jsonl_read("dataset/quizzes/friction_check.jsonl");
var picked_item;

if (ds_exists(reading_list, ds_type_list) && ds_list_size(reading_list) > 0) {
    picked_item = ds_list_find_value(reading_list, 0);
}

ds_list_destroy(reading_list);

if (is_undefined(picked_item)) {
    picked_item = {
        stem : "Which sentence leans the hardest into the tension?",
        passage : "The room waits. The air hums. The decision presses." ,
        key_ranges : []
    };
}

global.reading_item = picked_item;
scr_readingroom_load(global.reading_item);
