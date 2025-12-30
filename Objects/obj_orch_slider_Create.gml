/// obj_orch_slider : Create Event
// Sets dimensions and initial value for the orchestra slider.
if (!is_string(label)) {
    label = "";
}
range_height = 200;
knob_radius = 12;
hover = false;

var start_value = 0.5;
if (is_struct(global.orch_mix) && string_length(label) > 0) {
    start_value = variable_struct_get(global.orch_mix, label, start_value);
}

value = clamp(start_value, 0, 1);
