/// oUIRouter Draw GUI Event

var layout = ui_layout_compute();
var theme = ui_theme_state();
var pad = ui_pad();
var gui_w = layout.width;
var gui_h = layout.height;

function join_tokens(_arr) {
    if (!is_array(_arr)) {
        return "";
    }
    var out = "";
    for (var j = 0; j < array_length(_arr); ++j) {
        if (j > 0) out += ", ";
        out += string(_arr[j]);
    }
    return out;
}

draw_set_color(ui_col("background"));
draw_rectangle(0, 0, gui_w, gui_h, false);

draw_set_color(ui_col("text"));

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var topbar = layout.topbar;
var mode = activity_mode_get();
ui_panel(topbar.x, topbar.y, topbar.w, topbar.h, "Session");

var xp = is_struct(progress_state) && is_real(progress_state.xp) ? progress_state.xp : 0;
var level = is_struct(progress_state) && is_real(progress_state.level) ? progress_state.level : level_for_xp(xp);
var badge_count = 0;
if (is_struct(progress_state) && is_array(progress_state.badges)) {
    badge_count = array_length(progress_state.badges);
}
var completed = 0;
if (is_struct(progress_state) && is_struct(progress_state.cards)) {
    var keys = variable_struct_get_names(progress_state.cards);
    if (is_array(keys)) {
        for (var i = 0; i < array_length(keys); ++i) {
            var entry = progress_state.cards[$ keys[i]];
            if (is_struct(entry) && variable_struct_exists(entry, "passed") && entry.passed) {
                completed += 1;
            }
        }
    }
}

var top_y = topbar.y + theme.panel_header * 0.2 + pad * 0.4;
var top_x = topbar.x + pad;

draw_set_color(ui_col("text"));
draw_text(top_x, top_y, "XP: " + string(xp) + "  |  Level: " + string(level));
draw_text(top_x, top_y + 24, "Badges: " + string(badge_count) + "  |  Completed: " + string(completed));

var card_label = "No card";
if (is_struct(current_card)) {
    var title = variable_struct_exists(current_card, "title") && is_string(current_card.title) ? current_card.title : "";
    var card_id = variable_struct_exists(current_card, "id") ? string(current_card.id) : "";
    card_label = card_id;
    if (string_length(title) > 0) {
        card_label = card_id + " – " + title;
    }
}
draw_text(top_x, top_y + 48, "Current: " + card_label);

var net_text = net_status;
if (!global.net_online) {
    net_text = "Offline";
}
var mode_label = string_upper(mode);
draw_set_halign(fa_right);
draw_text(topbar.x + topbar.w - pad, top_y, "Mode: " + mode_label);
draw_text(topbar.x + topbar.w - pad, top_y + 24, "Network: " + net_text);
draw_set_halign(fa_left);

if (mode == "writing") {
    if (is_struct(layout.left)) {
        var left_rect = layout.left;
        var left_title = string_upper(left_view);
        var content_view = left_view;
        if (subview == "feedback") {
            left_title = "FEEDBACK";
            content_view = "feedback";
        }
        ui_panel(left_rect.x, left_rect.y, left_rect.w, left_rect.h, left_title);
        var clip_x = floor(left_rect.x + 1);
        var clip_y = floor(left_rect.y + theme.panel_header);
        var clip_w = floor(left_rect.w - theme.scrollbar_width - 2);
        if (clip_w < 8) clip_w = left_rect.w - 4;
        var clip_h = floor(left_rect.h - theme.panel_header - 2);
        if (clip_h < 0) clip_h = left_rect.h;
        gpu_set_scissor(clip_x, clip_y, clip_w, clip_h);

        var base_y = left_rect.y + theme.panel_header + pad;
        var cursor = base_y;
        var text_x = left_rect.x + pad;
        var text_w = left_rect.w - pad * 2 - theme.scrollbar_width;
        if (text_w < 24) text_w = left_rect.w - pad;
        var draw_y = cursor - scroll_left;

        if (content_view == "theory") {
            var theory_text = "";
            if (is_struct(current_card) && variable_struct_exists(current_card, "theory") && is_string(current_card.theory)) {
                theory_text = current_card.theory;
            } else if (is_struct(current_card) && variable_struct_exists(current_card, "prompt") && is_string(current_card.prompt)) {
                theory_text = current_card.prompt;
            } else {
                theory_text = "Theory not available.";
            }
            draw_set_color(ui_col("text"));
            draw_text_ext(text_x, draw_y, theory_text, 12, text_w);
            cursor += string_height_ext(theory_text, 12, text_w) + pad;
        } else if (content_view == "prompt") {
            if (is_struct(current_card)) {
                if (variable_struct_exists(current_card, "title") && is_string(current_card.title)) {
                    draw_set_color(ui_col("accent"));
                    draw_text(text_x, draw_y, current_card.title);
                    cursor += 26;
                    draw_y = cursor - scroll_left;
                }
                if (variable_struct_exists(current_card, "prompt") && is_string(current_card.prompt)) {
                    draw_set_color(ui_col("text"));
                    draw_text_ext(text_x, draw_y, current_card.prompt, 12, text_w);
                    cursor += string_height_ext(current_card.prompt, 12, text_w) + pad;
                    draw_y = cursor - scroll_left;
                }
                if (variable_struct_exists(current_card, "examples_positive") && is_array(current_card.examples_positive) && array_length(current_card.examples_positive) > 0) {
                    draw_set_color(ui_col("accent_soft"));
                    draw_text(text_x, draw_y, "Examples:");
                    cursor += 20;
                    draw_y = cursor - scroll_left;
                    draw_set_color(ui_col("text"));
                    for (var ex = 0; ex < array_length(current_card.examples_positive); ++ex) {
                        var example = current_card.examples_positive[ex];
                        draw_text_ext(text_x + 16, draw_y, string(example), 12, text_w - 16);
                        cursor += string_height_ext(string(example), 12, text_w - 16) + 8;
                        draw_y = cursor - scroll_left;
                    }
                }
                if (variable_struct_exists(current_card, "tags") && is_array(current_card.tags) && array_length(current_card.tags) > 0) {
                    draw_set_color(ui_col("text_muted"));
                    var tag_line = "Tags: " + join_tokens(current_card.tags);
                    draw_text_ext(text_x, draw_y, tag_line, 12, text_w);
                    cursor += string_height_ext(tag_line, 12, text_w) + pad;
                    draw_y = cursor - scroll_left;
                }
                if (variable_struct_exists(current_card, "gate_rules") && is_struct(current_card.gate_rules)) {
                    draw_set_color(ui_col("text_muted"));
                    draw_text(text_x, draw_y, "Constraints:");
                    cursor += 22;
                    draw_y = cursor - scroll_left;
                    var gate = current_card.gate_rules;
                    if (variable_struct_exists(gate, "must_include_any") && is_array(gate.must_include_any)) {
                        var any_text = "Include any: " + join_tokens(gate.must_include_any);
                        draw_text_ext(text_x + 16, draw_y, any_text, 12, text_w - 16);
                        cursor += string_height_ext(any_text, 12, text_w - 16) + 8;
                        draw_y = cursor - scroll_left;
                    }
                    if (variable_struct_exists(gate, "must_include_all") && is_array(gate.must_include_all)) {
                        var all_text = "Include all: " + join_tokens(gate.must_include_all);
                        draw_text_ext(text_x + 16, draw_y, all_text, 12, text_w - 16);
                        cursor += string_height_ext(all_text, 12, text_w - 16) + 8;
                        draw_y = cursor - scroll_left;
                    }
                }
            }
        } else if (content_view == "feedback") {
            var feedback = activity_last_result();
            if (!is_struct(feedback)) {
                feedback = last_result;
            }
            if (is_struct(feedback)) {
                var summary = tray_summary_text(feedback);
                draw_set_color(ui_col("text"));
                draw_text_ext(text_x, draw_y, summary, 12, text_w);
                cursor += string_height_ext(summary, 12, text_w) + pad;
                draw_y = cursor - scroll_left;
                if (variable_struct_exists(feedback, "notes") && is_string(feedback.notes)) {
                    draw_set_color(ui_col("text_muted"));
                    draw_text_ext(text_x, draw_y, feedback.notes, 12, text_w);
                    cursor += string_height_ext(feedback.notes, 12, text_w) + pad;
                    draw_y = cursor - scroll_left;
                }
                if (variable_struct_exists(feedback, "badgesAwarded") && is_array(feedback.badgesAwarded) && array_length(feedback.badgesAwarded) > 0) {
                    draw_set_color(ui_col("accent"));
                    draw_text(text_x, draw_y, "Badges earned:");
                    cursor += 22;
                    draw_y = cursor - scroll_left;
                    draw_set_color(ui_col("text"));
                    for (var fb = 0; fb < array_length(feedback.badgesAwarded); ++fb) {
                        draw_text(text_x + 16, draw_y, string(feedback.badgesAwarded[fb]));
                        cursor += 20;
                        draw_y = cursor - scroll_left;
                    }
                }
            } else {
                draw_set_color(ui_col("text_muted"));
                draw_text(text_x, draw_y, "No feedback yet. Submit an attempt to view results.");
                cursor += 24;
            }
        }

        gpu_set_scissor(0, 0, gui_w, gui_h);
        left_content_height = max(cursor - (left_rect.y + theme.panel_header), left_rect.h - theme.panel_header);
        scroll_left = ui_scrollbar(left_rect.y, left_content_height, left_rect.h - theme.panel_header, scroll_left);
    }

    if (is_struct(layout.right)) {
        var right_rect = layout.right;
        ui_panel(right_rect.x, right_rect.y, right_rect.w, right_rect.h, "Editor");
        var editor_clip_x = floor(right_rect.x + 1);
        var editor_clip_y = floor(right_rect.y + theme.panel_header);
        var editor_clip_w = floor(right_rect.w - theme.scrollbar_width - 2);
        if (editor_clip_w < 8) editor_clip_w = right_rect.w - 4;
        var editor_clip_h = floor(right_rect.h - theme.panel_header - 2);
        if (editor_clip_h < 0) editor_clip_h = right_rect.h;
        gpu_set_scissor(editor_clip_x, editor_clip_y, editor_clip_w, editor_clip_h);

        var editor_content_calc = right_rect.h - theme.panel_header;
        if (instance_exists(text_input)) {
            with (text_input) {
                ui_text_draw({ x: right_rect.x + pad, y: right_rect.y + theme.panel_header + pad, w: right_rect.w - pad * 2 - theme.scrollbar_width, h: right_rect.h - theme.panel_header - pad * 2, scroll: other.scroll_right });
                content_height = string_height_ext(ui_text_get(), 12, max(32, right_rect.w - pad * 2 - theme.scrollbar_width)) + pad * 2;
                other.right_content_height = max(other.right_content_height, content_height);
                editor_content_calc = max(editor_content_calc, content_height);
            }
        }
        gpu_set_scissor(0, 0, gui_w, gui_h);
        right_content_height = editor_content_calc;
        scroll_right = ui_scrollbar(right_rect.y, right_content_height, right_rect.h - theme.panel_header, scroll_right);

        var stats_y = right_rect.y + right_rect.h - theme.panel_header - theme.button_height - pad * 2;
        var stats_text = "Words: " + string(editor_stats.words) + "  |  Caps: " + string(round(editor_stats.caps * 100)) + "%  |  Characters: " + string(editor_stats.chars);
        draw_set_color(ui_col("text_muted"));
        draw_text(right_rect.x + pad, stats_y, stats_text);

        var button_y = right_rect.y + right_rect.h - theme.button_height - pad;
        var button_w = 150;
        var submit_x = right_rect.x + pad;
        var skip_x = submit_x + button_w + pad;
        var next_x = skip_x + button_w + pad;

        var submit_hotkey = "Ctrl+Enter";
        if (ui_button(submit_x, button_y, button_w, theme.button_height, submitting ? "Submitting..." : "Submit", submit_hotkey)) {
            if (!submitting) {
                submit_editor_text();
            }
        }
        if (ui_button(skip_x, button_y, button_w, theme.button_height, "Skip", "")) {
            if (!submitting) {
                skip_current_card();
            }
        }
        if (ui_button(next_x, button_y, button_w, theme.button_height, loading_next ? "Loading..." : "Next", "")) {
            if (!loading_next) {
                request_next_card();
            }
        }
    }
} else {
    if (is_struct(layout.content)) {
        var content_rect = layout.content;
        ui_panel(content_rect.x, content_rect.y, content_rect.w, content_rect.h, string_upper(mode));
        draw_set_color(ui_col("text"));
        draw_text(content_rect.x + pad, content_rect.y + theme.panel_header + pad, "Activity mode active. Use the picker to continue.");
    }
}

var nav = layout.nav;
var nav_count = array_length(nav_cycle);
if (nav_count > 0) {
    draw_set_color(ui_col("panel_bg"));
    draw_rectangle(nav.x, nav.y, nav.x + nav.w, nav.y + nav.h, false);
    draw_set_color(ui_col("panel_border"));
    draw_rectangle(nav.x, nav.y, nav.x + nav.w, nav.y + nav.h, true);
    var button_space = nav.w - pad * (nav_count + 1);
    if (button_space < 0) button_space = nav.w - pad * 2;
    var nav_w = button_space / nav_count;
    var nav_x = nav.x + pad;
    var nav_y = nav.y + pad * 0.5;
    var nav_h = nav.h - pad;
    for (var n = 0; n < nav_count; ++n) {
        var nav_name = nav_cycle[n];
        var label = string_upper(nav_name);
        if (nav_name == subview) {
            draw_set_color(ui_col("accent_soft"));
            draw_rectangle(nav_x - 2, nav_y - 2, nav_x + nav_w + 2, nav_y + nav_h + 2, true);
        }
        if (ui_button(nav_x, nav_y, nav_w, nav_h, label, "")) {
            subview = nav_name;
            if (nav_name == "theory" || nav_name == "prompt") {
                left_view = nav_name;
            }
        }
        nav_x += nav_w + pad;
    }
}

tray_draw(layout.tray);
