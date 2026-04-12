/// room_reading : Creation Code
// Layout the reading passage and highlight controls.
var layer = "Instances";

var controller = instance_create_layer(0, 0, layer, obj_reading_controller);
controller.x = 0;
controller.y = 0;

var passage = instance_create_layer(80, 120, layer, obj_reading_passage);
passage.x = 80;
passage.y = 120;

var question = instance_create_layer(80, 40, layer, obj_reading_question);
question.x = 80;
question.y = 40;

var submit = instance_create_layer(760, 640, layer, obj_reading_submit);
submit.x = 760;
submit.y = 640;

var cont = instance_create_layer(760, 720, layer, obj_reading_continue);
cont.x = 760;
cont.y = 720;
