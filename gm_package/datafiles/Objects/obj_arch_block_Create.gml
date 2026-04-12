/// obj_arch_block : Create Event
// Initializes block parameters.
block_label = string(block_label);
block_width = max(80, block_width);
block_weight = max(0.5, block_weight);
block_pull = max(0.2, block_pull);
home_x = x;
home_y = y;
drag = false;
dx = 0;
dy = 0;
slot_index = -1;
wobble_phase = random_range(0, pi);
