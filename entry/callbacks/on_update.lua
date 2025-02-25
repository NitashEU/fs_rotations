---@alias on_update fun()

-- Safe execution wrapper for module functions
-- @param module table The module containing the function
-- @param func_name string Name of the function to call
-- @param module_name string Name of the module for error tracking
local function safe_execute(module, func_name, module_name)
    if not module[func_name] then return end
    
    -- Check if this component is allowed to run based on error history
    if not FS.error_handler:can_run(module_name .. "." .. func_name) then
        return
    end
    
    local success, error_msg = pcall(module[func_name])
    if not success then
        -- Record the error and get guidance on whether to continue using this component
        FS.error_handler:record(module_name .. "." .. func_name, error_msg)
    end
end

---@type on_update
function FS.entry_helper.on_update()
    if not FS.settings.is_enabled() then
        return
    end
    
    -- Update error handler configuration from menu settings
    if FS.menu and FS.menu.error_handler then
        FS.error_handler.max_errors = FS.menu.error_handler.max_errors_slider:get()
        FS.error_handler.cooldown_period = FS.menu.error_handler.cooldown_slider:get()
    end
    
    -- Execute fast updates with error protection
    for i, module in pairs(FS.loaded_modules) do
        safe_execute(module, "on_fast_update", "module_" .. i)
    end
    
    if not FS.humanizer.can_run() then
        return
    end
    
    -- Update player reference
    local success, error_msg = pcall(function()
        FS.variables.me = core.object_manager.get_local_player()
    end)
    if not success then
        core.log_error("Failed to get player: " .. error_msg)
        return -- Critical failure, exit early
    end
    
    -- Update humanizer
    safe_execute(FS.humanizer, "update", "humanizer")
    
    -- Execute normal updates with error protection
    for i, module in pairs(FS.loaded_modules) do
        safe_execute(module, "on_update", "module_" .. i)
    end
    
    -- Execute spec update with error protection
    if FS.spec_config then
        safe_execute(FS.spec_config, "on_update", "spec_" .. (FS.spec_config.name or "unknown"))
    end
end
