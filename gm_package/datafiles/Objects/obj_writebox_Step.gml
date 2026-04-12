/// obj_writebox : Step Event
// Capture keyboard input and push it to global.player_response.
if (keyboard_string != "") {
    buffer_string += keyboard_string;
    keyboard_string = "";
}

if (keyboard_check_pressed(vk_backspace) && string_length(buffer_string) > 0) {
    buffer_string = string_copy(buffer_string, 1, string_length(buffer_string) - 1);
}

if (keyboard_check_pressed(vk_enter)) {
    buffer_string += "\n";
}

global.player_response = buffer_string;

caret_timer = (caret_timer + 1) mod caret_interval;
