/// obj_sym_controller : Create Event
// Prepares layouts and drawing metrics for Symmetry Lab.
if (!is_struct(global.sym_round)) {
    show_debug_message("obj_sym_controller: symmetry round not loaded");
    instance_destroy();
    return;
}

panel_left = global.sym_panel_left;
panel_width = global.sym_panel_width;
panel_top = 140;
panel_height = 420;

instruction_layout = scr_longtext_layout_create("Balance the scene. Slide the fold until calm settles.", 520, 16);
feedback_source = global.sym_feedback;
feedback_layout = scr_longtext_layout_create(feedback_source, 520, 16);

if (global.sym_mode == "text") {
    text_layout = global.sym_text_layout;
} else {
    text_layout = undefined;
}

global.sym_panel_top = panel_top;
global.sym_panel_height = panel_height;
