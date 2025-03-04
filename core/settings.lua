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
}

---@param keybind keybind
---@return boolean
function FS.settings.is_toggle_enabled(keybind)
    return plugin_helper:is_toggle_enabled(keybind)
end
