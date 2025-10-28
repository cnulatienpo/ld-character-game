/// Preview helpers used when grade_preview is unavailable.

function preview_word_count(_s) {
    if (!is_string(_s) || string_length(_s) == 0) {
        return 0;
    }
    var count = 0;
    var in_word = false;
    var len = string_length(_s);
    for (var i = 1; i <= len; ++i) {
        var ch = string_char_at(_s, i);
        var is_space = (ch == " " || ch == "\n" || ch == "\t" || ch == "\r");
        if (!is_space) {
            if (!in_word) {
                count += 1;
                in_word = true;
            }
        } else {
            in_word = false;
        }
    }
    return count;
}

function preview_caps_ratio(_s) {
    if (!is_string(_s) || string_length(_s) == 0) {
        return 0;
    }
    var letters = 0;
    var caps = 0;
    var len = string_length(_s);
    for (var i = 1; i <= len; ++i) {
        var ch = string_char_at(_s, i);
        var code = ord(ch);
        if ((code >= ord("A") && code <= ord("Z")) || (code >= ord("a") && code <= ord("z"))) {
            letters += 1;
            if (code >= ord("A") && code <= ord("Z")) {
                caps += 1;
            }
        }
    }
    if (letters <= 0) {
        return 0;
    }
    return caps / letters;
}
