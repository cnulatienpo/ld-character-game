/// room_friction : Creation Code
// Build the friction lab interface.
if (!scr_friction_load()) {
    show_debug_message("room_friction: unable to load data");
    exit;
}

var layer_id = layer_get_id("Instances");
var passage = instance_create_layer(120, 120, layer_id, obj_fc_passage);
passage.visible_height = 380;

instance_create_layer(720, 140, layer_id, obj_fc_question);
instance_create_layer(720, 380, layer_id, obj_fc_question2);
instance_create_layer(720, 540, layer_id, obj_fc_submit);
instance_create_layer(120, 540, layer_id, obj_fc_feedback);
