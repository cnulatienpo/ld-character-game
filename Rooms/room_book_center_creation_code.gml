/// room_book_center : Creation Code
// Sets up the center finding activity.
var layer_id = layer_get_id("Instances");

instance_create_layer(0, 0, layer_id, obj_db_center_controller);
instance_create_layer(0, 0, layer_id, obj_db_center_canvas);
instance_create_layer(0, 0, layer_id, obj_db_center_feedback);

var cont = instance_create_layer(520, 520, layer_id, obj_db_continue);
cont.x = 520;
cont.y = 520;
