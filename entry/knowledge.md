# Entry System Knowledge

## Overview
Handles plugin initialization and module loading.

## Key Interfaces

### Module Config
```lua
---@class ModuleConfig
---@field public on_update fun(): nil
---@field public on_fast_update fun()?: nil
---@field public on_render fun()?: nil
---@field public on_render_menu fun()?: nil
```

### Spec Config
```lua
---@class SpecConfig
---@field public spec_id number
---@field public class_id number
---@field public on_update fun(): nil
---@field public on_render fun(): nil
---@field public on_render_menu fun(): nil
---@field public on_render_control_panel fun(control_panel: table): table
```

## Components

### Initialization
- Validates environment
- Loads required modules
- Sets up callbacks
- Initializes spec modules

### Interfaces
- ModuleConfig: Core module functionality
- SpecConfig: Class-specific implementation

### Callbacks
- on_update: Core rotation logic
- on_render: Visual feedback
- on_render_menu: Settings UI
- on_render_control_panel: Quick toggles

## Best Practices
- Handle module load failures gracefully
- Validate spec requirements
- Follow interface contracts
- Clean up on shutdown
