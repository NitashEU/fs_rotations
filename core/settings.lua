---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")

FS.settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.menu.enable_script_check:get_state() end,
    ---@type fun(): integer
    min_delay = function() return FS.menu.min_delay:get() end,
    ---@type fun(): integer
    max_delay = function() return FS.menu.max_delay:get() end,
}

---@param keybind keybind
---@return boolean
function FS.settings.is_toggle_enabled(keybind)
    return plugin_helper:is_toggle_enabled(keybind)
end
