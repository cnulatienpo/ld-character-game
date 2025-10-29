# scripts/scr_tool_rails.gml
// -----------------------------------------------------------------------------
// Symmetrical tool rails management
// -----------------------------------------------------------------------------

globalvar tool_inventory;

tool_inventory = array_create(0);

function tool_rails_init() {
    if (!is_array(tool_inventory)) {
        tool_inventory = array_create(0);
    }

    if (array_length(tool_inventory) == 0) {
        var base = [
            { id : "wc", label : "Word Count", icon : "i_wc" },
            { id : "tags", label : "Tags", icon : "i_tags" },
            { id : "history", label : "History", icon : "i_history" },
            { id : "badges", label : "Badges", icon : "i_badges" }
        ];
        var out = array_create(array_length(base) * 2);
        var idx = 0;
        for (var i = 0; i < array_length(base); ++i) {
            var left_tool = base[i];
            out[idx++] = {
                id : left_tool.id,
                label : left_tool.label,
                side : "left",
                icon : left_tool.icon,
                unlocked : (i < 2)
            };
            out[idx++] = {
                id : left_tool.id,
                label : left_tool.label,
                side : "right",
                icon : left_tool.icon,
                unlocked : (i < 2)
            };
        }
        tool_inventory = out;
    }
}

function tool_rails_draw(_rect_left, _rect_right, _state) {
    var pad = 14;
    var card_h = 60;
    var card_gap = 10;

    var left_tools = array_create(0);
    var right_tools = array_create(0);
    for (var i = 0; i < array_length(tool_inventory); ++i) {
        var tool = tool_inventory[i];
        if (!tool.unlocked) continue;
        if (tool.side == "left") {
            array_push(left_tools, tool);
        } else if (tool.side == "right") {
            array_push(right_tools, tool);
        }
    }

    _state.rail_scroll_left = tool_rail_draw_column(_rect_left, left_tools, _state.rail_scroll_left, pad, card_gap, card_h);
    _state.rail_scroll_right = tool_rail_draw_column(_rect_right, right_tools, _state.rail_scroll_right, pad, card_gap, card_h);
}

function tool_rail_draw_column(_rect, _tools, _scroll, _pad, _gap, _card_h) {
    var x = _rect.x;
    var y = _rect.y;
    var w = _rect.w;
    var h = _rect.h;

    draw_set_color(make_color_rgb(18, 18, 22));
    draw_roundrect(x, y, x + w, y + h, 12, 12, false);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.05);
    draw_roundrect(x, y, x + w, y + h, 12, 12, false);
    draw_set_alpha(1);

    var scroll_max = max(0, (_card_h + _gap) * array_length(_tools) - _gap - (h - _pad * 2));
    _scroll = clamp(_scroll, 0, scroll_max);

    var clip_x1 = x + 4;
    var clip_y1 = y + 4;
    var clip_w = w - 8;
    var clip_h = h - 8;

    gpu_set_scissor_rect(clip_x1, clip_y1, clip_w, clip_h);

    var ty = y + _pad - _scroll;
    for (var i = 0; i < array_length(_tools); ++i) {
        var tool = _tools[i];
        var by = ty + i * (_card_h + _gap);
        draw_set_color(make_color_rgb(42, 48, 60));
        draw_roundrect(x + _pad, by, x + w - _pad, by + _card_h, 10, 10, false);
        draw_set_color(make_color_rgb(200, 205, 220));
        draw_text(x + _pad + 12, by + _card_h * 0.5 - 8, tool.label);
        draw_set_color(make_color_rgb(120, 160, 255));
        draw_rectangle(x + w - _pad - 32, by + _card_h * 0.5 - 12, x + w - _pad - 12, by + _card_h * 0.5 + 8, false);
    }

    gpu_reset_scissor();

    if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + w, y + h)) {
        if (function_exists("mouse_wheel_up")) {
            var wheel = mouse_wheel_up() - mouse_wheel_down();
            if (wheel != 0) {
                _scroll -= wheel * (_card_h * 0.3);
            }
        }
    }

    return _scroll;
}

function tool_rails_unlock(_id) {
    for (var i = 0; i < array_length(tool_inventory); ++i) {
        if (tool_inventory[i].id == _id) {
            tool_inventory[i].unlocked = true;
        }
    }
}
