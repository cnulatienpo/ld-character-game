/// room_orchestra : Creation Code
// Sets up The Orchestra mini-game.
if (!scr_orch_load()) {
    show_debug_message("room_orchestra: unable to load round");
    exit;
}

var layer_id = layer_get_id("Instances");
var controller = instance_create_layer(0, 0, layer_id, obj_orch_controller);
controller.x = 0;
controller.y = 0;

var labels = ["emotion", "stakes", "pacing"];
var base_x = 340;
var step_x = 80;
var top_y = 180;

for (var i = 0; i < array_length(labels); i++) {
    var slider = instance_create_layer(base_x + i * step_x, top_y, layer_id, obj_orch_slider);
    slider.label = labels[i];
}

var check_btn = instance_create_layer(520, 520, layer_id, obj_orch_button_check);
check_btn.x = 520;
check_btn.y = 520;

var cont_btn = instance_create_layer(700, 520, layer_id, obj_orch_button_continue);
cont_btn.x = 700;
cont_btn.y = 520;
