/// @function scr_book_symmetry_score(fold_x)
/// @description Compares left/right text weight based on the fold position.
function scr_book_symmetry_score(fold_x) {
    var layout = global.db_symmetry_layout;
    if (!is_struct(layout)) {
        return { ok: false, note: "Text not ready." };
    }

    var origin = global.db_symmetry_origin_x;
    if (!is_real(origin)) {
        origin = 160;
    }

    var width = max(1, layout.width);
    var total_chars = string_length(global.db_symmetry_text);
    var relative = clamp((fold_x - origin) / width, 0, 1);

    var left_chars = round(total_chars * relative);
    var right_chars = max(0, total_chars - left_chars);
    var diff = abs(left_chars - right_chars);
    var ratio = diff / max(1, total_chars);

    var ok = (ratio <= 0.12);
    var note;
    if (ok) {
        note = "Symmetry calms; both sides read steady.";
    } else if (left_chars > right_chars) {
        note = "Left side carries more weight; slide the fold right.";
    } else {
        note = "Right side carries more weight; slide the fold left.";
    }

    global.db_symmetry_diff = { left: left_chars, right: right_chars, diff: diff, ratio: ratio };

    return { ok: ok, note: note, left: left_chars, right: right_chars, ratio: ratio };
}
