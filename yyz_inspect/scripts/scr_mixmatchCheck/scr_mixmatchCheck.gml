/// @function scr_mixmatchCheck(_pairs_selected)
/// @description Validates player selections in the mix-and-match game mode by
/// comparing them against dataset/mixmatch_pairs.json. The function returns a
/// struct with correctness flags that UI objects can reference for visual
/// feedback.
///
/// Arguments:
/// _pairs_selected {array} - Array of structs {left : string, right : string}.
///
/// Returns:
/// struct {
///     correct : real (0-1),
///     total   : real,
///     matched : array of structs with result booleans
/// }
function scr_mixmatchCheck(_pairs_selected)
{
    var _json_path = working_directory + "dataset/mixmatch_pairs.json";

    if (!file_exists(_json_path))
    {
        show_debug_message("[scr_mixmatchCheck] Missing mixmatch_pairs.json at " + _json_path);
        return {
            correct : 0,
            total   : 0,
            matched : []
        };
    }

    var _buffer = buffer_load(_json_path);
    var _json_string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);

    var _data = json_decode(_json_string);
    if (!is_array(_data))
    {
        show_debug_message("[scr_mixmatchCheck] Expected an array of valid pairs.");
        return {
            correct : 0,
            total   : 0,
            matched : []
        };
    }

    var _results = [];
    var _correct_count = 0;

    for (var i = 0; i < array_length(_pairs_selected); ++i)
    {
        var _candidate = _pairs_selected[i];
        var _is_correct = false;

        for (var j = 0; j < array_length(_data); ++j)
        {
            var _answer = _data[j];
            if (_candidate.left == _answer.left && _candidate.right == _answer.right)
            {
                _is_correct = true;
                break;
            }
        }

        if (_is_correct)
        {
            _correct_count += 1;
        }

        array_push(_results, {
            left     : _candidate.left,
            right    : _candidate.right,
            isMatch  : _is_correct
        });
    }

    return {
        correct : (_correct_count == 0) ? 0 : _correct_count / max(1, array_length(_pairs_selected)),
        total   : array_length(_pairs_selected),
        matched : _results
    };
}
