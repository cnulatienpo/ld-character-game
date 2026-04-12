/// @function scr_kitchen_score()
/// @description Evaluates the current kitchen mix against the target profile.
function scr_kitchen_score() {
    if (!is_struct(global.kit_round) || !is_struct(global.kit_mix)) {
        return { score: 0, note: "Set the sliders first." };
    }

    var mix = global.kit_mix;
    var target = global.kit_round.target;

    var diffs = {
        salt: mix.salt - target.salt,
        acid: mix.acid - target.acid,
        sugar: mix.sugar - target.sugar,
        fat: mix.fat - target.fat
    };

    var total = abs(diffs.salt) + abs(diffs.acid) + abs(diffs.sugar) + abs(diffs.fat);
    var score = clamp(1 - total / 1.2, 0, 1);

    var join_words = function(arr) {
        if (!is_array(arr) || array_length(arr) == 0) {
            return "";
        }
        if (array_length(arr) == 1) {
            return arr[0];
        }
        var text = "";
        for (var i = 0; i < array_length(arr); i++) {
            if (i == 0) {
                text = arr[i];
            } else if (i == array_length(arr) - 1) {
                text = text + " and " + arr[i];
            } else {
                text = text + ", " + arr[i];
            }
        }
        return text;
    };

    var pushes = [];
    var gaps = [];

    if (diffs.salt > 0.05) array_push(pushes, "contrast");
    else if (diffs.salt < -0.05) array_push(gaps, "contrast");

    if (diffs.acid > 0.05) array_push(pushes, "tension");
    else if (diffs.acid < -0.05) array_push(gaps, "tension");

    if (diffs.sugar > 0.05) array_push(pushes, "harmony");
    else if (diffs.sugar < -0.05) array_push(gaps, "harmony");

    if (diffs.fat > 0.05) array_push(pushes, "richness");
    else if (diffs.fat < -0.05) array_push(gaps, "richness");

    var segments = [];

    if (array_length(pushes) > 0) {
        array_push(segments, "You added " + join_words(pushes) + ".");
    }

    if (array_length(gaps) > 0) {
        array_push(segments, "Ease back on " + join_words(gaps) + ".");
    }

    if (array_length(segments) == 0) {
        array_push(segments, "The mix stays close to the target.");
    }

    if (score > 0.75) {
        array_push(segments, "The mix is awake but not harsh.");
    } else if (score > 0.4) {
        array_push(segments, "It has promise; nudge the sliders and taste again.");
    } else {
        array_push(segments, "Right now it feels off; rebalance and retaste.");
    }

    var note = "";
    for (var s = 0; s < array_length(segments); s++) {
        if (s == 0) {
            note = segments[s];
        } else {
            note += " " + segments[s];
        }
    }

    global.kit_last_score = score;
    global.kit_feedback = note;

    return { score: score, note: note };
}
