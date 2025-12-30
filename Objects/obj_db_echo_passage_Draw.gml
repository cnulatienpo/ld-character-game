/// obj_db_echo_passage : Draw Event
// Draws the generous passage and highlights selections.
var layout = global.db_echo_layout;
if (!is_struct(layout)) {
    return;
}

var panel_width = layout.width + layout.margin * 2;
var panel_height = visible_h;

var bg = make_colour_rgb(48, 56, 68);
draw_set_colour(bg);
draw_rectangle(x0 - 24, y0 - 24, x0 + panel_width + 24, y0 + panel_height + 24, false);

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(160, 80, "Tap each echo when you spot it.\n\nLet the repetition guide you.");

var line_height = layout.line_height;
var first_line = floor(layout.scroll / line_height);
var last_line = ceil((layout.scroll + visible_h) / line_height);
last_line = clamp(last_line, 0, array_length(layout.lines));

var hit_indices = [];
if (ds_exists(global.db_echo_hits, ds_type_list)) {
    var sz = ds_list_size(global.db_echo_hits);
    for (var i = 0; i < sz; i++) {
        array_push(hit_indices, floor(global.db_echo_hits[| i]));
    }
}

for (var line = first_line; line < last_line; line++) {
    var line_y = y0 + (line * line_height) - layout.scroll;
    var highlight_alpha = 0;
    var highlight_col = make_colour_rgb(180, 220, 200);

    for (var h = 0; h < array_length(hit_indices); h++) {
        if (hit_indices[h] == line) {
            highlight_alpha = 0.35;
            break;
        }
    }

    if (is_array(global.db_echo_reveal) && array_length(global.db_echo_reveal) > 0) {
        for (var r = 0; r < array_length(global.db_echo_reveal); r++) {
            if (global.db_echo_reveal[r] == line) {
                highlight_alpha = max(highlight_alpha, 0.5);
                highlight_col = make_colour_rgb(220, 200, 160);
                break;
            }
        }
    }

    if (highlight_alpha > 0) {
        draw_set_colour(highlight_col);
        draw_set_alpha(highlight_alpha);
        draw_rectangle(x0, line_y, x0 + panel_width, line_y + line_height, false);
        draw_set_alpha(1);
    }
}

// Draw text after laying down highlights.
scr_draw_longtext(layout, x0, y0, visible_h);
