# scripts/scr_feedback_tray.gml
// -----------------------------------------------------------------------------
// Collapsible feedback tray helpers
// -----------------------------------------------------------------------------

function tray_init() {
    return {
        open : true,
        items : array_create(0),
        last : undefined
    };
}

function tray_push(_tray, _res) {
    array_push(_tray.items, _res);
    _tray.last = _res;
    if (array_length(_tray.items) > 10) {
        array_delete(_tray.items, 0, array_length(_tray.items) - 10);
    }
}

function tray_toggle(_tray) {
    _tray.open = !_tray.open;
}

function tray_draw(_x, _y, _w, _tray) {
    var header_h = 40;
    var padding = 16;
    var tray_h = header_h;
    var body_h = 0;

    var res = _tray.last;
    if (_tray.open && is_undefined(res) == false) {
        body_h = padding * 2;
        var note_val = "";
        if (is_struct(res) && variable_struct_exists(res, "notes")) {
            var raw = res.notes;
            if (is_string(raw)) {
                note_val = raw;
            }
        }
        if (string_length(note_val) > 0) {
            body_h += string_height_ext(note_val, 8, _w - padding * 2);
        }
        if (is_struct(res) && variable_struct_exists(res, "badgesAwarded") && is_array(res.badgesAwarded)) {
            body_h += 48;
        }
        body_h += 32; // for xp delta / score bar
    }

    tray_h += body_h;

    draw_set_color(make_color_rgb(24, 24, 28));
    draw_roundrect(_x, _y, _x + _w, _y + tray_h, 12, 12, false);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.08);
    draw_roundrect(_x, _y, _x + _w, _y + tray_h, 12, 12, false);
    draw_set_alpha(1);

    var title = "Feedback";
    draw_set_color(make_color_rgb(240, 244, 255));
    draw_text(_x + padding, _y + header_h * 0.5 - 8, title);

    var toggle_label = _tray.open ? "Hide" : "Show";
    var toggle_w = string_width(toggle_label) + 24;
    var toggle_x = _x + _w - padding - toggle_w;
    var toggle_y = _y + header_h * 0.5 - 12;
    var toggle_over = ui_mouse_in_rect_gui(toggle_x, toggle_y, toggle_w, 24);
    draw_set_color(toggle_over ? make_color_rgb(90, 110, 220) : make_color_rgb(60, 70, 90));
    draw_roundrect(toggle_x, toggle_y, toggle_x + toggle_w, toggle_y + 24, 8, 8, false);
    draw_set_color(make_color_rgb(220, 224, 240));
    draw_text(toggle_x + 12, toggle_y + 4, toggle_label);
    if (toggle_over && mouse_check_button_pressed(mb_left)) {
        tray_toggle(_tray);
    }

    if (!_tray.open || is_undefined(res)) {
        return { h : tray_h };
    }

    var body_y = _y + header_h;
    var score = 0;
    if (is_struct(res) && variable_struct_exists(res, "score")) {
        var raw_score = res.score;
        if (is_real(raw_score)) {
            score = clamp(raw_score, 0, 1);
        }
    }
    draw_set_color(make_color_rgb(40, 45, 60));
    draw_roundrect(_x + padding, body_y + padding, _x + _w - padding, body_y + padding + 16, 6, 6, false);
    draw_set_color(make_color_rgb(110, 220, 140));
    draw_roundrect(_x + padding, body_y + padding, _x + padding + ( _w - padding * 2) * score, body_y + padding + 16, 6, 6, false);
    draw_set_color(make_color_rgb(220, 226, 240));
    draw_text(_x + padding, body_y + padding + 22, "Score: " + string_format(score * 100, 2, 0) + "%");

    var notes = "";
    if (is_struct(res) && variable_struct_exists(res, "notes")) {
        var raw_notes = res.notes;
        if (is_string(raw_notes)) {
            notes = raw_notes;
        }
    }
    var text_y = body_y + padding + 40;
    if (string_length(notes) > 0) {
        draw_text_ext(_x + padding, text_y, notes, 8, _w - padding * 2);
        text_y += string_height_ext(notes, 8, _w - padding * 2) + padding;
    }

    if (is_struct(res) && variable_struct_exists(res, "badgesAwarded") && is_array(res.badgesAwarded) && array_length(res.badgesAwarded) > 0) {
        draw_set_color(make_color_rgb(255, 215, 120));
        for (var b = 0; b < array_length(res.badgesAwarded); ++b) {
            var badge = res.badgesAwarded[b];
            var by = text_y + b * 28;
            draw_roundrect(_x + padding, by, _x + padding + 160, by + 24, 8, 8, false);
            draw_text(_x + padding + 8, by + 4, badge);
        }
        text_y += array_length(res.badgesAwarded) * 28 + padding;
    }

    var xp = 0;
    if (is_struct(res) && variable_struct_exists(res, "xpDelta")) {
        var raw_xp = res.xpDelta;
        if (is_real(raw_xp)) {
            xp = raw_xp;
        }
    }
    if (xp != 0) {
        draw_set_color(make_color_rgb(130, 200, 255));
        draw_text(_x + padding, text_y, "+" + string(xp) + " XP");
    }

    return { h : tray_h };
}
