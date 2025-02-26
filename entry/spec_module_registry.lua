---@type enums
local enums = require("common/enums")

--- Registry of all supported spec modules with better dependency management
--- This creates a centralized registry of supported specializations with their module paths
--- for more robust module loading and dependency management
---
--- Advantages:
--- - Clear overview of all supported specs in one place
--- - Explicit dependency declaration 
--- - Better error handling
--- - Easier maintenance
--- - Interface compliance validation

-- Spec module registry maps spec enums to module info
local spec_module_registry = {
    -- Holy Paladin
    [enums.class_spec_id.spec_enum.HOLY_PALADIN] = {
        path = "classes/paladin/holy/bootstrap",
        name = "Holy Paladin",
        dependencies = {
            "heal_engine"
        },
        interface = "spec_module",
        enabled = true
    },
    
    -- Add other specs here in the future
    -- Example:
    --[[
    [enums.class_spec_id.spec_enum.DISCIPLINE_PRIEST] = {
        path = "classes/priest/discipline/bootstrap",
        name = "Discipline Priest",
        dependencies = {
            "heal_engine",
            "atonement_tracker"
        },
        interface = "spec_module",
        enabled = false -- Not yet implemented
    }
    --]]
}

-- Helper to check if dependencies are available
---@param dependencies string[] List of required module names
---@return boolean success
---@return string|nil error_message
local function validate_dependencies(dependencies)
    if not dependencies then return true, nil end
    
    for _, module_name in ipairs(dependencies) do
        if not FS.modules[module_name] then
            return false, "Missing required module: " .. module_name
        end
    end
    
    return true, nil
end

--- Checks if a specialization is supported by the registry
---@param spec_enum number The specialization enum to check
---@return boolean is_supported
function FS.is_spec_supported(spec_enum)
    local module_info = spec_module_registry[spec_enum]
    return module_info ~= nil and module_info.enabled
end

--- Gets the module info for a specialization
---@param spec_enum number The specialization enum to get info for
---@return table|nil module_info
function FS.get_spec_module_info(spec_enum)
    return spec_module_registry[spec_enum]
end

--- Loads a specialization module with dependency validation and interface compliance checks
---@param spec_enum number The specialization enum to load
---@return boolean success
---@return table|string|nil module_or_error Module if successful, error message if not
function FS.load_spec_module(spec_enum)
    local module_info = spec_module_registry[spec_enum]
    
    -- Check if module exists in registry
    if not module_info then
        return false, "Specialization not found in registry: " .. tostring(spec_enum)
    end
    
    -- Check if module is enabled
    if not module_info.enabled then
        return false, "Specialization is not currently supported: " .. module_info.name
    end
    
    -- Validate dependencies
    local deps_valid, deps_error = validate_dependencies(module_info.dependencies)
    if not deps_valid then
        return false, deps_error
    end
    
    -- Try to load the module
    local success, result = pcall(require, module_info.path)
    
    if not success then
        return false, "Failed to load " .. module_info.name .. ": " .. tostring(result)
    end
    
    -- Validate basic module structure
    if type(result) ~= "table" then
        return false, "Invalid module format for " .. module_info.name .. ": expected table, got " .. type(result)
    end
    
    -- Validate module interface
    if module_info.interface and FS.module_interface then
        local component_name = "module_registry." .. module_info.name
        local interface_valid, interface_error = FS.module_interface:validate(
            result, 
            module_info.interface, 
            component_name
        )
        
        if not interface_valid then
            return false, "Interface validation failed for " .. module_info.name .. ": " .. interface_error
        end
    end
    
    return true, result
end

-- Export the registry for inspection and debugging
FS.spec_module_registry = spec_module_registry

return spec_module_registry