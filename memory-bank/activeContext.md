# Menu System Cleanup Plan

## Current Issues
1. Duplicate window setup code between settings and weights windows
2. Complex manual offset calculations in settings window
3. Inconsistent layout management
4. Complex group handling

## Planned Improvements

### 1. Common Window Functions
Extract shared window setup logic into helper functions:
```lua
local function setup_window(window)
    -- Set gradient background
    -- Set initial size
    -- Set padding
end

local function render_header(window, text)
    -- Consistent header rendering with proper spacing
end
```

### 2. Simplified Layout System
- Replace manual offset calculations with cleaner column system
- Improve group management for settings window
- Standardize spacing and alignment

### 3. Modular Window Components
Break down window rendering into focused functions:
```lua
local function render_settings_window()
    -- Left column: Holy Shock, Word of Glory
    -- Right column: Divine Toll, Beacon, Holy Prism, Light of Dawn
end

local function render_weights_window()
    -- Left column: Divine Toll weights
    -- Right column: Beacon of Virtue weights
end
```

### 4. Implementation Strategy
1. Extract common window setup code
2. Implement cleaner layout system
3. Refactor settings window rendering
4. Refactor weights window rendering
5. Add proper spacing and alignment

## Next Steps
Switch to Code mode to implement these improvements while maintaining all existing functionality.