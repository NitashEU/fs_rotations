---@alias on_render_control_panel fun(control_panel: table): table

---@type on_render_control_panel
function FS.entry_helper.on_render_control_panel(control_panel)
    local control_panel_elements = control_panel or {}
    
    -- Safe execution for spec module control panel rendering
    if FS.spec_config and FS.spec_config.on_render_control_panel then
        local spec_name = FS.spec_config.name or "unknown"
        
        -- Check if allowed to run based on error history
        if FS.error_handler:can_run("spec_" .. spec_name .. ".on_render_control_panel") then
            local success, result = pcall(function()
                return FS.spec_config.on_render_control_panel(control_panel_elements)
            end)
            
            if success and result then
                control_panel_elements = result
            else
                -- Log the error and record it
                local error_msg = result or "Unknown error"
                FS.error_handler:record("spec_" .. spec_name .. ".on_render_control_panel", error_msg)
                
                -- Add error indicator to control panel
                if type(control_panel_elements) == "table" then
                    table.insert(control_panel_elements, {
                        type = "label",
                        text = "Error in control panel",
                        color = {r = 1, g = 0, b = 0, a = 1}
                    })
                end
            end
        else
            -- Add disabled indicator to control panel
            if type(control_panel_elements) == "table" then
                table.insert(control_panel_elements, {
                    type = "label",
                    text = "Control panel temporarily disabled",
                    color = {r = 1, g = 0.5, b = 0, a = 1}
                })
            end
        end
    end
    
    return control_panel_elements
end
