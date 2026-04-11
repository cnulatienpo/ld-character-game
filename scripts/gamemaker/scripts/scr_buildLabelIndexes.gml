function scr_buildLabelIndexes()
{
    if (!is_undefined(global.signals) && ds_exists(global.signals, ds_type_map)) ds_map_destroy(global.signals);
    if (!is_undefined(global.misconceptions) && ds_exists(global.misconceptions, ds_type_map)) ds_map_destroy(global.misconceptions);

    global.signals = ds_map_create();
    global.misconceptions = ds_map_create();

    if (is_undefined(global.labels) || !is_array(global.labels)) return;

    var _labels = global.labels;
    var _count = array_length(_labels);

    for (var i = 0; i < _count; ++i)
    {
        var _row = _labels[i];
        if (!is_struct(_row)) continue;
        if (!variable_struct_exists(_row, "concept_id")) continue;

        var _concept_id = string(_row.concept_id);

        if (variable_struct_exists(_row, "signal_id"))
        {
            var _signal_rows = ds_map_exists(global.signals, _concept_id)
                ? ds_map_find_value(global.signals, _concept_id)
                : [];

            array_push(_signal_rows, _row);
            ds_map_replace(global.signals, _concept_id, _signal_rows);
        }

        if (variable_struct_exists(_row, "misconception_id"))
        {
            var _mis_rows = ds_map_exists(global.misconceptions, _concept_id)
                ? ds_map_find_value(global.misconceptions, _concept_id)
                : [];

            array_push(_mis_rows, _row);
            ds_map_replace(global.misconceptions, _concept_id, _mis_rows);
        }
    }
}
