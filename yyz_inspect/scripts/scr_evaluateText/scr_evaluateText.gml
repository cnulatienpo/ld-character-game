function scr_evaluateText(_text, _concept_id)
{
    if (is_undefined(global.signals) || !ds_exists(global.signals, ds_type_map))
    {
        scr_buildLabelIndexes();
    }

    var _concept_key = string(_concept_id);
    var _found = scr_detectSignals(_text, _concept_key);
    var _missing = [];
    var _total = 0;

    if (!is_undefined(global.signals) && ds_exists(global.signals, ds_type_map) && ds_map_exists(global.signals, _concept_key))
    {
        var _signals = ds_map_find_value(global.signals, _concept_key);
        if (is_array(_signals))
        {
            _total = array_length(_signals);

            for (var i = 0; i < _total; ++i)
            {
                var _row = _signals[i];
                if (!is_struct(_row) || !variable_struct_exists(_row, "signal_id")) continue;

                var _signal_id = _row.signal_id;
                var _seen = false;
                for (var j = 0; j < array_length(_found); ++j)
                {
                    if (_found[j] == _signal_id)
                    {
                        _seen = true;
                        break;
                    }
                }

                if (!_seen) array_push(_missing, _signal_id);
            }
        }
    }

    var _success = (_total > 0) && (array_length(_found) / _total >= 0.5);

    return {
        success : _success,
        found   : _found,
        missing : _missing
    };
}
