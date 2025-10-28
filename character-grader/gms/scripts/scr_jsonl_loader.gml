/// @function jsonl_read_included(_filename)
/// @description Loads a JSONL file bundled with the project and returns an array of structs.
///
/// @param {string} _filename - Relative path to the Included File.
function jsonl_read_included(_filename) {
    var path = working_directory + _filename;
    if (!file_exists(path)) {
        path = _filename;
    }
    if (!file_exists(path)) {
        return [];
    }

    var raw_string = string_load(path);
    if (is_undefined(raw_string)) {
        return [];
    }

    var sanitized = string_replace_all(raw_string, "\r\n", "\n");
    sanitized = string_replace_all(sanitized, "\r", "\n");

    var lines = string_split(sanitized, "\n");
    if (!is_array(lines)) {
        return [];
    }

    var results = [];
    for (var i = 0; i < array_length(lines); ++i) {
        var line = string_trim(lines[i]);
        if (line == "" || string_copy(line, 1, 1) == "#") {
            continue;
        }
        var parsed = json_parse(line);
        if (is_struct(parsed)) {
            array_push(results, parsed);
        }
    }

    return results;
}
