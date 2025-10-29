/// Layout computation for the Character Game UI framework.

function ui_layout_compute() {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    if (gui_w <= 0) gui_w = room_width;
    if (gui_h <= 0) gui_h = room_height;

    var theme = ui_theme_state();
    var pad = ui_pad();
    var topbar_h = 68;
    var nav_h = 48;
    var tray_h = 176;

    var mode = activity_mode_get();
    if (!is_string(mode) || string_length(mode) <= 0) {
        mode = "writing";
    }

    if (mode != "writing") {
        tray_h = 120;
        if (mode == "flashcard") {
            tray_h = 140;
        }
    }

    var topbar_rect = { x: pad, y: pad, w: gui_w - pad * 2, h: topbar_h };
    var tray_y = gui_h - tray_h - pad;
    if (tray_y < topbar_rect.y + topbar_rect.h + pad) {
        tray_y = topbar_rect.y + topbar_rect.h + pad;
    }
    var nav_y = tray_y - nav_h - pad;
    if (nav_y < topbar_rect.y + topbar_rect.h + pad) {
        nav_y = topbar_rect.y + topbar_rect.h + pad;
    }

    var nav_rect = { x: pad, y: nav_y, w: gui_w - pad * 2, h: nav_h };
    var tray_rect = { x: pad, y: tray_y, w: gui_w - pad * 2, h: tray_h };

    var content_top = topbar_rect.y + topbar_rect.h + pad;
    var content_bottom = nav_rect.y - pad;
    if (content_bottom < content_top) {
        content_bottom = content_top + 100;
    }
    var content_h = content_bottom - content_top;
    if (content_h < 100) content_h = 100;

    var layout = {
        width: gui_w,
        height: gui_h,
        pad: pad,
        mode: mode,
        topbar: topbar_rect,
        nav: nav_rect,
        tray: tray_rect,
        content_top: content_top,
        content_bottom: content_bottom
    };

    if (mode == "writing") {
        var total_w = gui_w - pad * 3;
        if (total_w < 320) total_w = gui_w - pad * 2;
        var left_w = floor(total_w * 0.45);
        var right_w = total_w - left_w;
        if (left_w < 320) left_w = 320;
        if (right_w < 320) right_w = max(320, total_w - left_w);
        var left_rect = { x: pad, y: content_top, w: left_w, h: content_h };
        var right_rect = { x: pad * 2 + left_w, y: content_top, w: gui_w - pad * 3 - left_w, h: content_h };
        layout.left = left_rect;
        layout.right = right_rect;
    } else if (mode == "picker") {
        var picker_w = clamp(gui_w * 0.52, 320, gui_w - pad * 2);
        var picker_h = clamp(content_h + nav_h + pad, 260, gui_h - topbar_h - pad * 3);
        var picker_x = floor((gui_w - picker_w) * 0.5);
        var picker_y = content_top;
        layout.content = { x: picker_x, y: picker_y, w: picker_w, h: picker_h };
    } else if (mode == "flashcard") {
        var flash_w = clamp(gui_w * 0.4, 320, gui_w - pad * 2);
        var flash_x = floor((gui_w - flash_w) * 0.5);
        layout.content = { x: flash_x, y: content_top, w: flash_w, h: content_h + nav_h + pad };
    } else {
        var generic_w = clamp(gui_w * 0.5, 320, gui_w - pad * 2);
        var generic_x = floor((gui_w - generic_w) * 0.5);
        layout.content = { x: generic_x, y: content_top, w: generic_w, h: content_h + nav_h };
    }

    return layout;
}
