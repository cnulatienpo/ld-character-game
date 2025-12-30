/// @function scr_gateNext(_current_mode)
/// @description Determines the next room to advance to based on the current
/// mode, global progress, or adaptive logic. This script centralizes the
/// navigation rules so UI objects only need to call it and change rooms.
///
/// Arguments:
/// _current_mode {string} - Identifier for the context ("lesson", "arcade", etc.).
///
/// Globals read:
/// global.lesson_sequence - Array describing the lesson order.
/// global.lesson_pointer  - Index of the active lesson in the sequence.
/// global.arcade_round_index - Current arcade round index.
///
/// Returns:
/// string - Name of the room resource to load next.
function scr_gateNext(_current_mode)
{
    var _next_room = room_lesson; // Default fallback.

    switch (_current_mode)
    {
        case "lesson":
            if (is_undefined(global.lesson_sequence))
            {
                global.lesson_sequence = [room_lesson, room_arcade, room_mixmatch, room_reading];
            }

            if (is_undefined(global.lesson_pointer))
            {
                global.lesson_pointer = 0;
            }
            else
            {
                global.lesson_pointer = (global.lesson_pointer + 1) mod array_length(global.lesson_sequence);
            }

            _next_room = global.lesson_sequence[global.lesson_pointer];
            break;

        case "arcade":
            // After each arcade round, go to mixmatch for variety.
            _next_room = room_mixmatch;
            break;

        case "mixmatch":
            // Show feedback/reading view after mixmatch challenges.
            _next_room = room_reading;
            break;

        case "reading":
            // Return to the lesson loop to introduce new content.
            _next_room = room_lesson;
            break;

        default:
            show_debug_message("[scr_gateNext] Unknown mode: " + string(_current_mode));
            break;
    }

    return _next_room;
}
