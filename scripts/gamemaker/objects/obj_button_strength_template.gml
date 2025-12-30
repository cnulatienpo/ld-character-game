/// Object family: obj_button_strength_*
/// Purpose: Buttons that adjust a numeric strength/intensity global variable
/// used to configure lesson difficulty or feedback strictness.
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// strength_value = 0.5; // Replace with desired scalar (0.0 - 1.0).
///
/// LEFT PRESSED EVENT
/// ------------------------------------------------------------
/// global.feedback_strength = strength_value;
/// audio_play_sound(snd_button, 1, false);
/// show_debug_message("[Strength Button] Feedback strength set to " + string(strength_value));
