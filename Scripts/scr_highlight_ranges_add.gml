/// @function scr_highlight_ranges_add(ranges_array, start_idx, end_idx)
/// @description Adds a [start,end] pair to the supplied highlight array, clamping ordering.
/// @param ranges_array Array storing highlight entries (mutated in place).
/// @param start_idx Integer start line index.
/// @param end_idx Integer end line index (inclusive).
function scr_highlight_ranges_add(ranges_array, start_idx, end_idx) {
    if (!is_array(ranges_array)) {
        return;
    }

    if (end_idx < start_idx) {
        var temp = start_idx;
        start_idx = end_idx;
        end_idx = temp;
    }

    array_push(ranges_array, [start_idx, end_idx]);
}
