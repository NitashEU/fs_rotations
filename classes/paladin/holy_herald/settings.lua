FS.paladin_holy_herald.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.settings.is_toggle_enabled(FS.paladin_holy_herald.menu.enable_toggle) end,
    ---@type fun(): number
    hs_hp_threshold = function() return FS.paladin_holy_herald.menu.hs_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hs_last_charge_hp_threshold = function() return FS.paladin_holy_herald.menu.hs_last_charge_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hs_rising_sun_hp_threshold = function() return FS.paladin_holy_herald.menu.hs_rising_sun_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hs_critical_priority = function() return FS.paladin_holy_herald.menu.hs_critical_priority_slider:get() / 100 end,
    ---@type fun(): boolean
    hs_predictive_healing = function() return FS.paladin_holy_herald.menu.hs_predictive_healing_check:get_state() end,
    ---@type fun(): number
    ac_hp_threshold = function() return FS.paladin_holy_herald.menu.ac_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ac_min_targets = function() return FS.paladin_holy_herald.menu.ac_min_targets_slider:get() end,

    -- Word of Glory settings
    ---@type fun(): number
    wog_hp_threshold = function() return FS.paladin_holy_herald.menu.wog_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    wog_tank_hp_threshold = function() return FS.paladin_holy_herald.menu.wog_tank_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    wog_critical_hp_threshold = function() return FS.paladin_holy_herald.menu.wog_critical_hp_threshold_slider:get() / 100 end,

    -- Divine Toll settings
    ---@type fun(): number
    dt_hp_threshold = function() return FS.paladin_holy_herald.menu.dt_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    dt_min_targets = function() return FS.paladin_holy_herald.menu.dt_min_targets_slider:get() end,

    -- Divine Toll weights
    ---@type fun(): number
    dt_health_weight = function() return FS.paladin_holy_herald.menu.dt_weights.health:get() end,
    ---@type fun(): number
    dt_damage_weight = function() return FS.paladin_holy_herald.menu.dt_weights.damage:get() end,
    ---@type fun(): number
    dt_cluster_weight = function() return FS.paladin_holy_herald.menu.dt_weights.cluster:get() end,

    -- Beacon of Virtue settings
    ---@type fun(): number
    bov_hp_threshold = function() return FS.paladin_holy_herald.menu.bov_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    bov_min_targets = function() return FS.paladin_holy_herald.menu.bov_min_targets_slider:get() end,
    ---@type fun(): boolean
    bov_use_distance = function() return FS.paladin_holy_herald.menu.bov_weights.use_distance:get_state() end,

    -- Beacon of Virtue weights
    ---@type fun(): number
    bov_health_weight = function() return FS.paladin_holy_herald.menu.bov_weights.health:get() end,
    ---@type fun(): number
    bov_damage_weight = function() return FS.paladin_holy_herald.menu.bov_weights.damage:get() end,
    ---@type fun(): number
    bov_cluster_weight = function() return FS.paladin_holy_herald.menu.bov_weights.cluster:get() end,
    ---@type fun(): number
    bov_distance_weight = function() return FS.paladin_holy_herald.menu.bov_weights.distance:get() end,

    -- Holy Prism settings
    ---@type fun(): number
    hp_hp_threshold = function() return FS.paladin_holy_herald.menu.hp_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hp_min_targets = function() return FS.paladin_holy_herald.menu.hp_min_targets_slider:get() end,
    ---@type fun(): boolean
    hp_prioritize_dawnlight = function() return FS.paladin_holy_herald.menu.hp_prioritize_dawnlight_check:get_state() end,

    -- Light of Dawn settings
    ---@type fun(): number
    lod_hp_threshold = function() return FS.paladin_holy_herald.menu.lod_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    lod_min_targets = function() return FS.paladin_holy_herald.menu.lod_min_targets_slider:get() end,

    -- Flash of Light settings
    ---@type fun(): number
    fol_hp_threshold = function() return FS.paladin_holy_herald.menu.fol_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    fol_infusion_hp_threshold = function() return FS.paladin_holy_herald.menu.fol_infusion_hp_threshold_slider:get() / 100 end,

    -- Holy Light settings
    ---@type fun(): number
    hl_hp_threshold = function() return FS.paladin_holy_herald.menu.hl_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    hl_infusion_hp_threshold = function() return FS.paladin_holy_herald.menu.hl_infusion_hp_threshold_slider:get() / 100 end,
    
    -- Herald of the Sun specific settings
    ---@type fun(): boolean
    use_eternal_flame = function() return FS.paladin_holy_herald.menu.use_eternal_flame_check:get_state() end,
    ---@type fun(): boolean
    optimize_beams = function() return FS.paladin_holy_herald.menu.optimize_beams_check:get_state() end,
    ---@type fun(): boolean
    save_holy_prism = function() return FS.paladin_holy_herald.menu.save_holy_prism_check:get_state() end,
    ---@type fun(): boolean
    prioritize_self_dawnlight = function() return FS.paladin_holy_herald.menu.prioritize_self_dawnlight_check:get_state() end,
    
    -- UI Display Settings
    ---@type fun(): boolean
    show_awakening_tracker = function() return FS.paladin_holy_herald.menu.show_awakening_tracker_check:get_state() end,
    ---@type fun(): boolean
    show_buff_trackers = function() return FS.paladin_holy_herald.menu.show_buff_trackers_check:get_state() end,
    ---@type fun(): boolean
    show_cooldown_trackers = function() return FS.paladin_holy_herald.menu.show_cooldown_trackers_check:get_state() end,
    ---@type fun(): boolean
    show_suns_avatar_beams = function() return FS.paladin_holy_herald.menu.show_suns_avatar_beams_check:get_state() end,
    ---@type fun(): boolean
    show_dawnlight_indicators = function() return FS.paladin_holy_herald.menu.show_dawnlight_indicators_check:get_state() end,
    ---@type fun(): boolean
    show_empyrean_legacy_indicator = function() return FS.paladin_holy_herald.menu.show_empyrean_legacy_indicator_check:get_state() end,
    
    -- Cooldown Management settings
    ---@type fun(): boolean
    aw_auto_use = function() return FS.paladin_holy_herald.menu.aw_auto_use_check:get_state() end,
    ---@type fun(): number
    aw_min_targets = function() return FS.paladin_holy_herald.menu.aw_min_targets_slider:get() end,
    ---@type fun(): number
    aw_hp_threshold = function() return FS.paladin_holy_herald.menu.aw_hp_threshold_slider:get() / 100 end,
    
    -- Divine Toll settings
    ---@type fun(): boolean
    dt_auto_use = function() return FS.paladin_holy_herald.menu.dt_auto_use_check:get_state() end,
    ---@type fun(): boolean
    dt_save_for_emergency = function() return FS.paladin_holy_herald.menu.dt_save_for_emergency_check:get_state() end,
    
    -- Holy Prism settings
    ---@type fun(): boolean
    hp_auto_use = function() return FS.paladin_holy_herald.menu.hp_auto_use_check:get_state() end,
    ---@type fun(): boolean
    hp_save_for_awakening = function() return FS.paladin_holy_herald.menu.hp_save_for_awakening_check:get_state() end
}
