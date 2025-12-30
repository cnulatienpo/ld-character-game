/// @function scr_orch_load()
/// @description Loads an Orchestra round definition and prepares shared state.
function scr_orch_load() {
    var data = scr_json_read("dataset/orchestra_rounds.json");
    if (!is_struct(data) || !is_array(data.rounds)) {
        show_debug_message("scr_orch_load: dataset missing or malformed");
        return false;
    }

    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    var rounds = data.rounds;
    var candidates = [];
    for (var i = 0; i < array_length(rounds); i++) {
        var entry = rounds[i];
        if (scr_vocab_allows(entry, vocab)) {
            array_push(candidates, entry);
        }
    }

    if (array_length(candidates) == 0) {
        show_debug_message("scr_orch_load: no eligible rounds for current vocabulary");
        return false;
    }

    var pick = candidates[irandom(array_length(candidates) - 1)];

    var target_defaults = { emotion: 0.5, stakes: 0.5, pacing: 0.5 };
    if (is_struct(pick.target)) {
        target_defaults.emotion = clamp(real(variable_struct_get(pick.target, "emotion", 0.5)), 0, 1);
        target_defaults.stakes = clamp(real(variable_struct_get(pick.target, "stakes", 0.5)), 0, 1);
        target_defaults.pacing = clamp(real(variable_struct_get(pick.target, "pacing", 0.5)), 0, 1);
    }

    global.orch_round = {
        id: variable_struct_get(pick, "id", ""),
        goal: variable_struct_get(pick, "goal", "Shape the tone."),
        tips: variable_struct_get(pick, "tips", "Ease emotion, weigh stakes, balance pacing."),
        target: target_defaults,
        preview_passage: variable_struct_get(pick, "preview_passage", ""),
        design_note: variable_struct_get(pick, "design_note", "Tune weight, warmth, and breath together."),
        requires_vocabulary: variable_struct_get(pick, "requires_vocabulary", [])
    };

    global.orch_mix = {
        emotion: 0.5,
        stakes: 0.5,
        pacing: 0.5
    };

    global.orch_preview_source = string(global.orch_round.preview_passage);
    global.orch_feedback_line = "Slide the faders until the feel lands.";
    global.orch_last_score = 0;

    return true;
}
