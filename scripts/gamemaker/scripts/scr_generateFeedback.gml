function scr_generateFeedback(_text, _concept_id, _evaluation)
{
    if (is_struct(_evaluation) && variable_struct_exists(_evaluation, "success") && _evaluation.success)
    {
        return "Good. You are showing the concept. Push it further.";
    }

    var _concept_key = string(_concept_id);
    var _text_l = string_lower(string(_text));

    if (is_undefined(global.misconceptions) || !ds_exists(global.misconceptions, ds_type_map))
    {
        scr_buildLabelIndexes();
    }

    if (!is_undefined(global.misconceptions) && ds_exists(global.misconceptions, ds_type_map) && ds_map_exists(global.misconceptions, _concept_key))
    {
        var _rows = ds_map_find_value(global.misconceptions, _concept_key);
        if (is_array(_rows))
        {
            for (var i = 0; i < array_length(_rows); ++i)
            {
                var _row = _rows[i];
                if (!is_struct(_row)) continue;
                if (!variable_struct_exists(_row, "tells")) continue;

                var _matched = false;
                var _tells = _row.tells;

                if (is_array(_tells))
                {
                    for (var j = 0; j < array_length(_tells); ++j)
                    {
                        var _tell = string_lower(string(_tells[j]));
                        if (_tell != "" && string_pos(_tell, _text_l) > 0)
                        {
                            _matched = true;
                            break;
                        }
                    }
                }
                else
                {
                    var _tell_string = string_lower(string(_tells));
                    var _parts = string_split(_tell_string, ",");
                    for (var k = 0; k < array_length(_parts); ++k)
                    {
                        var _tell_part = string_trim(_parts[k]);
                        if (_tell_part != "" && string_pos(_tell_part, _text_l) > 0)
                        {
                            _matched = true;
                            break;
                        }
                    }
                }

                if (_matched && variable_struct_exists(_row, "corrective_feedback"))
                {
                    return string(_row.corrective_feedback);
                }
            }
        }
    }

    return "You're missing key signals. Make the concept more visible.";
}
