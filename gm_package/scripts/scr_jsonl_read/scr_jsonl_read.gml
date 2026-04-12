/// @function scr_jsonl_read(file_path)
/// @description Reads a JSONL file (one JSON object per line) and returns a ds_list of maps.
/// @param file_path String path to the JSONL file on disk.
//
// Each line in the file is parsed individually. Empty or whitespace-only lines are ignored
// so the caller can freely format the data file. Every valid JSON object is parsed with
// json_parse, producing either a struct or ds_map depending on GameMaker's configuration.
// The script collects these entries into a ds_list for convenient iteration downstream.
function scr_jsonl_read(file_path) {
    // Prepare an empty list that will hold all parsed quiz items.
    var items = ds_list_create();

    // Guard against missing files to avoid runtime errors. We simply return an empty list
    // if the requested file cannot be found.
    if (!file_exists(file_path)) {
        show_debug_message("scr_jsonl_read: file not found -> " + string(file_path));
        return items;
    }

    // Open the file for reading as plain text. JSONL uses UTF-8 text with newline separators.
    var file = file_text_open_read(file_path);

    // Read line-by-line until we reach the end of the file. Each iteration grabs one JSON object.
    while (!file_text_eof(file)) {
        var line = file_text_read_string(file);
        file_text_readln(file); // Consume the newline terminator.

        // Trim whitespace so we can skip blank spacer lines gracefully.
        line = string_trim(line);
        if (line == "") {
            continue;
        }

        // Parse the JSON payload. json_parse returns a struct in GMS2, which behaves like a map.
        // We wrap in a try/catch style using exception handling to report malformed JSON.
        var entry;
        try {
            entry = json_parse(line);
        } catch (e) {
            show_debug_message("scr_jsonl_read: unable to parse line -> " + line);
            entry = undefined;
        }

        // Only append successfully parsed entries.
        if (is_undefined(entry)) {
            continue;
        }

        ds_list_add(items, entry);
    }

    // Always close the file handle once finished.
    file_text_close(file);

    return items;
}
