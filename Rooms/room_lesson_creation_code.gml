/// room_lesson : Creation Code
// Layout the lesson UI pieces.
var layer = "Instances";

var controller = instance_create_layer(0, 0, layer, obj_lesson_controller);
controller.x = 0;
controller.y = 0;

var scroller = instance_create_layer(80, 120, layer, obj_textscroll);
scroller.x = 80;
scroller.y = 120;

var translator = instance_create_layer(880, 120, layer, obj_translation_panel);
translator.x = 880;
translator.y = 120;

var writer = instance_create_layer(80, 580, layer, obj_writebox);
writer.x = 80;
writer.y = 580;

var say_button = instance_create_layer(880, 520, layer, obj_behavior_say);
say_button.x = 880;
say_button.y = 520;

var show_button = instance_create_layer(880, 580, layer, obj_behavior_show);
show_button.x = 880;
show_button.y = 580;

var hide_button = instance_create_layer(880, 640, layer, obj_behavior_hide);
hide_button.x = 880;
hide_button.y = 640;

var low_button = instance_create_layer(1020, 520, layer, obj_strength_low);
low_button.x = 1020;
low_button.y = 520;

var med_button = instance_create_layer(1020, 580, layer, obj_strength_med);
med_button.x = 1020;
med_button.y = 580;

var high_button = instance_create_layer(1020, 640, layer, obj_strength_high);
high_button.x = 1020;
high_button.y = 640;

var submit_button = instance_create_layer(80, 820, layer, obj_submit);
submit_button.x = 80;
submit_button.y = 820;

var feedback = instance_create_layer(320, 780, layer, obj_feedback_panel);
feedback.x = 320;
feedback.y = 780;

var cont = instance_create_layer(960, 820, layer, obj_continue_button);
cont.x = 960;
cont.y = 820;
cont.next_stage = "lesson";
cont.label = "Choose and continue";
