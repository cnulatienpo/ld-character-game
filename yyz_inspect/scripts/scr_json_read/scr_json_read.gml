/// @function scr_json_read(file_path)
/// @description Reads a complete JSON file from disk and parses it into a struct/map.
/// @param file_path String path to the JSON data file.
function scr_json_read(file_path) {
    if (!file_exists(file_path)) {
        show_debug_message("scr_json_read: file not found -> " + string(file_path));
        return undefined;
    }

    var handle = file_text_open_read(file_path);
    var buffer = "";

    while (!file_text_eof(handle)) {
        buffer += file_text_readln(handle);
        if (!file_text_eof(handle)) {
            buffer += "\n";
        }
    }

    file_text_close(handle);

    if (string_length(buffer) == 0) {
        return undefined;
    }

    var parsed;
    try {
        parsed = json_parse(buffer);
    } catch (e) {
        show_debug_message("scr_json_read: unable to parse JSON -> " + string(file_path));
        parsed = undefined;
    }

    return parsed;
}
