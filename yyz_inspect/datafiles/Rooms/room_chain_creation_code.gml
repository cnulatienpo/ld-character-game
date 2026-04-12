/// room_chain : Creation Code
// Sets up the Chain Reaction mini-game.
if (!scr_chain_load()) {
    show_debug_message("room_chain: unable to load round");
    exit;
}

var layer_id = layer_get_id("Instances");
var controller = instance_create_layer(0, 0, layer_id, obj_chain_controller);
controller.x = 0;
controller.y = 0;

var prev_btn = instance_create_layer(500, 580, layer_id, obj_chain_button_prev);
prev_btn.x = 500;
prev_btn.y = 580;

var next_btn = instance_create_layer(640, 580, layer_id, obj_chain_button_next);
next_btn.x = 640;
next_btn.y = 580;

var submit_btn = instance_create_layer(520, 520, layer_id, obj_chain_button_submit);
submit_btn.x = 520;
submit_btn.y = 520;

var cont_btn = instance_create_layer(920, 580, layer_id, obj_chain_button_continue);
cont_btn.x = 920;
cont_btn.y = 580;
