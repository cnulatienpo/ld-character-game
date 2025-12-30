/// @function scr_gate_next(last_stage)
/// @description Wrapper added for the Character MVP loop. Mirrors Scripts/scr_gate_next.gml.
function scr_gate_next(last_stage)
{
    var stage = string_lower(string(last_stage));

    if (stage == "lesson")
    {
        room_goto(room_quiz);
        return;
    }

    if (stage == "quiz")
    {
        room_goto(room_reading);
        return;
    }

    if (stage == "reading")
    {
        room_goto(room_mixmatch);
        return;
    }

    room_goto(room_lesson);
}
