/// room_museum : Creation Code
// Sets up the Museum Game mini-game.
if (!scr_museum_load()) {
    show_debug_message("room_museum: unable to load data");
    exit;
}

var layer_id = layer_get_id("Instances");
instance_create_layer(0, 0, layer_id, obj_museum_controller);

var item_count = array_length(global.m_items);
var cols = 2;
var start_x = 80;
var start_y = 200;
var col_step = 360;
var row_step = 220;

for (var i = 0; i < item_count; i++) {
    var col = i mod cols;
    var row = i div cols;
    var px = start_x + col * col_step;
    var py = start_y + row * row_step;
    var panel = instance_create_layer(px, py, layer_id, obj_museum_panel);
    panel.item_index = i;
}

var check_btn = instance_create_layer(260, 520, layer_id, obj_museum_check);
check_btn.x = 260;
check_btn.y = 520;

var continue_btn = instance_create_layer(440, 520, layer_id, obj_museum_continue);
continue_btn.x = 440;
continue_btn.y = 520;
