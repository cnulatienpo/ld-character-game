/// @function scr_submitText()
/// @description Evaluates the player response locally and writes feedback
/// globals expected by the existing lesson -> feedback -> continue flow.
function scr_submitText()
{
    var _text = is_undefined(global.player_response) ? "" : string(global.player_response);
    var _concept = is_undefined(global.lesson_id) ? "" : global.lesson_id;

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
}
