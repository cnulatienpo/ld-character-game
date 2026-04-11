/// @function build_label_indexes()
/// @description Builds global signal and misconception indexes from global.labels.
function build_label_indexes() {
    if (variable_global_exists("signals") && ds_exists(global.signals, ds_type_map)) {
        ds_map_destroy(global.signals);
    }

    if (variable_global_exists("misconceptions") && ds_exists(global.misconceptions, ds_type_map)) {
        ds_map_destroy(global.misconceptions);
    }

    global.signals = ds_map_create();
    global.misconceptions = ds_map_create();

    if (!is_array(global.labels)) {
        return;
    }

    var label_count = array_length(global.labels);

    for (var i = 0; i < label_count; i++) {
        var row = global.labels[i];

        if (!is_struct(row)) {
            continue;
        }

        if (!variable_struct_exists(row, "concept_id")) {
            continue;
        }

        var concept_id = row.concept_id;

        if (variable_struct_exists(row, "signal_id")) {
            var signal_struct = {
                concept_id: concept_id,
                signal_id: row.signal_id,
                detection_hint: variable_struct_exists(row, "detection_hint") ? row.detection_hint : "",
                axis_value: variable_struct_exists(row, "axis_value") ? row.axis_value : ""
            };

            var signal_list = ds_map_exists(global.signals, concept_id) ? global.signals[? concept_id] : [];
            array_push(signal_list, signal_struct);
            global.signals[? concept_id] = signal_list;
        }

        if (variable_struct_exists(row, "misconception_id")) {
            var misconception_struct = {
                concept_id: concept_id,
                misconception_id: row.misconception_id,
                tells: variable_struct_exists(row, "tells") ? row.tells : "",
                corrective_feedback: variable_struct_exists(row, "corrective_feedback") ? row.corrective_feedback : "",
                micro_drill: variable_struct_exists(row, "micro_drill") ? row.micro_drill : ""
            };

            var misconception_list = ds_map_exists(global.misconceptions, concept_id) ? global.misconceptions[? concept_id] : [];
            array_push(misconception_list, misconception_struct);
            global.misconceptions[? concept_id] = misconception_list;
        }
    }
}

/// @function detect_signals(_text, _concept_id)
/// @description Detects concept signals in player text.
function detect_signals(_text, _concept_id) {
    var matched = [];

    if (!variable_global_exists("signals") || !ds_exists(global.signals, ds_type_map)) {
        return matched;
    }

    if (!ds_map_exists(global.signals, _concept_id)) {
        return matched;
    }

    var source_text = string_lower(string(_text));
    var signal_list = global.signals[? _concept_id];
    var signal_count = array_length(signal_list);

    for (var i = 0; i < signal_count; i++) {
        var signal_row = signal_list[i];
        var hint_text = string_lower(string(signal_row.detection_hint));

        if (string_length(hint_text) <= 0) {
            continue;
        }

        var words = string_split(hint_text, " ");
        var matched_words = 0;
        var word_count = array_length(words);

        for (var w = 0; w < word_count; w++) {
            var word = string_trim(words[w]);

            if (string_length(word) <= 0) {
                continue;
            }

            if (string_pos(word, source_text) > 0) {
                matched_words += 1;
            }
        }

        if (matched_words >= 2) {
            array_push(matched, signal_row.signal_id);
        }
    }

    return matched;
}

/// @function evaluate_text(_text, _concept_id)
/// @description Evaluates found and missing signals for a concept.
function evaluate_text(_text, _concept_id) {
    var found = detect_signals(_text, _concept_id);
    var missing = [];
    var total_signals = 0;

    if (variable_global_exists("signals") && ds_exists(global.signals, ds_type_map) && ds_map_exists(global.signals, _concept_id)) {
        var signal_list = global.signals[? _concept_id];
        total_signals = array_length(signal_list);

        for (var i = 0; i < total_signals; i++) {
            var signal_id = signal_list[i].signal_id;
            if (array_contains(found, signal_id)) {
                continue;
            }
            array_push(missing, signal_id);
        }
    }

    var found_count = array_length(found);
    var required_count = max(1, ceil(total_signals * 0.5));
    var success = (total_signals == 0) || (found_count >= required_count);

    return {
        success: success,
        found: found,
        missing: missing
    };
}

/// @function generate_feedback(_text, _concept_id)
/// @description Generates misconception feedback from tells.
function generate_feedback(_text, _concept_id) {
    var fallback = "Push the concept further. Add clearer signals.";

    if (!variable_global_exists("misconceptions") || !ds_exists(global.misconceptions, ds_type_map)) {
        return fallback;
    }

    if (!ds_map_exists(global.misconceptions, _concept_id)) {
        return fallback;
    }

    var source_text = string_lower(string(_text));
    var misconception_list = global.misconceptions[? _concept_id];
    var misconception_count = array_length(misconception_list);

    for (var i = 0; i < misconception_count; i++) {
        var row = misconception_list[i];
        var tells_text = string_lower(string(row.tells));

        if (string_length(tells_text) <= 0) {
            continue;
        }

        var tells_words = string_split(tells_text, " ");
        var tells_count = array_length(tells_words);

        for (var w = 0; w < tells_count; w++) {
            var tell = string_trim(tells_words[w]);
            if (string_length(tell) <= 0) {
                continue;
            }

            if (string_pos(tell, source_text) > 0) {
                return row.corrective_feedback;
            }
        }
    }

    return fallback;
}

/// @function run_writing_check(_text, _concept_id)
/// @description Full writing check pipeline.
function run_writing_check(_text, _concept_id) {
    var result = evaluate_text(_text, _concept_id);

    if (result.success) {
        return {
            success: true,
            feedback: "Good work. Your writing shows the core signals.",
            missing_signals: []
        };
    }

    return {
        success: false,
        feedback: generate_feedback(_text, _concept_id),
        missing_signals: result.missing
    };
}
