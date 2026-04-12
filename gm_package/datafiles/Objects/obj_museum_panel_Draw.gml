/// obj_museum_panel : Draw Event
// Draws the media description and choice row.
if (!is_array(global.m_items)) {
    exit;
}

if (item_index < 0 || item_index >= array_length(global.m_items)) {
    exit;
}

var item = global.m_items[item_index];
var match_state = "";
if (is_array(global.museum_matches) && item_index < array_length(global.museum_matches)) {
    match_state = string(global.museum_matches[item_index]);
}

var panel_col = make_colour_rgb(245, 245, 245);
if (match_state == "correct") panel_col = make_colour_rgb(220, 245, 220);
if (match_state == "wrong") panel_col = make_colour_rgb(245, 220, 220);

draw_set_color(panel_col);
draw_rectangle(x, y, x + panel_width, y + panel_height, false);

draw_set_color(c_black);
draw_text(x + 12, y + 12, string(item.media));
draw_text_ext(x + 12, y + 40, string(item.text), 24, panel_width - 24);

var choice_count = array_length(global.m_choices);
if (choice_count == 0) {
    exit;
}

var spacing = 6;
var choice_width = (panel_width - spacing * (choice_count - 1)) / max(1, choice_count);
var button_y1 = y + panel_height + 12;
var button_y2 = button_y1 + choice_height;

var selected_id = "";
if (item_index < array_length(global.museum_picks)) {
    selected_id = string(global.museum_picks[item_index]);
}

for (var i = 0; i < choice_count; i++) {
    var choice = global.m_choices[i];
    var bx1 = x + i * (choice_width + spacing);
    var bx2 = bx1 + choice_width;
    var col = make_colour_rgb(232, 232, 232);
    if (selected_id == choice.id) {
        col = make_colour_rgb(210, 225, 240);
        if (match_state == "correct") {
            col = make_colour_rgb(190, 235, 200);
        } else if (match_state == "wrong") {
            col = make_colour_rgb(235, 200, 200);
        }
    }
    if (hover_choice == choice.id) {
        col = merge_colour(col, c_white, 0.5);
    }
    draw_set_color(col);
    draw_rectangle(bx1, button_y1, bx2, button_y2, false);
    draw_set_color(c_black);
    draw_text(bx1 + 8, button_y1 + 6, string(choice.label));
}
