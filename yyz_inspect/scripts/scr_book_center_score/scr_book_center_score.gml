/// @function scr_book_center_score(click_x, click_y)
/// @description Scores the tap location for the center activity.
function scr_book_center_score(click_x, click_y) {
    var anchor = global.db_center_anchor;
    if (!is_struct(anchor)) {
        return { ok: false, note: "Anchor not set." };
    }

    var dist = point_distance(click_x, click_y, anchor.x, anchor.y);
    var ok = (dist <= 48);

    var note;
    if (ok) {
        note = "The frame holds here; that’s your center.";
    } else {
        note = "Slide closer to where the frame feels steady.";
    }

    global.db_center_feedback = note;
    global.db_center_mark = { x: click_x, y: click_y, dist: dist };

    return { ok: ok, note: note, distance: dist };
}
