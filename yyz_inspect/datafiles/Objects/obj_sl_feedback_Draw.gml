/// obj_sl_feedback : Draw Event
// Shows feedback once the player submits a choice.
if (!global.sl_submitted) {
    exit;
}

draw_set_font(-1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var text = string(global.sl_feedback_note);
if (text == "") {
    text = "Short beats love clipped strokes.";
}

draw_text(120, 420, text);
