/// room_kitchen : Creation Code
// Sets up the Form Kitchen mini-game.
if (!scr_kitchen_load()) {
    show_debug_message("room_kitchen: unable to load data");
    exit;
}

var layer_id = layer_get_id("Instances");
instance_create_layer(0, 0, layer_id, obj_kitchen_controller);

var labels = ["salt", "acid", "sugar", "fat"];
var start_y = 200;
var step_y = 70;

for (var i = 0; i < array_length(labels); i++) {
    var label = labels[i];
    var slider = instance_create_layer(180, start_y + i * step_y, layer_id, obj_kitch_slider);
    slider.label = label;
    slider.value = variable_struct_get(global.kit_mix, label, 0);
}

var taste_btn = instance_create_layer(460, 340, layer_id, obj_kitch_button_taste);
taste_btn.x = 460;
taste_btn.y = 340;

var cont_btn = instance_create_layer(640, 340, layer_id, obj_kitch_button_continue);
cont_btn.x = 640;
cont_btn.y = 340;
