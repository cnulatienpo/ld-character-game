/// @function scr_arcadeNextRound()
/// @description Advances the arcade game mode to the next round by reading
/// dataset/arcade_rounds.json, selecting the next challenge, and assigning
/// global variables that other objects will consume.
///
/// Globals touched:
/// global.arcade_round_index - Current round pointer (increments each call).
/// global.arcade_round_data  - Struct for the active round (targets, timers, etc.).
/// global.arcade_prompt      - Text to display in the UI.
function scr_arcadeNextRound()
{
    if (is_undefined(global.arcade_round_index))
    {
        global.arcade_round_index = 0;
    }
    else
    {
        global.arcade_round_index += 1;
    }

    var _json_path = working_directory + "dataset/arcade_rounds.json";

    if (!file_exists(_json_path))
    {
        show_debug_message("[scr_arcadeNextRound] Missing arcade_rounds.json at " + _json_path);
        return;
    }

    var _buffer = buffer_load(_json_path);
    var _json_string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);

    var _data = json_decode(_json_string);
    if (!is_array(_data))
    {
        show_debug_message("[scr_arcadeNextRound] Expected an array of rounds in arcade_rounds.json.");
        return;
    }

    // Wrap around once we reach the end of the dataset so the arcade mode can
    // loop indefinitely during development.
    var _index = global.arcade_round_index mod array_length(_data);
    var _round = _data[_index];

    global.arcade_round_data = _round;
    global.arcade_prompt = variable_struct_exists(_round, "prompt") ? _round.prompt : "";
    global.arcade_timer = variable_struct_exists(_round, "timer") ? _round.timer : 0;
    global.arcade_targets = variable_struct_exists(_round, "targets") ? _round.targets : [];

    show_debug_message("[scr_arcadeNextRound] Loaded arcade round index: " + string(_index));
}
