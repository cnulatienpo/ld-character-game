/// obj_museum_panel : Step Event
// Tracks hover for choice buttons and handles selection clicks.
hover_choice = "";

if (!is_array(global.m_choices) || !is_array(global.museum_picks)) {
    exit;
}

var choice_count = array_length(global.m_choices);
if (choice_count == 0) {
    exit;
}

var spacing = 6;
var choice_width = (panel_width - spacing * (choice_count - 1)) / max(1, choice_count);
var button_y1 = y + panel_height + 12;
var button_y2 = button_y1 + choice_height;

for (var i = 0; i < choice_count; i++) {
    var choice = global.m_choices[i];
    var bx1 = x + i * (choice_width + spacing);
    var bx2 = bx1 + choice_width;
    if (point_in_rectangle(mouse_x, mouse_y, bx1, button_y1, bx2, button_y2)) {
        hover_choice = choice.id;
        if (mouse_check_button_pressed(mb_left)) {
            if (item_index < array_length(global.museum_picks)) {
                global.museum_picks[item_index] = choice.id;
                global.museum_result = undefined;
                global.museum_feedback_sentence = undefined;
                global.museum_matches = array_create(array_length(global.museum_picks), "");
            }
        }
    }
}
