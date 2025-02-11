FS.paladin_holy.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.settings.is_toggle_enabled(FS.paladin_holy.menu.enable_toggle) end,
    ---@type fun(): number
    hs_hp_threshold = function() return FS.paladin_holy.menu.hs_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ac_hp_threshold = function() return FS.paladin_holy.menu.ac_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ac_min_targets = function() return FS.paladin_holy.menu.ac_min_targets_slider:get() end,

    -- Beacon of Virtue settings
    ---@type fun(): number
    bov_hp_threshold = function() return FS.paladin_holy.menu.bov_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    bov_min_targets = function() return FS.paladin_holy.menu.bov_min_targets_slider:get() end,
    ---@type fun(): boolean
    bov_use_distance = function() return FS.paladin_holy.menu.bov_weights.use_distance:get_state() end,

    -- Beacon of Virtue weights
    ---@type fun(): number
    bov_health_weight = function() return FS.paladin_holy.menu.bov_weights.health:get() end,
    ---@type fun(): number
    bov_damage_weight = function() return FS.paladin_holy.menu.bov_weights.damage:get() end,
    ---@type fun(): number
    bov_cluster_weight = function() return FS.paladin_holy.menu.bov_weights.cluster:get() end,
    ---@type fun(): number
    bov_distance_weight = function() return FS.paladin_holy.menu.bov_weights.distance:get() end,

    -- Holy Prism settings
    ---@type fun(): number
    hp_hp_threshold = function() return FS.paladin_holy.menu.hp_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hp_min_targets = function() return FS.paladin_holy.menu.hp_min_targets_slider:get() end,
}
