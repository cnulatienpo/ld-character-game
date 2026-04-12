/// obj_museum_check : Left Pressed Event
// Scores the Museum Game selections and stores feedback.
if (!point_in_rectangle(mouse_x, mouse_y, x, y, x + button_width, y + button_height)) {
    exit;
}

if (!is_array(global.museum_picks) || !is_array(global.m_answers)) {
    exit;
}

var count = array_length(global.museum_picks);
var picks = array_create(count, "");
for (var i = 0; i < count; i++) {
    picks[i] = string(global.museum_picks[i]);
}

var result = scr_museum_submit(picks);
global.museum_result = result;

global.museum_feedback_sentence = "The pause is tension; equal mass is balance.";

var matches = array_create(count, "");
for (var j = 0; j < count; j++) {
    var answer = "";
    if (j < array_length(global.m_answers)) {
        answer = string(global.m_answers[j]);
    }
    var pick = picks[j];
    if (pick == "") {
        matches[j] = "";
    } else if (pick == answer) {
        matches[j] = "correct";
    } else {
        matches[j] = "wrong";
    }
}

global.museum_matches = matches;
