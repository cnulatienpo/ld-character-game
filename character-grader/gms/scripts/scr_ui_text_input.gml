/// Script helpers backing oUITextInput.

function ui_text_init(_max_chars) {
    if (!is_real(_max_chars) || _max_chars <= 0) {
        _max_chars = 5000;
    }
    max_chars = floor(_max_chars);
    if (!is_string(text_value)) {
        text_value = "";
    }
    active = true;
    has_focus = true;
    caret_timer = 0;
    caret_visible = true;
    draw_rect = { x: 0, y: 0, w: 0, h: 0 };
    content_height = 0;
    wrap_width = 0;
    if (active) {
        keyboard_string = text_value;
    }
}

function ui_text_draw(_rect) {
    if (!is_struct(_rect)) {
        return;
    }
    var scroll = 0;
    if (variable_struct_exists(_rect, "scroll")) {
        scroll = _rect.scroll;
    }
    var pad = ui_pad();
    draw_rect = { x: _rect.x, y: _rect.y, w: _rect.w, h: _rect.h };
    wrap_width = max(32, _rect.w - pad * 2);

    var base_y = _rect.y + pad;
    var text_x = _rect.x + pad;
    var draw_y = base_y - scroll;
    var caret_text = is_string(text_value) ? text_value : "";
    if (has_focus && caret_visible) {
        caret_text += "|";
    }

    draw_set_color(ui_col("text"));
    draw_text_ext(text_x, draw_y, caret_text, 12, wrap_width);
}

function ui_text_get() {
    if (!is_string(text_value)) {
        return "";
    }
    return text_value;
}

function ui_text_set(_s) {
    if (!is_string(_s)) {
        _s = "";
    }
    text_value = _s;
    if (active && has_focus) {
        keyboard_string = text_value;
    }
}
