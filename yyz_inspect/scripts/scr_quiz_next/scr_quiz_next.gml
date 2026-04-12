/// @function scr_quiz_next()
/// @description Pops the next quiz item into global state. Returns false if the queue is empty.
function scr_quiz_next() {
    if (!ds_exists(global.quiz_items, ds_type_list)) {
        return false;
    }

    if (ds_list_size(global.quiz_items) <= 0) {
        global.quiz_current = undefined;
        return false;
    }

    // Grab the first item from the queue and remove it.
    var item = ds_list_find_value(global.quiz_items, 0);
    ds_list_delete(global.quiz_items, 0);

    global.quiz_current = item;
    global.quiz_choice = undefined;
    global.quiz_feedback = undefined;
    global.quiz_correct = undefined;

    // Build a reusable text layout for the passage so drawing and highlighting stay in sync.
    var passage_text;
    if (is_struct(item)) {
        passage_text = item.passage;
    } else {
        passage_text = ds_map_find_value(item, "passage");
    }

    var layout_width = 640;
    var margin = 32;
    global.quiz_layout = scr_longtext_layout_create(passage_text, layout_width, margin);

    return true;
}
