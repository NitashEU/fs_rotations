# Modules Knowledge

## Overview
Core modules providing shared functionality across the system.

## Key Interfaces

### Module Base
```lua
---@class base_module
---@field public on_update fun(): nil
---@field public on_fast_update fun()?: nil
---@field public on_render fun()?: nil
---@field public on_render_menu fun()?: nil
```

### Module Config
```lua
---@class module_config
---@field public settings table<string, function>
---@field public variables table<string, function>
---@field public menu table<string, any>
```

## Components

### Heal Engine
- Target selection algorithms
- Health tracking and prediction
- Damage intake analysis
- Cluster healing optimization

## Best Practices
- Follow ModuleConfig interface
- Handle state cleanup
- Cache calculations
- Use consistent error handling
