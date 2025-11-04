/// @function scr_gate_next(last_stage)
/// @description Decides which room should appear after finishing the given stage.
/// @param last_stage String tag for the room that just finished.
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
