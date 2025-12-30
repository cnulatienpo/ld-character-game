/// @function scr_book_echo_check(hits)
/// @description Scores the player's selected echo lines.
function scr_book_echo_check(hits) {
    var targets = global.db_echo_targets;
    if (!is_array(targets)) {
        return { ok: false, note: "Passage not ready.", reveal: [] };
    }

    var total_targets = 0;
    var reveal = [];
    for (var i = 0; i < array_length(targets); i++) {
        if (targets[i]) {
            total_targets += 1;
            array_push(reveal, i);
        }
    }

    var picked_targets = 0;
    var wrong_hits = 0;

    if (ds_exists(hits, ds_type_list)) {
        var size = ds_list_size(hits);
        for (var j = 0; j < size; j++) {
            var index = hits[| j];
            if (is_real(index)) {
                var idx = floor(index);
                if (idx >= 0 && idx < array_length(targets)) {
                    if (targets[idx]) {
                        picked_targets += 1;
                    } else {
                        wrong_hits += 1;
                    }
                }
            }
        }
    } else if (is_array(hits)) {
        for (var k = 0; k < array_length(hits); k++) {
            var idx2 = floor(hits[k]);
            if (idx2 >= 0 && idx2 < array_length(targets)) {
                if (targets[idx2]) {
                    picked_targets += 1;
                } else {
                    wrong_hits += 1;
                }
            }
        }
    }

    global.db_echo_reveal = reveal;

    var ok = (total_targets > 0 && picked_targets == total_targets && wrong_hits == 0);
    var note = "Repetition builds rhythm.";

    return {
        ok: ok,
        note: note,
        picked: picked_targets,
        total: total_targets,
        wrong: wrong_hits,
        reveal: reveal
    };
}
