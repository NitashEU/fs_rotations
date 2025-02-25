function FS.entry_helper.init()
    if not FS.entry_helper.load_required_modules() then
        core.log("Failed to load required modules")
        return false
    end
    if not FS.entry_helper.load_spec_module() then
        core.log("Failed to load spec module")
        return false
    end
    
    -- Check for settings migration
    if FS.settings.version.needs_migration() then
        core.log("Migrating settings from " .. FS.settings.version.current .. " to " .. FS.version:toString())
        -- Perform settings migration here if needed
        
        -- Update stored settings version
        FS.settings.version.update(FS.version:toString())
    end
    
    return true
end
