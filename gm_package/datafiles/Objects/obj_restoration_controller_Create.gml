/// obj_restoration_controller : Create Event
// Loads the restoration round data.
if (!scr_restoration_load()) {
    show_debug_message("obj_restoration_controller: unable to load round");
    instance_destroy();
    exit;
}

global.rg_note = "";
