/// Object: obj_submit
/// Purpose: UI button that triggers scr_submitText() when clicked, then begins
/// polling for grader output by scheduling scr_showFeedback().
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// hover = false;
/// label = "Submit";
///
/// LEFT PRESSED EVENT
/// ------------------------------------------------------------
/// scr_submitText();
/// alarm[0] = room_speed; // Re-check feedback after one second.
///
/// ALARM[0] EVENT
/// ------------------------------------------------------------
/// scr_showFeedback();
/// if (global.grader_pending) alarm[0] = room_speed; // Poll again if still running.
///
/// DRAW EVENT
/// ------------------------------------------------------------
/// draw_set_color(hover ? c_yellow : c_white);
/// draw_rectangle(x, y, x + 128, y + 48, false);
/// draw_set_halign(fa_center);
/// draw_set_valign(fa_middle);
/// draw_text(x + 64, y + 24, label);
///
/// MOUSE ENTER/LEAVE EVENTS (optional)
/// ------------------------------------------------------------
/// hover = true; // On Mouse Enter
/// hover = false; // On Mouse Leave
