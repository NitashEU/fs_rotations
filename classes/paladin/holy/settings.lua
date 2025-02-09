FS.paladin_holy.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.settings.is_toggle_enabled(FS.paladin_holy.menu.enable_toggle) end,
}
