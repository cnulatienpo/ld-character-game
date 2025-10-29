/// oUITextInput Draw GUI Event

if (!instance_exists(owner)) {
    exit;
}

if (!variable_instance_exists(owner, "editor_focus")) {
    exit;
}

if (!owner.editor_focus) {
    exit;
}

if (!caret_visible) {
    exit;
}

var rect = owner.editor_rect;
if (!is_struct(rect)) {
    exit;
}

if (!variable_instance_exists(owner, "editor_scroll")) {
    exit;
}

var wrap_w = rect.w - UI_PADDING * 2;
var content = string_copy(owner.editor_text, 1, owner.editor_caret - 1);
var lines = 0;
var line = "";
var len = string_length(content);
var line_height = string_height("A") + 8;

for (var i = 1; i <= len; ++i) {
    var ch = string_char_at(content, i);
    if (ch == "\n") {
        lines += 1;
        line = "";
        continue;
    }
    var next_line = line + ch;
    if (string_width(next_line) > wrap_w) {
        lines += 1;
        line = ch;
    } else {
        line = next_line;
    }
}

var caret_x = rect.x + UI_PADDING + string_width(line);
var caret_y = rect.y + UI_PADDING + lines * line_height - owner.editor_scroll;

if (caret_y >= rect.y + UI_PADDING - owner.editor_scroll && caret_y <= rect.y + rect.h) {
    draw_set_color(make_color_rgb(120, 170, 255));
    draw_rectangle(caret_x, caret_y, caret_x + 2, caret_y + string_height("A"), false);
}
