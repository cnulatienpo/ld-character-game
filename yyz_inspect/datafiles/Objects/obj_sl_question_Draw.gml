/// obj_sl_question : Draw Event
// Displays the prompt question in plain copy.
var text = "Which line fits this beat?";
if (is_string(global.sl_current.question) && global.sl_current.question != "") {
    text = global.sl_current.question;
}

draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);

draw_text(120, 80, text + "\n\nListen to the pulse and pick the line that lands with it.");
