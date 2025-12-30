/// obj_kitchen_controller : Draw Event
// Draws the goal, tips, sliders, and feedback.
draw_set_color(c_black);
var left_x = 80;
var top_y = 80;
var line_y = top_y;

for (var i = 0; i < array_length(goal_wrap.lines); i++) {
    draw_text(left_x, line_y, goal_wrap.lines[i]);
    line_y += goal_wrap.line_height;
}

line_y += 12;
for (var j = 0; j < array_length(tips_wrap.lines); j++) {
    draw_text(left_x, line_y, tips_wrap.lines[j]);
    line_y += tips_wrap.line_height;
}

line_y += 16;
for (var k = 0; k < array_length(explain_wrap.lines); k++) {
    draw_text(left_x, line_y, explain_wrap.lines[k]);
    line_y += explain_wrap.line_height;
}

var preview_x = 440;
var preview_y = 120;
var mix = global.kit_mix;
var tone_fragments = [];

if (mix.salt > 0.4) array_push(tone_fragments, "sharp sparks along the rim.");
else if (mix.salt < 0.25) array_push(tone_fragments, "details blur at the edges.");

if (mix.acid > 0.35) array_push(tone_fragments, "lines tug tight.");
else if (mix.acid < 0.2) array_push(tone_fragments, "the pull eases off.");

if (mix.sugar > 0.35) array_push(tone_fragments, "tones blend into one another.");
else if (mix.sugar < 0.2) array_push(tone_fragments, "the beat feels bare.");

if (mix.fat > 0.35) array_push(tone_fragments, "rich echoes linger.");
else if (mix.fat < 0.2) array_push(tone_fragments, "the body thins out fast.");

var preview_text = preview_seed;
for (var p = 0; p < array_length(tone_fragments); p++) {
    preview_text += " " + tone_fragments[p];
}

preview_lines = scr_quiz_text_wrap(preview_text, 360, 8);

draw_set_color(make_colour_rgb(240, 240, 240));
draw_rectangle(preview_x - 12, preview_y - 16, preview_x + preview_lines.width, preview_y + preview_lines.height, false);
draw_set_color(c_black);
var text_y = preview_y;
for (var q = 0; q < array_length(preview_lines.lines); q++) {
    draw_text(preview_x, text_y, preview_lines.lines[q]);
    text_y += preview_lines.line_height;
}

draw_set_color(c_black);
if (is_struct(feedback_wrap)) {
    var note_y = 420;
    draw_set_alpha(0.3 + note_alpha);
    draw_rectangle(440 - 12, note_y - 16, 440 + feedback_wrap.width, note_y + feedback_wrap.height, false);
    draw_set_alpha(1);
    var feed_y = note_y;
    for (var n = 0; n < array_length(feedback_wrap.lines); n++) {
        draw_text(440, feed_y, feedback_wrap.lines[n]);
        feed_y += feedback_wrap.line_height;
    }
}

draw_text(440, 360, "Press taste to see how it reads.");
