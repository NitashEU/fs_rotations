# System Patterns

## Code Organization Patterns

### Module Structure
```lua
FS.[module_name] = {
    settings = {},  -- Module settings
    menu = {},      -- Menu configuration
    variables = {}, -- State tracking
    logic = {}     -- Core functionality
}
```

### Rotation Logic Pattern
```lua
function FS.[spec_name].logic.rotations.[rotation_type]()
    -- Priority-based checks
    if [condition_1]() then
        return true
    end
    if [condition_2]() then
        return true
    end
    return false
end
```

### Spell Logic Pattern
```lua
function FS.[spec_name].logic.spells.[spell_name]()
    -- Target validation
    local target = FS.variables.[target_type]()
    if not target then
        return false
    end
    
    -- Spell cast validation
    if not FS.api.spell_helper:is_spell_queueable([spell_id], [caster], target, false, false) then
        return false
    end
    
    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target([spell_id], target, [priority])
    return true
end
```

## Core System Patterns

### Settings Management
- Centralized settings in core/settings.lua
- Consistent access patterns through FS.settings
- Type-safe configuration with clear defaults
- Standardized toggle handling

### Menu System
- Hierarchical menu structure
- Consistent naming conventions
- Standardized control panel integration
- Unified keybind management

### Variable Tracking
- Cached state management
- Clear update patterns
- Consistent access methods
- Efficient memory usage

### API Integration
- Modular API structure
- Consistent error handling
- Clear dependency management
- Standardized module exports

## Heal Engine Patterns

### Health Tracking
- Regular health state updates
- Efficient value caching
- Clear data structure patterns
- Historical data management

### Damage Prediction
- Historical data analysis
- Pattern-based prediction
- Efficient data storage
- Priority-based processing

### Memory Management
- Efficient data structures
- Clear cleanup patterns
- Resource optimization
- Cache management

## Documentation Patterns

### Memory Bank Structure
- Clear file organization
- Consistent update patterns
- Comprehensive tracking
- Version management

### Code Documentation
- Standard comment formats
- Clear function documentation
- Pattern documentation
- Implementation notes

## Best Practices
1. Consistent error handling
2. Clear module boundaries
3. Standard naming conventions
4. Efficient state management
5. Modular design patterns
6. Regular documentation updates
7. Performance optimization
8. Resource management
9. Clear dependency tracking
10. Maintainable architecture