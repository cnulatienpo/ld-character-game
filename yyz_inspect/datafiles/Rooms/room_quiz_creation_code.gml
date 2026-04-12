/// room_quiz : Creation Code
// Spawn quiz objects and layout answer buttons.
var layer = "Instances";

var controller = instance_create_layer(0, 0, layer, obj_quiz_controller);
controller.x = 0;
controller.y = 0;

var passage = instance_create_layer(80, 120, layer, obj_quiz_passage);
passage.x = 80;
passage.y = 120;

var stem = instance_create_layer(80, 60, layer, obj_quiz_stem);
stem.x = 80;
stem.y = 60;

var choice_y = 560;
for (var i = 0; i < 4; i++) {
    var choice = instance_create_layer(760, choice_y + i * 70, layer, obj_quiz_choice);
    choice.x = 760;
    choice.y = choice_y + i * 70;
}

var feedback = instance_create_layer(640, 720, layer, obj_quiz_feedback);
feedback.x = 640;
feedback.y = 720;

var cont = instance_create_layer(960, 820, layer, obj_continue_button);
cont.x = 960;
cont.y = 820;
cont.next_stage = "quiz";
cont.label = "Continue";
