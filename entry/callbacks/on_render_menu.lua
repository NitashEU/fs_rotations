---@type color
local color = require("common/color")

---@alias on_render_menu fun()

-- Safe execution wrapper for module menu rendering functions
-- @param module table The module containing the function
-- @param func_name string Name of the function to call
-- @param module_name string Name of the module for error tracking
local function safe_render_menu(module, func_name, module_name)
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

-- Safe function to render menu elements
-- @param menu_element table The menu element to render
-- @param label string The label for the menu element
-- @param tooltip string Optional tooltip
-- @return boolean Whether the render was successful
local function safe_render_element(menu_element, label, tooltip)
    if not menu_element then return false end
    
    local success, error_msg
    if tooltip then
        success, error_msg = pcall(function() menu_element:render(label, tooltip) end)
    else
        success, error_msg = pcall(function() menu_element:render(label) end)
    end
    
    if not success then
        FS.error_handler:record("menu_element." .. label, error_msg)
        return false
    end
    
    return true
end

---@type on_render_menu
function FS.entry_helper.on_render_menu()
    -- Wrap the entire menu rendering in a pcall
    local success, error_msg = pcall(function()
        FS.menu.main_tree:render("FS Rotations v" .. FS.version:toString(), function()
            -- Core settings section
            safe_render_element(FS.menu.enable_script_check, "Enable Script")
            if not FS.settings.is_enabled() then return end
            
            -- Humanizer section
            safe_render_element(FS.menu.humanizer, "Humanizer", color.white())
            safe_render_element(FS.menu.min_delay, "Min delay", "Min delay until next run.")
            safe_render_element(FS.menu.max_delay, "Max delay", "Max delay until next run.")
            
            -- Jitter settings
            safe_render_element(FS.menu.humanizer_jitter.enable_jitter, "Enable Jitter", 
                "Adds randomization to delays for more human-like behavior")
                
            if FS.settings.jitter.is_enabled() then
                safe_render_element(FS.menu.humanizer_jitter.base_jitter, "Base Jitter %",
                    "Base percentage of delay to use for randomization")
                safe_render_element(FS.menu.humanizer_jitter.latency_jitter, "Latency Jitter %",
                    "Additional jitter based on current latency")
                safe_render_element(FS.menu.humanizer_jitter.max_jitter, "Max Jitter %",
                    "Maximum total jitter percentage")
            end
            
            -- Error handler settings (new section)
            if FS.menu.error_handler then
                safe_render_element(FS.menu.error_handler.tree, "Error Handling", color.white())
                
                -- Only render error handling menu if the tree node is open
                if FS.menu.error_handler.tree:is_open() then
                    safe_render_element(FS.menu.error_handler.show_errors, "Show Error Details", 
                        "Display detailed error information in the menu")
                    
                    safe_render_element(FS.menu.error_handler.max_errors_slider, "Max Errors Before Disabling", 
                        "Number of errors before temporarily disabling a component")
                    
                    safe_render_element(FS.menu.error_handler.cooldown_slider, "Disable Duration (seconds)", 
                        "How long to disable a component after repeated errors")
                    
                    if safe_render_element(FS.menu.error_handler.clear_errors, "Clear All Errors") then
                        -- Button was clicked, clear error history
                        FS.error_handler:reset()
                    end
                    
                    -- Display error list if enabled
                    if FS.menu.error_handler.show_errors:get_state() then
                        local error_count = 0
                        
                        -- Count errors
                        for _ in pairs(FS.error_handler.errors) do
                            error_count = error_count + 1
                        end
                        
                        -- Display error count
                        core.menu.text("Active Errors: " .. error_count):render()
                        
                        -- List errors
                        if error_count > 0 then
                            for component, error_data in pairs(FS.error_handler.errors) do
                                local disabled_until = error_data.disabled_until or 0
                                local current_time = core.game_time() / 1000
                                local status = ""
                                
                                if disabled_until > current_time then
                                    status = " [DISABLED for " .. math.floor(disabled_until - current_time) .. "s]"
                                end
                                
                                local error_text = component .. status .. " (" .. error_data.count .. " times)"
                                core.menu.text(error_text):render()
                            end
                        end
                    end
                end
            end
            
            -- Module menus
            for i, module in pairs(FS.loaded_modules) do
                safe_render_menu(module, "on_render_menu", "module_" .. i)
            end
            
            -- Spec menu
            if FS.spec_config then
                safe_render_menu(FS.spec_config, "on_render_menu", 
                                "spec_" .. (FS.spec_config.name or "unknown"))
            end
        end)
    end)
    
    if not success then
        -- Critical failure in menu rendering
        core.log_error("Critical menu rendering error: " .. error_msg)
        
        -- Fallback minimal menu to ensure user can still control the addon
        pcall(function()
            core.menu.tree_node():render("FS Rotations [ERROR MODE]", function()
                core.menu.checkbox("Enable", "Script is currently in error recovery mode"):render(true)
                core.menu.text("Error: " .. error_msg):render()
            end)
        end)
    end
end
