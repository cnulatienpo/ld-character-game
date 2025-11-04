/// obj_museum_controller : Draw Event
// Renders the question prompt and feedback sentence.
if (!is_struct(global.museum_round)) {
    exit;
}

draw_set_color(c_black);
draw_text_ext(64, 64, question_text, 28, 520);

draw_text(64, 120, "Look across the rooms and tag what carries the weight.");

if (is_struct(global.museum_result)) {
    var score_text = "Score: " + string_format(global.museum_result.score * 100, 0, 0) + "%";
    draw_text(64, 152, score_text);
}

if (is_string(global.museum_feedback_sentence) && string_length(global.museum_feedback_sentence) > 0) {
    draw_text(64, 560, global.museum_feedback_sentence);
}
