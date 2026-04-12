/// room_book_echo : Creation Code
// Sets up the echo spotting activity.
var layer_id = layer_get_id("Instances");

instance_create_layer(0, 0, layer_id, obj_db_echo_controller);

var passage = instance_create_layer(0, 0, layer_id, obj_db_echo_passage);
passage.x0 = 160;
passage.y0 = 140;
passage.visible_h = 360;

var check_btn = instance_create_layer(160, 520, layer_id, obj_db_echo_check);
check_btn.x = 160;
check_btn.y = 520;

instance_create_layer(0, 0, layer_id, obj_db_echo_feedback);

var cont = instance_create_layer(520, 520, layer_id, obj_db_continue);
cont.x = 520;
cont.y = 520;
