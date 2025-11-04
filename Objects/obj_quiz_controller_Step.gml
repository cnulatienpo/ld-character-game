/// obj_quiz_controller : Step Event
// Syncs quiz choice buttons with the active item and polls for new rounds.

if (is_undefined(global.quiz_current)) {
    return;
}

var current_item = global.quiz_current;
var item_id;
if (is_struct(current_item) && variable_struct_exists(current_item, "id")) {
    item_id = current_item.id;
} else if (!is_undefined(current_item) && ds_exists(current_item, ds_type_map) && ds_map_exists(current_item, "id")) {
    item_id = ds_map_find_value(current_item, "id");
} else {
    item_id = current_item;
}

if (item_id == last_item_id) {
    return;
}

last_item_id = item_id;

var choices;
if (is_struct(current_item) && variable_struct_exists(current_item, "choices")) {
    choices = current_item.choices;
} else if (!is_undefined(current_item) && ds_exists(current_item, ds_type_map)) {
    choices = ds_map_find_value(current_item, "choices");
}

if (!is_array(choices)) {
    return;
}

choice_assign_index = 0;
choice_assign_data = choices;

with (obj_quiz_choice) {
    var idx = other.choice_assign_index;
    other.choice_assign_index += 1;

    my_id = "";
    my_text = "";

    if (!is_array(other.choice_assign_data)) {
        continue;
    }

    if (idx >= array_length(other.choice_assign_data)) {
        continue;
    }

    var entry = other.choice_assign_data[idx];
    if (is_struct(entry)) {
        my_id = entry.id;
        my_text = entry.text;
    } else if (!is_undefined(entry) && ds_exists(entry, ds_type_map)) {
        my_id = ds_map_find_value(entry, "id");
        my_text = ds_map_find_value(entry, "text");
    }
}
