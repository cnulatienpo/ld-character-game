/// room_book_symmetry : Creation Code
// Sets up the symmetry fold activity.
var layer_id = layer_get_id("Instances");

instance_create_layer(0, 0, layer_id, obj_db_symmetry_controller);
instance_create_layer(0, 0, layer_id, obj_db_symmetry_passage);
instance_create_layer(0, 0, layer_id, obj_db_symmetry_fold);

var submit = instance_create_layer(200, 480, layer_id, obj_db_symmetry_submit);
submit.x = 200;
submit.y = 480;

instance_create_layer(0, 0, layer_id, obj_db_symmetry_feedback);

var cont = instance_create_layer(520, 520, layer_id, obj_db_continue);
cont.x = 520;
cont.y = 520;
