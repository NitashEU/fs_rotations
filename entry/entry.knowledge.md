# Entry System Knowledge

## Overview
The entry system serves as the initialization and bootstrapping layer for the entire rotation framework. It manages spec detection, module loading, and establishes core event hooks that drive the rotation logic.

## Core Components

### 1. Entry Helper System
```lua
FS.entry_helper = {
    class_spec_map,    -- Maps spec IDs to module paths
    allowed_specs,     -- Supported specializations (currently only Holy Paladin)
    init(),            -- Core initialization
    load_required_modules(), -- Core module loading
    load_spec_module(),     -- Spec-specific loading
    check_spec(),          -- Spec validation
    on_update(),          -- Main update loop
    on_render(),          -- Rendering hook
    on_render_menu(),     -- Menu rendering
    on_render_control_panel() -- Control panel UI
}
```

### 2. Module Loading System
The system loads modules in a specific sequence:
1. Required modules (core/modules/heal_engine/index)
2. Spec-specific modules based on class/spec mapping

### 3. Interfaces

#### SpecConfig Interface
```lua
---@class SpecConfig
---@field class_id number -- Class identifier from enums
---@field spec_id number -- Specialization identifier from enums
---@field on_update function() -- Main rotation update
---@field on_render function() -- Visual updates
---@field on_render_menu function() -- Settings UI
---@field on_render_control_panel function(control_panel) -- Control panel elements
```

#### ModuleConfig Interface
```lua
---@class ModuleConfig
---@field on_update function() -- Standard update cycle
---@field on_fast_update function()? -- Optional high-frequency updates
---@field on_render function()? -- Optional visual updates
---@field on_render_menu function()? -- Optional settings UI
```

## Implementation Guidelines

### Module Loading
- Use pcall for protected module loading
- Validate module interfaces after loading
- Initialize in correct order (core → required → spec)
- Handle loading failures gracefully

### Spec Validation
- Check class/spec combination against allowed_specs
- Validate spec_id matches current player spec
- Create default spec config if validation passes
- Return false and prevent loading if validation fails

### Update Cycle Management
- Check enabled state before updates
- Run fast updates first
- Verify humanizer timing
- Update player state
- Execute module updates in order
- Run spec-specific updates last

### UI Integration
- Render core menu elements first
- Allow modules to extend menu
- Handle spec-specific UI elements
- Maintain consistent styling

## Core Functionality

### 1. Initialization Pipeline
```lua
-- Entry point sequence
1. load_required_modules() -- Loads core dependencies
2. load_spec_module()      -- Loads specialization module
3. check_spec()           -- Validates current spec
```

### 2. Update Cycle
The main update cycle (`on_update`) includes:
1. Enabled check
2. Fast updates for modules
3. Humanizer timing check
4. Player state update
5. Module updates
6. Spec-specific updates

### 3. UI System
- Menu rendering with humanizer settings
- Control panel integration
- Spec-specific UI elements

## Class/Spec Support
Currently supported specs:
- Holy Paladin (fully implemented)

Future planned specs:
- Protection Paladin
- Retribution Paladin

Note: Other specs listed in class_spec_map are planned but not yet implemented.

## Error Handling
- Module loading failures are caught and logged
- Spec validation prevents unsupported spec execution
- Graceful fallbacks for missing components
- Protected calls for module updates

## Performance Considerations
- Humanizer implementation for action timing
- Fast update cycle for time-critical operations
- Normal update cycle for standard operations
- State caching for player data

## File Structure
```
entry/
├── callbacks/
│   ├── index.lua           -- Callback registration
│   ├── on_render.lua       -- Rendering hooks
│   ├── on_render_menu.lua  -- Menu system
│   ├── on_update.lua       -- Update cycle
│   └── on_render_control_panel.lua
├── interfaces/
│   ├── module_config.lua   -- Module interface
│   └── spec_config.lua     -- Spec interface
├── check_spec.lua          -- Spec validation
├── entry_helper.lua        -- Core utilities
├── index.lua              -- Module orchestration
├── init.lua               -- Initialization
├── load_required_modules.lua
└── load_spec_module.lua
```

## Best Practices

### Module Development
- Implement all required interface methods
- Handle state transitions properly
- Clean up resources when disabled
- Follow error handling patterns

### Spec Implementation
- Validate all required fields
- Implement optional methods as needed
- Handle spec-specific resources
- Clean up on spec changes

### Integration
- Follow module loading sequence
- Use protected calls for safety
- Handle all error cases
- Maintain UI consistency
