/// Shared UI theme helpers for the Character Game UI framework.

function ui_theme_state() {
    if (!variable_global_exists("__ui_theme") || !is_struct(global.__ui_theme)) {
        global.__ui_theme = {
            pad: 18,
            panel_header: 32,
            button_height: 42,
            scroll_speed: 32,
            scrollbar_width: 12,
            last_panel: undefined,
            last_panel_header: 32,
            scroll_dragging: false,
            scroll_drag_offset: 0,
            scroll_drag_panel: undefined,
            scroll_drag_track: undefined,
            colors: {
                background: make_color_rgb(18, 20, 28),
                panel_bg: make_color_rgb(32, 38, 52),
                panel_border: make_color_rgb(58, 70, 98),
                panel_header: make_color_rgb(44, 54, 78),
                panel_header_text: c_white,
                text: c_white,
                text_muted: make_color_rgb(180, 190, 210),
                accent: make_color_rgb(96, 140, 255),
                accent_soft: make_color_rgb(66, 102, 204),
                success: make_color_rgb(60, 160, 90),
                danger: make_color_rgb(200, 70, 70),
                warning: make_color_rgb(220, 180, 90),
                tray_bg: make_color_rgb(24, 28, 40),
                tray_border: make_color_rgb(70, 90, 140),
                tray_highlight: make_color_rgb(110, 160, 255),
                button_bg: make_color_rgb(46, 56, 80),
                button_hover: make_color_rgb(70, 96, 150),
                button_active: make_color_rgb(96, 140, 255),
                button_text: c_white,
                scroll_track: make_color_rgb(50, 60, 80),
                scroll_thumb: make_color_rgb(120, 150, 210)
            }
        };
    }
    return global.__ui_theme;
}

function ui_pad() {
    return ui_theme_state().pad;
}

function ui_col(_key) {
    var theme = ui_theme_state();
    if (is_string(_key)) {
        if (is_struct(theme.colors) && variable_struct_exists(theme.colors, _key)) {
            return theme.colors[$ _key];
        }
    } else if (is_real(_key)) {
        return _key;
    }
    return theme.colors[$ "text"];
}

function ui_panel(_x, _y, _w, _h, _title) {
    var theme = ui_theme_state();
    var x2 = _x + _w;
    var y2 = _y + _h;
    draw_set_alpha(0.92);
    draw_set_color(ui_col("panel_bg"));
    draw_rectangle(_x, _y, x2, y2, false);
    draw_set_alpha(1);

    draw_set_color(ui_col("panel_border"));
    draw_rectangle(_x, _y, x2, y2, true);

    var header_h = theme.panel_header;
    var header_y = _y;
    var header_y2 = _y + header_h;
    draw_set_alpha(0.95);
    draw_set_color(ui_col("panel_header"));
    draw_rectangle(_x, header_y, x2, header_y2, false);
    draw_set_alpha(1);

    draw_set_color(ui_col("panel_header_text"));
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var pad = ui_pad();
    if (is_string(_title) && string_length(_title) > 0) {
        draw_text(_x + pad * 0.6, header_y + header_h * 0.5, _title);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    theme.last_panel = { x: _x, y: _y, w: _w, h: _h };
    theme.last_panel_header = header_h;
}

function ui_button(_x, _y, _w, _h, _label, _hotkey) {
    var theme = ui_theme_state();
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var hover = (mx >= _x && mx <= _x + _w && my >= _y && my <= _y + _h);
    var pressed = hover && mouse_check_button_pressed(mb_left);
    var active = pressed;

    var key_code = -1;
    if (is_real(_hotkey)) {
        key_code = _hotkey;
    } else if (is_struct(_hotkey) && variable_struct_exists(_hotkey, "key")) {
        key_code = _hotkey.key;
    }
    if (key_code >= 0 && keyboard_check_pressed(key_code)) {
        if (!is_struct(_hotkey) || !variable_struct_exists(_hotkey, "requires_ctrl") || keyboard_check(vk_control)) {
            active = true;
        }
    }

    var bg_col = ui_col("button_bg");
    if (hover) {
        bg_col = ui_col("button_hover");
    }
    if (active) {
        bg_col = ui_col("button_active");
    }

    draw_set_color(bg_col);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_color(ui_col("panel_border"));
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);

    var label = is_string(_label) ? _label : "";
    var hotkey_label = "";
    if (is_string(_hotkey) && string_length(_hotkey) > 0) {
        hotkey_label = _hotkey;
    } else if (is_struct(_hotkey) && variable_struct_exists(_hotkey, "label")) {
        hotkey_label = _hotkey.label;
    }
    if (string_length(hotkey_label) > 0) {
        label += "  [" + hotkey_label + "]";
    }

    draw_set_color(ui_col("button_text"));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_x + _w * 0.5, _y + _h * 0.5, label);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    return active;
}

function ui_wheel_delta() {
    if (function_exists("mouse_wheel_get_delta")) {
        return mouse_wheel_get_delta();
    }
    var delta = 0;
    if (function_exists("mouse_wheel_up")) {
        if (mouse_wheel_up()) delta += 1;
    }
    if (function_exists("mouse_wheel_down")) {
        if (mouse_wheel_down()) delta -= 1;
    }
    return delta;
}

function ui_scrollbar(_y, _content_h, _view_h, _scroll) {
    var theme = ui_theme_state();
    var panel = theme.last_panel;
    if (!is_struct(panel)) {
        return max(0, _scroll);
    }

    var max_scroll = max(0, _content_h - _view_h);
    var new_scroll = clamp(_scroll, 0, max_scroll);
    var track_x = panel.x + panel.w - theme.scrollbar_width - 2;
    var track_y = panel.y + theme.last_panel_header;
    var track_h = panel.h - theme.last_panel_header;
    if (track_h < 4) {
        track_h = panel.h;
        track_y = panel.y;
    }

    draw_set_alpha(0.35);
    draw_set_color(ui_col("scroll_track"));
    draw_rectangle(track_x, track_y, track_x + theme.scrollbar_width, track_y + track_h, false);
    draw_set_alpha(1);

    if (max_scroll <= 0) {
        draw_set_color(ui_col("scroll_thumb"));
        draw_rectangle(track_x + 1, track_y + 1, track_x + theme.scrollbar_width - 1, track_y + track_h - 1, false);
        return 0;
    }

    var view_ratio = clamp(_view_h / max(_content_h, 1), 0.05, 1);
    var thumb_h = max(18, track_h * view_ratio);
    if (thumb_h > track_h) thumb_h = track_h;
    var thumb_space = max(track_h - thumb_h, 1);
    var thumb_y = track_y + (thumb_space > 0 ? (new_scroll / max_scroll) * thumb_space : 0);

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (!mouse_check_button(mb_left)) {
        theme.scroll_dragging = false;
    }

    if (mouse_check_button_pressed(mb_left)) {
        if (mx >= track_x && mx <= track_x + theme.scrollbar_width && my >= thumb_y && my <= thumb_y + thumb_h) {
            theme.scroll_dragging = true;
            theme.scroll_drag_offset = my - thumb_y;
            theme.scroll_drag_panel = panel;
            theme.scroll_drag_track = { y: track_y, h: track_h, thumb_h: thumb_h };
            theme.scroll_drag_max = max_scroll;
        }
    }

    if (theme.scroll_dragging) {
        if (theme.scroll_drag_panel == panel && is_struct(theme.scroll_drag_track)) {
            var drag_info = theme.scroll_drag_track;
            var new_thumb_y = clamp(my - theme.scroll_drag_offset, track_y, track_y + drag_info.h - drag_info.thumb_h);
            if (drag_info.h > drag_info.thumb_h) {
                new_scroll = ((new_thumb_y - track_y) / (drag_info.h - drag_info.thumb_h)) * max_scroll;
            }
        }
    }

    draw_set_alpha(0.85);
    draw_set_color(ui_col("scroll_thumb"));
    draw_rectangle(track_x + 1, thumb_y, track_x + theme.scrollbar_width - 1, thumb_y + thumb_h, false);
    draw_set_alpha(1);

    return clamp(new_scroll, 0, max_scroll);
}
