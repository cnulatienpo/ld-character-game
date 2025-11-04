/// @function scr_arch_load()
/// @description Prepares block definitions for the Architecture Studio.
function scr_arch_load() {
    var labels = ["pattern", "contrast", "tension", "rest"];
    var blocks = [];

    for (var i = 0; i < array_length(labels); i++) {
        var label = labels[i];
        var w = irandom_range(96, 140);
        var weight = real(irandom_range(12, 20)) / 10;
        var pull = real(irandom_range(5, 15)) / 10;
        array_push(blocks, {
            label: label,
            width: w,
            weight: weight,
            pull: pull
        });
    }

    global.arch_blocks = blocks;
    global.arch_config = {
        base_x: 520,
        base_y: 420,
        slot_height: 56,
        slot_count: 6,
        area: { x1: 420, y1: 140, x2: 620, y2: 420 }
    };

    global.arch_slots = array_create(global.arch_config.slot_count, noone);
    global.arch_feedback_note = "Drag blocks to the base and look for balance.";
    global.arch_last_result = undefined;
    global.arch_wobble_timer = 0;
    global.arch_wobble_amp = 0;
    global.arch_wobble_phase = 0;
    global.arch_wobble_state = "idle";

    return true;
}
