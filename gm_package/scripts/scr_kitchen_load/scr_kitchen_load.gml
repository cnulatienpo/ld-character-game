/// @function scr_kitchen_load()
/// @description Loads a Form Kitchen round definition from disk into global scope.
function scr_kitchen_load() {
    var data = scr_json_read("dataset/kitchen_recipes.json");
    if (!is_struct(data) || !variable_struct_exists(data, "rounds")) {
        show_debug_message("scr_kitchen_load: no rounds found");
        return false;
    }

    var rounds = data.rounds;
    if (!is_array(rounds) || array_length(rounds) == 0) {
        show_debug_message("scr_kitchen_load: empty rounds array");
        return false;
    }

    var pick = rounds[irandom(array_length(rounds) - 1)];
    if (!is_struct(pick)) {
        show_debug_message("scr_kitchen_load: invalid round entry");
        return false;
    }

    var start_mix = {
        salt: 0.25,
        acid: 0.25,
        sugar: 0.25,
        fat: 0.25
    };

    if (variable_struct_exists(pick, "start") && is_struct(pick.start)) {
        start_mix.salt = real(variable_struct_get(pick.start, "salt", start_mix.salt));
        start_mix.acid = real(variable_struct_get(pick.start, "acid", start_mix.acid));
        start_mix.sugar = real(variable_struct_get(pick.start, "sugar", start_mix.sugar));
        start_mix.fat = real(variable_struct_get(pick.start, "fat", start_mix.fat));
    }

    var target_source = start_mix;
    if (variable_struct_exists(pick, "target") && is_struct(pick.target)) {
        target_source = pick.target;
    }

    global.kit_round = {
        goal: variable_struct_get(pick, "goal", "Shape the flavor."),
        tips: variable_struct_get(pick, "tips", "Nudge contrast, keep harmony steady."),
        target: {
            salt: clamp(real(variable_struct_get(target_source, "salt", start_mix.salt)), 0, 1),
            acid: clamp(real(variable_struct_get(target_source, "acid", start_mix.acid)), 0, 1),
            sugar: clamp(real(variable_struct_get(target_source, "sugar", start_mix.sugar)), 0, 1),
            fat: clamp(real(variable_struct_get(target_source, "fat", start_mix.fat)), 0, 1)
        },
        explain: variable_struct_get(pick, "explain", "Each slider echoes a sentence move."),
        sample: [
            "The market hums with clatter.",
            "Steam curls past the sign maker.",
            "The speaker leans close over the pot."
        ]
    };

    global.kit_mix = {
        salt: clamp(start_mix.salt, 0, 1),
        acid: clamp(start_mix.acid, 0, 1),
        sugar: clamp(start_mix.sugar, 0, 1),
        fat: clamp(start_mix.fat, 0, 1)
    };

    global.kit_feedback = "Taste and adjust until the text feels right.";
    global.kit_last_score = 0;
    global.kit_sample_pick = choose(0, 1, 2);

    return true;
}
