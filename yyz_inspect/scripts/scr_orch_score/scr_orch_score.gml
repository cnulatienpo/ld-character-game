/// @function scr_orch_score()
/// @description Scores the current mix against the target fader positions.
function scr_orch_score() {
    if (!is_struct(global.orch_round)) {
        return { score: 0, note: "Adjust until the blend settles." };
    }

    var target = global.orch_round.target;
    if (!is_struct(target)) {
        target = { emotion: 0.5, stakes: 0.5, pacing: 0.5 };
    }

    var mix = global.orch_mix;
    if (!is_struct(mix)) {
        mix = { emotion: 0.5, stakes: 0.5, pacing: 0.5 };
    }

    var de = clamp(real(variable_struct_get(mix, "emotion", 0.5)) - real(variable_struct_get(target, "emotion", 0.5)), -1, 1);
    var ds = clamp(real(variable_struct_get(mix, "stakes", 0.5)) - real(variable_struct_get(target, "stakes", 0.5)), -1, 1);
    var dp = clamp(real(variable_struct_get(mix, "pacing", 0.5)) - real(variable_struct_get(target, "pacing", 0.5)), -1, 1);

    var dist = sqrt(sqr(de) + sqr(ds) + sqr(dp));
    var max_dist = sqrt(3);
    var score = clamp(1 - dist / max_dist, 0, 1);

    var note = "Tune weight, warmth, and breath together.";
    if (is_string(global.orch_round.design_note) && string_length(global.orch_round.design_note) > 0) {
        note = global.orch_round.design_note;
    }

    global.orch_last_score = score;
    global.orch_feedback_line = note;

    return { score: score, note: note };
}
