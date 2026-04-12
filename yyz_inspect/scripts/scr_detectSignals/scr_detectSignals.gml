function scr_detectSignals(_text, _concept_id)
{
    var _found = [];
    var _concept_key = string(_concept_id);

    if (is_undefined(global.signals) || !ds_exists(global.signals, ds_type_map)) return _found;
    if (!ds_map_exists(global.signals, _concept_key)) return _found;

    var _signals = ds_map_find_value(global.signals, _concept_key);
    if (!is_array(_signals)) return _found;

    var _text_l = string_lower(string(_text));

    for (var i = 0; i < array_length(_signals); ++i)
    {
        var _row = _signals[i];
        if (!is_struct(_row)) continue;
        if (!variable_struct_exists(_row, "signal_id")) continue;
        if (!variable_struct_exists(_row, "detection_hint")) continue;

        var _hint = string_lower(string(_row.detection_hint));
        var _tokens = string_split(_hint, " ");
        var _matches = 0;

        for (var j = 0; j < array_length(_tokens); ++j)
        {
            var _word = string_trim(_tokens[j]);
            if (_word == "") continue;

            if (string_pos(_word, _text_l) > 0)
            {
                _matches += 1;
            }
        }

        if (_matches >= 2)
        {
            array_push(_found, _row.signal_id);
        }
    }

    return _found;
}
