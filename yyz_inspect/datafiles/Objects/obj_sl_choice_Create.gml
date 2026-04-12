/// obj_sl_choice : Create Event
// Prepares a choice button for the Sound Lab round.
choice_slot = is_real(choice_slot) ? choice_slot : 0;
choice_id = "";
choice_text = "";
hover = false;
selected = false;
result_ok = false;

var round = global.sl_current;
if (is_struct(round) && is_array(round.choices)) {
    var choices = round.choices;
    if (choice_slot >= 0 && choice_slot < array_length(choices)) {
        var entry = choices[choice_slot];
        choice_id = string(entry.id);
        choice_text = string(entry.text);
    }
}
