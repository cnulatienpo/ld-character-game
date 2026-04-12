/// Native GML grader port for character writing beats.
/// This removes the hard runtime dependency on Node for scoring logic.

function cg__contains(_text_lower, _needle) {
    return string_pos(_needle, _text_lower) > 0;
}

function cg__contains_any(_text_lower, _terms) {
    for (var i = 0; i < array_length(_terms); i++) {
        if (cg__contains(_text_lower, _terms[i])) {
            return true;
        }
    }
    return false;
}

function cg__collect_matches(_text_lower, _terms) {
    var out = [];
    for (var i = 0; i < array_length(_terms); i++) {
        var t = _terms[i];
        if (cg__contains(_text_lower, t)) {
            array_push(out, t);
        }
    }
    return out;
}

function cg__wordish(_text) {
    var t = string_lower(_text);
    t = string_replace_all(t, "\n", " ");
    t = string_replace_all(t, "\r", " ");
    t = string_replace_all(t, ".", " ");
    t = string_replace_all(t, ",", " ");
    t = string_replace_all(t, "!", " ");
    t = string_replace_all(t, "?", " ");
    t = string_replace_all(t, ":", " ");
    t = string_replace_all(t, ";", " ");
    t = string_replace_all(t, "(", " ");
    t = string_replace_all(t, ")", " ");
    t = string_replace_all(t, "[", " ");
    t = string_replace_all(t, "]", " ");
    t = string_replace_all(t, "{", " ");
    t = string_replace_all(t, "}", " ");
    t = string_replace_all(t, '"', " ");
    return t;
}

function cg__tokens(_text) {
    var t = cg__wordish(_text);
    var raw = string_split(t, " ");
    var out = [];
    for (var i = 0; i < array_length(raw); i++) {
        var tok = string_trim(raw[i]);
        if (string_length(tok) > 0) {
            array_push(out, tok);
        }
    }
    return out;
}

function cg__array_has(_arr, _value) {
    for (var i = 0; i < array_length(_arr); i++) {
        if (_arr[i] == _value) return true;
    }
    return false;
}

function cg__digit_present(_text) {
    for (var i = 1; i <= string_length(_text); i++) {
        var c = string_char_at(_text, i);
        if (c >= "0" && c <= "9") return true;
    }
    return false;
}

function cg__strength_from_signals(_behavior, _signals) {
    var b = string_lower(string(_behavior));
    var behavior_hit = false;
    if (b == "say") behavior_hit = (_signals.say == 1);
    if (b == "show") behavior_hit = (_signals.show == 1);
    if (b == "hide") behavior_hit = (_signals.hide == 1);

    if (_signals.field_change == 1 && _signals.pressure == 1 && _signals.follow_through == 1 && behavior_hit) {
        return "high";
    }
    if (_signals.pressure == 1 && _signals.follow_through == 1 && behavior_hit) {
        return "medium";
    }
    if (_signals.say == 1 || _signals.show == 1 || _signals.hide == 1) {
        return "low";
    }
    return "low";
}

function cg__maneuvers(_behavior, _target, _computed) {
    var focus = _computed;
    if (is_string(_target) && string_length(_target) > 0) {
        focus = string_lower(_target);
    }
    var behavior = string_lower(string(_behavior));
    var maneuvers = [];

    if (behavior == "say" && focus == "low") {
        array_push(maneuvers, "let another character name the want");
        array_push(maneuvers, "turn a vow into a deadline");
    } else if (behavior == "show" && (focus == "medium" || focus == "high")) {
        array_push(maneuvers, "use object wear and tear to imply cost");
        array_push(maneuvers, "switch a gesture from small to big");
    } else if (behavior == "hide" && (focus == "medium" || focus == "high")) {
        array_push(maneuvers, "answer a question with an action");
        array_push(maneuvers, "swap truth for humor then let the humor fail");
    } else {
        array_push(maneuvers, "echo the choice with a textured detail");
        array_push(maneuvers, "let a small reaction hint at the next beat");
    }

    return maneuvers;
}

function cg__rewrite_for_dialect(_text, _level) {
    var out = string(_text);

    if (_level <= 3) {
        out = string_replace_all(out, "archetype", "role");
        out = string_replace_all(out, "resonance", "echo");
        out = string_replace_all(out, "mythic", "legend");
    }
    if (_level <= 2) {
        out = string_replace_all(out, "scene", "moment");
        out = string_replace_all(out, "beat", "moment");
        out = string_replace_all(out, "status", "standing");
    }
    if (_level <= 1) {
        out = string_replace_all(out, "pressure", "cost");
        out = string_replace_all(out, "signal", "cue");
        out = string_replace_all(out, "pattern", "track");
    }

    return out;
}

function cg__join_comma(_arr) {
    if (!is_array(_arr) || array_length(_arr) <= 0) return "";
    var out = "";
    for (var i = 0; i < array_length(_arr); i++) {
        if (i > 0) out += ", ";
        out += string(_arr[i]);
    }
    return out;
}

function cg__extract_unlocked_ids(_unlocked_json_path) {
    var unlocked = [];

    if (variable_global_exists("unlocked_signals") && ds_exists(global.unlocked_signals, ds_type_list)) {
        for (var i = 0; i < ds_list_size(global.unlocked_signals); i++) {
            var id = ds_list_find_value(global.unlocked_signals, i);
            if (!cg__array_has(unlocked, id)) array_push(unlocked, id);
        }
    }

    if (is_string(_unlocked_json_path) && string_length(_unlocked_json_path) > 0 && file_exists(_unlocked_json_path)) {
        var parsed = scr_json_read(_unlocked_json_path);
        if (is_struct(parsed)) {
            if (variable_struct_exists(parsed, "unlocked_signals") && is_array(parsed.unlocked_signals)) {
                for (var j = 0; j < array_length(parsed.unlocked_signals); j++) {
                    var sig = parsed.unlocked_signals[j];
                    if (!cg__array_has(unlocked, sig)) array_push(unlocked, sig);
                }
            }
        }
    }

    return unlocked;
}

function cg__seeder_path_candidates() {
    var candidates = [];
    array_push(candidates, "character-grader/data/seeder.sample.json");
    array_push(candidates, "dataset/character_full_master.seeder.json");

    if (variable_global_exists("dataset_index") && is_struct(global.dataset_index) && variable_struct_exists(global.dataset_index, "seeders") && is_array(global.dataset_index.seeders) && array_length(global.dataset_index.seeders) > 0) {
        var first = string(global.dataset_index.seeders[0]);
        if (string_pos("dataset/", first) != 1) {
            array_push(candidates, "dataset/" + first);
        }
        array_push(candidates, first);
    }

    return candidates;
}

function cg__load_seeder_tiles() {
    var paths = cg__seeder_path_candidates();
    for (var i = 0; i < array_length(paths); i++) {
        var p = paths[i];
        var data = scr_json_read(p);
        if (is_struct(data) && variable_struct_exists(data, "tiles") && is_array(data.tiles)) {
            return data.tiles;
        }
    }
    return [];
}

function cg__tile_meets_precedence(_tile, _unlocked_ids) {
    if (!is_struct(_tile) || !variable_struct_exists(_tile, "precedence")) return true;
    var precedence = _tile.precedence;
    if (!is_struct(precedence) || !variable_struct_exists(precedence, "comes_after")) return true;
    var needs = precedence.comes_after;
    if (!is_array(needs) || array_length(needs) <= 0) return true;

    for (var i = 0; i < array_length(needs); i++) {
        if (!cg__array_has(_unlocked_ids, needs[i])) return false;
    }
    return true;
}

function cg__tile_within_dialect(_tile, _dialect_level) {
    if (!is_struct(_tile) || !variable_struct_exists(_tile, "language")) return true;
    var lang = _tile.language;
    if (!is_struct(lang) || !variable_struct_exists(lang, "dialect_level")) return true;
    return real(lang.dialect_level) <= real(_dialect_level);
}

function cg__collect_next_unlocks(_concept, _behavior, _signals, _dialect_level, _unlocked_ids) {
    var tiles = cg__load_seeder_tiles();
    var out = [];

    if (!is_array(tiles) || array_length(tiles) <= 0) return out;

    for (var i = 0; i < array_length(tiles); i++) {
        var tile = tiles[i];
        if (!is_struct(tile) || !variable_struct_exists(tile, "id")) continue;

        var tile_id = tile.id;
        if (cg__array_has(_unlocked_ids, tile_id) || cg__array_has(out, tile_id)) continue;
        if (!cg__tile_within_dialect(tile, _dialect_level)) continue;
        if (!cg__tile_meets_precedence(tile, _unlocked_ids)) continue;

        var tile_concept = variable_struct_exists(tile, "concept") ? string_lower(string(tile.concept)) : "";
        var concept_match = (tile_concept == string_lower(string(_concept)));

        var allow = false;

        if (_signals.pressure == 1 && _signals.follow_through == 1) {
            allow = true;
        }

        if (!allow && _signals.say == 1 && _signals.show == 1 && is_struct(tile) && variable_struct_exists(tile, "behaviors") && is_array(tile.behaviors)) {
            for (var b = 0; b < array_length(tile.behaviors); b++) {
                if (string_lower(string(tile.behaviors[b])) == "hide") {
                    allow = concept_match;
                    break;
                }
            }
        }

        if (!allow && _signals.field_change == 1 && is_struct(tile) && variable_struct_exists(tile, "strength_tiers") && is_array(tile.strength_tiers)) {
            for (var s = 0; s < array_length(tile.strength_tiers); s++) {
                if (string_lower(string(tile.strength_tiers[s])) == "high" && concept_match) {
                    allow = true;
                    break;
                }
            }
        }

        // If behavior-specific tile is available for this concept, allow it as a lighter unlock.
        if (!allow && concept_match && is_struct(tile) && variable_struct_exists(tile, "behaviors") && is_array(tile.behaviors)) {
            for (var bb = 0; bb < array_length(tile.behaviors); bb++) {
                if (string_lower(string(tile.behaviors[bb])) == string_lower(string(_behavior))) {
                    allow = true;
                    break;
                }
            }
        }

        if (allow) {
            array_push(out, tile_id);
        }
    }

    return out;
}

function character_grade_native(_text, _concept, _behavior, _target_strength, _dialect_level, _unlocked_json_path) {
    var text_raw = string(_text);
    var text_lower = string_lower(text_raw);
    var tokens = cg__tokens(text_raw);

    var SAY_TERMS = ["\"", "i want", "i need", "i decide", "i promise", "i swear", "i admit", "i confess", "i am going to", "i'm going to", "my goal", "i will", "decided", "choose", "promise"];
    var SHOW_TERMS = ["push", "grab", "slam", "shove", "pace", "nod", "glance", "stare", "clench", "tremble", "flinch", "fidget", "shrug", "smirk", "smile", "grin", "grimace", "sigh", "huff", "storm", "step", "lean", "fold", "smell", "sweat", "heartbeat", "pulse", "taste", "sound", "echo", "heat", "cold", "chill", "buzz", "sting", "keys", "door", "phone", "screen", "hoodie", "ring", "knife", "coffee", "table", "receipt", "bus", "train", "stairs", "locker"];
    var HIDE_TERMS = ["maybe", "kinda", "sort of", "whatever", "it's fine", "its fine", "i'm okay", "i am okay", "change the subject", "doesn't answer", "doesnt answer", "laughs it off", "shrug"];
    var SPECIFIC_NOUNS = ["door", "keys", "table", "receipt", "hoodie", "bus", "knife", "ring", "coffee", "locker", "alley", "cashier", "subway", "poster", "stairs", "bench", "notebook", "badge", "mirror", "couch"];
    var PRESSURE_TERMS = ["risk", "lose", "if i don't", "if i dont", "deadline", "she'll leave", "shell leave", "get fired", "owe", "caught", "afraid", "hurt", "embarrassed", "humiliated", "stakes", "pressure"];
    var CONSEQUENCE_LINKERS = ["so", "therefore", "which means", "after", "then i", "as a result", "leading to"];
    var FIELD_CHANGE = ["they stare", "they glare", "they laugh", "they gasp", "the room goes quiet", "the room falls quiet", "crowd", "manager", "everyone", "he backs off", "she backs off", "she nods", "i can't anymore", "i cant anymore", "i finally", "i won't", "i wont", "i'm done", "i am done"];

    var evidence = {
        say: [],
        show: [],
        hide: [],
        specificity: [],
        pressure: [],
        follow_through: [],
        field_change: []
    };

    var signals = {
        say: 0,
        show: 0,
        hide: 0,
        specificity: 0,
        pressure: 0,
        follow_through: 0,
        field_change: 0
    };

    evidence.say = cg__collect_matches(text_lower, SAY_TERMS);
    if (array_length(evidence.say) > 0) signals.say = 1;

    evidence.show = cg__collect_matches(text_lower, SHOW_TERMS);
    if (array_length(evidence.show) > 0) signals.show = 1;

    evidence.hide = cg__collect_matches(text_lower, HIDE_TERMS);
    if (array_length(evidence.hide) > 0) signals.hide = 1;

    var concrete_count = 0;
    for (var i = 0; i < array_length(tokens); i++) {
        if (cg__array_has(SPECIFIC_NOUNS, tokens[i])) {
            concrete_count += 1;
            if (!cg__array_has(evidence.specificity, tokens[i])) {
                array_push(evidence.specificity, tokens[i]);
            }
        }
    }
    if (concrete_count >= 2 || cg__digit_present(text_raw)) {
        signals.specificity = 1;
        if (cg__digit_present(text_raw)) array_push(evidence.specificity, "number/proper noun");
    }

    evidence.pressure = cg__collect_matches(text_lower, PRESSURE_TERMS);
    if (array_length(evidence.pressure) > 0) signals.pressure = 1;

    evidence.follow_through = cg__collect_matches(text_lower, CONSEQUENCE_LINKERS);
    var has_action_shift = (cg__contains(text_lower, "then i") && (cg__contains(text_lower, "ed ") || cg__contains(text_lower, "ing ")));
    if (array_length(evidence.follow_through) > 0 && has_action_shift) {
        signals.follow_through = 1;
    } else if (array_length(evidence.follow_through) > 0) {
        var ed_count = 0;
        for (var j = 0; j < array_length(tokens); j++) {
            var token = tokens[j];
            if (string_length(token) >= 2 && string_copy(token, string_length(token) - 1, 2) == "ed") {
                ed_count += 1;
            }
        }
        if (ed_count >= 2) signals.follow_through = 1;
    }

    evidence.field_change = cg__collect_matches(text_lower, FIELD_CHANGE);
    if (array_length(evidence.field_change) > 0) signals.field_change = 1;

    var score = signals.say + signals.show + signals.hide + signals.specificity + signals.pressure + signals.follow_through + signals.field_change;
    var strength = cg__strength_from_signals(_behavior, signals);
    var maneuvers = cg__maneuvers(_behavior, _target_strength, strength);

    var observed = [];
    if (signals.say == 1) array_push(observed, "say");
    if (signals.show == 1) array_push(observed, "show");
    if (signals.hide == 1) array_push(observed, "hide");
    if (signals.specificity == 1) array_push(observed, "specificity");
    if (signals.pressure == 1) array_push(observed, "pressure");
    if (signals.follow_through == 1) array_push(observed, "follow_through");
    if (signals.field_change == 1) array_push(observed, "field_change");

    var observed_str = "no core";
    if (array_length(observed) > 0) observed_str = cg__join_comma(observed);

    var feedback = "This moment lands in the " + strength + " tier after checking " + observed_str + " signals.";
    if (signals.pressure == 0 || signals.follow_through == 0) {
        feedback += " Keep tracing cost and response so consequence reads clearly.";
    } else if (signals.field_change == 0) {
        feedback += " You can still hint at how the room shifts after the move.";
    }
    if (array_length(maneuvers) >= 2) {
        feedback += " Try " + maneuvers[0] + " or " + maneuvers[1] + ".";
    }

    feedback = cg__rewrite_for_dialect(feedback, _dialect_level);

    var rationale = [];
    if (signals.say == 1) array_push(rationale, cg__rewrite_for_dialect("Intent surfaces through direct declaration.", _dialect_level));
    if (signals.show == 1) array_push(rationale, cg__rewrite_for_dialect("Physical beats and sensory detail are present.", _dialect_level));
    if (signals.hide == 1) array_push(rationale, cg__rewrite_for_dialect("Evasion language appears in the moment.", _dialect_level));
    if (signals.specificity == 1) array_push(rationale, cg__rewrite_for_dialect("Concrete anchors increase specificity.", _dialect_level));
    if (signals.pressure == 1) array_push(rationale, cg__rewrite_for_dialect("Cost language is visible.", _dialect_level));
    if (signals.follow_through == 1) array_push(rationale, cg__rewrite_for_dialect("Cause and response are linked.", _dialect_level));
    if (signals.field_change == 1) array_push(rationale, cg__rewrite_for_dialect("The field shifts after the action.", _dialect_level));

    var maneuvers_out = [];
    for (var k = 0; k < array_length(maneuvers); k++) {
        array_push(maneuvers_out, cg__rewrite_for_dialect(maneuvers[k], _dialect_level));
    }

    var unlocked_ids = cg__extract_unlocked_ids(_unlocked_json_path);
    var next_unlocks = cg__collect_next_unlocks(_concept, _behavior, signals, _dialect_level, unlocked_ids);

    return {
        strength: strength,
        score: score,
        signals: signals,
        rationale: rationale,
        feedback: feedback,
        maneuvers: maneuvers_out,
        next_unlocks: next_unlocks
    };
}
