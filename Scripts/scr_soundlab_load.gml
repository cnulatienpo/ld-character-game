/// @function scr_soundlab_load()
/// @description Loads a Sound Lab round and prepares the beat pattern timers.
function scr_soundlab_load() {
    var data = scr_json_read("dataset/soundlab_rounds.json");
    if (!is_struct(data) || !is_array(data.rounds)) {
        show_debug_message("scr_soundlab_load: missing or invalid dataset");
        return false;
    }

    var rounds = data.rounds;
    var vocab = global.player_vocab;
    if (!is_array(vocab)) {
        vocab = [];
    }

    var pool = [];
    for (var i = 0; i < array_length(rounds); i++) {
        var entry = rounds[i];
        if (scr_vocab_allows(entry, vocab)) {
            array_push(pool, entry);
        }
    }

    if (array_length(pool) == 0) {
        pool = rounds;
    }

    if (array_length(pool) == 0) {
        show_debug_message("scr_soundlab_load: no rounds available");
        return false;
    }

    var pick = pool[irandom(array_length(pool) - 1)];
    global.sl_rounds = rounds;
    global.sl_current = pick;

    var pattern_string = string(pick.pattern);
    if (string_length(pattern_string) == 0) {
        pattern_string = "short-short-short";
    }

    var tokens = string_split(pattern_string, "-");
    var beat_short = max(6, round(room_speed * 0.35));
    var beat_long = max(beat_short + 4, round(room_speed * 0.7));

    var steps = [];
    for (var t = 0; t < array_length(tokens); t++) {
        var label = string_lower(string(tokens[t]));
        var duration = beat_short;
        switch (label) {
            case "short":
                duration = beat_short;
                break;
            case "long":
                duration = beat_long;
                break;
            default:
                duration = beat_short;
                break;
        }
        array_push(steps, { label: label, duration: duration });
    }

    global.sl_pattern_tokens = tokens;
    global.sl_pattern_steps = steps;
    global.sl_play_index = 0;
    global.sl_beat_timer = 0;
    global.sl_bar_goal = 3;
    global.sl_bar_count = 0;
    global.sl_playing = false;
    global.sl_selection = undefined;
    global.sl_feedback_note = "";
    global.sl_submitted = false;

    return true;
}
