/// obj_soundlab_controller : Create Event
// Loads Sound Lab data and kicks off the beat loop.
if (!scr_soundlab_load()) {
    show_debug_message("obj_soundlab_controller: unable to load Sound Lab round");
    instance_destroy();
    exit;
}

scr_soundlab_play();

question_text = string(global.sl_current.question);
if (question_text == "") {
    question_text = "Which line fits this beat?";
}

global.sl_custom_text = "";
global.sl_write_feedback = "";
global.sl_write_prompt = "Write one line that lands with this beat.\n\nKeep it clipped if the beat feels short.";
