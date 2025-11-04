/// @function scr_toggleTranslation()
/// @description Flips the visibility flag for translated lesson content and
/// prepares a composite string that UI elements can render immediately.
///
/// Globals modified:
/// global.show_translation       - Boolean controlling translation visibility.
/// global.translation_draw_text  - Cached string for draw_text usage.
function scr_toggleTranslation()
{
    if (is_undefined(global.show_translation))
    {
        global.show_translation = false;
    }

    global.show_translation = !global.show_translation;

    if (global.show_translation)
    {
        var _translation = is_undefined(global.design_translation) ? "" : string(global.design_translation);
        global.translation_draw_text = "Translation:\n" + _translation;
    }
    else
    {
        global.translation_draw_text = "";
    }
}
