# Integration Patterns

## Overview
This document outlines the implementation patterns and integration approaches used in the project, with a focus on class/spec module organization and the menu system.

## Class/Spec Module Pattern

### Directory Structure
```
classes/[class]/[spec]/
├── index.lua        # Main entry point
├── bootstrap.lua    # Initialization
├── drawing.lua      # UI/Drawing related code
├── menu.lua         # Menu definitions
├── settings.lua     # Configuration
├── ids/            # Game constants
│   ├── index.lua   # Constants entry point
│   ├── auras.lua   # Buff/debuff IDs
│   ├── spells.lua  # Spell IDs
│   └── talents.lua # Talent IDs
└── logic/          # Core functionality
    ├── index.lua   # Main logic
    ├── spells/     # Spell implementations
    │   ├── index.lua
    │   └── [spell].lua
    └── rotations/  # Rotation implementations
        ├── index.lua
        └── [rotation].lua
```

### Module Integration Pattern

```lua
-- index.lua - Main entry point
require("classes/[class]/[spec]/drawing")
require("classes/[class]/[spec]/menu")
require("classes/[class]/[spec]/settings")
require("classes/[class]/[spec]/ids/index")
require("classes/[class]/[spec]/logic/index")
```

### Menu System Integration

```lua
-- menu.lua
local tag = "[class]_[spec]_"
local name = "[Class] [Spec]"

FS.[class]_[spec].menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind([id], false, tag .. "enable_toggle"),
}

---@type on_render_menu
function FS.[class]_[spec].menu.on_render_menu()
    FS.[class]_[spec].menu.main_tree:render(name, function()
        FS.[class]_[spec].menu.enable_toggle:render("Enable Script")
    end)
end

---@type on_render_control_panel
function FS.[class]_[spec].menu.on_render_control_panel(control_panel)
    FS.menu.insert_toggle(control_panel, FS.[class]_[spec].menu.enable_toggle, name)
    return control_panel
end
```

### Settings Pattern

```lua
-- settings.lua
FS.[class]_[spec].settings = {
    ---@type fun(): boolean
    is_enabled = function() 
        return FS.settings.is_toggle_enabled(FS.[class]_[spec].menu.enable_toggle) 
    end,
}
```

### Constants Organization

```lua
-- ids/index.lua
require("classes/[class]/[spec]/ids/auras")
require("classes/[class]/[spec]/ids/spells")
require("classes/[class]/[spec]/ids/talents")

-- ids/spells.lua
FS.[class]_[spec].spells = {
    -- Spell definitions
}

-- ids/auras.lua
FS.[class]_[spec].auras = {
    -- Aura definitions ordered alphabetically
}

-- ids/talents.lua
FS.[class]_[spec].talents = {
    -- Talent definitions using core.spell_book.is_spell_learned
}
```

### Rotation Implementation Pattern

```lua
-- logic/rotations/[rotation].lua
---@return boolean
function FS.[class]_[spec].logic.rotations.[rotation]()
    -- Check rotation conditions
    if not FS.[class]_[spec].variables.[condition]() then
        return false
    end
    
    -- Execute rotation priority
    if FS.[class]_[spec].logic.spells.[spell1]() then
        return true
    end
    if FS.[class]_[spec].logic.spells.[spell2]() then
        return true
    end
    return true
end
```

### Spell Implementation Pattern

```lua
-- logic/spells/[spell].lua
---@return boolean
function FS.[class]_[spec].logic.spells.[spell]()
    -- Get valid target
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end
    
    -- Check spell can be cast
    if not FS.api.spell_helper:is_spell_queueable(FS.[class]_[spec].spells.[spell], FS.variables.me, target, false, false) then
        return false
    end
    
    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.[class]_[spec].spells.[spell], target, 1)
    return true
end
```

### Variables and Buff Management Pattern
```lua
-- variables.lua
FS.[class]_[spec].variables = {
    -- Resources first
    resource_name = function() return FS.variables.resource(enums.power_type.RESOURCE) end,
    -- Then buffs in alphabetical order
    buff_one_up = function() return FS.variables.buff_up(FS.[class]_[spec].auras.buff_one) end,
    buff_two_remains = function() return FS.variables.buff_remains(FS.[class]_[spec].auras.buff_two) end
}

-- Important Notes:
-- 1. Always use FS.variables functions for consistency (buff_up, buff_remains, etc.)
-- 2. Keep resources first, then buffs in alphabetical order
-- 3. buff_remains returns time in milliseconds, convert when comparing (e.g., 4 seconds = 4000ms)
```

## Best Practices

### 1. Namespace Convention
- Use consistent FS.[class]_[spec] namespace
- Keep all related components under the same namespace
- Use clear, descriptive names for components

### 2. Type Annotations
- Use ---@type annotations for function signatures
- Document parameter types and return values
- Maintain consistent type usage across modules

### 3. Menu Organization
- Group related toggles logically
- Use consistent naming for menu items
- Implement both menu and control panel rendering
- Follow established toggle patterns

### 4. Code Structure
- Maintain clear separation of concerns
- Group related functionality in appropriate files
- Use consistent file organization across specs
- Keep modules focused and single-purpose

### 5. Constants Management
- Organize game-specific constants by type
- Use separate files for different constant categories
- Maintain clear constant naming conventions
- Document constant purposes and usage
- Keep auras and other constants ordered alphabetically

### 6. Rotation Management
- Separate rotations into individual files
- Clear priority system implementation
- Proper condition checking
- Efficient spell queueing

### 7. Buff Tracking
- Use FS.variables functions for consistency
- Keep buff checks in variables.lua
- Remember buff_remains returns milliseconds
- Proper buff condition handling

## Common Pitfalls

### 1. Namespace Collisions
- Avoid global namespace pollution
- Use full namespacing for all components
- Check for naming conflicts

### 2. Menu Integration
- Ensure proper toggle initialization
- Handle menu state persistence
- Validate menu item uniqueness
- Check for duplicate keybinds

### 3. Module Dependencies
- Maintain clear require order
- Handle circular dependencies
- Document module relationships
- Ensure proper initialization order

### 4. Type Safety
- Validate function parameters
- Check return values
- Handle edge cases
- Maintain type consistency

### 5. Rotation Implementation
- Avoid hardcoded priorities
- Handle missing targets gracefully
- Proper resource management
- Clear rotation conditions

### 6. Time Units
- Remember buff_remains returns milliseconds
- Convert time units appropriately (e.g., 4 seconds = 4000ms)
- Document time unit expectations in comments

## Future Considerations

### 1. Extensibility
- Design for easy spec additions
- Plan for new feature integration
- Maintain backward compatibility
- Document extension points

### 2. Maintenance
- Regular pattern review
- Update documentation
- Remove deprecated code
- Maintain consistent style

### 3. Testing
- Validate integration points
- Test edge cases
- Monitor performance
- Verify state management