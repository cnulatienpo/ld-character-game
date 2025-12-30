/// obj_bootstrap : Create Event
// Sets up the core globals and kicks off the character learning loop.

// Ensure the gate object exists so we can route between rooms.
if (!instance_exists(obj_gate)) {
    var gate = instance_create_layer(-100, -100, "Instances", obj_gate);
    gate.visible = false;
}

// Basic globals for the player's vocabulary and meta progress.
global.player_vocab = ["moment","want","feeling","choice","balance","weight","pattern","pressure"];

if (variable_global_exists("completed_seeds")) {
    if (ds_exists(global.completed_seeds, ds_type_list)) {
        ds_list_destroy(global.completed_seeds);
    }
}
global.completed_seeds = ds_list_create();

if (variable_global_exists("unlocked_signals")) {
    if (ds_exists(global.unlocked_signals, ds_type_list)) {
        ds_list_destroy(global.unlocked_signals);
    }
}
global.unlocked_signals = ds_list_create();

// Load the dataset index with a safe fallback if the file is unavailable.
var dataset_index = scr_json_read("dataset/index.json");
if (is_undefined(dataset_index)) {
    dataset_index = {
        seeders : ["character_full_master.seeder.json"],
        quizzes : ["dataset/quizzes/spot_the_pressure.jsonl"],
    };
}
global.dataset_index = dataset_index;

// Choose the first lesson seed.
global.current_seed_id = "desc_what_it_is";

// Mark the current lesson metadata so UI objects know what to show.
global.lesson_feedback = "";
global.grader_feedback = "";
global.grader_feedback_compact = "";
global.grader_pending = false;

// Jump straight into the lesson room after setup completes.
room_goto(room_lesson);
