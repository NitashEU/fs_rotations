FS.paladin_holy.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.settings.is_toggle_enabled(FS.paladin_holy.menu.enable_toggle) end,
    ---@type fun(): number
    hs_hp_threshold = function() return FS.paladin_holy.menu.hs_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ac_hp_threshold = function() return FS.paladin_holy.menu.ac_hp_threshold_slider:get() / 100 end,
    ---@type fun(): number
    ac_min_targets = function() return FS.paladin_holy.menu.ac_min_targets_slider:get() end,
}
