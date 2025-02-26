# Validation Library

The validation library provides a standardized way to validate function parameters, settings, and other values throughout the codebase. It integrates with the error handler system to provide consistent error reporting.

## Basic Usage

```lua
-- Simple parameter validation
local component = "my_component.function_name"
if not FS.validator.check_number(value, "parameter_name", 0, 100, component) then
    return nil -- or other appropriate error handling
end

-- Checking if a parameter is required
if not FS.validator.check_required(value, "parameter_name", component) then
    return nil
end

-- Setting default values
value = FS.validator.default(value, default_value)
```

## Available Validation Functions

### Type Validation

* `check_number(value, name, min, max, component)` - Validates that a value is a number and optionally within a range
* `check_string(value, name, allowed_values, component)` - Validates that a value is a string and optionally one of allowed values
* `check_table(value, name, component)` - Validates that a value is a table
* `check_table_keys(value, name, required_keys, component)` - Validates that a table has required keys
* `check_function(value, name, component)` - Validates that a value is a function
* `check_boolean(value, name, allow_nil, component)` - Validates that a value is a boolean or nil if allowed
* `check_game_object(value, name, component)` - Validates that a value is a valid game object

### Special Validation Functions

* `check_required(value, name, component)` - Validates that a value is not nil
* `check_percent(value, name, component)` - Validates that a value is a number between 0-100

### Utility Functions

* `default(value, default_value)` - Returns the value or default if value is nil
* `validate_params(params, validations, component)` - Validates multiple parameters using a validation map

## Component Auto-Detection

If no component name is provided to validation functions, the library will attempt to detect the component name from the call stack. However, it's recommended to provide an explicit component name for clearer error messages.

## Integration with Error Handler

All validation functions integrate with the error handler system to report errors and potentially disable problematic components:

```lua
-- The error handler is called internally by validation functions
if not FS.validator.check_number(value, "parameter_name", 0, 100, component) then
    -- At this point, FS.error_handler:record has already been called
    return nil
end
```

## Best Practices

1. **Always validate required parameters first**
   ```lua
   if not FS.validator.check_required(param1, "param1", component) or
      not FS.validator.check_required(param2, "param2", component) then
      return nil
   end
   ```

2. **Use type-specific validation functions**
   ```lua
   -- Instead of:
   if type(value) ~= "number" or value < 0 or value > 100 then
       -- error handling
   end
   
   -- Use:
   if not FS.validator.check_number(value, "value", 0, 100, component) then
       return nil
   end
   ```

3. **Set default values consistently**
   ```lua
   param = FS.validator.default(param, false)
   ```

4. **Validate settings from config**
   ```lua
   local threshold = FS.config:get("module.setting", 50)
   if not FS.validator.check_percent(threshold, "threshold", component) then
       return false
   end
   ```

5. **Use percent validation for health thresholds**
   ```lua
   if not FS.validator.check_percent(hp_threshold, "hp_threshold", component) then
       return nil
   end
   ```

## Example Usage in Spell Implementation

```lua
function FS.class_spec.logic.spells.example_spell()
    local component = "class_spec.spells.example_spell"
    
    -- Early exit if not castable
    if not FS.api.spell_helper:is_spell_queueable(FS.class_spec.spells.example_spell, FS.variables.me, FS.variables.me, true, true) then
        return false
    end

    -- Get and validate settings
    local hp_threshold = FS.class_spec.settings.example_spell_threshold()
    if not FS.validator.check_percent(hp_threshold, "hp_threshold", component) then
        return false
    end
    
    -- Get target
    local target = FS.modules.heal_engine.get_single_target(
        hp_threshold,
        FS.class_spec.spells.example_spell,
        true,   -- skip_facing
        false   -- don't skip range
    )

    if not target then
        return false
    end

    FS.api.spell_queue:queue_spell_target(FS.class_spec.spells.example_spell, target, 1)
    return true
end
```

## Example Usage in API Function

```lua
---Get a clustered healing target optimized for AOE healing
---@param hp_threshold number Maximum health percentage to consider for healing targets (0-100)
---@param spell_id number ID of the healing spell to check castability
---@param radius number Radius of the AOE healing effect in yards
---@param min_targets number Minimum number of targets to consider a valid cluster
---@param skip_facing boolean Whether to skip facing requirement check
---@param skip_range boolean Whether to skip range requirement check
---@return game_object|nil target The central target for AOE healing, or nil if no valid target found
function FS.modules.heal_engine.get_clustered_heal_target(hp_threshold, spell_id, radius, min_targets, skip_facing, skip_range)
    local component = "heal_engine.get_clustered_heal_target"
    
    -- Validate required parameters
    if not FS.validator.check_required(hp_threshold, "hp_threshold", component) or
       not FS.validator.check_required(spell_id, "spell_id", component) or
       not FS.validator.check_required(radius, "radius", component) then
        return nil
    end
    
    -- Validate parameter types and ranges
    if not FS.validator.check_percent(hp_threshold, "hp_threshold", component) or
       not FS.validator.check_number(spell_id, "spell_id", nil, nil, component) or
       not FS.validator.check_number(radius, "radius", 0, nil, component) then
        return nil
    end
    
    -- Set defaults for optional parameters
    min_targets = FS.validator.default(min_targets, 1)
    skip_facing = FS.validator.default(skip_facing, false)
    skip_range = FS.validator.default(skip_range, false)
    
    -- Validate optional parameters
    if not FS.validator.check_number(min_targets, "min_targets", 1, nil, component) or
       not FS.validator.check_boolean(skip_facing, "skip_facing", false, component) or
       not FS.validator.check_boolean(skip_range, "skip_range", false, component) then
        return nil
    end
    
    -- Function implementation...
end
```