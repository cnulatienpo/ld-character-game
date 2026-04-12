/// obj_garden_controller : Create Event
// Ensures the Word Garden state is loaded and spawns draggable word instances.
if (!is_struct(global.garden_round)) {
    if (!scr_garden_load()) {
        show_debug_message("obj_garden_controller: unable to load round");
        instance_destroy();
        exit;
    }
}

var layer_id = layer_get_id("Instances");
with (obj_garden_word) {
    instance_destroy();
}

if (ds_exists(global.garden_words, ds_type_list)) {
    for (var i = 0; i < ds_list_size(global.garden_words); i++) {
        var word_struct = ds_list_find_value(global.garden_words, i);
        if (!is_struct(word_struct)) {
            continue;
        }
        var inst = instance_create_layer(word_struct.x, word_struct.y, layer_id, obj_garden_word);
        inst.word_index = i;
        inst.label = word_struct.label;
        inst.tier = word_struct.tier;
    }
}

preview_width = 280;
preview_x = 780;
preview_y = 180;
preview_spacing = 18;
