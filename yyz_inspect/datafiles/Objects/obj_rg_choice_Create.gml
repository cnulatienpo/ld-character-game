/// obj_rg_choice : Create Event
// Prepares a palette choice for the restoration game.
choice_slot = is_real(choice_slot) ? choice_slot : 0;
choice_id = "";
choice_text = "";
choice_tags = [];
used = false;
hover = false;

var round = global.rg_round;
if (is_struct(round) && is_array(round.palette)) {
    var palette = round.palette;
    if (choice_slot >= 0 && choice_slot < array_length(palette)) {
        var entry = palette[choice_slot];
        choice_id = string(entry.id);
        choice_text = string(entry.text);
        choice_tags = entry.tags;
    }
}
