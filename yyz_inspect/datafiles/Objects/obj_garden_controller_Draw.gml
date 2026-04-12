/// obj_garden_controller : Draw Event
// Renders instructions, garden beds, preview sentence, and feedback.
if (!is_struct(global.garden_round)) {
    exit;
}

var margin_left = 64;
var text_width = 360;
var stem_text = string(global.garden_round.stem);
draw_set_color(c_black);
draw_text_ext(margin_left, 80, stem_text, 32, text_width);

draw_set_color(make_colour_rgb(240, 240, 240));
draw_rectangle(margin_left - 24, 160, margin_left + text_width + 24, 420, false);

draw_set_color(c_black);
draw_text(margin_left, 140, "Plant one to lead, two to support, and let the rest settle low.");

if (is_array(global.garden_beds)) {
    for (var b = 0; b < array_length(global.garden_beds); b++) {
        var bed = global.garden_beds[b];
        var rect = bed.rect;
        var tier = bed.tier;
        var base_col = make_colour_rgb(230, 235, 240);
        if (tier == "mid") base_col = make_colour_rgb(230, 240, 230);
        if (tier == "tall") base_col = make_colour_rgb(240, 230, 240);
        if (is_string(global.garden_hover_tier) && global.garden_hover_tier == tier) {
            base_col = merge_colour(base_col, c_white, 0.5);
        }
        draw_set_color(base_col);
        draw_rectangle(rect.x1, rect.y1, rect.x2, rect.y2, false);
        draw_set_color(c_black);
        draw_text(rect.x1 + 12, rect.y1 + 10, tier);
    }
}

// Preview panel
var px = preview_x;
var py = preview_y;
var pw = preview_width;
var panel_height = 220;
draw_set_color(make_colour_rgb(248, 245, 240));
draw_rectangle(px - 24, py - 40, px + pw + 24, py + panel_height, false);

draw_set_color(c_black);
draw_text(px - 8, py - 28, "Test sentence");

var tall_words = [];
var mid_words = [];
var low_words = [];
var all_words = [];

if (ds_exists(global.garden_words, ds_type_list)) {
    for (var i = 0; i < ds_list_size(global.garden_words); i++) {
        var entry = ds_list_find_value(global.garden_words, i);
        if (!is_struct(entry)) {
            continue;
        }
        var label = string(entry.label);
        array_push(all_words, label);
        switch (string(entry.tier)) {
            case "tall":
                array_push(tall_words, label);
                break;
            case "mid":
                array_push(mid_words, label);
                break;
            default:
                array_push(low_words, label);
                break;
        }
    }
}

if (array_length(tall_words) == 0 && array_length(all_words) > 0) {
    array_push(tall_words, all_words[0]);
}

if (array_length(mid_words) == 0 && array_length(all_words) > 0) {
    array_push(mid_words, all_words[min(1, array_length(all_words) - 1)]);
}
if (array_length(mid_words) < 2) {
    for (var mi = 0; mi < array_length(all_words) && array_length(mid_words) < 2; mi++) {
        var candidate = all_words[mi];
        var already_mid = false;
        for (var ck = 0; ck < array_length(mid_words); ck++) {
            if (mid_words[ck] == candidate) {
                already_mid = true;
                break;
            }
        }
        if (!already_mid) {
            array_push(mid_words, candidate);
        }
    }
}

if (array_length(low_words) == 0) {
    for (var lw = 0; lw < array_length(all_words); lw++) {
        array_push(low_words, all_words[lw]);
    }
}

var tokens = [];
array_push(tokens, { text: "The", tier: "filler" });
array_push(tokens, { text: tall_words[0], tier: "tall" });
array_push(tokens, { text: "takes", tier: "filler" });
array_push(tokens, { text: "the", tier: "filler" });
array_push(tokens, { text: "lead", tier: "filler" });
array_push(tokens, { text: "while", tier: "filler" });
array_push(tokens, { text: mid_words[0], tier: "mid" });
if (array_length(mid_words) > 1) {
    array_push(tokens, { text: "and", tier: "filler" });
    array_push(tokens, { text: mid_words[1], tier: "mid" });
}
array_push(tokens, { text: "steady", tier: "filler" });
array_push(tokens, { text: "the", tier: "filler" });
array_push(tokens, { text: "scene.", tier: "filler" });
array_push(tokens, { text: "The", tier: "filler" });
array_push(tokens, { text: "ground", tier: "filler" });
array_push(tokens, { text: "stays", tier: "filler" });
array_push(tokens, { text: "quiet:", tier: "filler" });

for (var lw_index = 0; lw_index < array_length(low_words); lw_index++) {
    var quiet_word = string(low_words[lw_index]);
    var suffix = (lw_index == array_length(low_words) - 1) ? "." : ",";
    array_push(tokens, { text: quiet_word + suffix, tier: "low" });
}

var offset_x = 0;
var offset_y = 0;
var line_height = preview_spacing * 1.8;
for (var t = 0; t < array_length(tokens); t++) {
    var token = tokens[t];
    var token_text = string(token.text);
    var token_tier = string(token.tier);
    var scale = 1;
    var colour = make_colour_rgb(120, 120, 120);
    if (token_tier == "mid") {
        scale = 1.2;
        colour = make_colour_rgb(70, 90, 140);
    } else if (token_tier == "tall") {
        scale = 1.6;
        colour = make_colour_rgb(40, 40, 90);
    } else if (token_tier == "low") {
        scale = 0.95;
        colour = make_colour_rgb(150, 150, 150);
    }

    var word_width = string_width(token_text) * scale;
    if (offset_x + word_width > pw) {
        offset_x = 0;
        offset_y += line_height;
    }
    draw_set_color(colour);
    draw_text_transformed(px + offset_x, py + offset_y, token_text, scale, scale, 0);
    offset_x += word_width + preview_spacing;
}

draw_set_color(c_black);
draw_text(px - 8, py + panel_height - 32, "Let the leader breathe while the rest hush.");

if (is_struct(global.garden_result)) {
    var note_text = string(global.garden_result.note);
    draw_set_color(c_black);
    draw_text(margin_left, 440, note_text);
}
