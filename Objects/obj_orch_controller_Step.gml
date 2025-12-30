/// obj_orch_controller : Step Event
// Updates preview and feedback layouts as the mix changes.
if (is_struct(global.orch_mix)) {
    var mix = global.orch_mix;
    if (mix.emotion != current_mix.emotion || mix.stakes != current_mix.stakes || mix.pacing != current_mix.pacing) {
        current_mix = {
            emotion: mix.emotion,
            stakes: mix.stakes,
            pacing: mix.pacing
        };
        preview_text = scr_orch_apply_to_text(preview_source, current_mix);
        preview_layout = scr_longtext_layout_create(preview_text, 520, 20);
    }
}

if (is_string(global.orch_feedback_line) && global.orch_feedback_line != feedback_source) {
    feedback_source = global.orch_feedback_line;
    feedback_layout = scr_longtext_layout_create(feedback_source, 520, 12);
}
