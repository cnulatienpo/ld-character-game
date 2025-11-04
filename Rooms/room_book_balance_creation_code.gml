/// room_book_balance : Creation Code
// Sets up the balance slider activity.
var layer_id = layer_get_id("Instances");

instance_create_layer(0, 0, layer_id, obj_db_balance_controller);
instance_create_layer(0, 0, layer_id, obj_db_balance_canvas);

var slider = instance_create_layer(0, 0, layer_id, obj_db_balance_slider);
slider.x = 0;
slider.y = 0;

var submit = instance_create_layer(220, 500, layer_id, obj_db_balance_submit);
submit.x = 220;
submit.y = 500;

var feedback = instance_create_layer(0, 0, layer_id, obj_db_balance_feedback);

var cont = instance_create_layer(520, 500, layer_id, obj_db_continue);
cont.x = 520;
cont.y = 500;
