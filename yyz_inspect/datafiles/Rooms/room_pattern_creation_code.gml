/// room_pattern : Creation Code
// Build the pattern & break interface.
if (!scr_pattern_load()) {
    show_debug_message("room_pattern: unable to load data");
    exit;
}

var layer_id = layer_get_id("Instances");
var passage = instance_create_layer(120, 120, layer_id, obj_pb_passage);
passage.visible_height = 440;

instance_create_layer(120, 80, layer_id, obj_pb_toggle);
instance_create_layer(120, 600, layer_id, obj_pb_submit);
instance_create_layer(320, 600, layer_id, obj_pb_feedback);
