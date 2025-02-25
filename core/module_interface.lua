-- Module Interface Standardization
-- Provides consistent interface definitions and validation for all module types
-- Integrates with FS.validator for comprehensive validation

---@class ModuleInterface
FS.module_interface = {
  -- Registry of known interface types and their validation rules
  ---@type table<string, table>
  interfaces = {},

  -- Initialize the module interface system
  ---@return nil
  init = function(self)
    -- Register standard interfaces
    self:register_interface("core_module", self.create_core_module_interface())
    self:register_interface("spec_module", self.create_spec_module_interface())
    self:register_interface("ui_module", self.create_ui_module_interface())
    self:register_interface("data_module", self.create_data_module_interface())
  end,

  -- Register a new interface type with validation rules
  ---@param interface_name string Name of the interface
  ---@param interface_def table Interface definition with validation rules
  ---@return nil
  register_interface = function(self, interface_name, interface_def)
    self.interfaces[interface_name] = interface_def
  end,

  -- Validate that a module implements a specific interface
  ---@param module table The module to validate
  ---@param interface_name string The interface to validate against
  ---@param component_name string The component name for error reporting
  ---@return boolean valid Whether the module implements the interface
  ---@return string|nil error_message Error message if validation failed
  validate = function(self, module, interface_name, component_name)
    local interface = self.interfaces[interface_name]
    if not interface then
      local err = "Unknown interface: " .. interface_name
      FS.error_handler:record(component_name, err)
      return false, err
    end

    -- Check that module is a table
    local success, err = FS.validator.check_table(module, "module", component_name)
    if not success then
      return false, err
    end

    -- Validate required fields
    for field_name, validation in pairs(interface.required_fields or {}) do
      local field_value = module[field_name]
      
      -- Special handling for "oneof" validations
      if validation.type == "oneof" then
        local valid = false
        local errors = {}
        
        for _, option in ipairs(validation.options) do
          local option_success, option_err = option(field_value, field_name, component_name)
          if option_success then
            valid = true
            break
          else
            table.insert(errors, option_err)
          end
        end
        
        if not valid then
          local err = field_name .. " failed validation: " .. table.concat(errors, " OR ")
          FS.error_handler:record(component_name, err)
          return false, err
        end
      else
        -- Standard validation
        local success, err = validation(field_value, field_name, component_name)
        if not success then
          return false, err
        end
      end
    end

    -- Check for deprecated fields and log warnings
    for field_name, warning in pairs(interface.deprecated_fields or {}) do
      if module[field_name] ~= nil then
        -- Use 2 as the stack level to indicate this is a warning, not an error
        FS.error_handler:record(component_name, "Warning: " .. warning, 2)
      end
    end

    -- Successful validation
    return true
  end,

  -- Get documentation for an interface
  ---@param interface_name string The interface name
  ---@return string documentation Markdown documentation for the interface
  get_documentation = function(self, interface_name)
    local interface = self.interfaces[interface_name]
    if not interface then
      return "Unknown interface: " .. interface_name
    end

    local doc = "# " .. interface_name .. " Interface\n\n"
    doc = doc .. interface.description .. "\n\n"
    
    doc = doc .. "## Required Fields\n\n"
    for field_name, validation in pairs(interface.required_fields or {}) do
      doc = doc .. "- `" .. field_name .. "`: " .. (validation.description or "No description") .. "\n"
    end
    
    doc = doc .. "\n## Optional Fields\n\n"
    for field_name, validation in pairs(interface.optional_fields or {}) do
      doc = doc .. "- `" .. field_name .. "`: " .. (validation.description or "No description") .. "\n"
    end
    
    if interface.deprecated_fields and next(interface.deprecated_fields) then
      doc = doc .. "\n## Deprecated Fields\n\n"
      for field_name, warning in pairs(interface.deprecated_fields) do
        doc = doc .. "- `" .. field_name .. "`: " .. warning .. "\n"
      end
    end
    
    doc = doc .. "\n## Example\n\n```lua\n" .. interface.example .. "\n```\n"
    
    return doc
  end,

  -- Create validation function with description
  ---@param validation_fn function The validation function
  ---@param description string Description of the field
  ---@return table validation_def Validation definition with function and description
  create_validation = function(validation_fn, description)
    return {
      validate = validation_fn,
      description = description,
      __call = function(self, ...)
        return self.validate(...)
      end
    }
  end,

  -- Create interface definition for core modules
  ---@return table interface_def Core module interface definition
  create_core_module_interface = function()
    return {
      description = "Core modules provide fundamental functionality used by other modules.",
      required_fields = {
        -- Core lifecycle hooks
        on_update = {
          description = "Called on each update cycle (slower frequency)",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
        on_fast_update = {
          description = "Called on each fast update cycle (higher frequency)",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Menu rendering hook
        on_render_menu = {
          description = "Called when rendering the module's menu",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
      },
      optional_fields = {
        -- Visual rendering hook
        on_render = {
          description = "Called when rendering the module's visuals (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Settings schema
        settings = {
          description = "Module settings schema (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_table(value, name, component)
          end
        },
      },
      deprecated_fields = {
        run_once = "Use initialization in the constructor instead of run_once"
      },
      example = [[
return {
  on_update = function()
    -- Update logic here
  end,
  on_fast_update = function()
    -- Fast update logic here
  end,
  on_render_menu = function()
    -- Menu rendering logic here
  end,
  on_render = function()
    -- Visual rendering logic here (optional)
  end
}
      ]]
    }
  end,

  -- Create interface definition for specialization modules
  ---@return table interface_def Specialization module interface definition
  create_spec_module_interface = function()
    return {
      description = "Specialization modules implement class-specific rotation logic.",
      required_fields = {
        -- Class and spec identification
        class_id = {
          description = "Class identifier",
          __call = function(self, value, name, component)
            return FS.validator.check_number(value, name, 0, nil, component)
          end
        },
        spec_id = {
          description = "Specialization identifier",
          __call = function(self, value, name, component)
            return FS.validator.check_number(value, name, 0, nil, component)
          end
        },
        -- Core update hook
        on_update = {
          description = "Called on each update cycle to execute rotation logic",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Menu rendering hooks
        on_render_menu = {
          description = "Called when rendering the specialization menu",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
        on_render_control_panel = {
          description = "Called when rendering the control panel",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
      },
      optional_fields = {
        -- Visual rendering
        on_render = {
          description = "Called when rendering specialization-specific visuals",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Settings configuration
        settings = {
          description = "Specialization settings configuration",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_table(value, name, component)
          end
        },
        -- Reset handlers
        on_reset = {
          description = "Called when the specialization should reset its state",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        on_combat_start = {
          description = "Called when entering combat",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        on_combat_end = {
          description = "Called when leaving combat",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
      },
      deprecated_fields = {},
      example = [[
return {
  class_id = 2,
  spec_id = 3,
  on_update = function()
    -- Rotation logic here
  end,
  on_render = function()
    -- Visual rendering logic here
  end,
  on_render_menu = function()
    -- Menu rendering logic here
  end,
  on_render_control_panel = function()
    -- Control panel rendering logic here
  end
}
      ]]
    }
  end,

  -- Create interface definition for UI modules
  ---@return table interface_def UI module interface definition
  create_ui_module_interface = function()
    return {
      description = "UI modules provide user interface components and visualizations.",
      required_fields = {
        -- UI rendering hook
        on_render = {
          description = "Called when rendering the UI components",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Menu rendering hook
        on_render_menu = {
          description = "Called when rendering the module's menu",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
      },
      optional_fields = {
        -- Update hooks
        on_update = {
          description = "Called on each update cycle (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        on_fast_update = {
          description = "Called on each fast update cycle (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Settings schema
        settings = {
          description = "UI settings schema (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_table(value, name, component)
          end
        },
      },
      deprecated_fields = {},
      example = [[
return {
  on_render = function()
    -- UI rendering logic here
  end,
  on_render_menu = function()
    -- Menu rendering logic here
  end,
  on_update = function()
    -- Update logic here (optional)
  end
}
      ]]
    }
  end,

  -- Create interface definition for data modules
  ---@return table interface_def Data module interface definition
  create_data_module_interface = function()
    return {
      description = "Data modules provide data collection, storage, and analysis functionality.",
      required_fields = {
        -- Data collection hook
        on_update = {
          description = "Called on each update cycle to collect and process data",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
        -- API functions
        get_data = {
          description = "Function to retrieve data from the module",
          __call = function(self, value, name, component)
            return FS.validator.check_function(value, name, component)
          end
        },
      },
      optional_fields = {
        -- Fast update hook
        on_fast_update = {
          description = "Called on each fast update cycle (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Menu rendering
        on_render_menu = {
          description = "Called when rendering the module's menu (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Visual data display
        on_render = {
          description = "Called when rendering data visualizations (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
        -- Reset handlers
        reset = {
          description = "Function to reset the module's data (optional)",
          __call = function(self, value, name, component)
            if value == nil then return true end
            return FS.validator.check_function(value, name, component)
          end
        },
      },
      deprecated_fields = {},
      example = [[
return {
  on_update = function()
    -- Data collection logic here
  end,
  get_data = function(key)
    -- Return requested data
    return stored_data[key]
  end,
  on_render_menu = function()
    -- Menu rendering logic here (optional)
  end,
  reset = function()
    -- Reset data storage
  end
}
      ]]
    }
  end,
}

-- Initialize module interface system
FS.module_interface:init()

-- Return module for proper loading
return FS.module_interface