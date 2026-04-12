/// obj_gt_controller : Create Event
// Ensures Gravity Test data is ready.
if (!is_struct(global.gt_item)) {
    if (!scr_gravity_load()) {
        show_debug_message("obj_gt_controller: unable to load passage");
        instance_destroy();
        exit;
    }
}

question_text = "Which ending settles better?";
