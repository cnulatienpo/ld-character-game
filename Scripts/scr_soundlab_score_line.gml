/// @function scr_soundlab_score_line(text)
/// @description Provides cadence guidance for a custom line in Sound Lab.
function scr_soundlab_score_line(text) {
    var input_text = string_trim(string(text));
    if (input_text == "") {
        return { ok: false, note: "Try a few clipped strokes to match the beat." };
    }

    input_text = string_replace_all(input_text, "\n", " ");

    var words = string_split(input_text, " ");
    var word_count = array_length(words);

    var clause_breaks = 1;
    for (var i = 0; i < string_length(input_text); i++) {
        var ch = string_char_at(input_text, i + 1);
        if (ch == "." || ch == "," || ch == ";") {
            clause_breaks += 1;
        }
    }

    var steps = is_array(global.sl_pattern_tokens) ? array_length(global.sl_pattern_tokens) : 1;
    if (steps <= 0) {
        steps = 1;
    }

    var avg_words = word_count / steps;
    var avg_breaks = clause_breaks / steps;

    var note;
    if (avg_words <= 4 && avg_breaks >= 1) {
        note = "Your line clips along; the beat should land well.";
    } else if (avg_words > 6) {
        note = "Your line lingers; try shorter units to match the beat.";
    } else {
        note = "Watch the pauses; trim or add a beat to settle it.";
    }

    return { ok: (avg_words <= 5), note: note };
}
