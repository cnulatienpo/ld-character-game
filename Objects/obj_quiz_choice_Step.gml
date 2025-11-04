/// obj_quiz_choice : Step Event
// Updates button text from the active quiz item and tracks hover state.
if (!is_undefined(global.quiz_current)) {
    var choices = is_struct(global.quiz_current) ? global.quiz_current.choices : ds_map_find_value(global.quiz_current, "choices");
    if (is_array(choices)) {
        for (var i = 0; i < array_length(choices); i++) {
            var choice = choices[i];
            var choice_id = is_struct(choice) ? choice.id : ds_map_find_value(choice, "id");
            if (choice_id == my_id) {
                my_text = is_struct(choice) ? choice.text : ds_map_find_value(choice, "text");
                break;
            }
        }
    }
}

hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height);
