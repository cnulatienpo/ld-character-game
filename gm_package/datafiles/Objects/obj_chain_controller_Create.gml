/// obj_chain_controller : Create Event
// Prepares layouts and selection state for Chain Reaction.
if (!is_struct(global.cr_item)) {
    show_debug_message("obj_chain_controller: chain reaction item not loaded");
    instance_destroy();
    return;
}

if (!is_struct(global.cr_layout_start)) {
    global.cr_layout_start = scr_longtext_layout_create(string(variable_struct_get(global.cr_item, "start", "")), 360, 24);
}
if (!is_struct(global.cr_layout_end)) {
    global.cr_layout_end = scr_longtext_layout_create(string(variable_struct_get(global.cr_item, "end", "")), 360, 24);
}
if (!is_array(global.cr_layout_options)) {
    var options = variable_struct_get(global.cr_item, "options", []);
    global.cr_layout_options = [];
    if (is_array(options)) {
        for (var i = 0; i < array_length(options); i++) {
            global.cr_layout_options[i] = scr_longtext_layout_create(string(options[i]), 360, 24);
        }
    }
}

if (!is_real(global.cr_current_idx)) {
    global.cr_current_idx = 0;
}

current_index = clamp(global.cr_current_idx, 0, array_length(global.cr_layout_options) - 1);
start_layout = global.cr_layout_start;
end_layout = global.cr_layout_end;
option_layouts = global.cr_layout_options;
feedback_source = global.cr_feedback_line;
if (!is_string(feedback_source)) {
    feedback_source = "Which middle keeps it moving?";
    global.cr_feedback_line = feedback_source;
}
feedback_layout = scr_longtext_layout_create(feedback_source, 360, 20);

prompt_layout = scr_longtext_layout_create("Which line keeps it moving?", 520, 16);
