/// obj_kitch_slider : Create Event
// Initializes slider dimensions and hooks into the shared mix struct.
if (!is_string(label)) {
    label = "";
}
slider_width = 200;
slider_height = 12;
knob_radius = 10;
hover = false;
value = is_string(label) && variable_struct_exists(global.kit_mix, label) ? variable_struct_get(global.kit_mix, label, 0) : 0;
