/// obj_mm_left_token : Step Event
// Handle dragging and snapping tokens onto answer slots.
var token_half_w = 72;
var token_half_h = 20;
var over = point_in_rectangle(mouse_x, mouse_y, x - token_half_w, y - token_half_h, x + token_half_w, y + token_half_h);

if (mouse_check_button_pressed(mb_left) && over) {
    drag = true;
    drag_offset_x = mouse_x - x;
    drag_offset_y = mouse_y - y;
    depth = -50;
}

if (drag) {
    x = mouse_x - drag_offset_x;
    y = mouse_y - drag_offset_y;
}

if (drag && mouse_check_button_released(mb_left)) {
    drag = false;
    depth = -10;

    // Release existing slot claim before searching for a new one.
    if (assigned_slot != noone) {
        with (assigned_slot) {
            occupant = noone;
        }
        if (ds_map_exists(global.mm_pairs_user, token_label)) {
            ds_map_delete(global.mm_pairs_user, token_label);
        }
        assigned_slot = noone;
    }

    var best_slot = noone;
    var best_dist = 99999;

    with (obj_mm_right_slot) {
        var slot_center_x = x + slot_width * 0.5;
        var slot_center_y = y + slot_height * 0.5;
        if (point_in_rectangle(other.x, other.y, x, y, x + slot_width, y + slot_height)) {
            var dist = point_distance(other.x, other.y, slot_center_x, slot_center_y);
            if (dist < best_dist) {
                best_dist = dist;
                best_slot = id;
            }
        }
    }

    if (best_slot != noone) {
        with (best_slot) {
            if (occupant != noone) {
                with (occupant) {
                    assigned_slot = noone;
                    x = home_x;
                    y = home_y;
                    if (ds_map_exists(global.mm_pairs_user, token_label)) {
                        ds_map_delete(global.mm_pairs_user, token_label);
                    }
                }
            }
            occupant = other.id;
            other.x = x + slot_width * 0.5;
            other.y = y + slot_height * 0.5;
            other.assigned_slot = id;
            ds_map_set(global.mm_pairs_user, other.token_label, slot_index);
        }
    } else {
        x = home_x;
        y = home_y;
    }
}

// Allow tokens to return home when right-clicked.
if (!drag && mouse_check_button_pressed(mb_right) && over) {
    if (assigned_slot != noone) {
        with (assigned_slot) {
            occupant = noone;
        }
        assigned_slot = noone;
    }
    if (ds_map_exists(global.mm_pairs_user, token_label)) {
        ds_map_delete(global.mm_pairs_user, token_label);
    }
    x = home_x;
    y = home_y;
}
