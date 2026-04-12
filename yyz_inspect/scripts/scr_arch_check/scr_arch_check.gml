/// @function scr_arch_check()
/// @description Evaluates the current block stack for balance.
function scr_arch_check() {
    if (!is_array(global.arch_slots)) {
        return { stable: false, note: "Place blocks on the base to test the stack." };
    }

    var stack = [];
    for (var i = 0; i < array_length(global.arch_slots); i++) {
        var inst = global.arch_slots[i];
        if (instance_exists(inst)) {
            array_push(stack, {
                label: inst.block_label,
                weight: inst.block_weight,
                pull: inst.block_pull,
                index: i
            });
        }
    }

    if (array_length(stack) == 0) {
        return { stable: false, note: "No stack yet; slide a block onto the base." };
    }

    var wobble = 0;
    var highlight = [];
    var surprises = [];
    var last_label = "";
    var contrast_run = 0;

    for (var j = 0; j < array_length(stack); j++) {
        var entry = stack[j];
        var label = entry.label;

        if (label == "contrast") {
            contrast_run += 1;
            wobble += 0.2 * contrast_run;
        } else {
            contrast_run = 0;
        }

        if (label == "tension" && last_label == "rest") {
            wobble += 0.25;
            array_push(surprises, "tension rising above rest");
        }

        if ((label == "pattern" && last_label == "contrast") || (label == "contrast" && last_label == "pattern")) {
            array_push(highlight, "rhythm");
        }

        if (entry.weight > 1.8 && j > 1) {
            wobble += 0.15;
        }

        if (entry.pull > 1.2 && j == array_length(stack) - 1) {
            wobble += 0.1;
        }

        last_label = label;
    }

    var stable = wobble < 1.1;

    var fragments = [];
    if (stable) {
        if (array_length(highlight) > 0) {
            array_push(fragments, "This stack holds: rhythm with one surprise.");
        } else {
            array_push(fragments, "This stack holds steady lines.");
        }

        if (array_length(surprises) > 0) {
            array_push(fragments, "In prose, that reads as flow with a beat.");
        } else {
            array_push(fragments, "In prose, that reads as calm pacing.");
        }
    } else {
        var reasons = [];
        if (contrast_run > 1) {
            array_push(reasons, "too much contrast in a row");
        }
        if (array_length(surprises) > 0) {
            array_push(reasons, "tension stacked high");
        }
        if (array_length(reasons) == 0) {
            array_push(reasons, "weights fighting each other");
        }
        array_push(fragments, "The stack wobbles; " + join_reasons(reasons) + ".");
        array_push(fragments, "Shift a block to give the base room to breathe.");
    }

    var note = "";
    for (var k = 0; k < array_length(fragments); k++) {
        if (k == 0) {
            note = fragments[k];
        } else {
            note += " " + fragments[k];
        }
    }

    global.arch_last_result = { stable: stable, note: note };
    global.arch_feedback_note = note;

    return { stable: stable, note: note };
}

function join_reasons(list) {
    if (!is_array(list) || array_length(list) == 0) {
        return "";
    }
    if (array_length(list) == 1) {
        return list[0];
    }
    var text = "";
    for (var i = 0; i < array_length(list); i++) {
        if (i == 0) {
            text = list[i];
        } else if (i == array_length(list) - 1) {
            text = text + " and " + list[i];
        } else {
            text = text + ", " + list[i];
        }
    }
    return text;
}
