/// @function scr_quiz_text_wrap(_text, _width, _margin)
/// @description Wraps `_text` into lines that fit `_width`, padding with `_margin` on each side.
/// @param _text The string to wrap.
/// @param _width Maximum width for the text block in pixels.
/// @param _margin Horizontal padding in pixels.
function scr_quiz_text_wrap(_text, _width, _margin) {
    var wrap_width = max(32, _width);
    var pad = max(0, _margin);
    var words = string_split(string(_text), " ");
    var lines = [];
    var current = "";
    var base_width = wrap_width - pad * 2;
    var lh = string_height("Ay") + 2;

    for (var i = 0; i < array_length(words); i++) {
        var word = words[i];
        if (string_length(word) == 0) {
            continue;
        }

        var next_line = (string_length(current) == 0) ? word : current + " " + word;
        if (string_width(next_line) <= base_width) {
            current = next_line;
        } else {
            if (string_length(current) > 0) {
                array_push(lines, current);
            }
            current = word;
        }
    }

    if (string_length(current) > 0) {
        array_push(lines, current);
    }

    if (array_length(lines) == 0) {
        array_push(lines, "");
    }

    var block_height = array_length(lines) * lh + pad * 2;

    return {
        lines: lines,
        line_height: lh,
        scroll: 0,
        height: block_height,
        width: wrap_width
    };
}
