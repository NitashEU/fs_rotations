---@type enums
local enums = require("common/enums")
-- Load the spec module registry
require("entry/spec_module_registry")

---Loads the module for the player's specialization using the registry pattern
---This improves error handling, provides better diagnostics, and validates dependencies
---@return boolean
function FS.entry_helper.load_spec_module()
    -- Get specialization enum for current player
    local spec_enum = enums.class_spec_id.get_specialization_enum(FS.spec_config.class_id, FS.spec_config.spec_id)
    
    -- Check if we support this specialization
    if not FS.is_spec_supported(spec_enum) then
        core.log_error("Unsupported specialization: " .. tostring(spec_enum) .. 
                       " (Class: " .. FS.spec_config.class_id .. ", Spec: " .. FS.spec_config.spec_id .. ")")
        
        -- If we have registry data but it's disabled, provide more info
        local module_info = FS.get_spec_module_info(spec_enum)
        if module_info and not module_info.enabled then
            core.log_warning("The " .. module_info.name .. " module exists but is currently disabled.")
        end
        
        return false
    end
    
    -- Load the module using the registry
    local success, result = FS.load_spec_module(spec_enum)
    
    if success then
        -- Successfully loaded
        FS.spec_config = result
        
        -- Get module info for logging
        local module_info = FS.get_spec_module_info(spec_enum)
        core.log("Successfully loaded " .. module_info.name .. " module")
        
        -- Note: Event emission removed; direct function calls should be used for initialization if needed
        
        return true
    else
        -- Log the error message returned from the registry
        core.log_error(result)
        
        -- Record in error handler
        if FS.error_handler then
            FS.error_handler:record("load_spec_module", result)
        end
        
        return false
    end
end
