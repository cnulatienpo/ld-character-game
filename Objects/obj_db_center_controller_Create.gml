/// obj_db_center_controller : Create Event
// Loads data for the center activity.
if (!scr_book_center_load()) {
    show_debug_message("obj_db_center_controller: unable to load center activity");
    instance_destroy();
    exit;
}

global.db_center_prompt = "Tap where the frame feels anchored.\n\nLet the weight tell you.";
