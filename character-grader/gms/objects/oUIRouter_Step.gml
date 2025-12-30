/// oUIRouter Step Event

var mode = activity_mode_get();
if (!is_string(mode) || string_length(mode) <= 0) {
    mode = "writing";
}

if (keyboard_check_pressed(vk_escape)) {
    paused = !paused;
    if (instance_exists(text_input)) {
        with (text_input) {
            has_focus = (!other.paused) && other.subview == "editor" && activity_mode_get() == "writing";
        }
    }
}

if (paused) {
    if (instance_exists(text_input)) {
        with (text_input) {
            active = false;
            has_focus = false;
        }
    }
    return;
}

if (keyboard_check_pressed(ord("1"))) {
    nav_index = 0;
    subview = nav_cycle[0];
    left_view = "theory";
}
if (keyboard_check_pressed(ord("2"))) {
    nav_index = 1;
    subview = nav_cycle[1];
    left_view = "prompt";
}
if (keyboard_check_pressed(ord("3"))) {
    nav_index = 2;
    subview = nav_cycle[2];
}
if (keyboard_check_pressed(ord("4"))) {
    nav_index = 3;
    subview = nav_cycle[3];
}

if (keyboard_check_pressed(vk_tab)) {
    var dir = keyboard_check(vk_shift) ? -1 : 1;
    var count = array_length(nav_cycle);
    if (count > 0) {
        nav_index = (nav_index + dir + count) mod count;
        subview = nav_cycle[nav_index];
        if (subview == "theory" || subview == "prompt") {
            left_view = subview;
        }
    }
}

current_card = act_current_card();
mode = activity_mode_get();
if (!is_string(mode) || string_length(mode) <= 0) {
    mode = "writing";
}

if (instance_exists(text_input)) {
    with (text_input) {
        active = (activity_mode_get() == "writing") && !other.submitting;
        if (!active) {
            has_focus = false;
        } else if (other.subview == "editor") {
            has_focus = true;
        }
    }
    if (subview != "editor") {
        with (text_input) {
            has_focus = false;
        }
    }
}

if (mode == "writing" && !submitting && subview == "editor") {
    if (keyboard_check(vk_control) && keyboard_check_pressed(vk_enter)) {
        submit_editor_text();
    }
}

var text_value = "";
if (instance_exists(text_input)) {
    with (text_input) {
        text_value = ui_text_get();
    }
}
if (is_string(text_value)) {
    editor_stats.words = preview_word_count(text_value);
    editor_stats.caps = preview_caps_ratio(text_value);
    editor_stats.chars = string_length(text_value);
}

if (instance_exists(text_input)) {
    with (text_input) {
        other.right_content_height = max(content_height, draw_rect.h);
    }
}

var layout = ui_layout_compute();
var theme = ui_theme_state();
var wheel = ui_wheel_delta();
if (wheel != 0 && mode == "writing") {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    if (is_struct(layout.left)) {
        var left_rect = layout.left;
        if (mx >= left_rect.x && mx <= left_rect.x + left_rect.w && my >= left_rect.y && my <= left_rect.y + left_rect.h) {
            scroll_left -= wheel * theme.scroll_speed;
        }
    }
    if (is_struct(layout.right)) {
        var right_rect = layout.right;
        if (mx >= right_rect.x && mx <= right_rect.x + right_rect.w && my >= right_rect.y && my <= right_rect.y + right_rect.h) {
            scroll_right -= wheel * theme.scroll_speed;
        }
    }
}

if (is_struct(layout.left)) {
    var left_view_h = layout.left.h - theme.panel_header;
    var left_max = max(0, left_content_height - left_view_h);
    scroll_left = clamp(scroll_left, 0, left_max);
}
if (is_struct(layout.right)) {
    var right_view_h = layout.right.h - theme.panel_header;
    var right_max = max(0, right_content_height - right_view_h);
    scroll_right = clamp(scroll_right, 0, right_max);
}

var count_cycle = array_length(nav_cycle);
for (var i = 0; i < count_cycle; ++i) {
    if (nav_cycle[i] == subview) {
        nav_index = i;
        break;
    }
}
