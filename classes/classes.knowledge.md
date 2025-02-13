# Classes Knowledge

## Overview
Contains class-specific implementations for supported WoW classes. Each specialization follows a standardized module structure for consistency and maintainability.

## Key Interfaces

### Class Module
```lua
---@class class_module
---@field public spec_id number -- Specialization identifier
---@field public class_id number -- Class identifier
---@field public settings table<string, function> -- Configuration getters
---@field public variables table<string, function> -- Runtime state
---@field public talents table<number, boolean> -- Selected talents
```

### Spec Configuration
```lua
---@class SpecConfig
---@field spec_id number -- Spec identifier
---@field class_id number -- Class identifier
---@field on_update function(delta_time: number) -- Main update loop
---@field on_render function() -- Visual updates
---@field on_render_menu function() -- Settings UI
---@field on_render_control_panel function() -- Control panel UI
```

## Directory Structure
```
classes/
├── knowledge.md
└── {class_name}/
    ├── knowledge.md
    └── {spec_name}/
        ├── bootstrap.lua     # Module initialization and config
        ├── drawing.lua       # Visualization and UI rendering
        ├── index.lua         # Module entry point and imports
        ├── menu.lua          # Settings UI configuration
        ├── settings.lua      # Settings getters and defaults
        ├── variables.lua     # Runtime state management
        ├── ids/             # Constants and spell IDs
        └── logic/           # Core rotation implementation
```

## Implementation Guidelines

### Module Organization
1. Keep rotation logic separate from spell implementations
2. Use settings.lua for all configurable values
3. Implement variables.lua for runtime state tracking
4. Centralize IDs in ids/ directory
5. Handle visualization in drawing.lua

### Settings Best Practices
1. All thresholds should be percentage-based (0-100)
2. Group related settings (e.g., by spell)
3. Use descriptive names for menu items
4. Provide tooltips for complex options
5. Implement proper validation

### State Management
1. Cache frequently accessed values
2. Track buff/debuff states
3. Monitor resource levels
4. Handle proc conditions
5. Track cooldown states

### Rotation Implementation
1. Implement proper priority system
2. Handle movement conditions
3. Support toggle states
4. Track GCD alignment
5. Manage resource pooling

### Cleanup & Reset
1. Clear cached values
2. Reset state trackers
3. Handle spec switches
4. Clean up UI elements
5. Remove buff monitors

## Integration Points
- Menu system via menu.lua
- Core API through FS.api
- Buff tracking via buff_manager
- Spell queueing through spell_queue
- Target selection via target_selector

## Testing Guidelines
1. Verify settings persistence
2. Test rotation priority
3. Validate buff tracking
4. Check resource management
5. Monitor performance impact

## Supported Classes

### Paladin
Core class implementation providing systems for Holy specialization with extensibility for future specs.

#### Base Interface
```lua
---@class paladin_base
---@field public holy_power fun(): number Current Holy Power resource level
---@field public buff_up fun(aura_id: number): boolean Check if specific aura is active
---@field public buff_remains fun(aura_id: number): number Remaining duration of aura
---@field public talent_selected fun(talent_id: number): boolean Check if talent is selected
---@field public get_active_seals fun(): table<number> Get currently active seals
```

#### Core Systems
1. Resource Management
   - Holy Power and Mana management
   - Specialization resources
   - Cooldown tracking

2. Combat Systems
   - Role fulfillment and target prioritization
   - Position and movement optimization

3. Utility Systems
   - Blessings and Auras
   - Crowd control and group support

#### Available Specializations
1. Holy
   - Healing focus with resource optimization
   - Group coordination and position management

#### Planned Specializations
- Protection
- Retribution
