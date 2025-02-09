if FS.entry_helper.init() then
    core.register_on_update_callback(FS.entry_helper.on_update)
    core.register_on_render_callback(FS.entry_helper.on_render)
    core.register_on_render_menu_callback(FS.entry_helper.on_render_menu)
    core.register_on_render_control_panel_callback(FS.entry_helper.on_render_control_panel)
else
    core.log("Failed to initialize FS Rotations")
end
