/// obj_quiz_choice : Left Pressed Event
// Submits the player's selection and activates feedback.
if (my_id == "") {
    return;
}

var result = scr_quiz_submit(my_id);
global.quiz_feedback = result;
instance_activate_object(obj_quiz_feedback);
