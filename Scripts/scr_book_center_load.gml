/// @function scr_book_center_load()
/// @description Prepares the hidden anchor point for the center activity.
function scr_book_center_load() {
    var anchor = {
        x: room_width * 0.52,
        y: room_height * 0.46
    };

    global.db_center_anchor = anchor;
    global.db_center_feedback = "";
    global.db_center_mark = undefined;

    global.db_center_shapes = [
        { x: 200, y: 220, w: 160, h: 120, col: make_colour_rgb(120, 150, 200) },
        { x: 500, y: 260, w: 200, h: 80, col: make_colour_rgb(200, 140, 120) },
        { x: 360, y: 360, w: 120, h: 120, col: make_colour_rgb(160, 180, 160) }
    ];

    return true;
}
