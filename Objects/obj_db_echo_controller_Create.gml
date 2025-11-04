/// obj_db_echo_controller : Create Event
// Loads a passage for the echo spotting page.
if (!scr_book_echo_load()) {
    show_debug_message("obj_db_echo_controller: unable to load passage");
    instance_destroy();
    exit;
}

global.db_echo_note = "";
