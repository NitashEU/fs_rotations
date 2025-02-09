# Product Context

## Project Overview
This is a Lua-based project that provides various game-related functionalities through a structured API interface system, specifically designed for PvE scenarios. The system offers comprehensive tools for unit management, spell handling, geometry calculations, and UI interactions.

## Memory Bank Structure
The project's documentation is organized in the `memory-bank/` directory:
- `productContext.md` - Project overview and structure
- `apiReference.md` - Comprehensive API documentation
- `activeContext.md` - Current status and next steps
- `integrationPatterns.md` - PvE integration examples and best practices

## Code Organization Patterns

### Class/Spec Structure
```
classes/
└── [class]/
    └── [spec]/
        ├── index.lua        # Main entry point, requires all components
        ├── bootstrap.lua    # Initialization
        ├── drawing.lua      # UI/Drawing related code
        ├── menu.lua         # Menu definitions and callbacks
        ├── settings.lua     # Configuration and settings
        ├── ids/            # Game-specific constants
        │   ├── index.lua   # Requires all ID files
        │   ├── auras.lua   # Aura/buff IDs
        │   ├── spells.lua  # Spell IDs
        │   └── talents.lua # Talent IDs
        └── logic/          # Core functionality
            └── index.lua   # Logic implementation
```

### Coding Patterns

#### 1. Namespace Convention
- Uses `FS.[class]_[spec]` namespace for all components
- Example: `FS.paladin_holy.settings`, `FS.paladin_holy.menu`

#### 2. Menu System
```lua
local tag = "[class]_[spec]_"
local name = "[Class] [Spec]"

FS.[class]_[spec].menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind([id], false, tag .. "enable_toggle"),
}
```

#### 3. Settings Pattern
```lua
FS.[class]_[spec].settings = {
    ---@type fun(): boolean
    is_enabled = function() return FS.settings.is_toggle_enabled(FS.[class]_[spec].menu.enable_toggle) end,
}
```

#### 4. Callback Implementation
- Clear type annotations using ---@type
- Consistent naming: on_render_menu, on_render_control_panel, etc.
- Return values documented and typed

#### 5. Constants Organization
- Separated by type (spells, auras, talents)
- Centralized in ids/ directory
- Each type in its own file for maintainability

## API Structure

### Core APIs
- `core.lua` - Core functionality
- `game_object.lua` - Game object handling
- `menu.lua` - Menu system interface

### Common Modules
Located in `_api/common/`:

#### Base Systems
- `enums.lua` - Enumeration definitions
- `unit_manager.lua` - Unit management system

#### Geometry
Located in `_api/common/geometry/`:
- `geometry.lua` - General geometry utilities
- `vec2.lua` - 2D vector operations
- `vec3.lua` - 3D vector operations

#### Modules
Located in `_api/common/modules/`:
- `buff_manager.lua` - Buff management system
- `spell_queue.lua` - Spell queueing system

#### Utility Helpers
Located in `_api/common/utility/`:
- `control_panel_helper.lua` - Control panel interface
- `dungeons_helper.lua` - Dungeon-specific utilities
- `inventory_helper.lua` - Inventory management
- `key_helper.lua` - Key input handling
- `plugin_helper.lua` - Plugin system utilities
- `spell_helper.lua` - Spell system utilities
- `ui_buttons_info.lua` - UI button information
- `unit_helper.lua` - Unit manipulation utilities

## Design Philosophy
1. **PvE Focus**
   - Optimized for PvE scenarios
   - Efficient unit and resource management
   - Clear and predictable behavior patterns

2. **Modularity**
   - Clear separation of concerns
   - Independent but integrable components
   - Consistent interface design

3. **Performance**
   - Efficient resource usage
   - Appropriate caching strategies
   - Optimized calculations

4. **Maintainability**
   - Comprehensive documentation
   - Clear code organization
   - Consistent naming conventions
   - Type annotations for function signatures