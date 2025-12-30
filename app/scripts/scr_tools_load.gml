/// scr_tools_load.gml
// Runtime registry loader for tool unlock data
// -----------------------------------------------------------------------------

globalvar tool_registry_initialized;
globalvar tool_unlocks_map;
globalvar tool_catalog_map;
globalvar topic_metrics_map;

tool_registry_initialized = false;

function __tools_read_json(_relative_path) {
    var full_path = _relative_path;
    if (!file_exists(full_path)) {
        full_path = working_directory + _relative_path;
    }
    if (!file_exists(full_path)) {
        show_debug_message("[tools] Missing file: " + _relative_path);
        return undefined;
    }
    var handle = file_text_open_read(full_path);
    var text = "";
    while (!file_text_eof(handle)) {
        text += file_text_readln(handle);
        if (!file_text_eof(handle)) {
            text += "\n";
        }
    }
    file_text_close(handle);
    if (string_length(text) == 0) {
        return undefined;
    }
    return json_parse(text);
}

function __tools_struct_has(_struct, _key) {
    return is_struct(_struct) && variable_struct_exists(_struct, _key);
}

function __tools_metric_key(_topic, _metric) {
    return string(_topic) + "." + string(_metric);
}

function __tools_collect_progress_metrics(_progress) {
    var collected = {};
    if (is_struct(_progress) && __tools_struct_has(_progress, "metrics")) {
        var provided = _progress.metrics;
        if (is_struct(provided)) {
            var keys = variable_struct_get_names(provided);
            for (var i = 0; i < array_length(keys); ++i) {
                var k = keys[i];
                collected[@ k] = provided[$ k];
            }
        }
    }

    var attempt_total = 0;
    if (is_struct(_progress)) {
        if (__tools_struct_has(_progress, "attempt_count")) {
            attempt_total = max(0, _progress.attempt_count);
        }
        if (__tools_struct_has(_progress, "cards")) {
            var cards = _progress.cards;
            if (is_struct(cards)) {
                var card_keys = variable_struct_get_names(cards);
                var pass_count = 0;
                var visible_cards = 0;
                for (var c = 0; c < array_length(card_keys); ++c) {
                    var card_key = card_keys[c];
                    var card = cards[$ card_key];
                    if (is_struct(card)) {
                        visible_cards += 1;
                        if (__tools_struct_has(card, "passed") && card.passed) {
                            pass_count += 1;
                        }
                        if (__tools_struct_has(card, "attempts")) {
                            attempt_total += card.attempts;
                        }
                    }
                }
                if (visible_cards > 0) {
                    collected[@ "global.pass-ratio"] = pass_count / visible_cards;
                    collected[@ "global.cards"] = visible_cards;
                }
            }
        }
        if (__tools_struct_has(_progress, "xp")) {
            collected[@ "global.xp"] = _progress.xp;
        }
        if (__tools_struct_has(_progress, "level")) {
            collected[@ "global.level"] = _progress.level;
        }
        if (__tools_struct_has(_progress, "streak")) {
            collected[@ "global.streak"] = _progress.streak;
        }
    }
    collected[@ "global.attempts"] = attempt_total;
    return collected;
}

function tools_init() {
    if (!is_undefined(tool_unlocks_map)) {
        ds_map_destroy(tool_unlocks_map);
    }
    if (!is_undefined(tool_catalog_map)) {
        ds_map_destroy(tool_catalog_map);
    }
    if (!is_undefined(topic_metrics_map)) {
        ds_map_destroy(topic_metrics_map);
    }

    tool_unlocks_map = ds_map_create();
    tool_catalog_map = ds_map_create();
    topic_metrics_map = ds_map_create();

    var registry = __tools_read_json("game_thingss/runtime/tools.registry.json");
    var unlocks = __tools_read_json("game_thingss/runtime/tools.unlocks.json");
    var metrics_flat = __tools_read_json("game_thingss/runtime/tools.metrics.json");

    if (is_undefined(registry) || is_undefined(unlocks) || is_undefined(metrics_flat)) {
        show_debug_message("[tools] Registry load failed; check Included Files.");
        return false;
    }

    // Catalog tools
    var tools_array = registry.tools;
    if (is_array(tools_array)) {
        for (var i = 0; i < array_length(tools_array); ++i) {
            var tool_entry = tools_array[i];
            if (!is_struct(tool_entry)) continue;
            var tool_id = tool_entry.id;
            var info = {
                name: tool_entry.name,
                side: tool_entry.side,
                icon: tool_entry.icon,
                weight: tool_entry.weight,
            };
            ds_map_add(tool_catalog_map, tool_id, info);
            var unlock_array = [];
            if (is_array(tool_entry.unlocks)) {
                for (var u = 0; u < array_length(tool_entry.unlocks); ++u) {
                    var requirement = tool_entry.unlocks[u];
                    if (!is_struct(requirement)) continue;
                    var req_struct = {
                        topic: requirement.topic,
                        metric: requirement.metric,
                    };
                    if (__tools_struct_has(requirement, "min")) {
                        req_struct.min = requirement.min;
                    }
                    if (__tools_struct_has(requirement, "max")) {
                        req_struct.max = requirement.max;
                    }
                    if (__tools_struct_has(requirement, "streak")) {
                        req_struct.streak = requirement.streak;
                    }
                    array_push(unlock_array, req_struct);
                }
            }
            ds_map_add(tool_unlocks_map, tool_id, unlock_array);
        }
    }

    // Topic metrics list
    if (is_array(metrics_flat)) {
        for (var m = 0; m < array_length(metrics_flat); ++m) {
            var metric_entry = metrics_flat[m];
            if (!is_struct(metric_entry)) continue;
            var topic_id = metric_entry.topic_id;
            var metric_struct = {
                id: metric_entry.metric_id,
                name: metric_entry.name,
                threshold: metric_entry.threshold,
                kind: metric_entry.kind,
                source: metric_entry.source,
            };
            if (__tools_struct_has(metric_entry, "levels")) {
                metric_struct.levels = metric_entry.levels;
            }
            if (__tools_struct_has(metric_entry, "notes")) {
                metric_struct.notes = metric_entry.notes;
            }
            if (ds_map_exists(topic_metrics_map, topic_id)) {
                var bucket = ds_map_find_value(topic_metrics_map, topic_id);
                array_push(bucket, metric_struct);
                ds_map_replace(topic_metrics_map, topic_id, bucket);
            } else {
                var new_bucket = [];
                array_push(new_bucket, metric_struct);
                ds_map_add(topic_metrics_map, topic_id, new_bucket);
            }
        }
    }

    tool_registry_initialized = true;
    return true;
}

function tools_check_unlocks(_progress) {
    if (!tool_registry_initialized) {
        tools_init();
    }
    var newly_unlocked = [];
    var still_locked = [];
    var counts = __tools_collect_progress_metrics(_progress);

    var unlocked_existing = [];
    if (is_struct(_progress)) {
        if (__tools_struct_has(_progress, "unlocked_tools")) {
            var existing = _progress.unlocked_tools;
            if (is_array(existing)) {
                unlocked_existing = existing;
            }
        } else if (__tools_struct_has(_progress, "unlocked_signals")) {
            var signals = _progress.unlocked_signals;
            if (is_array(signals)) {
                unlocked_existing = signals;
            }
        }
    }

    var tool_keys = ds_map_keys(tool_unlocks_map);
    for (var i = 0; i < ds_list_size(tool_keys); ++i) {
        var tool_id = ds_list_find_value(tool_keys, i);
        var requirements = ds_map_find_value(tool_unlocks_map, tool_id);
        var satisfied = true;
        for (var r = 0; r < array_length(requirements); ++r) {
            var req = requirements[r];
            var metric_key = __tools_metric_key(req.topic, req.metric);
            var value = 0;
            if (__tools_struct_has(counts, metric_key)) {
                value = counts[$ metric_key];
            } else if (__tools_struct_has(counts, req.metric)) {
                value = counts[$ req.metric];
            }
            var needed = 1;
            if (__tools_struct_has(req, "min")) {
                needed = req.min;
            }
            if (value < needed) {
                satisfied = false;
                break;
            }
            if (__tools_struct_has(req, "streak")) {
                var streak_needed = req.streak;
                var streak_value = 0;
                if (__tools_struct_has(counts, "global.streak")) {
                    streak_value = counts[$ "global.streak"];
                }
                if (streak_value < streak_needed) {
                    satisfied = false;
                    break;
                }
            }
        }
        if (satisfied) {
            var already = false;
            for (var a = 0; a < array_length(unlocked_existing); ++a) {
                if (unlocked_existing[a] == tool_id) {
                    already = true;
                    break;
                }
            }
            if (!already) {
                array_push(newly_unlocked, tool_id);
            }
        } else {
            array_push(still_locked, tool_id);
        }
    }
    ds_list_destroy(tool_keys);

    return {
        newly_unlocked: newly_unlocked,
        still_locked: still_locked,
        counts: counts,
    };
}

function tools_side_for(_tool_id) {
    if (!tool_registry_initialized) {
        tools_init();
    }
    if (!ds_map_exists(tool_catalog_map, _tool_id)) {
        return "both";
    }
    var info = ds_map_find_value(tool_catalog_map, _tool_id);
    if (is_struct(info) && __tools_struct_has(info, "side")) {
        return info.side;
    }
    return "both";
}
