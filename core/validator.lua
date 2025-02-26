-- Standardized validation library for FS Rotations
-- Used to validate function parameters, settings, and other values consistently
-- Integrates with FS.error_handler for comprehensive error tracking

FS.validator = {
    -- Internal helper to get proper component name
    _get_component_name = function(component)
        if not component or component == "" then
            local info = debug.getinfo(3, "Sl")
            local filename = info.source:match("@(.*)")
            -- Remove path prefix, convert to dot notation
            filename = filename:gsub("^.*/", ""):gsub("%.lua$", ""):gsub("/", ".")
            return "validator." .. filename
        end
        return component
    end,
    
    -- Check if value is a number within optional range
    -- @param value any Value to check
    -- @param name string Name of the parameter for error messages
    -- @param min number|nil Optional minimum value
    -- @param max number|nil Optional maximum value
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_number = function(value, name, min, max, component)
        component = FS.validator._get_component_name(component)
        
        if type(value) ~= "number" then
            local err = name .. " must be a number"
            FS.error_handler:record(component, err)
            return false, err
        end
        
        if min ~= nil and value < min then
            local err = name .. " must be at least " .. min
            FS.error_handler:record(component, err)
            return false, err
        end
        
        if max ~= nil and value > max then
            local err = name .. " must be at most " .. max
            FS.error_handler:record(component, err)
            return false, err
        end
        
        return true
    end,
    
    -- Check if value is a string matching optional allowed values
    -- @param value any Value to check
    -- @param name string Name of the parameter for error messages
    -- @param allowed_values table|nil Optional table of allowed values
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_string = function(value, name, allowed_values, component)
        component = FS.validator._get_component_name(component)
        
        if type(value) ~= "string" then
            local err = name .. " must be a string"
            FS.error_handler:record(component, err)
            return false, err
        end
        
        if allowed_values then
            local found = false
            for _, allowed in ipairs(allowed_values) do
                if value == allowed then
                    found = true
                    break
                end
            end
            
            if not found then
                local err = name .. " must be one of: " .. table.concat(allowed_values, ", ")
                FS.error_handler:record(component, err)
                return false, err
            end
        end
        
        return true
    end,
    
    -- Check if value is a table
    -- @param value any Value to check
    -- @param name string Name of the parameter for error messages
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_table = function(value, name, component)
        component = FS.validator._get_component_name(component)
        
        if type(value) ~= "table" then
            local err = name .. " must be a table"
            FS.error_handler:record(component, err)
            return false, err
        end
        
        return true
    end,
    
    -- Check if table has required keys
    -- @param value table Table to check
    -- @param name string Name of the parameter for error messages
    -- @param required_keys table List of required keys
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_table_keys = function(value, name, required_keys, component)
        component = FS.validator._get_component_name(component)
        
        local success, err = FS.validator.check_table(value, name, component)
        if not success then
            return false, err
        end
        
        for _, key in ipairs(required_keys) do
            if value[key] == nil then
                local err = name .. " must have '" .. key .. "' key"
                FS.error_handler:record(component, err)
                return false, err
            end
        end
        
        return true
    end,
    
    -- Check if value is a function
    -- @param value any Value to check
    -- @param name string Name of the parameter for error messages
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_function = function(value, name, component)
        component = FS.validator._get_component_name(component)
        
        if type(value) ~= "function" then
            local err = name .. " must be a function"
            FS.error_handler:record(component, err)
            return false, err
        end
        
        return true
    end,
    
    -- Check if value is a boolean
    -- @param value any Value to check
    -- @param name string Name of the parameter for error messages
    -- @param allow_nil boolean If true, nil is also considered valid
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_boolean = function(value, name, allow_nil, component)
        component = FS.validator._get_component_name(component)
        
        if value == nil and allow_nil then
            return true
        end
        
        if type(value) ~= "boolean" then
            local err = name .. " must be a boolean"
            if allow_nil then
                err = err .. " or nil"
            end
            FS.error_handler:record(component, err)
            return false, err
        end
        
        return true
    end,
    
    -- Check if a required parameter exists
    -- @param value any Value to check
    -- @param name string Name of the parameter for error messages
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_required = function(value, name, component)
        component = FS.validator._get_component_name(component)
        
        if value == nil then
            local err = name .. " is required"
            FS.error_handler:record(component, err)
            return false, err
        end
        
        return true
    end,
    
    -- Check if a value is a valid game object
    -- @param value any Value to check
    -- @param name string Name of the parameter for error messages
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_game_object = function(value, name, component)
        component = FS.validator._get_component_name(component)
        
        local success, err = FS.validator.check_table(value, name, component)
        if not success then
            return false, err
        end
        
        if not value.guid or type(value.guid) ~= "string" then
            local err = name .. " must be a valid game object with guid"
            FS.error_handler:record(component, err)
            return false, err
        end
        
        return true
    end,
    
    -- Check multiple parameters at once
    -- @param params table Table of parameter values indexed by name
    -- @param validations table Table of validation functions indexed by parameter name
    -- @param component string|nil Component name for error reporting
    -- @return boolean True if all validations pass, false otherwise
    validate_params = function(params, validations, component)
        component = FS.validator._get_component_name(component)
        
        for name, validation in pairs(validations) do
            local success, _ = validation(params[name], name, component)
            if not success then
                return false
            end
        end
        
        return true
    end,
    
    -- Get a parameter with default value if nil
    -- @param value any Value to use
    -- @param default any Default value if original is nil
    -- @return any Original value or default
    default = function(value, default)
        if value == nil then
            return default
        end
        return value
    end,
    
    -- Validate a numeric setting that must be in percent range (0-100)
    -- @param value any Value to check
    -- @param name string Name of the setting for error messages
    -- @param component string|nil Component name for error reporting
    -- @return boolean, string|nil True if valid, otherwise false and error message
    check_percent = function(value, name, component)
        return FS.validator.check_number(value, name, 0, 100, component)
    end
}

-- Return the module for proper loading
return FS.validator