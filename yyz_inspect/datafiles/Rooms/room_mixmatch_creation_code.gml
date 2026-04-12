/// room_mixmatch : Creation Code
// Set up the mix & match room layout.
var layer = "Instances";

var controller = instance_create_layer(0, 0, layer, obj_mm_controller);
controller.x = 0;
controller.y = 0;

// Ensure we have data even if the loader fell back to defaults.
var left_items = is_array(global.mm_left) ? global.mm_left : ["signal", "pressure", "balance", "pattern", "weight"];
var right_items = is_array(global.mm_right) ? global.mm_right : ["A gentle push.", "A hard lean.", "A steady beat.", "A sudden break.", "A quiet wait."];

if (!is_array(global.mm_left)) {
    global.mm_left = left_items;
}
if (!is_array(global.mm_right)) {
    global.mm_right = right_items;
}

var left_x = 160;
var left_y = 160;
var slot_x = 560;
var slot_y = 140;
var step_y = 80;

for (var i = 0; i < array_length(left_items); i++) {
    var label = left_items[i];
    var token = instance_create_layer(left_x, left_y + i * step_y, layer, obj_mm_left_token);
    token.token_label = label;
    token.home_x = token.x;
    token.home_y = token.y;
}

for (var j = 0; j < array_length(right_items); j++) {
    var text = right_items[j];
    var slot = instance_create_layer(slot_x, slot_y + j * step_y, layer, obj_mm_right_slot);
    slot.slot_index = j;
    slot.slot_text = text;
}

var submit = instance_create_layer(slot_x, slot_y + array_length(right_items) * step_y + 40, layer, obj_mm_submit);
submit.x = slot_x;
submit.y = slot_y + array_length(right_items) * step_y + 40;

var feedback = instance_create_layer(left_x, left_y + array_length(left_items) * step_y + 40, layer, obj_mm_feedback);
feedback.x = left_x;
feedback.y = left_y + array_length(left_items) * step_y + 40;

var cont = instance_create_layer(slot_x + 200, submit.y + 80, layer, obj_continue_button);
cont.x = slot_x + 200;
cont.y = submit.y + 80;
cont.next_stage = "mix";
cont.label = "Continue";
