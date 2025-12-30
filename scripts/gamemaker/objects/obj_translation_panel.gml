/// Object: obj_translation_panel
/// Purpose: Toggleable overlay panel that shows translated lesson text when
/// global.show_translation is true. Bind scr_toggleTranslation() to a button
/// or keyboard shortcut to flip visibility.
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// panel_width  = 320;
/// panel_height = 480;
/// panel_color  = make_color_rgb(24, 24, 24);
/// panel_alpha  = 0.85;
/// text_margin  = 16;
///
/// DRAW EVENT
/// ------------------------------------------------------------
/// if (!global.show_translation) exit;
///
/// draw_set_alpha(panel_alpha);
/// draw_set_color(panel_color);
/// draw_rectangle(x, y, x + panel_width, y + panel_height, false);
/// draw_set_alpha(1);
/// draw_set_color(c_white);
/// draw_text_ext(x + text_margin, y + text_margin, global.translation_draw_text, panel_width - text_margin * 2, -1);
