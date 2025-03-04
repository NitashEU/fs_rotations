---@alias on_render_control_panel fun(control_panel: table): table

---@type on_render_control_panel
function FS.entry_helper.on_render_control_panel(control_panel)
    local control_panel_elements = control_panel or {}
    if FS.spec_config.on_render_control_panel then
        control_panel_elements = FS.spec_config.on_render_control_panel(control_panel_elements)
    end
    return control_panel_elements
end
