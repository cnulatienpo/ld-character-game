/// Object: obj_writebox
/// Purpose: Captures multi-line player input and synchronizes it with the
/// global.player_response variable expected by scr_submitText().
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// buffer_string   = "";
/// caret_blink     = 0;
/// caret_interval  = 30;
/// font_resource   = fnt_body;
/// box_width       = 640;
/// box_height      = 240;
/// padding         = 16;
///
/// STEP EVENT
/// ------------------------------------------------------------
/// // Append keyboard input to the buffer string. GameMaker's keyboard_string
/// // automatically collects printable characters when text input is active.
/// if (keyboard_string != "")
/// {
///     buffer_string += keyboard_string;
///     keyboard_string = "";
/// }
///
/// if (keyboard_check_pressed(vk_backspace) && string_length(buffer_string) > 0)
/// {
///     buffer_string = string_copy(buffer_string, 1, string_length(buffer_string) - 1);
/// }
///
/// if (keyboard_check_pressed(vk_enter))
/// {
///     buffer_string += "\n";
/// }
///
/// global.player_response = buffer_string;
///
/// caret_blink = (caret_blink + 1) mod caret_interval;
///
/// DRAW EVENT
/// ------------------------------------------------------------
/// draw_set_color(c_white);
/// draw_rectangle(x, y, x + box_width, y + box_height, false);
/// draw_set_font(font_resource);
/// draw_set_color(c_ltgray);
/// draw_text_ext(x + padding, y + padding, buffer_string, box_width - padding * 2, -1);
///
/// if (caret_blink < caret_interval / 2)
/// {
///     var _caret_x = x + padding + string_width_ext(buffer_string, box_width - padding * 2, -1);
///     var _caret_y = y + padding + string_height_ext(buffer_string, box_width - padding * 2, -1) - 16;
///     draw_rectangle(_caret_x, _caret_y, _caret_x + 2, _caret_y + 16, false);
/// }
