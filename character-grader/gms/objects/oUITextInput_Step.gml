/// oUITextInput Step Event

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

caret_timer = (caret_timer + 1) mod 60;
caret_visible = (caret_timer < 30);

if (!variable_instance_exists(owner, "editor_text")) {
    exit;
}
if (!variable_instance_exists(owner, "editor_caret")) {
    exit;
}

with (owner) {
    editor_caret = clamp(editor_caret, 1, string_length(editor_text) + 1);
}

if (!variable_instance_exists(owner, "editor_focus")) {
    exit;
}

if (!owner.editor_focus) {
    exit;
}

if (keyboard_check(vk_control) && keyboard_check_pressed(ord("A"))) {
    with (owner) {
        editor_caret = string_length(editor_text) + 1;
    }
}

if (keyboard_check(vk_control) && keyboard_check_pressed(ord("V"))) {
    if (function_exists("clipboard_get_text")) {
        var clip = clipboard_get_text();
        if (is_string(clip)) {
            var limit = max_chars;
            if (variable_instance_exists(owner, "editor_max_chars") && is_real(owner.editor_max_chars)) {
                limit = owner.editor_max_chars;
            }
            clip_limit = limit;
            with (owner) {
                var add = clip;
                var limit_local = other.clip_limit;
                if (!is_real(limit_local)) {
                    limit_local = other.max_chars;
                }
                if (string_length(editor_text) + string_length(add) > limit_local) {
                    add = string_copy(add, 1, max(0, limit_local - string_length(editor_text)));
                }
                if (string_length(add) > 0) {
                    var before = string_copy(editor_text, 1, editor_caret - 1);
                    var after = string_copy(editor_text, editor_caret, string_length(editor_text) - editor_caret + 1);
                    editor_text = before + add + after;
                    editor_caret += string_length(add);
                }
            }
            clip_limit = undefined;
        }
    }
}
