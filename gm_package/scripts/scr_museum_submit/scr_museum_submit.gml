/// @function scr_museum_submit(picks_array)
/// @description Scores the Museum Game selections and returns a summary.
function scr_museum_submit(picks_array) {
    if (!is_array(picks_array) || !is_array(global.m_answers)) {
        return { score: 0, note: "The pause is tension; equal mass is balance." };
    }

    var total = array_length(global.m_answers);
    if (total == 0) {
        return { score: 0, note: "The pause is tension; equal mass is balance." };
    }

    var correct = 0;
    for (var i = 0; i < total; i++) {
        var answer = string(global.m_answers[i]);
        var pick = "";
        if (i < array_length(picks_array)) {
            pick = string(picks_array[i]);
        }
        if (pick == answer) {
            correct += 1;
        }
    }

    var score_value = correct / total;
    var note_text = global.museum_round.design_note;
    if (!is_string(note_text) || string_length(note_text) == 0) {
        note_text = "The pause is tension; equal mass is balance.";
    }

    return { score: score_value, note: note_text };
}
