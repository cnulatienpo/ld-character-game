/// obj_quiz_controller : Create Event
// Loads the quiz pool using the player's vocabulary.

var pool = ["dataset/quizzes/spot_the_pressure.jsonl"];
scr_quiz_load(pool, global.player_vocab);

if (!scr_quiz_next()) {
    global.quiz_current = undefined;
}

// Cache reference so we can assign buttons when the prompt changes.
last_item_id = -1;
