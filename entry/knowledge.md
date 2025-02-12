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
---@field class_id number
---@field spec_id number
---@field on_update function()
---@field on_render function()
---@field on_render_menu function()
---@field on_render_control_panel function(control_panel)
```

#### ModuleConfig Interface
```lua
---@class ModuleConfig
---@field on_update function()
---@field on_fast_update function()
---@field on_render function()
---@field on_render_menu function()
```

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
Currently implemented specs include:
- Warriors (Arms, Fury, Protection)
- Paladins (Holy, Protection, Retribution)
- Hunters (Beast Mastery, Marksmanship, Survival)
- Rogues (Assassination, Outlaw, Subtlety)
- Priests (Discipline, Holy, Shadow)
- Death Knights (Blood, Frost, Unholy)
- Shamans (Elemental, Enhancement, Restoration)
- Mages (Arcane, Fire, Frost)
- Warlocks (Affliction)

Note: Currently, only Holy Paladin is marked as an allowed spec.

## Error Handling
- Module loading failures are caught and logged
- Spec validation prevents unsupported spec execution
- Graceful fallbacks for missing components

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
