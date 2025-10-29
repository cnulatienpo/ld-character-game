# scripts/scr_ui_centerstack.gml
// -----------------------------------------------------------------------------
// Center stack UI helpers
// -----------------------------------------------------------------------------

#macro UI_CONTENT_W 860
#macro UI_RAIL_W    220
#macro UI_GAP       16
#macro UI_PADDING   20
#macro UI_EDITOR_H  580

function ui_center_rects() {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var cx = max(UI_GAP, (gw - UI_CONTENT_W) * 0.5);
    var rail_h = gh - UI_GAP * 2;

    return {
        content : { x : cx, y : UI_GAP, w : UI_CONTENT_W },
        rail_left : {
            x : max(UI_GAP, cx - UI_GAP - UI_RAIL_W),
            y : UI_GAP,
            w : UI_RAIL_W,
            h : rail_h
        },
        rail_right : {
            x : min(gw - UI_GAP - UI_RAIL_W, cx + UI_CONTENT_W + UI_GAP),
            y : UI_GAP,
            w : UI_RAIL_W,
            h : rail_h
        }
    };
}

function ui_box_autogrow(_x, _y, _w, _text, _max_w, _wrap) {
    var wrap_w = (_wrap) ? min(_w - UI_PADDING * 2, _max_w) : -1;
    var h = UI_PADDING * 2;
    if (string_length(_text) > 0) {
        var line_h = string_height_ext(_text, UI_PADDING * 0.75, wrap_w);
        h += line_h;
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(26, 26, 30));
    draw_roundrect(_x, _y, _x + _w, _y + h, 12, 12, false);
    draw_set_color(make_color_rgb(235, 235, 240));
    draw_set_alpha(0.1);
    draw_roundrect(_x, _y, _x + _w, _y + h, 12, 12, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(255, 255, 255));

    if (string_length(_text) > 0) {
        var tx = _x + UI_PADDING;
        var ty = _y + UI_PADDING;
        if (_wrap) {
            draw_text_ext(tx, ty, _text, UI_PADDING * 0.75, wrap_w);
        } else {
            draw_text(tx, ty, _text);
        }
    }

    return { h : h };
}

function ui_box_editor(_x, _y, _w, _h, _state) {
    var header_h = 42;
    var body_y = _y + header_h;
    var body_h = _h - header_h;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // background
    draw_set_color(make_color_rgb(18, 18, 22));
    draw_roundrect(_x, _y, _x + _w, _y + _h, 16, 16, false);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.08);
    draw_roundrect(_x, _y, _x + _w, _y + _h, 16, 16, false);
    draw_set_alpha(1);

    // header strip
    draw_set_color(make_color_rgb(36, 36, 42));
    draw_roundrect(_x, _y, _x + _w, _y + header_h, 16, 16, false);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_text(_x + UI_PADDING, _y + header_h * 0.5 - 8, "Editor");

    var words = wc_count(_state.editor_text);
    var caps = caps_ratio(_state.editor_text) * 100;
    var stats = string("Words: ") + string(words) + "    Caps: " + string_format(caps, 2, 1) + "%";
    draw_set_color(make_color_rgb(180, 186, 200));
    draw_text(_x + _w - UI_PADDING - string_width(stats), _y + header_h * 0.5 - 8, stats);

    // body
    var scroll_max = max(0, string_height_ext(_state.editor_text, UI_PADDING * 0.75, _w - UI_PADDING * 2) - body_h + UI_PADDING * 2);
    _state.editor_scroll = clamp(_state.editor_scroll, 0, scroll_max);

    var clip_x1 = _x + UI_PADDING;
    var clip_y1 = body_y + UI_PADDING;
    var clip_x2 = _x + _w - UI_PADDING;
    var clip_y2 = _y + _h - UI_PADDING;

    gpu_set_scissor_rect(clip_x1, clip_y1, clip_x2 - clip_x1, clip_y2 - clip_y1);
    draw_set_color(make_color_rgb(230, 232, 240));
    draw_text_ext(_x + UI_PADDING, body_y + UI_PADDING - _state.editor_scroll, _state.editor_text, UI_PADDING * 0.75, _w - UI_PADDING * 2);
    gpu_reset_scissor();

    // scrollbars (simple)
    if (scroll_max > 0) {
        var bar_h = max(32, body_h * (body_h / (body_h + scroll_max)));
        var bar_y = body_y + (_state.editor_scroll / scroll_max) * (body_h - bar_h);
        draw_set_color(make_color_rgb(80, 90, 110));
        draw_roundrect(_x + _w - 10, bar_y, _x + _w - 6, bar_y + bar_h, 2, 2, false);
    }

    // focus management
    if (mouse_check_button_pressed(mb_left)) {
        if (ui_mouse_in_rect_gui(_x, _y, _w, _h)) {
            _state.editor_focus = true;
        } else {
            _state.editor_focus = false;
        }
    }
}

function ui_action_strip(_x, _y, _w, _buttons) {
    var button_w = (_w - UI_GAP * 2) / 3;
    var button_h = 44;
    var labels = ["Submit", "Skip", "Next"];
    var result = "";

    for (var i = 0; i < 3; ++i) {
        var bx = _x + i * (button_w + UI_GAP);
        var by = _y;
        var over = ui_mouse_in_rect_gui(bx, by, button_w, button_h);
        var col = over ? make_color_rgb(90, 120, 255) : make_color_rgb(60, 70, 90);
        draw_set_color(col);
        draw_roundrect(bx, by, bx + button_w, by + button_h, 10, 10, false);
        draw_set_color(make_color_rgb(240, 242, 255));
        draw_text(bx + button_w * 0.5 - string_width(labels[i]) * 0.5, by + button_h * 0.5 - 8, labels[i]);

        if (over && mouse_check_button_pressed(mb_left)) {
            result = string(labels[i]);
        }
    }

    return result;
}

function ui_mouse_in_rect_gui(_x, _y, _w, _h) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    return (mx >= _x && mx <= _x + _w && my >= _y && my <= _y + _h);
}

function ui_editor_handle_input(_state) {
    if (!_state.editor_focus) {
        keyboard_string = "";
        return;
    }

    var insert_text = keyboard_string;
    keyboard_string = "";

    var max_chars = 5000;
    if (variable_instance_exists(_state, "editor_max_chars") && is_real(_state.editor_max_chars)) {
        max_chars = _state.editor_max_chars;
    }

    if (string_length(insert_text) > 0) {
        var remaining = max_chars - string_length(_state.editor_text);
        if (remaining <= 0) {
            insert_text = "";
        } else if (string_length(insert_text) > remaining) {
            insert_text = string_copy(insert_text, 1, remaining);
        }
        if (string_length(insert_text) > 0) {
            var before = string_copy(_state.editor_text, 1, _state.editor_caret - 1);
            var after = string_copy(_state.editor_text, _state.editor_caret, string_length(_state.editor_text) - _state.editor_caret + 1);
            _state.editor_text = before + insert_text + after;
            _state.editor_caret += string_length(insert_text);
        }
    }

    if (keyboard_check_pressed(vk_backspace)) {
        if (_state.editor_caret > 1) {
            var before_len = _state.editor_caret - 2;
            var before = (before_len >= 0) ? string_copy(_state.editor_text, 1, before_len + 1) : "";
            var after = string_copy(_state.editor_text, _state.editor_caret, string_length(_state.editor_text) - _state.editor_caret + 1);
            _state.editor_text = before + after;
            _state.editor_caret = max(1, _state.editor_caret - 1);
        }
    }

    if (keyboard_check_pressed(vk_delete)) {
        var after_len = max(0, string_length(_state.editor_text) - _state.editor_caret);
        var after = string_copy(_state.editor_text, _state.editor_caret + 1, after_len);
        var before = string_copy(_state.editor_text, 1, _state.editor_caret - 1);
        _state.editor_text = before + after;
    }

    if (keyboard_check_pressed(vk_left)) {
        _state.editor_caret = max(1, _state.editor_caret - 1);
    }

    if (keyboard_check_pressed(vk_right)) {
        _state.editor_caret = min(string_length(_state.editor_text) + 1, _state.editor_caret + 1);
    }

    if (keyboard_check_pressed(vk_home)) {
        _state.editor_caret = 1;
    }

    if (keyboard_check_pressed(vk_end)) {
        _state.editor_caret = string_length(_state.editor_text) + 1;
    }

    _state.editor_caret = clamp(_state.editor_caret, 1, string_length(_state.editor_text) + 1);
}

function wc_count(_s) {
    if (string_length(_s) <= 0) return 0;
    var count = 0;
    var in_word = false;
    for (var i = 1; i <= string_length(_s); ++i) {
        var ch = string_char_at(_s, i);
        if (ch == " " || ch == "\n" || ch == "\t") {
            if (in_word) {
                count++;
                in_word = false;
            }
        } else {
            in_word = true;
        }
    }
    if (in_word) count++;
    return count;
}

function caps_ratio(_s) {
    var len = string_length(_s);
    if (len <= 0) return 0;
    var caps = 0;
    var total = 0;
    for (var i = 1; i <= len; ++i) {
        var ch = string_char_at(_s, i);
        if (ord(ch) >= ord("A") && ord(ch) <= ord("Z")) {
            caps++;
            total++;
        } else if (ord(ch) >= ord("a") && ord(ch) <= ord("z")) {
            total++;
        }
    }
    if (total <= 0) return 0;
    return caps / total;
}
