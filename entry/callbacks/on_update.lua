---@alias on_update fun()

---Safe execution wrapper for module functions
---@param module table The module containing the function
---@param func_name string Name of the function to call
---@param module_name string Name of the module for error tracking
local function safe_execute(module, func_name, module_name)
    if not module[func_name] then return end
    
    -- Create component name
    local component = module_name .. "." .. func_name
    
    -- Use the enhanced safe_execute method in error_handler
    FS.error_handler:safe_execute(module[func_name], component)
end

---@type on_update
function FS.entry_helper.on_update()
    if not FS.settings.is_enabled() then
        return
    end
    
    -- Update error handler configuration from menu settings
    if FS.menu and FS.menu.error_handler then
        -- Update error handler settings safely
        pcall(function()
            FS.error_handler.max_errors = FS.menu.error_handler.max_errors_slider:get()
            FS.error_handler.base_cooldown = FS.menu.error_handler.base_cooldown_slider:get()
            FS.error_handler.max_cooldown = FS.menu.error_handler.max_cooldown_slider:get()
            FS.error_handler.capture_state = FS.menu.error_handler.capture_state_checkbox:get()
        end)
    end
    
    -- Execute fast updates with error protection
    for i, module in pairs(FS.loaded_modules) do
        safe_execute(module, "on_fast_update", "module_" .. i)
    end
    
    if not FS.humanizer.can_run() then
        return
    end
    
    -- Update player reference with enhanced error handling
    local success, player = FS.error_handler:safe_execute(function()
        return core.object_manager.get_local_player()
    end, "core.get_local_player")
    
    if not success or not player then
        return -- Critical failure, exit early
    end
    
    FS.variables.me = player
    
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
