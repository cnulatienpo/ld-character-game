/// obj_soundlab_controller : Step Event
// Restarts the beat loop if it finishes before the player answers.
if (!global.sl_playing && !global.sl_submitted) {
    scr_soundlab_play();
}
