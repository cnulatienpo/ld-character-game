/// obj_mm_controller : Create Event
// Loads a mix & match round and clears prior feedback.

var loaded = scr_mixmatch_load();
if (!loaded) {
    global.mm_left = ["signal", "pressure", "balance", "pattern", "weight"];
    global.mm_right = ["A gentle push.", "A hard lean.", "A steady beat.", "A sudden break.", "A quiet wait."];
    global.mm_right_order = [0, 1, 2, 3, 4];
    global.mm_answer_map = ds_map_create();
    if (variable_global_exists("mm_pairs_user") && ds_exists(global.mm_pairs_user, ds_type_map)) {
        ds_map_destroy(global.mm_pairs_user);
    }
    global.mm_pairs_user = ds_map_create();
}

global.mm_feedback = "";
global.mm_result = undefined;
