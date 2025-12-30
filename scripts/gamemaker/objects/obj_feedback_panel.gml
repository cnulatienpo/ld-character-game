/// Object: obj_feedback_panel
/// Purpose: Presents the condensed grader feedback produced by
/// scr_showFeedback(). Place this in rooms where you want to display scoring
/// information immediately after submission.
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// panel_width  = 400;
/// panel_height = 240;
/// font_title   = fnt_title;
/// font_body    = fnt_body;
///
/// DRAW EVENT
/// ------------------------------------------------------------
/// draw_set_color(make_color_rgb(10, 40, 60));
/// draw_rectangle(x, y, x + panel_width, y + panel_height, false);
/// draw_set_font(font_title);
/// draw_set_color(c_white);
/// draw_text(x + 16, y + 16, "Feedback");
/// draw_set_font(font_body);
/// draw_text_ext(x + 16, y + 64, global.grader_feedback_compact, panel_width - 32, -1);
