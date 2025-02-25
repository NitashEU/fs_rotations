---@type enums
local enums = require("common/enums")

---Loads the module for the player's specialization with enhanced error handling
---@return boolean
function FS.entry_helper.load_spec_module()
    -- Get specialization enum for current player
    local spec_enum = enums.class_spec_id.get_specialization_enum(FS.spec_config.class_id, FS.spec_config.spec_id)
    
    -- Get module path 
    local module_path = FS.entry_helper.class_spec_map[spec_enum]
    if not module_path then
        core.log_error("Unsupported specialization: " .. tostring(spec_enum) .. 
                       " (Class: " .. FS.spec_config.class_id .. ", Spec: " .. FS.spec_config.spec_id .. ")")
        return false
    end
    
    -- Full path to bootstrap file
    local full_path = "classes/" .. module_path .. "/bootstrap"
    
    -- Try to load the module
    local success, result = pcall(require, full_path)
    
    if success then
        -- Successfully loaded
        FS.spec_config = result
        
        -- Validate module interface
        if type(FS.spec_config) ~= "table" then
            core.log_error("Invalid spec module: not a table")
            return false
        end
        
        -- Log successful load
        core.log("Successfully loaded spec module: " .. (FS.spec_config.name or module_path))
        return true
    else
        -- Log the error
        local error_msg = result or "Unknown error"
        core.log_error("Failed to load spec module (" .. full_path .. "): " .. error_msg)
        
        -- Record in error handler if available
        if FS.error_handler then
            FS.error_handler:record("load_spec_module." .. module_path, error_msg)
        end
        
        return false
    end
end
