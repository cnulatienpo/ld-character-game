/// scr_gate_next(last_stage)
/// Mirror of Scripts/scr_gate_next.gml for quick import into GameMaker Studio 2.
function scr_gate_next(last_stage) {
    var stage = string_lower(string(last_stage));

    if (stage == "lesson") {
        room_goto(room_quiz);
        return;
    }

    if (stage == "quiz") {
        room_goto(room_reading);
        return;
    }

    if (stage == "reading") {
        room_goto(room_mixmatch);
        return;
    }

    room_goto(room_lesson);
}
