/// Persistent user id helper for the online MVP.

function ensure_user_id() {
    var filename = "user_id.txt";
    var path = working_directory + filename;
    if (!file_exists(path) && file_exists(filename)) {
        path = filename;
    }

    var stored_id = "";
    if (file_exists(path)) {
        var reader = file_text_open_read(path);
        if (reader >= 0) {
            if (!file_text_eof(reader)) {
                stored_id = file_text_read_string(reader);
            }
            file_text_close(reader);
        }
    }

    if (!is_string(stored_id) || string_length(stored_id) <= 0) {
        var suffix = ((get_timer() div 1000) mod 900000) + 100000;
        stored_id = "u-" + string(suffix);
        var writer = file_text_open_write(path);
        if (writer >= 0) {
            file_text_write_string(writer, stored_id);
            file_text_close(writer);
        }
    }

    return stored_id;
}
