/// oUIStack Step Event

net_spinner = (net_spinner + 1) mod 360;

var action = action_clicked;
action_clicked = "";

if (keyboard_check(vk_control) && keyboard_check_pressed(vk_enter)) {
    submit_current_attempt();
}

if (keyboard_check(vk_control) && keyboard_check_pressed(ord("K"))) {
    tray_toggle(tray);
}

if (action == "Submit") {
    submit_current_attempt();
} else if (action == "Skip") {
    skip_current_card();
} else if (action == "Next") {
    request_next_card();
}

ui_editor_handle_input(self);

if (is_struct(editor_rect)) {
    if (ui_mouse_in_rect_gui(editor_rect.x, editor_rect.y, editor_rect.w, editor_rect.h)) {
        if (function_exists("mouse_wheel_up")) {
            var wheel = mouse_wheel_up() - mouse_wheel_down();
            if (wheel != 0) {
                editor_scroll = max(0, editor_scroll - wheel * 36);
            }
        }
    }
}

if (submitting) {
    net_msg = "Submitting...";
}
