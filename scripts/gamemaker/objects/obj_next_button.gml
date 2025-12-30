/// Object: obj_next_button
/// Purpose: Moves the player to the next room/state using scr_gateNext().
/// Configure the current_mode variable to match the context in which the
/// button is placed ("lesson", "arcade", etc.).
///
/// Suggested events:
/// CREATE EVENT
/// ------------------------------------------------------------
/// current_mode = "lesson";
/// label = "Next";
///
/// LEFT PRESSED EVENT
/// ------------------------------------------------------------
/// var _target_room = scr_gateNext(current_mode);
/// room_goto(_target_room);
///
/// DRAW EVENT
/// ------------------------------------------------------------
/// draw_set_color(c_white);
/// draw_rectangle(x, y, x + 128, y + 48, false);
/// draw_set_halign(fa_center);
/// draw_set_valign(fa_middle);
/// draw_text(x + 64, y + 24, label);
