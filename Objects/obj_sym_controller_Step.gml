/// obj_sym_controller : Step Event
// Syncs shared values and refreshes layouts when feedback changes.
global.sym_panel_left = panel_left;
global.sym_panel_width = panel_width;
global.sym_panel_top = panel_top;
global.sym_panel_height = panel_height;

global.sym_fold_x = clamp(global.sym_fold_x, panel_left + 32, panel_left + panel_width - 32);

if (is_string(global.sym_feedback) && global.sym_feedback != feedback_source) {
    feedback_source = global.sym_feedback;
    feedback_layout = scr_longtext_layout_create(feedback_source, 520, 16);
}

if (global.sym_mode == "text" && is_struct(global.sym_text_layout) && text_layout != global.sym_text_layout) {
    text_layout = global.sym_text_layout;
}
