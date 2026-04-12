/// obj_lesson_controller : Create Event
// Loads the current lesson seed and prepares translation + prompt text.

// Prime behaviour controls for SAY/SHOW/HIDE toggles.
global.behavior_choice = "say";
global.strength_choice = "medium";

// Load the prose, translation, examples, and prompt for the current seed.
scr_loadLesson(global.current_seed_id);

if (is_undefined(global.lesson_text) || string_length(string(global.lesson_text)) <= 0) {
    global.lesson_text = "Hold the moment steady. Notice the weight, the air, the pressure in the choice. Let the words lean into that balance.";
}

if (is_undefined(global.design_translation) || string_length(string(global.design_translation)) <= 0) {
    var translations = scr_json_read("dataset/examples_by_seed.json");
    var entry_array;
    if (is_struct(translations)) {
        if (variable_struct_exists(translations, global.current_seed_id)) {
            entry_array = variable_struct_get(translations, global.current_seed_id);
        }
    } else if (!is_undefined(translations) && ds_exists(translations, ds_type_map)) {
        if (ds_map_exists(translations, global.current_seed_id)) {
            entry_array = ds_map_find_value(translations, global.current_seed_id);
        }
    }

    if (is_array(entry_array) && array_length(entry_array) > 0) {
        var entry = entry_array[0];
        global.design_translation = is_struct(entry) ? entry.text : ds_map_find_value(entry, "text");
    }

    if (is_undefined(global.design_translation) || string_length(string(global.design_translation)) <= 0) {
        global.design_translation = "Shift this beat into plain moves. Spell out what the character does, sees, and feels so the weight is clear.";
    }
}

// Provide a plain writing prompt.
global.lesson_prompt = "Write what the character is doing and wanting in this moment.";

// Reset response and feedback so the player starts fresh every visit.
global.player_response = "";
global.lesson_feedback = "";

global.grader_feedback = "";
global.grader_feedback_compact = "";
if (is_struct(global.grader_full_report)) {
    global.grader_full_report = undefined;
}
