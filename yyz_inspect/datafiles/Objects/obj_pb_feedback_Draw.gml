/// obj_pb_feedback : Draw Event
if (is_undefined(global.pb_result)) {
    exit;
}

draw_set_color(c_black);
draw_text(x, y, "Design reason: " + string(global.pb_result.explain));
