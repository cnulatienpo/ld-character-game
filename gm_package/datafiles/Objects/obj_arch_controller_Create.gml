/// obj_arch_controller : Create Event
// Sets up the Architecture Studio environment.
if (!is_struct(global.arch_config)) {
    scr_arch_load();
}

check_wrap = scr_quiz_text_wrap("Stack pattern, contrast, tension, rest. Let the tower breathe.", 340, 8);
feedback_wrap = undefined;
platform_width = 220;
