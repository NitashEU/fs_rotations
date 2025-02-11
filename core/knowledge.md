# Core Systems Knowledge

## Overview
Core functionality and shared systems for the rotation framework.

## Key Interfaces

### Settings Interface
```lua
---@class core_settings
---@field public is_enabled fun(): boolean
---@field public min_delay fun(): number
---@field public max_delay fun(): number
---@field public jitter table<string, function>
```

### Variables Interface
```lua
---@class core_variables
---@field public me game_object
---@field public resource fun(power_type: number): number
---@field public buff_up fun(aura_id: number): boolean
---@field public buff_remains fun(aura_id: number): number
---@field public aura_up fun(aura_id: number): boolean
```

### Humanizer Interface
```lua
---@class humanizer
---@field public can_run fun(): boolean
---@field public update fun(): nil
---@field public get_delay fun(): number
```

## Components

### API Integration
- Wraps game API functionality
- Provides typed interfaces
- Manages core system access

### Humanizer
- Adds realistic delays and jitter
- Prevents detection
- Configurable timing parameters

### Settings
- Centralized configuration
- Consistent getter patterns
- Debug options

### Variables
- Shared state management
- Cross-module communication
- Runtime configuration

## Best Practices
- Use consistent error handling
- Cache frequently accessed values
- Clean up resources in resets
- Follow type definitions
