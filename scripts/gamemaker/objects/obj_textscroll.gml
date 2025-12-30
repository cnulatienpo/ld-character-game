/// Object: obj_textscroll
/// Purpose: Displays lesson text with a smooth vertical scroll effect so long
/// text bodies remain readable.
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// // Initialize scroll state and references to global lesson text.
/// scroll_speed = 1;              // Pixels per step; tweak to taste.
/// scroll_offset = 0;             // Tracks how far we've scrolled.
/// scroll_padding = 32;           // Additional padding before/after text.
/// font_resource = fnt_body;      // Replace with your font asset.
/// text_source = @"global.lesson_text";
///
/// STEP EVENT
/// ------------------------------------------------------------
/// // Increment offset and clamp so we do not scroll past the final line.
/// var _text = is_undefined(global.lesson_text) ? "" : string(global.lesson_text);
/// var _text_height = string_height_ext(_text, room_width - 64, -1);
/// var _max_offset = max(0, _text_height - (display_get_height() - scroll_padding * 2));
///
/// if (keyboard_check(vk_up))      scroll_offset -= scroll_speed * 2;
/// else if (keyboard_check(vk_down)) scroll_offset += scroll_speed * 2;
/// else                             scroll_offset += scroll_speed;
///
/// scroll_offset = clamp(scroll_offset, 0, _max_offset);
///
/// DRAW EVENT
/// ------------------------------------------------------------
/// draw_set_font(font_resource);
/// draw_set_color(c_white);
/// draw_text_ext(32, 32 - scroll_offset, global.lesson_text, room_width - 64, -1);
