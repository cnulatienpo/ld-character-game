/// @function scr_showFeedback()
/// @description Reads dataset/out.json produced by grader.js, extracts summary
/// information, and stores it in globals for UI objects to render. This script
/// assumes scr_submitText() has already executed and the grader has finished.
///
/// Globals modified:
/// global.grader_pending     - Cleared when output is detected.
/// global.grader_feedback    - Text summarizing grader results.
/// global.grader_scores      - Struct with numeric breakdowns (accuracy, etc.).
/// global.grader_full_report - Raw struct for advanced UI renderers.
function scr_showFeedback()
{
    var _output_path = working_directory + "dataset/out.json";

    // If the grader has not yet produced an output file, we simply bail out.
    if (!file_exists(_output_path))
    {
        show_debug_message("[scr_showFeedback] Waiting for grader output.");
        return;
    }

    var _buffer = buffer_load(_output_path);
    var _json_string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);

    var _data = json_decode(_json_string);

    if (!is_struct(_data))
    {
        show_debug_message("[scr_showFeedback] out.json did not decode into a struct.");
        return;
    }

    // Extract safe defaults to guard against missing properties in the grader output.
    global.grader_feedback = variable_struct_exists(_data, "summary")
        ? _data.summary
        : "No feedback available.";

    global.grader_scores = variable_struct_exists(_data, "scores")
        ? _data.scores
        : undefined;

    global.grader_full_report = _data;

    // Provide a condensed text version for quick draw_text usage.
    if (is_struct(global.grader_scores))
    {
        var _score_text = "";
        var _keys = variable_struct_get_names(global.grader_scores);
        for (var i = 0; i < array_length(_keys); ++i)
        {
            var _key = _keys[i];
            _score_text += string(_key) + ": " + string(global.grader_scores[$ _key]) + "\n";
        }
        global.grader_feedback_compact = global.grader_feedback + "\n" + _score_text;
    }
    else
    {
        global.grader_feedback_compact = global.grader_feedback;
    }

    global.grader_pending = false;
}
