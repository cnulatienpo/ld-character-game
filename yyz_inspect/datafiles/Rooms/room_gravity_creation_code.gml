/// room_gravity : Creation Code
// Sets up the Gravity Test mini-game.
if (!scr_gravity_load()) {
    show_debug_message("room_gravity: unable to load data");
    exit;
}

var layer_id = layer_get_id("Instances");
instance_create_layer(0, 0, layer_id, obj_gt_controller);

var passage = instance_create_layer(80, 180, layer_id, obj_gt_passage);
passage.visible_height = 320;

var left_panel = instance_create_layer(640, 200, layer_id, obj_gt_ending_panel);
left_panel.side = "left";
left_panel.panel_width = 260;
left_panel.panel_height = 180;

var right_panel = instance_create_layer(940, 200, layer_id, obj_gt_ending_panel);
right_panel.side = "right";
right_panel.panel_width = 260;
right_panel.panel_height = 180;

var slider = instance_create_layer(700, 420, layer_id, obj_gt_slider);
slider.slider_width = 220;

var choose_btn = instance_create_layer(700, 460, layer_id, obj_gt_choose);
choose_btn.x = 700;
choose_btn.y = 460;

var continue_btn = instance_create_layer(900, 460, layer_id, obj_gt_continue);
continue_btn.x = 900;
continue_btn.y = 460;
