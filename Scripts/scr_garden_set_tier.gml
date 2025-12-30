/// @function scr_garden_set_tier(word_index, tier_string)
/// @description Updates the stored tier for a garden word when dropped into a bed.
function scr_garden_set_tier(word_index, tier_string) {
    if (!ds_exists(global.garden_words, ds_type_list)) {
        return;
    }

    if (word_index < 0 || word_index >= ds_list_size(global.garden_words)) {
        return;
    }

    var word_struct = ds_list_find_value(global.garden_words, word_index);
    if (!is_struct(word_struct)) {
        return;
    }

    word_struct.tier = string(tier_string);
    ds_list_replace(global.garden_words, word_index, word_struct);
}
