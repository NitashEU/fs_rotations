FS.paladin_holy.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.settings.is_toggle_enabled(FS.paladin_holy.menu.enable_toggle) end,
    ---@type fun(): number
    hs_hp_threshold = function() return FS.paladin_holy.menu.hs_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hs_last_charge_hp_threshold = function() return FS.paladin_holy.menu.hs_last_charge_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hs_rising_sun_hp_threshold = function() return FS.paladin_holy.menu.hs_rising_sun_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hs_critical_priority = function() return FS.paladin_holy.menu.hs_critical_priority_slider:get() / 100 end,
    ---@type fun(): boolean
    hs_predictive_healing = function() return FS.paladin_holy.menu.hs_predictive_healing_check:get_state() end,
    ---@type fun(): number
    ac_hp_threshold = function() return FS.paladin_holy.menu.ac_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ac_min_targets = function() return FS.paladin_holy.menu.ac_min_targets_slider:get() end,

    -- Word of Glory settings
    ---@type fun(): number
    wog_hp_threshold = function() return FS.paladin_holy.menu.wog_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    wog_tank_hp_threshold = function() return FS.paladin_holy.menu.wog_tank_hp_threshold_slider:get() / 100 end,

    -- Divine Toll settings
    ---@type fun(): number
    dt_hp_threshold = function() return FS.paladin_holy.menu.dt_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    dt_min_targets = function() return FS.paladin_holy.menu.dt_min_targets_slider:get() end,

    -- Divine Toll weights
    ---@type fun(): number
    dt_health_weight = function() return FS.paladin_holy.menu.dt_weights.health:get() end,
    ---@type fun(): number
    dt_damage_weight = function() return FS.paladin_holy.menu.dt_weights.damage:get() end,
    ---@type fun(): number
    dt_cluster_weight = function() return FS.paladin_holy.menu.dt_weights.cluster:get() end,

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

    -- Light of Dawn settings
    ---@type fun(): number
    lod_hp_threshold = function() return FS.paladin_holy.menu.lod_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    lod_min_targets = function() return FS.paladin_holy.menu.lod_min_targets_slider:get() end,

    -- Flash of Light settings
    ---@type fun(): number
    fol_hp_threshold = function() return FS.paladin_holy.menu.fol_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    fol_infusion_hp_threshold = function() return FS.paladin_holy.menu.fol_infusion_hp_threshold_slider:get() / 100 end,

    -- Holy Light settings
    ---@type fun(): number
    hl_hp_threshold = function() return FS.paladin_holy.menu.hl_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hl_infusion_hp_threshold = function() return FS.paladin_holy.menu.hl_infusion_hp_threshold_slider:get() / 100 end
}
