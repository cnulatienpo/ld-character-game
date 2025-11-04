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
