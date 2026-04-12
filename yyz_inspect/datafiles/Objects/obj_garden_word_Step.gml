/// obj_garden_word : Step Event
// Handles dragging and drop detection for beds.
var word_width = string_width(label) + word_padding * 2;
var left = x - word_width * 0.5;
var top = y - word_height * 0.5;
var right = x + word_width * 0.5;
var bottom = y + word_height * 0.5;

hover = point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom);

if (mouse_check_button_pressed(mb_left) && hover) {
    dragging = true;
    drag_dx = mouse_x - x;
    drag_dy = mouse_y - y;
}

if (dragging) {
    x = mouse_x - drag_dx;
    y = mouse_y - drag_dy;
    global.garden_hover_tier = undefined;
    if (is_array(global.garden_beds)) {
        for (var b = 0; b < array_length(global.garden_beds); b++) {
            var bed = global.garden_beds[b];
            var rect = bed.rect;
            if (point_in_rectangle(mouse_x, mouse_y, rect.x1, rect.y1, rect.x2, rect.y2)) {
                global.garden_hover_tier = bed.tier;
                break;
            }
        }
    }
}

if (dragging && mouse_check_button_released(mb_left)) {
    dragging = false;
    var placed = false;
    if (is_array(global.garden_beds)) {
        for (var c = 0; c < array_length(global.garden_beds); c++) {
            var drop_bed = global.garden_beds[c];
            var drop_rect = drop_bed.rect;
            if (point_in_rectangle(mouse_x, mouse_y, drop_rect.x1, drop_rect.y1, drop_rect.x2, drop_rect.y2)) {
                scr_garden_set_tier(word_index, drop_bed.tier);
                tier = drop_bed.tier;
                x = (drop_rect.x1 + drop_rect.x2) * 0.5;
                y = (drop_rect.y1 + drop_rect.y2) * 0.5;
                placed = true;
                break;
            }
        }
    }
    if (!placed) {
        scr_garden_set_tier(word_index, tier);
    }
    global.garden_hover_tier = undefined;
    global.garden_result = undefined;
}

if (ds_exists(global.garden_words, ds_type_list)) {
    if (word_index >= 0 && word_index < ds_list_size(global.garden_words)) {
        var entry = ds_list_find_value(global.garden_words, word_index);
        if (is_struct(entry)) {
            entry.x = x;
            entry.y = y;
            entry.tier = tier;
            ds_list_replace(global.garden_words, word_index, entry);
        }
    }
}
