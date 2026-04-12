/// @function scr_quiz_submit(choice_id)
/// @description Evaluates the player's choice against the current answer and returns feedback data.
/// @param choice_id The identifier string for the selected option ("a".."d").
function scr_quiz_submit(choice_id) {
    if (is_undefined(global.quiz_current)) {
        return { correct: false, explain: "No question loaded." };
    }

    var answer = is_struct(global.quiz_current) ? global.quiz_current.answer : ds_map_find_value(global.quiz_current, "answer");
    var design_note = is_struct(global.quiz_current) ? global.quiz_current.design_note : ds_map_find_value(global.quiz_current, "design_note");

    global.quiz_choice = choice_id;
    global.quiz_correct = (choice_id == answer);

    return {
        correct: global.quiz_correct,
        explain: string(design_note)
    };
}
