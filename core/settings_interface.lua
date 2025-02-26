-- Settings Interface for FS Rotations
-- Bridge between legacy settings system and centralized settings manager

---@class SettingsInterface
---@field registered_modules table Table of registered modules
FS.settings_interface = {
    registered_modules = {}
}

---Register all settings from a module with the settings manager
---@param module_name string The module name (e.g., "core", "paladin_holy")
---@param settings_table table Table of settings to register
---@param mappings table|nil Optional mappings of setting names to types/options
---@return boolean Success of registration
function FS.settings_interface:register_module(module_name, settings_table, mappings)
    local component = "settings_interface.register_module"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_table(settings_table, "settings_table", component) then return false end
    
    -- Use empty mappings if not provided
    mappings = FS.validator.default(mappings, {})
    
    -- Register with the settings manager
    local success = FS.settings_manager:register_module(module_name, settings_table, mappings)
    if success then
        -- Mark this module as registered
        self.registered_modules[module_name] = true
    end
    
    return success
end

---Generate mappings for standard setting types based on naming conventions
---@param settings_table table The settings table to analyze
---@return table Mappings table
function FS.settings_interface:generate_mappings(settings_table)
    local mappings = {}
    
    for name, getter in pairs(settings_table) do
        if type(getter) == "function" then
            -- Analyze name to guess type
            if name:match("_check$") or name:match("is_enabled") then
                mappings[name] = { type = FS.settings_manager.TYPES.BOOLEAN }
            elseif name:match("_threshold$") or name:match("_priority$") then
                mappings[name] = { 
                    type = FS.settings_manager.TYPES.PERCENT,
                    options = { min = 0, max = 100 }
                }
            elseif name:match("_min_") or name:match("_max_") then
                mappings[name] = { type = FS.settings_manager.TYPES.NUMBER }
            end
        elseif type(getter) == "table" then
            -- For nested settings
            for nested_name, nested_getter in pairs(getter) do
                if type(nested_getter) == "function" then
                    local full_name = name .. "." .. nested_name
                    
                    -- Analyze nested name to guess type
                    if nested_name:match("_check$") or nested_name:match("is_enabled") then
                        mappings[full_name] = { type = FS.settings_manager.TYPES.BOOLEAN }
                    elseif nested_name:match("_threshold$") or nested_name:match("_priority$") then
                        mappings[full_name] = { 
                            type = FS.settings_manager.TYPES.PERCENT,
                            options = { min = 0, max = 100 }
                        }
                    elseif nested_name:match("_min_") or nested_name:match("_max_") then
                        mappings[full_name] = { type = FS.settings_manager.TYPES.NUMBER }
                    end
                end
            end
        end
    end
    
    return mappings
end

---Register all known settings from existing modules
---@return boolean Success of registration
function FS.settings_interface:register_known_modules()
    local success = true
    
    -- Register core settings
    if FS.settings and not self.registered_modules["core"] then
        local mappings = self:generate_mappings(FS.settings)
        success = success and self:register_module("core", FS.settings, mappings)
    end
    
    -- Register heal engine settings
    if FS.modules and 
       FS.modules.heal_engine and 
       FS.modules.heal_engine.settings and 
       not self.registered_modules["heal_engine"] then
        local mappings = self:generate_mappings(FS.modules.heal_engine.settings)
        success = success and self:register_module("heal_engine", FS.modules.heal_engine.settings, mappings)
    end
    
    -- Register holy paladin settings
    if FS.paladin_holy and 
       FS.paladin_holy.settings and 
       not self.registered_modules["paladin_holy"] then
        local mappings = self:generate_mappings(FS.paladin_holy.settings)
        success = success and self:register_module("paladin_holy", FS.paladin_holy.settings, mappings)
    end
    
    return success
end

---Create legacy-compatible getters
---@param module_table table The module table to augment
---@param module_name string The module name
---@return nil
function FS.settings_interface:create_compatible_getters(module_table, module_name)
    local settings_table = module_table.settings
    if not settings_table then return end
    
    -- Create a proxy for each setting
    for name, getter in pairs(settings_table) do
        if type(getter) == "function" then
            -- Create a proxy function that uses settings_manager
            local original_getter = getter
            settings_table[name] = function(...)
                -- Try to get from settings manager first
                local value = FS.settings_manager:get(module_name, name)
                
                -- Fall back to original getter if needed
                if value == nil then
                    return original_getter(...)
                end
                
                return value
            end
        elseif type(getter) == "table" then
            -- For nested settings
            for nested_name, nested_getter in pairs(getter) do
                if type(nested_getter) == "function" then
                    -- Create a proxy function for nested setting
                    local original_nested_getter = nested_getter
                    getter[nested_name] = function(...)
                        -- Try to get from settings manager first
                        local full_name = name .. "." .. nested_name
                        local value = FS.settings_manager:get(module_name, full_name)
                        
                        -- Fall back to original getter if needed
                        if value == nil then
                            return original_nested_getter(...)
                        end
                        
                        return value
                    end
                end
            end
        end
    end
end

---Initialize the settings interface
---@return nil
function FS.settings_interface:init()
    -- Register known modules
    self:register_known_modules()
    
    -- Create compatible getters
    self:create_compatible_getters(FS, "core")
    
    if FS.modules and FS.modules.heal_engine then
        self:create_compatible_getters(FS.modules.heal_engine, "heal_engine")
    end
    
    if FS.paladin_holy then
        self:create_compatible_getters(FS.paladin_holy, "paladin_holy")
    end
end

-- Return the module for proper loading
return FS.settings_interface