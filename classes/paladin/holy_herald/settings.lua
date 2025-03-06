FS.paladin_holy_herald.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.settings.is_toggle_enabled(FS.paladin_holy_herald.menu.enable_toggle) end,
    ---@type fun(): number
    hs_hp_threshold = function() return FS.paladin_holy_herald.menu.hs_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hs_last_charge_hp_threshold = function()
        return FS.paladin_holy_herald.menu.hs_last_charge_hp_threshold_slider:get() /
            100
    end,
    ---@type fun(): number
    hs_rising_sun_hp_threshold = function()
        return FS.paladin_holy_herald.menu.hs_rising_sun_hp_threshold_slider:get() /
            100
    end,

    -- Eternal Flame settings
    ---@type fun(): number
    ef_hp_threshold = function() return FS.paladin_holy_herald.menu.ef_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ef_tank_hp_threshold = function() return FS.paladin_holy_herald.menu.ef_tank_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ef_critical_hp_threshold = function() return FS.paladin_holy_herald.menu.ef_critical_hp_threshold_slider:get() / 100 end,

    -- Divine Toll settings
    ---@type fun(): number
    dt_hp_threshold = function() return FS.paladin_holy_herald.menu.dt_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    dt_min_targets = function() return FS.paladin_holy_herald.menu.dt_min_targets_slider:get() end,
    ---@type fun(): boolean
    dt_force_on_aw = function() return FS.paladin_holy_herald.menu.dt_force_on_aw:get_state() end,

    -- Divine Toll weights
    ---@type fun(): number
    dt_health_weight = function() return FS.paladin_holy_herald.menu.dt_weights.health:get() / 100 end,
    ---@type fun(): number
    dt_damage_weight = function() return FS.paladin_holy_herald.menu.dt_weights.damage:get() / 100 end,
    ---@type fun(): number
    dt_cluster_weight = function() return FS.paladin_holy_herald.menu.dt_weights.cluster:get() / 100 end,

    -- Beacon of Virtue settings
    ---@type fun(): number
    bov_hp_threshold = function() return FS.paladin_holy_herald.menu.bov_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    bov_min_targets = function() return FS.paladin_holy_herald.menu.bov_min_targets_slider:get() end,
    ---@type fun(): boolean
    bov_use_distance = function() return FS.paladin_holy_herald.menu.bov_weights.use_distance:get_state() end,

    -- Beacon of Virtue weights
    ---@type fun(): number
    bov_health_weight = function() return FS.paladin_holy_herald.menu.bov_weights.health:get() / 100 end,
    ---@type fun(): number
    bov_damage_weight = function() return FS.paladin_holy_herald.menu.bov_weights.damage:get() / 100 end,
    ---@type fun(): number
    bov_cluster_weight = function() return FS.paladin_holy_herald.menu.bov_weights.cluster:get() / 100 end,
    ---@type fun(): number
    bov_distance_weight = function() return FS.paladin_holy_herald.menu.bov_weights.distance:get() / 100 end,

    -- Holy Prism settings
    ---@type fun(): number
    hp_hp_threshold = function() return FS.paladin_holy_herald.menu.hp_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hp_min_targets = function() return FS.paladin_holy_herald.menu.hp_min_targets_slider:get() end,
    ---@type fun(): boolean
    hp_save_for_aw = function() return FS.paladin_holy_herald.menu.hp_save_for_aw:get_state() end,

    -- Light of Dawn settings
    ---@type fun(): number
    lod_hp_threshold = function() return FS.paladin_holy_herald.menu.lod_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    lod_min_targets = function() return FS.paladin_holy_herald.menu.lod_min_targets_slider:get() end,

    -- Flash of Light settings
    ---@type fun(): number
    fol_hp_threshold = function() return FS.paladin_holy_herald.menu.fol_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    fol_infusion_hp_threshold = function()
        return FS.paladin_holy_herald.menu.fol_infusion_hp_threshold_slider:get() /
            100
    end,

    -- Holy Light settings
    ---@type fun(): number
    hl_hp_threshold = function() return FS.paladin_holy_herald.menu.hl_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hl_infusion_hp_threshold = function() return FS.paladin_holy_herald.menu.hl_infusion_hp_threshold_slider:get() / 100 end,

    aw_hp_threshold = function() return FS.paladin_holy_herald.menu.aw_hp_threshold_slider:get() / 100 end,
    aw_min_targets = function() return FS.paladin_holy_herald.menu.aw_min_targets_slider:get() end,
    aw_auto_use = function() return FS.settings.is_toggle_enabled(FS.paladin_holy_herald.menu.aw_auto_use_check) end,
}
