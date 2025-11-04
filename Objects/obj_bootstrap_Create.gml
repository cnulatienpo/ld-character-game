/// obj_bootstrap : Create Event
// Temporary harness to demonstrate quiz and reading room loading. Comment/uncomment the sections
// you need while testing inside GameMaker Studio 2.

// --- Multiple-choice quiz demo ---
// global.player_vocab = ["balance","weight","rhythm","tension","contrast","pressure"];
// var quiz_pool = ["dataset/quizzes/spot_the_pressure.jsonl"];
// scr_quiz_load(quiz_pool, global.player_vocab);
// if (scr_quiz_next()) {
//     room_goto(room_quiz);
// }

// --- Reading room demo ---
// var reading_array = scr_jsonl_read("dataset/quizzes/friction_check.jsonl");
// if (ds_list_size(reading_array) > 0) {
//     global.reading_item = ds_list_find_value(reading_array, 0);
//     room_goto(room_reading);
// }
// ds_list_destroy(reading_array);

// --- Mix & Match demo ---
// scr_mixmatch_load();
// room_goto(room_mixmatch);

// --- Pattern & Break demo ---
// if (scr_pattern_load()) {
//     room_goto(room_pattern);
// }

// --- Friction Lab demo ---
// if (scr_friction_load()) {
//     room_goto(room_friction);
// }

// ORCHESTRA
// scr_orch_load(); room_goto(room_orchestra);

// SYMMETRY LAB
// scr_sym_load(); room_goto(room_symmetry);

// CHAIN REACTION
// var arr = scr_jsonl_read("dataset/chain_reaction.jsonl");
// if (ds_exists(arr, ds_type_list) && ds_list_size(arr) > 0) {
//     global.cr_item = ds_list_find_value(arr, 0);
//     global.cr_layout_start = undefined;
//     global.cr_layout_end = undefined;
//     global.cr_layout_options = undefined;
//     global.cr_feedback_line = "Which middle keeps it moving?";
//     global.cr_current_idx = 0;
//     room_goto(room_chain);
// }
// if (ds_exists(arr, ds_type_list)) ds_list_destroy(arr);

// WORD GARDEN
scr_garden_load(); room_goto(room_garden);

// GRAVITY TEST
// scr_gravity_load(); room_goto(room_gravity);

// THE MUSEUM GAME
// scr_museum_load(); room_goto(room_museum);
