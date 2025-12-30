/// room_soundlab : Creation Code
// Sets up the Sound Lab mini-game.
var layer_id = layer_get_id("Instances");

instance_create_layer(0, 0, layer_id, obj_soundlab_controller);
instance_create_layer(0, 0, layer_id, obj_sl_question);

var pulse = instance_create_layer(720, 220, layer_id, obj_sl_pulse);
pulse.x = 720;
pulse.y = 220;

var choice_y = 200;
for (var i = 0; i < 3; i++) {
    var btn = instance_create_layer(120, choice_y + i * 120, layer_id, obj_sl_choice);
    btn.choice_slot = i;
}

var feedback = instance_create_layer(120, 420, layer_id, obj_sl_feedback);
feedback.x = 120;
feedback.y = 420;

var cont = instance_create_layer(520, 460, layer_id, obj_sl_continue);
cont.x = 520;
cont.y = 460;

var writebox = instance_create_layer(120, 360, layer_id, obj_sl_writebox);
writebox.x = 120;
writebox.y = 360;

var write_submit = instance_create_layer(660, 360, layer_id, obj_sl_write_submit);
write_submit.x = 660;
write_submit.y = 360;

var write_feedback = instance_create_layer(120, 460, layer_id, obj_sl_write_feedback);
write_feedback.x = 120;
write_feedback.y = 500;
