/// obj_museum_controller : Create Event
// Ensures the Museum Game data is ready.
if (!is_struct(global.museum_round)) {
    if (!scr_museum_load()) {
        show_debug_message("obj_museum_controller: unable to load round");
        instance_destroy();
        exit;
    }
}

question_text = string(global.museum_round.question);
if (string_length(question_text) == 0) {
    question_text = "Which part feels heavier?";
}
