/// oUITextInput Step Event

if (!is_string(text_value)) text_value = "";
if (!is_real(max_chars) || max_chars <= 0) max_chars = 5000;

caret_timer += 1;
if (caret_timer >= 24) {
    caret_timer = 0;
    caret_visible = !caret_visible;
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
if (mouse_check_button_pressed(mb_left)) {
    var inside = false;
    if (is_struct(draw_rect)) {
        if (mx >= draw_rect.x && mx <= draw_rect.x + draw_rect.w && my >= draw_rect.y && my <= draw_rect.y + draw_rect.h) {
            inside = true;
        }
    }
    if (inside && active) {
        has_focus = true;
        keyboard_string = text_value;
    } else {
        has_focus = false;
    }
}

if (!active) {
    has_focus = false;
}

if (has_focus && active) {
    text_value = keyboard_string;
    if (keyboard_check_pressed(vk_tab)) {
        text_value += "    ";
        keyboard_string = text_value;
    }
    if (string_length(text_value) > max_chars) {
        text_value = string_copy(text_value, 1, max_chars);
        keyboard_string = text_value;
    }
    caret_visible = true;
} else {
    caret_visible = false;
}

var wrap = max(32, wrap_width);
content_height = string_height_ext(text_value, 12, wrap) + ui_pad() * 2;
