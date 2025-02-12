# Core Knowledge

## Overview
The core folder provides fundamental logic and utilities that every class or module relies on. It implements essential services through five main components: API integration, state management, action timing control, settings management, and UI rendering.

## System Architecture

### 1. API System (api.lua)
Centralized module access through `FS.api`:
```lua
FS.api = {
    buff_manager,      -- Track buffs and debuffs
    combat_forecast,   -- Predict combat states
    health_prediction, -- Forecast health changes
    spell_helper,      -- Validate spell states
    spell_queue,       -- Manage casting queue
    unit_helper,       -- Check unit states
    target_selector,   -- Select optimal targets
    plugin_helper,     -- Handle plugin lifecycle
    control_panel_helper, -- Manage UI panels
    key_helper         -- Handle input bindings
}
```

### 2. Variables System (variables.lua)
Core state management through `FS.variables`:
```lua
FS.variables = {
    me,              -- Local player object
    target,          -- Current target getter
    enemy_target,    -- Valid enemy target getter
    is_valid_enemy_target, -- Target validation
    buff_up,         -- Check buff presence
    buff_remains,    -- Get buff duration
    aura_up,         -- Check aura presence
    aura_remains,    -- Get aura duration
    resource         -- Get power resources
}
```

Key Features:
- Lazy evaluation through getter functions
- Automatic target validation
- Buff/debuff tracking
- Resource management
- Combat state validation

### 3. Humanizer System (humanizer.lua)
Sophisticated action timing with `FS.humanizer`:
```lua
FS.humanizer = {
    next_run,        -- Next action timestamp
    can_run,         -- Action availability check
    update,          -- Update timing state
}
```

Timing Features:
- Network-aware delays (1.5x ping)
- Configurable jitter system:
  - Base jitter: 5-30% randomization
  - Latency jitter: 1-20% based on ping
  - Maximum jitter cap: 10-50%
- Random delay distribution
- Normalized latency impact

### 4. Settings System (settings.lua)
Configuration management through `FS.settings`:
```lua
FS.settings = {
    is_enabled,      -- Global enable state
    min_delay,       -- Minimum action delay
    max_delay,       -- Maximum action delay
    jitter = {
        is_enabled,      -- Jitter toggle
        base_jitter,     -- Base randomization
        latency_jitter,  -- Network adjustment
        max_jitter       -- Upper bound
    },
    is_toggle_enabled -- Plugin toggle state
}
```

### 5. Menu System (menu.lua)
Advanced UI management through `FS.menu`:

Components:
- Window Management
  ```lua
  window_style = {
      background,    -- Gradient colors
      size,         -- Default dimensions
      padding,      -- Content spacing
      header_color, -- Text styling
      header_spacing,
      column_spacing
  }
  ```

UI Elements:
- Core Controls
  - Checkboxes (`checkbox`)
  - Sliders (`slider_int`, `slider_float`)
  - Keybinds (`keybind`)
  - Comboboxes (`combobox`, `combobox_reorderable`)
  - Color Pickers (`colorpicker`)
  - Text Input (`text_input`)
  - Headers (`header`)
  - Buttons (`button`)

Layout Features:
- Two-column system (`begin_columns`)
- Consistent headers (`render_header`)
- Settings sections (`render_settings_section`)
- Window styling (`setup_window`)

## Integration System

### Core Initialization (index.lua)
```lua
FS.modules = {}  -- Module registry
```

Required Components:
1. API integration
2. Humanizer system
3. Menu system
4. Settings management
5. Variable tracking

### Module Interface
```lua
---@class base_module
---@field public on_update fun(): nil
---@field public on_fast_update fun()?: nil
---@field public on_render fun()?: nil
---@field public on_render_menu fun()?: nil
```

## Implementation Guidelines

### State Management
- Use getter functions for dynamic values
- Validate game objects before use
- Handle invalid states gracefully
- Cache frequently accessed values

### Action Timing
- Check `humanizer.can_run()` before actions
- Update timing with `humanizer.update()`
- Consider network conditions
- Use appropriate jitter settings

### Settings Integration
- Access via `FS.settings` getters
- Use toggle state management
- Implement proper validation
- Handle plugin integration

### Menu Implementation
- Follow window style guidelines
- Use standard control creation
- Implement proper layouts
- Handle window management

## Best Practices

### Error Handling
- Validate all inputs
- Check object states
- Handle transitions
- Provide fallbacks

### Performance
- Use lazy evaluation
- Cache frequent calls
- Update appropriately
- Manage memory

### Integration
- Follow module patterns
- Use correct interfaces
- Implement callbacks
- Handle state properly
