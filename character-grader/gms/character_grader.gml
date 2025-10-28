/// @function character_grade(text, concept, behavior, target_strength, dialect_level, unlocked_json)
/// @description Proxy that calls the compiled Node grader from GameMaker Studio.
///
/// DEV SHELL MODE ------------------------------------------------------------
/// 1. Ensure Node.js is installed and `character-grader/dist/index.js` exists.
/// 2. Call this script; it writes `grader_in.json` next to the project, then
///    uses `shell_execute` to run: `node dist/index.js --seeder data/...`
///    Note: replace `node` path if your environment requires it.
/// 3. After the CLI finishes, it reads `grader_out.json` for the results.
///
/// FILE DROP MODE -----------------------------------------------------------
/// If `shell_execute` is unavailable (HTML5, consoles), this script only
/// writes `grader_in.json`. Run the Node CLI separately (e.g. as part of
/// your build pipeline) to process the file and drop `grader_out.json`.
/// Load the response the next frame.
///
/// Both modes return a struct with `strength`, `score`, and `feedback`.
/// Customize the working directory as needed.

function character_grade(_text, _concept, _behavior, _target_strength, _dialect_level, _unlocked_json_path) {
    var working_dir = "character-grader";
    var input_path = working_dir + "/grader_in.json";
    var output_path = working_dir + "/grader_out.json";

    var payload = {
        text: _text,
        concept: _concept,
        behavior: _behavior,
        target_strength: _target_strength,
        player: {
            dialect_level: _dialect_level,
            unlocked_signals: []
        }
    };

    if (file_exists(_unlocked_json_path)) {
        var unlocked_string = string_load(_unlocked_json_path);
        var unlocked_json = json_parse(unlocked_string);
        if (is_struct(unlocked_json)) {
            payload.player = unlocked_json;
            payload.player.dialect_level = _dialect_level;
        }
    }

    var json_string = json_stringify(payload);
    string_save(input_path, json_string);

    // DEV SHELL MODE: uncomment to execute the Node CLI directly.
    // var command = "node dist/index.js --seeder data/seeder.sample.json";
    // command += " --concept \"" + string(_concept) + "\"";
    // command += " --behavior \"" + string(_behavior) + "\"";
    // command += " --dialect " + string(_dialect_level);
    // command += " --text \"" + string(_text) + "\"";
    // command += " --target \"" + string(_target_strength) + "\"";
    // command += " --unlocked " + _unlocked_json_path;
    // shell_execute("cmd.exe", "/c " + command, working_dir); // adapt for macOS/Linux

    if (file_exists(output_path)) {
        var result_raw = string_load(output_path);
        var result = json_parse(result_raw);
        if (is_struct(result)) {
            return {
                strength: result.strength,
                score: result.score,
                feedback: result.feedback
            };
        }
    }

    // fallback: return minimal struct until CLI output arrives
    return {
        strength: "low",
        score: 0,
        feedback: "Awaiting grader output"
    };
}
