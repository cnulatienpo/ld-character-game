/// obj_arch_block : Step Event
// Handles dragging and placement logic.
var bbox_l = bbox_left;
var bbox_r = bbox_right;
var bbox_t = bbox_top;
var bbox_b = bbox_bottom;

if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, bbox_l, bbox_t, bbox_r, bbox_b)) {
    drag = true;
    dx = mouse_x - x;
    dy = mouse_y - y;
    if (slot_index >= 0 && is_array(global.arch_slots)) {
        if (global.arch_slots[slot_index] == id) {
            global.arch_slots[slot_index] = noone;
        }
    }
    slot_index = -1;
}

if (drag) {
    x = mouse_x - dx;
    y = mouse_y - dy;
}

if (drag && mouse_check_button_released(mb_left)) {
    drag = false;
    var cfg = global.arch_config;
    if (is_struct(cfg) && point_in_rectangle(x, y, cfg.area.x1, cfg.area.y1, cfg.area.x2, cfg.area.y2)) {
        var slot = -1;
        if (is_array(global.arch_slots)) {
            for (var i = 0; i < array_length(global.arch_slots); i++) {
                if (global.arch_slots[i] == noone) {
                    slot = i;
                    break;
                }
            }
        }
        if (slot != -1) {
            slot_index = slot;
            global.arch_slots[slot] = id;
            x = cfg.base_x;
            y = cfg.base_y - slot * cfg.slot_height;
        } else {
            x = home_x;
            y = home_y;
        }
    } else {
        x = home_x;
        y = home_y;
    }
}
