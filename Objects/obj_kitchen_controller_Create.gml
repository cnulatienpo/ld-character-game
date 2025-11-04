/// obj_kitchen_controller : Create Event
// Sets up runtime values for the Form Kitchen room.
goal_wrap = scr_quiz_text_wrap(global.kit_round.goal, 340, 8);
tips_wrap = scr_quiz_text_wrap(global.kit_round.tips, 340, 8);
explain_wrap = scr_quiz_text_wrap(global.kit_round.explain, 340, 8);
feedback_wrap = undefined;
preview_seed = is_array(global.kit_round.sample) ? global.kit_round.sample[global.kit_sample_pick] : "Steam lifts from the pan.";
preview_lines = scr_quiz_text_wrap(preview_seed, 360, 8);
note_alpha = 1;
