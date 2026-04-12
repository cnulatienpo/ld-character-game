/// obj_db_balance_canvas : Draw Event
// Draws the two rectangles and slider track.
var left_rect = { x: 200, y: 200, w: 180, h: 200 };
var right_rect = { x: 420, y: 200, w: 180, h: 200 };

var t = clamp(global.db_balance_value, 0, 1);
var left_weight = lerp(0.4, 1, 1 - t);
var right_weight = lerp(0.4, 1, t);

draw_set_colour(make_colour_rgb(40 + left_weight * 120, 60 + left_weight * 100, 80 + left_weight * 80));
draw_rectangle(left_rect.x, left_rect.y, left_rect.x + left_rect.w, left_rect.y + left_rect.h, false);

draw_set_colour(make_colour_rgb(40 + right_weight * 120, 60 + right_weight * 100, 80 + right_weight * 80));
draw_rectangle(right_rect.x, right_rect.y, right_rect.x + right_rect.w, right_rect.y + right_rect.h, false);

var track_x1 = 220;
var track_x2 = 560;
var track_y = 440;

draw_set_colour(make_colour_rgb(80, 80, 90));
draw_rectangle(track_x1, track_y - 4, track_x2, track_y + 4, false);

draw_set_colour(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(180, 120, global.db_balance_prompt);
