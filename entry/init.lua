function FS.entry_helper.init()
    if not FS.entry_helper.load_required_modules() then
        core.log("Failed to load required modules")
        return false
    end
    if not FS.entry_helper.load_spec_module() then
        core.log("Failed to load required modules")
        return false
    end
    return true
end
