/// @function scr_loadLesson(_lesson_id)
/// @description Loads lesson text, translation, and metadata from dataset/lessons.json
/// and stores the data into global variables for later use.
///
/// Arguments:
/// _lesson_id {string|real} - The identifier of the lesson to fetch.
///
/// Global state populated:
/// global.lesson_id          - Numeric/string identifier of the active lesson.
/// global.lesson_text        - Body text for the lesson display.
/// global.lesson_title       - Title used for UI headings.
/// global.design_translation - Optional translated version of the text.
/// global.lesson_media       - Optional media path for the lesson.
///
/// This script is intentionally verbose and thoroughly commented so you can
/// tailor it to your own dataset format. The JSON structure expected by this
/// scaffold resembles:
/// {
///     "lessons": [
///         {
///             "id": 1,
///             "title": "Greeting", 
///             "text": "Hello, world!",
///             "translation": "Hola, mundo!",
///             "media": "dataset/media/lesson_1.png"
///         }
///     ]
/// }
function scr_loadLesson(_lesson_id)
{
    // Cache dataset path so we only change it in one location if the
    // project folder layout changes later.
    var _json_path = working_directory + "dataset/lessons.json";

    // Ensure the file exists before attempting to read. This prevents runtime
    // crashes and allows us to log actionable debug information instead.
    if (!file_exists(_json_path))
    {
        show_debug_message("[scr_loadLesson] Missing lessons.json at " + _json_path);
        return;
    }

    // Load the JSON file into a temporary buffer, then convert it to a string.
    var _buffer = buffer_load(_json_path);
    var _json_string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);

    // Decode the JSON string into GameMaker structs/arrays.
    var _data = json_decode(_json_string);

    // Guard clause in case the JSON root is not what we expect.
    if (!is_struct(_data) || !variable_struct_exists(_data, "lessons"))
    {
        show_debug_message("[scr_loadLesson] lessons.json root must contain a 'lessons' array.");
        return;
    }

    var _lessons = _data.lessons;
    var _found = false;

    // Iterate through the lessons array to find the matching entry.
    for (var i = 0; i < array_length(_lessons); ++i)
    {
        var _lesson = _lessons[i];

        if (variable_struct_exists(_lesson, "id") && _lesson.id == _lesson_id)
        {
            // Copy all relevant fields into global scope for ease of use
            // across objects and rooms.
            global.lesson_id = _lesson.id;
            global.lesson_title = variable_struct_exists(_lesson, "title") ? _lesson.title : "Untitled Lesson";
            global.lesson_text = variable_struct_exists(_lesson, "text") ? _lesson.text : "";
            global.design_translation = variable_struct_exists(_lesson, "translation") ? _lesson.translation : "";
            global.lesson_media = variable_struct_exists(_lesson, "media") ? _lesson.media : "";

            // Track any additional metadata that future systems might rely on.
            global.lesson_metadata = variable_struct_exists(_lesson, "metadata") ? _lesson.metadata : undefined;

            _found = true;
            break;
        }
    }

    if (!_found)
    {
        show_debug_message("[scr_loadLesson] Could not find lesson with id: " + string(_lesson_id));
    }
}
