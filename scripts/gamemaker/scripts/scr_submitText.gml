/// @function scr_submitText()
/// @description Collects the player response, writes it to a staging file,
/// invokes the Node-based grader CLI (grader.js) via shell_execute, and
/// prepares global state for downstream feedback scripts to consume.
///
/// Expected globals:
/// global.player_response   - Text captured from obj_writebox.
/// global.lesson_id         - Active lesson identifier.
/// global.response_path     - (Optional) Override path where submission JSON is written.
///
/// Globals modified:
/// global.grader_pending    - Flag set true while grader runs externally.
/// global.grader_invoked_at - Timestamp for debugging asynchronous behaviour.
///
/// Output files:
/// dataset/out.json         - Expected output from grader.js.
/// dataset/submission.json  - Player answer payload written by this script.
function scr_submitText()
{
    // Fallback to an empty string if the UI has not yet populated the response.
    var _response_text = is_undefined(global.player_response) ? "" : string(global.player_response);

    // Construct a lightweight submission payload that the grader understands.
    var _submission_struct = {
        lesson_id : is_undefined(global.lesson_id) ? -1 : global.lesson_id,
        response  : _response_text
    };

    var _submission_json = json_stringify(_submission_struct);

    // Determine the filesystem target. Keeping everything inside the dataset
    // folder makes debugging easier because we can inspect the artifacts in one place.
    var _submission_path = is_undefined(global.response_path)
        ? working_directory + "dataset/submission.json"
        : global.response_path;

    // Persist the JSON payload. We use buffer_save to avoid locale-dependent
    // file_text quirks and ensure UTF-8 output.
    var _buffer = buffer_create(string_length(_submission_json) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _submission_json);
    buffer_save(_buffer, _submission_path);
    buffer_delete(_buffer);

    // Prepare to invoke the Node CLI. Note that shell_execute executes
    // asynchronously on most desktop targets, so we retain metadata that lets
    // other systems poll for grader completion.
    var _grader_script = working_directory + "grader.js";
    var _working_dir = working_directory; // Optional third argument for clarity.

    if (!file_exists(_grader_script))
    {
        show_debug_message("[scr_submitText] grader.js not found at " + _grader_script);
        return;
    }

    // Compose arguments. Wrapping each in quotes preserves spaces in paths.
    var _arguments = "\"" + _grader_script + "\"";
    _arguments += " \"" + _submission_path + "\"";

    // Launch the grader via Node. Adjust the executable name if targeting a
    // platform that uses a different Node binary alias.
    shell_execute("node", _arguments, _working_dir);

    global.grader_pending = true;
    global.grader_invoked_at = current_time;
    show_debug_message("[scr_submitText] Submitted response and launched grader.");
}
