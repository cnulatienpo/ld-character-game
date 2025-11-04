/// room_arch : Creation Code
// Sets up the Architecture Studio mini-game.
if (!scr_arch_load()) {
    show_debug_message("room_arch: failed to load block data");
    exit;
}

var layer_id = layer_get_id("Instances");
instance_create_layer(0, 0, layer_id, obj_arch_controller);

var shelf_x = 160;
var shelf_y = 180;
var shelf_step = 90;

for (var i = 0; i < array_length(global.arch_blocks); i++) {
    var data = global.arch_blocks[i];
    var block = instance_create_layer(shelf_x, shelf_y + i * shelf_step, layer_id, obj_arch_block);
    block.block_label = data.label;
    block.block_width = data.width;
    block.block_weight = data.weight;
    block.block_pull = data.pull;
    block.home_x = block.x;
    block.home_y = block.y;
}

var check_btn = instance_create_layer(460, 340, layer_id, obj_arch_button_check);
check_btn.x = 460;
check_btn.y = 340;

var cont_btn = instance_create_layer(640, 340, layer_id, obj_arch_button_continue);
cont_btn.x = 640;
cont_btn.y = 340;
