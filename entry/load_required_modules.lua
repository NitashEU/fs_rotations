-- Required modules with interface validation
---@type table<string, string>
local required_modules = {
    heal_engine = {
        path = "core/modules/heal_engine/index",
        interface = "core_module"
    }
}

--- Loads all required core modules with interface validation
---@return boolean success Whether all modules loaded successfully
function FS.entry_helper.load_required_modules()
    -- Load core systems first
    require("core/index")
    
    -- Initialize FS.modules table if it doesn't exist
    FS.modules = FS.modules or {}
    FS.loaded_modules = FS.loaded_modules or {}
    
    -- Load each required module
    for module_name, module_info in pairs(required_modules) do
        local success, result = pcall(require, module_info.path)
        
        if not success then
            core.log_error("Failed to load required module " .. module_name .. ": " .. tostring(result))
            
            -- Record in error handler
            if FS.error_handler then
                FS.error_handler:record("load_required_modules", 
                    "Failed to load required module " .. module_name .. ": " .. tostring(result))
            end
            
            return false
        end
        
        -- Basic type validation
        if type(result) ~= "table" then
            core.log_error("Invalid module format for " .. module_name .. ": expected table, got " .. type(result))
            
            -- Record in error handler
            if FS.error_handler then
                FS.error_handler:record("load_required_modules", 
                    "Invalid module format for " .. module_name .. ": expected table, got " .. type(result))
            end
            
            return false
        end
        
        -- Interface validation if applicable
        if module_info.interface and FS.module_interface then
            local component_name = "load_required_modules." .. module_name
            local interface_valid, interface_error = FS.module_interface:validate(
                result,
                module_info.interface,
                component_name
            )
            
            if not interface_valid then
                core.log_error("Interface validation failed for " .. module_name .. ": " .. interface_error)
                
                -- Record in error handler
                if FS.error_handler then
                    FS.error_handler:record(component_name, 
                        "Interface validation failed: " .. interface_error)
                end
                
                return false
            end
        end
        
        -- Store module
        FS.modules[module_name] = result
        table.insert(FS.loaded_modules, result)
        core.log("Loaded required module: " .. module_name)
    end
    
    return true
end
