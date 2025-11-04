/// obj_chain_controller : Step Event
// Syncs selection index and feedback layout.
var option_count = array_length(option_layouts);
if (option_count > 0) {
    var desired = clamp(global.cr_current_idx, 0, option_count - 1);
    if (desired != current_index) {
        current_index = desired;
    }
} else {
    current_index = 0;
}

if (is_string(global.cr_feedback_line) && global.cr_feedback_line != feedback_source) {
    feedback_source = global.cr_feedback_line;
    feedback_layout = scr_longtext_layout_create(feedback_source, 360, 20);
}
