/// @function scr_submitText()
/// @description Evaluates the player response locally and writes feedback
/// globals expected by the existing lesson -> feedback -> continue flow.
function scr_submitText()
{
    var _text = is_undefined(global.player_response) ? "" : string(global.player_response);
    var _concept = is_undefined(global.lesson_id) ? "" : global.lesson_id;
    var _behavior = is_undefined(global.behavior_choice) ? "say" : string(global.behavior_choice);
    var _target_strength = is_undefined(global.strength_choice) ? "medium" : string(global.strength_choice);
    var _dialect_level = 1;

    if (variable_global_exists("player_dialect_level")) {
        _dialect_level = max(1, min(4, real(global.player_dialect_level)));
    }

    // Prefer native character grader when available.
    if (function_exists("character_grade_native")) {
        var _grade = character_grade_native(_text, _concept, _behavior, _target_strength, _dialect_level, "");

        global.feedback_summary = _grade.feedback;
        global.feedback_scores = _grade.signals;
        global.feedback_ready = true;

        global.grader_feedback = _grade.feedback;
        global.grader_scores = _grade.signals;
        global.grader_feedback_compact = _grade.feedback;
        global.grader_full_report = _grade;
        global.grader_pending = false;
        global.grader_unlocks_debug = "";

        // Merge suggested unlocks into persistent global list.
        if (variable_struct_exists(_grade, "next_unlocks") && is_array(_grade.next_unlocks)) {
            var _unlock_line = "";
            for (var ui = 0; ui < array_length(_grade.next_unlocks); ui++) {
                var _uid = _grade.next_unlocks[ui];
                if (ui > 0) _unlock_line += ", ";
                _unlock_line += string(_uid);
            }
            if (string_length(_unlock_line) > 0) {
                global.grader_unlocks_debug = "New unlocks: " + _unlock_line;
            }

            if (!variable_global_exists("unlocked_signals") || !ds_exists(global.unlocked_signals, ds_type_list)) {
                global.unlocked_signals = ds_list_create();
            }

            for (var i = 0; i < array_length(_grade.next_unlocks); i++) {
                var _id = _grade.next_unlocks[i];
                if (ds_list_find_index(global.unlocked_signals, _id) < 0) {
                    ds_list_add(global.unlocked_signals, _id);
                }
            }
        }

        return;
    }

    if (is_undefined(global.signals) || !ds_exists(global.signals, ds_type_map)
    ||  is_undefined(global.misconceptions) || !ds_exists(global.misconceptions, ds_type_map))
    {
        scr_buildLabelIndexes();
    }

    var _result = scr_evaluateText(_text, _concept);
    var _feedback = scr_generateFeedback(_text, _concept, _result);

    global.feedback_summary = _feedback;
    global.feedback_scores = _result.found;
    global.feedback_ready = true;

    global.grader_feedback = _feedback;
    global.grader_scores = _result;
    global.grader_feedback_compact = _feedback;
    global.grader_pending = false;
    global.grader_unlocks_debug = "";
}
