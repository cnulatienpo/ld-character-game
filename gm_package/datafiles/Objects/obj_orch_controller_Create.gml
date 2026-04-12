/// obj_orch_controller : Create Event
// Sets up layouts and preview text for The Orchestra mini-game.
if (!is_struct(global.orch_round)) {
    show_debug_message("obj_orch_controller: orchestra round not loaded");
    instance_destroy();
    return;
}

goal_layout = scr_longtext_layout_create(global.orch_round.goal, 360, 12);
tips_layout = scr_longtext_layout_create(global.orch_round.tips, 360, 12);
preview_source = global.orch_preview_source;
current_mix = {
    emotion: global.orch_mix.emotion,
    stakes: global.orch_mix.stakes,
    pacing: global.orch_mix.pacing
};
preview_text = scr_orch_apply_to_text(preview_source, current_mix);
preview_layout = scr_longtext_layout_create(preview_text, 520, 20);
feedback_layout = scr_longtext_layout_create(global.orch_feedback_line, 520, 12);
feedback_source = global.orch_feedback_line;

panel_height = 360;

label_layout = scr_longtext_layout_create("Which one lands?", 360, 12);
