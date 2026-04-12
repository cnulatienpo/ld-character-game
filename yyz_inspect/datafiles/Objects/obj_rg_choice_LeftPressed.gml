/// obj_rg_choice : Left Pressed Event
// Applies the detail when clicked.
if (used) {
    exit;
}

var result = scr_restoration_apply(choice_id);
global.rg_note = result.note;
