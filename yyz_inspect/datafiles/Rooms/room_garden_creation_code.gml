/// room_garden : Creation Code
// Sets up the Word Garden mini-game.
if (!scr_garden_load()) {
    show_debug_message("room_garden: unable to load data");
    exit;
}

var layer_id = layer_get_id("Instances");
instance_create_layer(0, 0, layer_id, obj_garden_controller);

var check_btn = instance_create_layer(200, 480, layer_id, obj_garden_check);
check_btn.x = 200;
check_btn.y = 480;

var continue_btn = instance_create_layer(380, 480, layer_id, obj_garden_continue);
continue_btn.x = 380;
continue_btn.y = 480;
