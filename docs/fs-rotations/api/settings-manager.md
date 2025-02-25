# Settings Manager

The Settings Manager is a centralized system for managing, validating, and observing settings changes across all modules in the FS Rotations plugin. It provides a unified interface for accessing settings with built-in validation, default values, and change notifications.

## Key Features

- **Centralized Registry**: All settings are registered in a single location
- **Validation**: Built-in validation with configurable rules for each setting
- **Change Notifications**: Subscribe to setting changes with callback functions
- **Type Safety**: Enforced type checking for all settings
- **Default Values**: Fallback to default values when settings are invalid
- **UI Integration**: Automatic integration with menu elements
- **Legacy Compatibility**: Works alongside the existing settings system

## Architecture

The Settings Manager consists of four main components:

1. **Settings Manager** (`FS.settings_manager`): Core registry and validation logic
2. **Settings Interface** (`FS.settings_interface`): Bridge to legacy settings system
3. **Settings Validation** (`FS.settings_validation`): Real-time validation for menu elements
4. **Settings Menu** (`FS.settings_menu`): UI for viewing and managing settings

## Usage Examples

### Registering Settings

```lua
-- Register a single setting
FS.settings_manager:register(
    "my_module",                 -- Module name
    "hp_threshold",              -- Setting name
    function() return menu.slider:get() / 100 end, -- Getter function
    FS.settings_manager.TYPES.PERCENT,       -- Setting type
    { min = 0, max = 100 },      -- Options (optional)
    0.85                         -- Default value (optional)
)

-- Register all settings from a module with automatic type detection
FS.settings_interface:register_module("my_module", FS.my_module.settings)
```

### Accessing Settings

```lua
-- Get a setting value with validation
local threshold = FS.settings_manager:get("my_module", "hp_threshold", 0.85)

-- Legacy-compatible access (works with both systems)
local threshold = FS.my_module.settings.hp_threshold()
```

### Change Notifications

```lua
-- Add a listener for setting changes
FS.settings_manager:add_listener(
    "my_module", 
    "hp_threshold", 
    function(new_value)
        print("Threshold changed to: " .. tostring(new_value))
    },
    "my_listener_id" -- Optional ID for later removal
)

-- Remove a listener
FS.settings_manager:remove_listener("my_module", "hp_threshold", "my_listener_id")
```

### Validation

```lua
-- Validate a setting value
local is_valid = FS.settings_manager:validate("my_module", "hp_threshold", 0.75)

-- Register validation for a menu element
FS.settings_validation:register_hook(
    my_slider,         -- Menu element
    "my_module",       -- Module name
    "hp_threshold",    -- Setting name
    function(value)    -- Optional custom validator
        return value >= 0 and value <= 1
    }
)
```

## Setting Types

The Settings Manager supports the following types:

- `NUMBER`: General numeric value
- `BOOLEAN`: True/false value
- `STRING`: Text value
- `PERCENT`: Percentage value (0-100)
- `INTEGER`: Whole number
- `FLOAT`: Decimal number
- `ENUM`: String value from a predefined list

Each type has appropriate validation rules:

```lua
-- Number with min/max
{ type = FS.settings_manager.TYPES.NUMBER, options = { min = 0, max = 100 } }

-- Boolean
{ type = FS.settings_manager.TYPES.BOOLEAN }

-- String with allowed values
{ type = FS.settings_manager.TYPES.STRING, options = { allowed_values = {"option1", "option2"} } }

-- Percentage
{ type = FS.settings_manager.TYPES.PERCENT }

-- Enum
{ type = FS.settings_manager.TYPES.ENUM, options = { allowed_values = {"option1", "option2"} } }
```

## Integration with Menu Elements

The Settings Manager integrates with the menu system to provide real-time validation:

1. Menu elements are registered with corresponding settings
2. Validation occurs when values change in the UI
3. Invalid values are rejected with error messages
4. Setting changes trigger registered callbacks

## Benefits

- **Consistency**: All settings follow the same validation rules
- **Error Reduction**: Catches invalid settings before they cause issues
- **Centralized Management**: View all settings in one place
- **Reactivity**: Components can respond to setting changes
- **Maintainability**: Clear separation of UI and logic

## Best Practices

1. Always register settings with appropriate types and validation
2. Use the settings manager for accessing settings values
3. Leverage change notifications for reactive behavior
4. Provide meaningful default values
5. Use consistent naming conventions for settings

## API Reference

### FS.settings_manager

- `register(module_name, setting_name, getter, setting_type, options, default_value)`: Register a setting
- `get(module_name, setting_name, default_value)`: Get a setting value with validation
- `validate(module_name, setting_name, value)`: Validate a setting value
- `add_listener(module_name, setting_name, listener, listener_id)`: Add a change listener
- `remove_listener(module_name, setting_name, listener_id)`: Remove a change listener
- `notify_change(module_name, setting_name, value)`: Notify listeners of a change
- `list_settings(module_filter)`: List all registered settings
- `get_default(module_name, setting_name)`: Get default value for a setting

### FS.settings_interface

- `register_module(module_name, settings_table, mappings)`: Register all settings from a module
- `generate_mappings(settings_table)`: Generate type mappings based on naming conventions
- `create_compatible_getters(module_table, module_name)`: Create legacy-compatible getters

### FS.settings_validation

- `register_hook(menu_elem, module_name, setting_name, validator)`: Register validation for a menu element
- `register_module_hooks(module_name, menu_table, mappings)`: Register validation for all menu elements in a module