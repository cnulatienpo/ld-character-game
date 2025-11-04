/// obj_sl_choice : Left Pressed Event
// Submits the choice when clicked.
if (global.sl_submitted) {
    exit;
}

var result = scr_soundlab_submit(choice_id);
selected = true;
result_ok = result.ok;
