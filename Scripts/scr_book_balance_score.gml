/// @function scr_book_balance_score(t)
/// @description Evaluates the balance slider placement.
function scr_book_balance_score(t) {
    var value = clamp(real(t), 0, 1);
    var low = 0.45;
    var high = 0.55;

    var ok = (value >= low && value <= high);
    var note;
    if (ok) {
        note = "Balance is even; both sides carry weight.";
    } else if (value < low) {
        note = "Left side leans heavy; ease the slider toward center.";
    } else {
        note = "Right side leans heavy; ease it back toward center.";
    }

    return { ok: ok, note: note };
}
