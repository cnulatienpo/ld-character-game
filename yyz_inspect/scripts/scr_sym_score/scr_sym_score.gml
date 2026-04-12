/// @function scr_sym_score(fold_x)
/// @description Evaluates balance based on the fold line position.
/// @param fold_x X position of the fold line.
function scr_sym_score(fold_x) {
    var left_edge = global.sym_panel_left;
    var panel_width = max(1, global.sym_panel_width);
    var relative = clamp((fold_x - left_edge) / panel_width, 0, 1);

    var balance = 1 - abs(relative - 0.5) / 0.5;
    balance = clamp(balance, 0, 1);

    var note;
    if (abs(relative - 0.5) < 0.08) {
        note = "This sits in calm balance; the room exhales.";
    } else if (relative > 0.5) {
        note = "This leans right; that tilt adds a little energy.";
    } else {
        note = "This leans left; that tilt gives the scene a charge.";
    }

    if (is_struct(global.sym_round) && string_length(global.sym_round.design_note) > 0) {
        // Use the design note for core feedback when close to center.
        if (abs(relative - 0.5) < 0.02) {
            note = global.sym_round.design_note;
        }
    }

    return { balance: balance, note: note };
}
