/// obj_sl_pulse : Step Event
// Advances the pulse animation alongside the beat array.
if (!is_array(global.sl_pattern_steps)) {
    exit;
}

if (!global.sl_playing) {
    pulse_scale = lerp(pulse_scale, 1, 0.1);
    exit;
}

if (global.sl_play_index < 0 || global.sl_play_index >= array_length(global.sl_pattern_steps)) {
    global.sl_play_index = 0;
}

var step_data = global.sl_pattern_steps[global.sl_play_index];
var duration = max(1, step_data.duration);

global.sl_beat_timer += 1;

var phase = global.sl_beat_timer / duration;
if (phase > 1) {
    global.sl_play_index += 1;
    global.sl_beat_timer = 0;
    if (global.sl_play_index >= array_length(global.sl_pattern_steps)) {
        global.sl_play_index = 0;
        global.sl_bar_count += 1;
        if (global.sl_bar_count >= global.sl_bar_goal) {
            global.sl_playing = false;
        }
    }
    step_data = global.sl_pattern_steps[global.sl_play_index];
    duration = max(1, step_data.duration);
    phase = 0;
}

var pulse_target = 1.2;
if (step_data.label == "long") {
    pulse_target = 1.4;
}

var eased = 1 + sin(phase * pi) * (pulse_target - 1);
pulse_scale = lerp(pulse_scale, eased, 0.3);
