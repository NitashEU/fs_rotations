local required_modules = {
    "core/modules/heal_engine/index"
}

function FS.entry_helper.load_required_modules()
    require("core/index")
    for _, module_path in ipairs(required_modules) do
        local success, module = pcall(require, module_path)
        if success then
            table.insert(FS.modules, module)
        end
    end
    return true
end
