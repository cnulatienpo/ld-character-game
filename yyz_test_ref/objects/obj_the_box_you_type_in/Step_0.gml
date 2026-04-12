var key = keyboard_lastkey;

if (keyboard_check_pressed(key)) {
    // letters
    if (key >= ord("A") && key <= ord("Z")) {
        typed_text += chr(key);
    }

    // space
    if (key == vk_space) {
        typed_text += " ";
    }

    // backspace
    if (key == vk_backspace && string_length(typed_text) > 0) {
        typed_text = string_delete(typed_text, string_length(typed_text), 1);
    }
}
