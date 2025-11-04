/// obj_sl_choice : Draw Event
// Renders the choice button with generous text.
var width = 520;
var height = 100;
var rect_x = x;
var rect_y = y;

var bg = make_colour_rgb(60, 60, 70);
if (hover && !global.sl_submitted) {
    bg = make_colour_rgb(80, 80, 100);
}

if (global.sl_submitted) {
    var answer_id = "";
    if (is_struct(global.sl_current)) {
        answer_id = string(global.sl_current.answer);
    }

    if (global.sl_selection == choice_id) {
        bg = result_ok ? make_colour_rgb(100, 130, 80) : make_colour_rgb(130, 60, 60);
    } else if (answer_id == choice_id) {
        bg = make_colour_rgb(90, 120, 90);
    }
}

draw_set_alpha(0.9);
draw_set_colour(bg);
draw_rectangle(rect_x, rect_y, rect_x + width, rect_y + height, false);
draw_set_alpha(1);

draw_set_colour(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var text_margin = 12;
draw_text_ext(rect_x + text_margin, rect_y + text_margin, choice_text, -1, width - text_margin * 2);
