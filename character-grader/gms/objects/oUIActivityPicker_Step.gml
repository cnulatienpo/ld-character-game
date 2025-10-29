/// oUIActivityPicker Step Event

var mode = activity_mode_get();
if (mode != "picker") {
    choice_index = -1;
    exit;
}

var card = act_current_card();
var labels = [];
question_text = "";
if (is_struct(card)) {
    if (variable_struct_exists(card, "prompt") && is_string(card.prompt)) {
        question_text = card.prompt;
    } else if (variable_struct_exists(card, "title") && is_string(card.title)) {
        question_text = card.title;
    } else {
        question_text = "Choose an answer";
    }
    if (variable_struct_exists(card, "choices") && is_array(card.choices)) {
        labels = card.choices;
    } else if (variable_struct_exists(card, "options") && is_array(card.options)) {
        labels = card.options;
    } else if (variable_struct_exists(card, "answers") && is_array(card.answers)) {
        labels = card.answers;
    }
}

if (!is_array(labels) || array_length(labels) <= 0) {
    labels = ["Option A", "Option B", "Option C"];
}

choice_labels = labels;
