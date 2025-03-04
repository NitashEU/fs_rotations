FS.modules.heal_engine.settings = {
    logging = {
        health = {
            ---@type fun(): number
            get_threshold = function() return FS.modules.heal_engine.menu.logging.health.threshold:get() end,
            ---@type fun(): boolean
            should_show_cleanup = function() return FS.modules.heal_engine.menu.logging.health.show_cleanup:get_state() end,
        },

        dps = {
            ---@type fun(): number
            get_threshold = function() return FS.modules.heal_engine.menu.logging.dps.threshold:get() end,
            ---@type fun(): boolean
            should_show_fight = function() return FS.modules.heal_engine.menu.logging.dps.show_fight:get_state() end,
            ---@type fun(): boolean
            should_show_windows = function() return FS.modules.heal_engine.menu.logging.dps.show_windows:get_state() end,
        }
    },

    tracking = {
        windows = {
            ---@type fun(): boolean
            is_1s_enabled = function() return FS.modules.heal_engine.menu.tracking.windows.enable_1s:get_state() end,
            ---@type fun(): boolean
            is_5s_enabled = function() return FS.modules.heal_engine.menu.tracking.windows.enable_5s:get_state() end,
            ---@type fun(): boolean
            is_10s_enabled = function() return FS.modules.heal_engine.menu.tracking.windows.enable_10s:get_state() end,
            ---@type fun(): boolean
            is_15s_enabled = function() return FS.modules.heal_engine.menu.tracking.windows.enable_15s:get_state() end,
        }
    }
}
