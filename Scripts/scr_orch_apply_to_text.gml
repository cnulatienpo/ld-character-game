/// @function scr_orch_apply_to_text(text, mix_struct)
/// @description Applies a simple tonal transformation to the preview passage based on slider values.
/// @param text Base passage with placeholder tokens.
/// @param mix_struct Struct containing emotion, stakes, and pacing values.
function scr_orch_apply_to_text(text, mix_struct) {
    if (!is_string(text)) {
        return "";
    }

    var emotion = 0.5;
    var stakes = 0.5;
    var pacing = 0.5;

    if (is_struct(mix_struct)) {
        emotion = clamp(real(variable_struct_get(mix_struct, "emotion", emotion)), 0, 1);
        stakes = clamp(real(variable_struct_get(mix_struct, "stakes", stakes)), 0, 1);
        pacing = clamp(real(variable_struct_get(mix_struct, "pacing", pacing)), 0, 1);
    }

    var emo_phrase;
    if (emotion > 0.66) {
        emo_phrase = "A warm current steadied her resolve.";
    } else if (emotion < 0.34) {
        emo_phrase = "She kept her feelings clipped and cool.";
    } else {
        emo_phrase = "She let a measured kindness hold her tone steady.";
    }

    var stakes_phrase;
    if (stakes > 0.66) {
        stakes_phrase = "Every creak pressed against her ribs like a warning.";
    } else if (stakes < 0.34) {
        stakes_phrase = "The sounds barely grazed her focus, distant and soft.";
    } else {
        stakes_phrase = "Each noise nudged at her attention without tipping it.";
    }

    var pacing_phrase;
    if (pacing > 0.66) {
        pacing_phrase = "She chopped the moment into short counts. One beat. Another. Move now.";
    } else if (pacing < 0.34) {
        pacing_phrase = "She let the beat stretch, linking one long breath to the next before she moved.";
    } else {
        pacing_phrase = "She measured each beat, steady and even, no rush and no drag.";
    }

    var transformed = string_replace_all(text, "EMO_TONE", emo_phrase);
    transformed = string_replace_all(transformed, "STAKE_DETAIL", stakes_phrase);
    transformed = string_replace_all(transformed, "PACING_BEAT", pacing_phrase);

    return transformed;
}
