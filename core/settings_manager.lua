-- Centralized Settings Manager for FS Rotations
-- Provides validation, change notifications, and unified interface for all settings

---@class SettingsManager
---@field private settings table Table of all registered settings
---@field private listeners table Table of change listeners
---@field private validators table Table of setting validators
---@field private defaults table Table of default values for settings
FS.settings_manager = {
    -- Internal storage
    settings = {},
    listeners = {},
    validators = {},
    defaults = {},
    
    -- Version tracking
    version = {
        ---@type string Current settings version in storage
        current = core.settings.get("fs_rotations_version", "0.0.0"),
        
        ---@param new_version string Update the stored settings version
        ---@return nil
        update = function(new_version)
            core.settings.set("fs_rotations_version", new_version)
        end,
        
        ---@return boolean True if settings version is older than code version
        needs_migration = function()
            return FS.version:isNewerThan(FS.settings_manager.version.current)
        end
    },
    
    -- Setting types
    TYPES = {
        NUMBER = "number",
        BOOLEAN = "boolean",
        STRING = "string",
        PERCENT = "percent",
        INTEGER = "integer",
        FLOAT = "float",
        ENUM = "enum"
    }
}

---Register a setting with the settings manager
---@param module_name string The module name (e.g., "core", "paladin_holy")
---@param setting_name string The setting name (e.g., "min_delay")
---@param getter function Function that returns the current value
---@param setting_type string The type of setting (use FS.settings_manager.TYPES)
---@param options table|nil Additional options (min, max, allowed_values)
---@param default_value any|nil The default value for the setting
---@return boolean Success of registration
function FS.settings_manager:register(module_name, setting_name, getter, setting_type, options, default_value)
    local component = "settings_manager.register"
    
    -- Validate required parameters
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_string(setting_name, "setting_name", nil, component) then return false end
    if not FS.validator.check_function(getter, "getter", component) then return false end
    if not FS.validator.check_string(setting_type, "setting_type", nil, component) then return false end
    
    -- Handle options
    options = FS.validator.default(options, {})
    if not FS.validator.check_table(options, "options", component) then return false end
    
    -- Full setting path
    local full_path = module_name .. "." .. setting_name
    
    -- Store the setting
    self.settings[full_path] = {
        getter = getter,
        type = setting_type,
        options = options,
        module = module_name,
        name = setting_name
    }
    
    -- Store default value if provided
    if default_value ~= nil then
        self.defaults[full_path] = default_value
    end
    
    -- Create validator based on type
    self:create_validator(full_path, setting_type, options)
    
    return true
end

---Create a validator for a registered setting
---@param full_path string The full path to the setting
---@param setting_type string The type of setting
---@param options table Additional options (min, max, allowed_values)
---@return boolean Success of validator creation
function FS.settings_manager:create_validator(full_path, setting_type, options)
    local component = "settings_manager.create_validator"
    
    -- Create validator function based on type
    if setting_type == self.TYPES.NUMBER then
        self.validators[full_path] = function(value, name)
            return FS.validator.check_number(value, name, options.min, options.max, component)
        end
    elseif setting_type == self.TYPES.PERCENT then
        self.validators[full_path] = function(value, name)
            return FS.validator.check_percent(value, name, component)
        end
    elseif setting_type == self.TYPES.BOOLEAN then
        self.validators[full_path] = function(value, name)
            return FS.validator.check_boolean(value, name, false, component)
        end
    elseif setting_type == self.TYPES.STRING then
        self.validators[full_path] = function(value, name)
            return FS.validator.check_string(value, name, options.allowed_values, component)
        end
    elseif setting_type == self.TYPES.INTEGER or setting_type == self.TYPES.FLOAT then
        self.validators[full_path] = function(value, name)
            return FS.validator.check_number(value, name, options.min, options.max, component)
        end
    elseif setting_type == self.TYPES.ENUM then
        self.validators[full_path] = function(value, name)
            return FS.validator.check_string(value, name, options.allowed_values, component)
        end
    else
        FS.error_handler:record(component, "Unknown setting type: " .. setting_type)
        return false
    end
    
    return true
end

---Get a setting value with validation
---@param module_name string The module name
---@param setting_name string The setting name
---@param default_value any|nil The default value if validation fails
---@return any The setting value
function FS.settings_manager:get(module_name, setting_name, default_value)
    local component = "settings_manager.get"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then 
        return default_value 
    end
    
    if not FS.validator.check_string(setting_name, "setting_name", nil, component) then 
        return default_value 
    end
    
    -- Full setting path
    local full_path = module_name .. "." .. setting_name
    
    -- Check if setting exists
    local setting = self.settings[full_path]
    if not setting then
        FS.error_handler:record(component, "Setting not found: " .. full_path)
        return default_value
    end
    
    -- Get value from getter
    local success, value = pcall(setting.getter)
    if not success then
        FS.error_handler:record(component, "Error getting setting value: " .. full_path .. " - " .. tostring(value))
        return default_value
    end
    
    -- Validate the value
    local validator = self.validators[full_path]
    if validator and not validator(value, full_path) then
        FS.error_handler:record(component, "Setting value failed validation: " .. full_path)
        return default_value
    end
    
    return value
end

---Add a change listener for a specific setting
---@param module_name string The module name
---@param setting_name string The setting name
---@param listener function Function to call when the setting changes
---@param listener_id string|nil Unique ID for the listener (for removal)
---@return string Listener ID
function FS.settings_manager:add_listener(module_name, setting_name, listener, listener_id)
    local component = "settings_manager.add_listener"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return "" end
    if not FS.validator.check_string(setting_name, "setting_name", nil, component) then return "" end
    if not FS.validator.check_function(listener, "listener", component) then return "" end
    
    -- Full setting path
    local full_path = module_name .. "." .. setting_name
    
    -- Generate ID if not provided
    listener_id = listener_id or tostring(math.random(1000000, 9999999))
    
    -- Initialize listeners table for this setting if needed
    if not self.listeners[full_path] then
        self.listeners[full_path] = {}
    end
    
    -- Store the listener
    self.listeners[full_path][listener_id] = listener
    
    return listener_id
end

---Remove a change listener
---@param module_name string The module name
---@param setting_name string The setting name
---@param listener_id string The listener ID
---@return boolean Success of removal
function FS.settings_manager:remove_listener(module_name, setting_name, listener_id)
    local component = "settings_manager.remove_listener"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_string(setting_name, "setting_name", nil, component) then return false end
    if not FS.validator.check_string(listener_id, "listener_id", nil, component) then return false end
    
    -- Full setting path
    local full_path = module_name .. "." .. setting_name
    
    -- Check if listeners exist for this setting
    if not self.listeners[full_path] then
        return false
    end
    
    -- Remove the listener
    if self.listeners[full_path][listener_id] then
        self.listeners[full_path][listener_id] = nil
        return true
    end
    
    return false
end

---Notify listeners of a setting change
---@param module_name string The module name
---@param setting_name string The setting name
---@param value any The new value
---@return boolean Success of notification
function FS.settings_manager:notify_change(module_name, setting_name, value)
    local component = "settings_manager.notify_change"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_string(setting_name, "setting_name", nil, component) then return false end
    
    -- Full setting path
    local full_path = module_name .. "." .. setting_name
    
    -- Check if listeners exist for this setting
    if not self.listeners[full_path] then
        return true -- No listeners to notify
    end
    
    -- Notify all listeners
    for _, listener in pairs(self.listeners[full_path]) do
        local success, err = pcall(listener, value)
        if not success then
            FS.error_handler:record(component, "Error in listener: " .. tostring(err))
        end
    end
    
    return true
end

---Register all settings from a module
---@param module_name string The module name (e.g., "core", "paladin_holy")
---@param settings_table table Table of settings to register
---@param mappings table|nil Optional mappings of setting names to types/options
---@return boolean Success of registration
function FS.settings_manager:register_module(module_name, settings_table, mappings)
    local component = "settings_manager.register_module"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_table(settings_table, "settings_table", component) then return false end
    
    -- Use empty mappings if not provided
    mappings = FS.validator.default(mappings, {})
    
    -- Register each setting
    for setting_name, getter in pairs(settings_table) do
        -- Skip if not a function (might be a nested table)
        if type(getter) == "function" then
            local mapping = mappings[setting_name] or {}
            local setting_type = mapping.type or self.TYPES.NUMBER -- Default to NUMBER
            local options = mapping.options or {}
            local default_value = mapping.default
            
            self:register(module_name, setting_name, getter, setting_type, options, default_value)
        elseif type(getter) == "table" then
            -- For nested tables (e.g., FS.settings.jitter)
            for nested_name, nested_getter in pairs(getter) do
                if type(nested_getter) == "function" then
                    local full_name = setting_name .. "." .. nested_name
                    local mapping = mappings[full_name] or {}
                    local setting_type = mapping.type or self.TYPES.NUMBER
                    local options = mapping.options or {}
                    local default_value = mapping.default
                    
                    self:register(module_name, full_name, nested_getter, setting_type, options, default_value)
                end
            end
        end
    end
    
    return true
end

---Get default value for a setting
---@param module_name string The module name
---@param setting_name string The setting name
---@return any|nil The default value or nil if not set
function FS.settings_manager:get_default(module_name, setting_name)
    local full_path = module_name .. "." .. setting_name
    return self.defaults[full_path]
end

---Validate a setting value against its validator
---@param module_name string The module name
---@param setting_name string The setting name
---@param value any The value to validate
---@return boolean Valid or not
function FS.settings_manager:validate(module_name, setting_name, value)
    local component = "settings_manager.validate"
    
    -- Validate inputs
    if not FS.validator.check_string(module_name, "module_name", nil, component) then return false end
    if not FS.validator.check_string(setting_name, "setting_name", nil, component) then return false end
    
    -- Full setting path
    local full_path = module_name .. "." .. setting_name
    
    -- Check if validator exists
    local validator = self.validators[full_path]
    if not validator then
        FS.error_handler:record(component, "Validator not found: " .. full_path)
        return false
    end
    
    -- Validate the value
    return validator(value, full_path)
end

---List all registered settings
---@param module_filter string|nil Optional module filter
---@return table List of registered settings
function FS.settings_manager:list_settings(module_filter)
    local result = {}
    
    for full_path, setting in pairs(self.settings) do
        if not module_filter or setting.module == module_filter then
            table.insert(result, {
                module = setting.module,
                name = setting.name,
                type = setting.type,
                options = setting.options,
                default = self.defaults[full_path]
            })
        end
    end
    
    return result
end

-- Initialize settings_manager with default mappings
function FS.settings_manager:init()
    -- Core settings mappings
    local core_mappings = {
        ["is_enabled"] = { type = self.TYPES.BOOLEAN },
        ["min_delay"] = { 
            type = self.TYPES.INTEGER, 
            options = { min = 0, max = 1500 }, 
            default = 125 
        },
        ["max_delay"] = { 
            type = self.TYPES.INTEGER, 
            options = { min = 1, max = 1500 }, 
            default = 250 
        },
        ["jitter.is_enabled"] = { type = self.TYPES.BOOLEAN, default = true },
        ["jitter.base_jitter"] = { 
            type = self.TYPES.FLOAT, 
            options = { min = 0.05, max = 0.30 }, 
            default = 0.15 
        },
        ["jitter.latency_jitter"] = { 
            type = self.TYPES.FLOAT, 
            options = { min = 0.01, max = 0.20 }, 
            default = 0.05 
        },
        ["jitter.max_jitter"] = { 
            type = self.TYPES.FLOAT, 
            options = { min = 0.10, max = 0.50 }, 
            default = 0.25 
        }
    }
    
    -- Register core settings
    self:register_module("core", FS.settings, core_mappings)
    
    -- Add observer functionality to monitor changes
    self:setup_change_observers()
end

---Setup change observers for menu elements
function FS.settings_manager:setup_change_observers()
    -- Create getter wrappers with notification
    -- This solution uses proxy functions to observe changes from menu elements
    
    -- Core settings
    for menu_path, menu_key in pairs({
        ["is_enabled"] = "enable_script_check",
        ["min_delay"] = "min_delay",
        ["max_delay"] = "max_delay",
        ["jitter.is_enabled"] = "humanizer_jitter.enable_jitter",
        ["jitter.base_jitter"] = "humanizer_jitter.base_jitter",
        ["jitter.latency_jitter"] = "humanizer_jitter.latency_jitter",
        ["jitter.max_jitter"] = "humanizer_jitter.max_jitter"
    }) do
        local old_value = nil
        local function get_nested(obj, path)
            if not path then return obj end
            
            local parts = {}
            for part in path:gmatch("[^%.]+") do
                table.insert(parts, part)
            end
            
            local current = obj
            for _, part in ipairs(parts) do
                if current[part] == nil then return nil end
                current = current[part]
            end
            
            return current
        end
        
        -- Set up auto-notification when value changes
        local checker_id = "observer_" .. menu_path
        local menu_elem = get_nested(FS.menu, menu_key)
        
        if menu_elem then
            -- Setup a timer to periodically check this setting for changes
            FS.error_handler:safe_execute("settings_manager.setup_change_observers", function()
                FS.core.timer_manager.add_interval_timer(
                    checker_id,
                    0.5, -- Check every 500ms
                    function()
                        -- Get current value
                        local setting = self.settings["core." .. menu_path]
                        if not setting then return end
                        
                        local success, current_value = pcall(setting.getter)
                        if not success then return end
                        
                        -- Check if value changed
                        if old_value ~= nil and old_value ~= current_value then
                            self:notify_change("core", menu_path, current_value)
                        end
                        
                        -- Update stored value
                        old_value = current_value
                    end
                )
            end)
        end
    end
end

-- Return the module for proper loading
return FS.settings_manager