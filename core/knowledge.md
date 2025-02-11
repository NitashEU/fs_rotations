# Core Systems Knowledge

## UI Guidelines

### Window Styling
- Set window properties before begin():
  1. Set background gradient
  2. Set initial size
  3. Set padding
- Use consistent colors:
  - Background gradient: (20,20,31,255) to (31,31,46,255)
  - Window background: Semi-transparent (20,20,31,200)
  - Text: White (255,255,255,255)
  - Separators: Light purple (77,77,102,255)
- Standard spacing:
  - Window padding: 15px
  - Header spacing: 36px
  - Column spacing: 400px
  - Content line spacing: 64px for bounds

### Menu Helpers
- render_header: Consistent header styling and spacing
- begin_columns: Two-column layout with proper alignment
- render_settings_section: Group related settings with header
- setup_window: Apply standard window styling

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
