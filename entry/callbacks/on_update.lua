---@alias on_update fun()

---@type on_update
function FS.entry_helper.on_update()
    if not FS.settings.is_enabled() then
        return
    end
    for _, module in pairs(FS.modules) do
        if module.on_fast_update then
            module.on_fast_update()
        end
    end
    if not FS.humanizer.can_run() then
        return
    end
    FS.variables.me = core.object_manager.get_local_player()
    FS.humanizer.update()
    for _, module in pairs(FS.modules) do
        if module.on_update then
            module.on_update()
        end
    end
    if FS.spec_config.on_update then
        FS.spec_config.on_update()
    end
end
