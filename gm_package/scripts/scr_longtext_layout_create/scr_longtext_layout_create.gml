/// @function scr_longtext_layout_create(text, width, margin)
/// @description Creates a reusable layout struct for long passages with wrapped lines.
/// @param text The raw passage text containing paragraph breaks.
/// @param width Maximum text width before wrapping to the next line.
/// @param margin Horizontal margin applied when drawing (stored for convenience).
function scr_longtext_layout_create(text, width, margin) {
    var layout = {
        lines: [],
        line_height: 28,
        scroll: 0,
        width: width,
        margin: margin,
        height: 0
    };

    if (is_undefined(text)) {
        return layout;
    }

    // Normalise newline variants so both Windows and Unix style breaks are handled.
    var normalized = string_replace_all(string_replace_all(text, "\r\n", "\n"), "\r", "\n");

    // Split by explicit newlines. Blank lines are preserved to create visual breathing room.
    var raw_lines = string_split(normalized, "\n");

    // Wrap each raw line to fit inside the requested width, respecting word boundaries.
    for (var i = 0; i < array_length(raw_lines); i++) {
        var source_line = raw_lines[i];
        if (source_line == "") {
            array_push(layout.lines, "");
            continue;
        }

        var words = string_split(source_line, " ");
        var current_line = "";

        for (var j = 0; j < array_length(words); j++) {
            var word = words[j];
            if (word == "") {
                continue;
            }

            var candidate = (current_line == "") ? word : current_line + " " + word;

            // string_width gives the pixel width for the current draw font. To keep things consistent
            // we clamp against the provided layout width. If the line would overflow, we finalize the
            // current line and start a new one with the word that did not fit.
            if (string_width(candidate) > width && current_line != "") {
                array_push(layout.lines, current_line);
                current_line = word;
            } else {
                current_line = candidate;
            }
        }

        if (current_line != "") {
            array_push(layout.lines, current_line);
        }
    }

    // Precompute the total rendered height for scroll bounds.
    layout.height = array_length(layout.lines) * layout.line_height;

    return layout;
}
