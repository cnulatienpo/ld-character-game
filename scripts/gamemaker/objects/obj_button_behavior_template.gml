/// Object family: obj_button_behavior_*
/// Purpose: Buttons that set global behaviour modes (e.g., "calm", "energetic")
/// by writing to global.behavior_mode. Duplicate this object and rename with a
/// suffix that reflects the desired behaviour, then update the target_mode
/// variable in the Create event.
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// target_mode = "calm"; // Replace per duplicate.
///
/// LEFT PRESSED EVENT
/// ------------------------------------------------------------
/// global.behavior_mode = target_mode;
/// audio_play_sound(snd_button, 1, false); // Optional feedback.
/// show_debug_message("[Behavior Button] Mode set to " + target_mode);
