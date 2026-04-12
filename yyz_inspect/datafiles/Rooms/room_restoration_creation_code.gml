/// room_restoration : Creation Code
// Sets up the restoration game.
var layer_id = layer_get_id("Instances");

instance_create_layer(0, 0, layer_id, obj_restoration_controller);
instance_create_layer(0, 0, layer_id, obj_rg_passage);

var choice_y = 160;
if (is_struct(global.rg_round) && is_array(global.rg_round.palette)) {
    var count = array_length(global.rg_round.palette);
    for (var i = 0; i < count; i++) {
        var choice = instance_create_layer(760, choice_y + i * 110, layer_id, obj_rg_choice);
        choice.choice_slot = i;
        choice.x = 760;
        choice.y = choice_y + i * 110;
    }
}

var check_btn = instance_create_layer(140, 480, layer_id, obj_rg_check);
check_btn.x = 140;
check_btn.y = 480;

instance_create_layer(0, 0, layer_id, obj_rg_feedback);

var cont = instance_create_layer(520, 520, layer_id, obj_db_continue);
cont.x = 520;
cont.y = 520;
