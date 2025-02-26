# Module Interfaces

This document describes the standardized module interfaces used throughout the FS Rotations system. These interfaces ensure consistent structure, improve reliability, and enable better error reporting.

## Overview

The FS Rotations module system uses a standardized approach to module definitions, with clearly defined interfaces for different types of modules. This ensures that:

1. Modules implement all required functionality
2. Modules follow consistent patterns
3. Errors are detected early and reported clearly
4. Dependencies are properly managed

## Interface Types

The system supports multiple module types, each with specific interface requirements:

### Core Module Interface

Core modules provide fundamental functionality used by other modules.

#### Required Fields

- `on_update`: Function called on each update cycle (slower frequency)
- `on_fast_update`: Function called on each fast update cycle (higher frequency)
- `on_render_menu`: Function called when rendering the module's menu

#### Optional Fields

- `on_render`: Function called when rendering the module's visuals (optional)
- `settings`: Table defining module settings schema (optional)

#### Example

```lua
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
```

### Specialization Module Interface

Specialization modules implement class-specific rotation logic.

#### Required Fields

- `class_id`: Number representing the class identifier
- `spec_id`: Number representing the specialization identifier
- `on_update`: Function called on each update cycle to execute rotation logic
- `on_render_menu`: Function called when rendering the specialization menu
- `on_render_control_panel`: Function called when rendering the control panel

#### Optional Fields

- `on_render`: Function called when rendering specialization-specific visuals
- `settings`: Table defining specialization settings
- `on_reset`: Function called when the specialization should reset its state
- `on_combat_start`: Function called when entering combat
- `on_combat_end`: Function called when leaving combat

#### Example

```lua
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
```

### UI Module Interface

UI modules provide user interface components and visualizations.

#### Required Fields

- `on_render`: Function called when rendering the UI components
- `on_render_menu`: Function called when rendering the module's menu

#### Optional Fields

- `on_update`: Function called on each update cycle (optional)
- `on_fast_update`: Function called on each fast update cycle (optional)
- `settings`: Table defining UI settings schema (optional)

#### Example

```lua
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
```

### Data Module Interface

Data modules provide data collection, storage, and analysis functionality.

#### Required Fields

- `on_update`: Function called on each update cycle to collect and process data
- `get_data`: Function to retrieve data from the module

#### Optional Fields

- `on_fast_update`: Function called on each fast update cycle (optional)
- `on_render_menu`: Function called when rendering the module's menu (optional)
- `on_render`: Function called when rendering data visualizations (optional)
- `reset`: Function to reset the module's data (optional)

#### Example

```lua
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
```

## Validation System

The module interface system uses a comprehensive validation approach:

1. **Registry-Based Interface Definitions**: Each interface type is registered with validation rules
2. **Field-Level Validation**: Each required and optional field has specific validation rules
3. **Type Checking**: Validates that fields have the correct data types
4. **Dependency Validation**: Ensures required dependencies are available before loading
5. **Error Reporting**: Clear error messages with component context for debugging

## Using Module Interfaces

### Implementing a Module

When implementing a module, you should:

1. Determine which interface type your module should implement
2. Ensure all required fields are implemented
3. Add optional fields as needed
4. Return the module table from your entry point file

### Registering a Module

To register a module:

1. For core modules, add it to the `required_modules` table in `entry/load_required_modules.lua`
2. For specialization modules, add it to the `spec_module_registry` in `entry/spec_module_registry.lua`

### Validating a Module

The system automatically validates modules during loading. If you want to manually validate a module:

```lua
local valid, error_message = FS.module_interface:validate(
    module_table,
    "interface_type",
    "component_name"
)

if not valid then
    -- Handle validation failure
    core.log_error(error_message)
end
```

## Best Practices

1. **Complete Implementation**: Ensure all required fields are implemented
2. **Clear Separation**: Keep different functionality in separate fields
3. **Consistent Parameters**: Use consistent parameter patterns across related methods
4. **Error Handling**: Add error handling in all callback functions
5. **Documentation**: Document complex functionality with comments
6. **Type Annotations**: Use LuaDoc annotations for better IDE support

## Extending the Interface System

To add a new interface type:

1. Create a function in `core/module_interface.lua` to define the interface
2. Add the interface to the `init` function's registration list
3. Update documentation in this file