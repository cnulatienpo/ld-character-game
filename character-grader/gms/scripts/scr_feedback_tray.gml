/// Feedback tray helpers for the Character Game UI.

function tray_state() {
    if (!variable_global_exists("__ui_tray") || !is_struct(global.__ui_tray)) {
        tray_init();
    }
    return global.__ui_tray;
}

function tray_init() {
    var tray = {
        entries: [],
        minimized: false,
        pinned: false,
        highlight_timer: 0,
        tab_height: 26,
        max_entries: 6
    };
    global.__ui_tray = tray;
    return tray;
}

function tray_push(_result) {
    var tray = tray_state();
    if (!is_struct(_result)) {
        return tray;
    }
    array_push(tray.entries, _result);
    while (array_length(tray.entries) > tray.max_entries) {
        array_delete(tray.entries, 0, 1);
    }
    tray.highlight_timer = 60;
    if (!tray.pinned) {
        tray.minimized = false;
    }
    return tray;
}

function tray_summary_text(_result) {
    if (!is_struct(_result)) {
        return "Awaiting feedback";
    }
    var parts = [];
    if (variable_struct_exists(_result, "score") && is_real(_result.score)) {
        var score_text = "Score " + string_format(_result.score, 0, 2);
        array_push(parts, score_text);
    }
    if (variable_struct_exists(_result, "xpDelta") && is_real(_result.xpDelta)) {
        var xp_text = "XP +" + string(_result.xpDelta);
        array_push(parts, xp_text);
    }
    if (variable_struct_exists(_result, "notes") && is_string(_result.notes) && string_length(_result.notes) > 0) {
        var note = _result.notes;
        if (string_length(note) > 140) {
            note = string_copy(note, 1, 137) + "...";
        }
        array_push(parts, note);
    }
    var summary = "";
    for (var i = 0; i < array_length(parts); ++i) {
        if (i > 0) summary += "  ·  ";
        summary += parts[i];
    }
    if (string_length(summary) <= 0) {
        summary = "Attempt recorded";
    }
    return summary;
}

function tray_draw(_rect) {
    var tray = tray_state();
    if (!is_struct(_rect)) {
        return;
    }

    var pad = ui_pad();
    var theme = ui_theme_state();
    var header_h = theme.panel_header;
    var height_full = _rect.h;
    var height_active = tray.minimized ? tray.tab_height : height_full;
    if (height_active < tray.tab_height) height_active = tray.tab_height;

    var y1 = _rect.y + height_full - height_active;
    var y2 = _rect.y + height_full;
    var x1 = _rect.x;
    var x2 = _rect.x + _rect.w;

    draw_set_alpha(0.92);
    draw_set_color(ui_col("tray_bg"));
    draw_rectangle(x1, y1, x2, y2, false);
    draw_set_alpha(1);
    draw_set_color(ui_col("tray_border"));
    draw_rectangle(x1, y1, x2, y2, true);

    var tab_w = 140;
    var tab_h = tray.tab_height;
    var tab_x = x2 - tab_w - pad * 0.5;
    var tab_y = y1 - tab_h + 6;
    if (tab_y < _rect.y) tab_y = y1 - tab_h * 0.5;

    draw_set_color(ui_col("tray_bg"));
    draw_rectangle(tab_x, tab_y, tab_x + tab_w, tab_y + tab_h, false);
    draw_set_color(ui_col("tray_border"));
    draw_rectangle(tab_x, tab_y, tab_x + tab_w, tab_y + tab_h, true);

    draw_set_color(ui_col("panel_header_text"));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var tab_label = tray.minimized ? "Show Feedback" : "Hide Feedback";
    draw_text(tab_x + tab_w * 0.5, tab_y + tab_h * 0.5, tab_label);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    if (mouse_check_button_pressed(mb_left)) {
        if (mx >= tab_x && mx <= tab_x + tab_w && my >= tab_y && my <= tab_y + tab_h) {
            tray.minimized = !tray.minimized;
        }
    }

    if (tray.minimized) {
        return;
    }

    var entries = tray.entries;
    var latest = undefined;
    if (is_array(entries) && array_length(entries) > 0) {
        latest = entries[array_length(entries) - 1];
    }

    var title_y = y1 + pad * 0.75;
    draw_set_color(ui_col("panel_header_text"));
    draw_text(x1 + pad, title_y, "Feedback");

    var summary_y = title_y + 24;
    draw_set_color(ui_col("text"));
    var summary = tray_summary_text(latest);
    draw_text_ext(x1 + pad, summary_y, summary, 12, _rect.w - pad * 2);

    if (is_struct(latest) && variable_struct_exists(latest, "badgesAwarded") && is_array(latest.badgesAwarded)) {
        var badges = latest.badgesAwarded;
        if (array_length(badges) > 0) {
            var badge_y = summary_y + 40;
            draw_set_color(ui_col("accent"));
            draw_text(x1 + pad, badge_y, "Badges:");
            var badge_x = x1 + pad + 80;
            draw_set_color(ui_col("text"));
            for (var b = 0; b < array_length(badges); ++b) {
                var badge = badges[b];
                draw_text(badge_x, badge_y, string(badge));
                badge_x += 120;
            }
        }
    }

    if (tray.highlight_timer > 0) {
        tray.highlight_timer -= 1;
        var glow = clamp(tray.highlight_timer / 60, 0, 1);
        draw_set_alpha(glow * 0.4);
        draw_set_color(ui_col("tray_highlight"));
        draw_rectangle(x1, y1, x2, y2, false);
        draw_set_alpha(1);
    }

    var pin_size = 20;
    var pin_x = x1 + _rect.w - pin_size - pad;
    var pin_y = y1 + pad * 0.5;
    draw_set_color(tray.pinned ? ui_col("accent") : ui_col("text_muted"));
    draw_rectangle(pin_x, pin_y, pin_x + pin_size, pin_y + pin_size, false);
    draw_set_color(ui_col("panel_border"));
    draw_rectangle(pin_x, pin_y, pin_x + pin_size, pin_y + pin_size, true);
    draw_set_color(ui_col("panel_header_text"));
    draw_text(pin_x + pin_size * 0.5, pin_y + pin_size * 0.5, tray.pinned ? "■" : "□");

    if (mouse_check_button_pressed(mb_left)) {
        if (mx >= pin_x && mx <= pin_x + pin_size && my >= pin_y && my <= pin_y + pin_size) {
            tray.pinned = !tray.pinned;
            if (tray.pinned) {
                tray.minimized = false;
            }
        }
    }
}
