---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")

FS.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.menu.enable_script_check:get_state() end,
    ---@type fun(): integer
    min_delay = function() return FS.menu.min_delay:get() end,
    ---@type fun(): integer
    max_delay = function() return FS.menu.max_delay:get() end,

    -- Add jitter settings
    jitter = {
        ---@type fun(): boolean
        is_enabled = function() return FS.menu.humanizer_jitter.enable_jitter:get_state() end,
        ---@type fun(): number
        base_jitter = function() return FS.menu.humanizer_jitter.base_jitter:get() end,
        ---@type fun(): number
        latency_jitter = function() return FS.menu.humanizer_jitter.latency_jitter:get() end,
        ---@type fun(): number
        max_jitter = function() return FS.menu.humanizer_jitter.max_jitter:get() end,
    },

    -- Version tracking for settings migration
    version = {
        ---@type string Current settings version in storage
        current = core.settings.get("fs_rotations_version", "0.0.0"),
        
        ---@param new_version string Update the stored settings version
        update = function(new_version)
            core.settings.set("fs_rotations_version", new_version)
        end,
        
        ---@return boolean True if settings version is older than code version
        needs_migration = function()
            return FS.version:isNewerThan(FS.settings.version.current)
        end
    }
}

---@param keybind keybind
---@return boolean
function FS.settings.is_toggle_enabled(keybind)
    return plugin_helper:is_toggle_enabled(keybind)
end
