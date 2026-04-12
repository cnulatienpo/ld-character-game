/// @function scr_soundlab_play()
/// @description Begins playback of the prepared Sound Lab beat pattern.
function scr_soundlab_play() {
    if (!is_array(global.sl_pattern_steps) || array_length(global.sl_pattern_steps) == 0) {
        show_debug_message("scr_soundlab_play: pattern missing");
        return false;
    }

    global.sl_playing = true;
    global.sl_play_index = 0;
    global.sl_beat_timer = 0;
    global.sl_bar_count = 0;
    global.sl_last_pulse_scale = 1;

    return true;
}
