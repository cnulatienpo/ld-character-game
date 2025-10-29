/// oUIActivityPicker Draw GUI Event

if (activity_mode_get() != "picker") {
    exit;
}

var layout = ui_layout_compute();
var pad = ui_pad();
var theme = ui_theme_state();
var rect = is_struct(layout.content) ? layout.content : { x: pad, y: pad * 2, w: layout.width - pad * 2, h: layout.height * 0.5 };
ui_panel(rect.x, rect.y, rect.w, rect.h, "Activity");

var text_x = rect.x + pad;
var text_y = rect.y + theme.panel_header + pad;
var text_w = rect.w - pad * 2;
var question = is_string(question_text) ? question_text : "Make a selection";
draw_set_color(ui_col("text"));
draw_text_ext(text_x, text_y, question, 12, text_w);

var button_y = text_y + string_height_ext(question, 12, text_w) + pad * 2;
var button_h = theme.button_height;
var labels = is_array(choice_labels) ? choice_labels : [];
var count = array_length(labels);
if (count <= 0) {
    labels = ["Continue"];
    count = 1;
}

var button_w = rect.w - pad * 2;
if (button_w > 360) button_w = 360;
var button_x = rect.x + (rect.w - button_w) * 0.5;

for (var i = 0; i < count; ++i) {
    var label = string(labels[i]);
    if (ui_button(button_x, button_y, button_w, button_h, label, "")) {
        choice_index = i;
        selected_label = label;
        if (instance_exists(controller)) {
            with (controller) {
                handle_picker_choice(other.selected_label);
            }
        }
    }
    button_y += button_h + pad;
}
