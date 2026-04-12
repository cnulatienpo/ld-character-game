/// obj_db_symmetry_controller : Create Event
// Prepares text and layout for the symmetry activity.
global.db_symmetry_text = "The passage waits for a fold down the middle.\n\nEach sentence leans either side, sharing the weight.";
var layout = scr_longtext_layout_create(global.db_symmetry_text, 480, 20);
layout.scroll = 0;
global.db_symmetry_layout = layout;
global.db_symmetry_origin_x = 200;
global.db_symmetry_origin_y = 160;
global.db_symmetry_visible_h = 280;
global.db_symmetry_fold_x = global.db_symmetry_origin_x + layout.width * 0.5;
global.db_symmetry_note = "";
