/// @function scr_gravity_submit(choice)
/// @description Compares the player's selected ending with the editor's preferred landing.
function scr_gravity_submit(choice) {
    if (!is_struct(global.gt_item)) {
        return { ok: false, note: "Resolution is where energy settles. One ending releases tension more honestly." };
    }

    var preferred = string(global.gt_item.preferred);
    var picked = string(choice);
    var match = (preferred == picked);

    var note_text = global.gt_item.design_note;
    if (!is_string(note_text) || string_length(note_text) == 0) {
        note_text = "Resolution is where energy settles. One ending releases tension more honestly.";
    }

    return { ok: match, note: note_text };
}
