/// room_mixmatch : Creation Code
// Prepare the mix & match interface.
if (!scr_mixmatch_load()) {
    show_debug_message("room_mixmatch: unable to load data");
    exit;
}

var layer_id = layer_get_id("Instances");
var left_x = 160;
var left_y = 140;
var slot_x = 520;
var slot_y = 120;
var step_y = 80;

for (var i = 0; i < array_length(global.mm_left); i++) {
    var label = global.mm_left[i];
    var token = instance_create_layer(left_x, left_y + i * step_y, layer_id, obj_mm_left_token);
    token.token_label = label;
    token.home_x = token.x;
    token.home_y = token.y;
}

for (var j = 0; j < array_length(global.mm_right); j++) {
    var text = global.mm_right[j];
    var slot = instance_create_layer(slot_x, slot_y + j * step_y, layer_id, obj_mm_right_slot);
    slot.slot_index = j;
    slot.slot_text = text;
}

instance_create_layer(520, slot_y + array_length(global.mm_right) * step_y + 40, layer_id, obj_mm_submit);
instance_create_layer(160, left_y + array_length(global.mm_left) * step_y + 40, layer_id, obj_mm_feedback);
