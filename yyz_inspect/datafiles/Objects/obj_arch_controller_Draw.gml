/// obj_arch_controller : Draw Event
// Draws instructions, the platform, and feedback.
draw_set_color(c_black);
var left_x = 80;
var text_y = 80;
for (var i = 0; i < array_length(check_wrap.lines); i++) {
    draw_text(left_x, text_y, check_wrap.lines[i]);
    text_y += check_wrap.line_height;
}

draw_set_color(make_colour_rgb(210, 210, 210));
var cfg = global.arch_config;
draw_rectangle(cfg.base_x - platform_width / 2, cfg.base_y + 20, cfg.base_x + platform_width / 2, cfg.base_y + 36, false);
draw_set_color(make_colour_rgb(235, 235, 235));
draw_rectangle(cfg.area.x1, cfg.area.y1, cfg.area.x2, cfg.area.y2, true);
draw_set_color(make_colour_rgb(190, 190, 190));
draw_rectangle(cfg.area.x1, cfg.area.y1, cfg.area.x2, cfg.area.y2, false);

draw_set_color(c_black);
draw_text(cfg.area.x1 + 12, cfg.area.y2 + 28, "Drop blocks here.");

if (is_struct(feedback_wrap)) {
    var note_y = 440;
    draw_set_color(make_colour_rgb(245, 245, 245));
    draw_rectangle(440 - 12, note_y - 16, 440 + feedback_wrap.width, note_y + feedback_wrap.height, false);
    draw_set_color(c_black);
    var fy = note_y;
    for (var j = 0; j < array_length(feedback_wrap.lines); j++) {
        draw_text(440, fy, feedback_wrap.lines[j]);
        fy += feedback_wrap.line_height;
    }
}
