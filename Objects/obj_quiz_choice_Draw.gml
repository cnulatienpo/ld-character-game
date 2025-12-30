/// obj_quiz_choice : Draw Event
// Paints a simple rectangular button with plain language.
var bg_colour = hover ? make_colour_rgb(220, 235, 245) : make_colour_rgb(230, 230, 230);
if (!is_undefined(global.quiz_choice) && global.quiz_choice == my_id) {
    bg_colour = global.quiz_correct ? make_colour_rgb(210, 245, 210) : make_colour_rgb(245, 210, 210);
}

draw_set_color(bg_colour);
draw_rectangle(x, y, x + button_width, y + button_height, false);

draw_set_color(c_black);
draw_text(x + 12, y + 12, my_text);
