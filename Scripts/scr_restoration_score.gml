/// @function scr_restoration_score()
/// @description Scores the restored passage against target tags.
function scr_restoration_score() {
    var round = global.rg_round;
    if (!is_struct(round)) {
        return { score: 0, note: "Round not ready.", missing: [], extra: [] };
    }

    var target_tags = round.target_tags;
    if (!is_array(target_tags)) {
        target_tags = [];
    }

    var applied = global.rg_applied_tags;
    if (!is_array(applied)) {
        applied = [];
    }

    var unique_applied = [];
    for (var i = 0; i < array_length(applied); i++) {
        var tag = string(applied[i]);
        var exists = false;
        for (var j = 0; j < array_length(unique_applied); j++) {
            if (unique_applied[j] == tag) {
                exists = true;
                break;
            }
        }
        if (!exists) {
            array_push(unique_applied, tag);
        }
    }

    var missing = [];
    for (var k = 0; k < array_length(target_tags); k++) {
        var target = string(target_tags[k]);
        var found = false;
        for (var m = 0; m < array_length(unique_applied); m++) {
            if (unique_applied[m] == target) {
                found = true;
                break;
            }
        }
        if (!found) {
            array_push(missing, target);
        }
    }

    var extra = [];
    for (var n = 0; n < array_length(unique_applied); n++) {
        var applied_tag = unique_applied[n];
        var match = false;
        for (var p = 0; p < array_length(target_tags); p++) {
            if (string(target_tags[p]) == applied_tag) {
                match = true;
                break;
            }
        }
        if (!match) {
            array_push(extra, applied_tag);
        }
    }

    var hits = array_length(target_tags) - array_length(missing);
    var score = 0;
    if (array_length(target_tags) > 0) {
        score = clamp(hits / array_length(target_tags), 0, 1);
    }

    var note = string(round.design_note);

    if (array_length(extra) > 0) {
        var extra_text = "";
        for (var a = 0; a < array_length(extra); a++) {
            if (extra_text != "") {
                extra_text += ", ";
            }
            extra_text += string(extra[a]);
        }
        note += " Extra tags: " + extra_text + ".";
    }

    if (array_length(missing) > 0) {
        var miss_text = "";
        for (var b = 0; b < array_length(missing); b++) {
            if (miss_text != "") {
                miss_text += ", ";
            }
            miss_text += string(missing[b]);
        }
        note += " Missing tags: " + miss_text + ".";
    }

    for (var q = 0; q < array_length(extra); q++) {
        if (extra[q] == "telling_only") {
            note += " Try a concrete move instead of a label.";
            break;
        }
    }

    global.rg_feedback_note = note;

    return { score: score, note: note, missing: missing, extra: extra };
}
