/// @function scr_character_grader_native_selftest()
/// @description Runs fixed native grader smoke tests and logs a summary.
/// Call manually from debug console or temporary object event.
function scr_character_grader_native_selftest() {
    if (!function_exists("character_grade_native")) {
        show_debug_message("[grader-selftest] character_grade_native not found.");
        return { ok: false, passed: 0, total: 0 };
    }

    var tests = [
        {
            name: "say_low",
            text: "\"I want out,\" I say and decide to leave.",
            concept: "Decision",
            behavior: "say",
            target: "low",
            expect_min_score: 1,
            expect_strength_any: ["low", "medium", "high"]
        },
        {
            name: "show_pressure_medium",
            text: "I grab the keys, pace by the door, and if I don't move now I lose the job.",
            concept: "Conflict",
            behavior: "show",
            target: "medium",
            expect_min_score: 2,
            expect_strength_any: ["low", "medium", "high"]
        },
        {
            name: "hide_signal",
            text: "Maybe it's fine, I shrug it off and change the subject.",
            concept: "Decision",
            behavior: "hide",
            target: "medium",
            expect_min_score: 1,
            expect_strength_any: ["low", "medium", "high"]
        },
        {
            name: "high_chain",
            text: "I decide now, so I slammed the door, then I marched downstairs. Everyone stared and the room went quiet.",
            concept: "Change",
            behavior: "say",
            target: "high",
            expect_min_score: 4,
            expect_strength_any: ["medium", "high"]
        },
        {
            name: "dialect_rewrite",
            text: "I feel pressure and signal in this scene.",
            concept: "Description",
            behavior: "say",
            target: "low",
            expect_min_score: 1,
            expect_strength_any: ["low", "medium", "high"],
            expect_feedback_contains_any: ["cost", "cue", "moment"]
        }
    ];

    var passed = 0;
    var total = array_length(tests);

    for (var i = 0; i < total; i++) {
        var t = tests[i];
        var dialect = (t.name == "dialect_rewrite") ? 1 : 3;
        var out = character_grade_native(t.text, t.concept, t.behavior, t.target, dialect, "");

        var ok = true;

        if (!is_struct(out)) ok = false;
        if (ok && (!variable_struct_exists(out, "score") || real(out.score) < real(t.expect_min_score))) ok = false;

        if (ok) {
            var strength_ok = false;
            var s = string_lower(string(out.strength));
            for (var j = 0; j < array_length(t.expect_strength_any); j++) {
                if (s == string_lower(string(t.expect_strength_any[j]))) {
                    strength_ok = true;
                    break;
                }
            }
            if (!strength_ok) ok = false;
        }

        if (ok && variable_struct_exists(t, "expect_feedback_contains_any")) {
            var fb = string_lower(string(out.feedback));
            var has_term = false;
            for (var k = 0; k < array_length(t.expect_feedback_contains_any); k++) {
                if (string_pos(string_lower(string(t.expect_feedback_contains_any[k])), fb) > 0) {
                    has_term = true;
                    break;
                }
            }
            if (!has_term) ok = false;
        }

        if (ok) {
            passed += 1;
            show_debug_message("[grader-selftest] PASS " + t.name + " | strength=" + string(out.strength) + " score=" + string(out.score));
        } else {
            show_debug_message("[grader-selftest] FAIL " + t.name + " | output=" + json_stringify(out));
        }
    }

    var summary = "[grader-selftest] " + string(passed) + "/" + string(total) + " passed";
    show_debug_message(summary);

    return {
        ok: passed == total,
        passed: passed,
        total: total
    };
}
