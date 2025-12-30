/// room_symmetry : Creation Code
// Sets up the Symmetry Lab mini-game.
if (!scr_sym_load()) {
    show_debug_message("room_symmetry: unable to load round");
    exit;
}

var layer_id = layer_get_id("Instances");
var controller = instance_create_layer(0, 0, layer_id, obj_sym_controller);
controller.x = 0;
controller.y = 0;

var fold = instance_create_layer(global.sym_fold_x, 0, layer_id, obj_sym_fold);
fold.y = 0;

var cont_btn = instance_create_layer(900, 580, layer_id, obj_sym_button_continue);
cont_btn.x = 900;
cont_btn.y = 580;
