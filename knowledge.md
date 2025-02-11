# Project Sylvanas Plugin Knowledge

## Overview
A plugin for Project Sylvanas WoW scripting platform providing Holy Paladin rotation and healing support.

## Key Interfaces

### Plugin Entry
```lua
---@class plugin_entry
---@field public init fun(): boolean
---@field public on_update fun(): nil
---@field public on_render fun(): nil
---@field public on_render_menu fun(): nil
---@field public on_render_control_panel fun(control_panel: table): table
```

### Core Systems
```lua
---@class core_systems
---@field public register_on_update_callback fun(callback: function): nil
---@field public register_on_render_callback fun(callback: function): nil
---@field public register_on_render_menu_callback fun(callback: function): nil
---@field public register_on_render_control_panel_callback fun(callback: function): nil
```

## Coding Guidelines

### File Structure
- Use consistent file naming: lowercase with underscores
- Group related functionality in subdirectories
- Keep files focused and single-purpose
- Place interfaces in dedicated files
- Maintain clear separation between modules

### Code Organization
- Place requires at top of file
- Group related functions together
- Order functions by dependency (callers before callees)
- Keep file size manageable (< 300 lines preferred)
- Use clear section comments for logical groupings

### Naming Conventions
- Functions: verb_noun format (e.g., get_health, update_state)
- Variables: noun_descriptor format (e.g., health_value, buff_duration)
- Constants: UPPER_CASE
- Use descriptive names that indicate purpose
- Prefix private functions with underscore

### Type Annotations
- Always use ---@type annotations for variables
- Document function parameters and returns
- Define interfaces for complex types
- Use consistent type naming (PascalCase)
- Include null/optional annotations where applicable

### Function Design
- Single responsibility principle
- Early returns for guard clauses
- Validate parameters at function start
- Return consistent types
- Document side effects in comments

### State Management
- Minimize global state
- Use getter functions for computed values
- Cache frequently accessed values
- Clear state in reset functions
- Document state dependencies

### Error Handling
- Check parameters validity
- Handle edge cases explicitly
- Use consistent error patterns
- Log meaningful error messages
- Fail fast and visibly

### Performance
- Cache computed values
- Minimize table creation in hot paths
- Use appropriate update frequencies
- Clean up resources properly
- Profile critical sections

### Comments and Documentation
- Document non-obvious logic
- Explain complex algorithms
- Include usage examples for APIs
- Keep comments current with code
- Use consistent comment style

### Testing and Debugging
- Add debug logging for complex logic
- Make code testable by design
- Include validation checks
- Support debug visualization
- Add performance monitoring

## Module Guidelines

### Settings
- Use consistent getter pattern
- Normalize value ranges
- Group related settings
- Include validation
- Document default values

### Menu System
- Follow tree structure pattern
- Group related controls
- Use consistent naming
- Include tooltips
- Support keyboard navigation

### Rotation Logic
- Separate spell logic from rotation
- Use priority system
- Handle edge cases
- Support multiple modes
- Include fallbacks

### Spell Implementation
- Validate requirements
- Check resources
- Handle cooldowns
- Support cancellation
- Include range checks

## Best Practices

### Code Quality
- Keep functions small and focused
- Avoid duplicate code
- Use meaningful names
- Document complex logic
- Follow consistent style

### Resource Management
- Clean up in reset functions
- Cache expensive operations
- Release resources properly
- Monitor memory usage
- Handle combat transitions

### Performance Optimization
- Profile before optimizing
- Cache frequent calculations
- Use appropriate data structures
- Batch operations when possible
- Monitor frame times

### Maintainability
- Write self-documenting code
- Keep dependencies clear
- Make changes reversible
- Support debugging
- Document assumptions

### Security
- Validate all inputs
- Handle edge cases
- Protect against exploits
- Log security events
- Follow safe patterns

## Plugin Architecture

### Entry System
- Main entry point through `main.lua` and `header.lua`
- Handles plugin initialization and registration
- Loads required modules and spec-specific code
- Manages callback system:
  - on_update: Core rotation and healing logic
  - on_fast_update: High-frequency health tracking
  - on_render: Visual feedback and debugging
  - on_render_menu: Settings UI
  - on_render_control_panel: Quick access toggles

### Core Systems

#### Heal Engine
- Core module for healing decisions and target selection
- Settings and configuration:
  - Configurable tracking windows (1s, 5s, 10s, 15s)
  - Debug logging options
  - Performance tuning parameters
- Health tracking:
  - Stores historical health values
  - Calculates damage taken per second
  - Cleans up old data periodically
- Combat management:
  - Tracks fight-wide statistics
  - Resets state on combat end
  - Logs significant health changes
- Target selection functions:
  - get_single_target: Priority-based single target healing
  - get_clustered_heal_target: Multi-target healing optimization
  - get_group_heal_target: Party/raid healing
  - get_enemy_clustered_heal_target: Enemy-based healing
  - get_tank_damage_target: Tank-specific healing
  - get_healer_damage_target: Healer-specific healing
- Damage tracking:
  - Multiple time windows (1s, 5s, 10s, 15s)
  - Historical data management
  - Automatic cleanup of old values
- Performance optimizations:
  - Health value caching
  - Periodic data cleanup
  - Configurable update frequencies
  - Efficient target filtering

#### Module System
- Modular architecture with clear interfaces
- Each module follows ModuleConfig interface
- Supports on_update, on_fast_update, and rendering callbacks
- Modules loaded through entry/load_required_modules.lua
- Modules can define their own menu, settings, and drawing functions

#### Settings System
- Centralized settings management
- Consistent getter patterns for all settings
- Support for:
  - Boolean toggles
  - Integer sliders
  - Float sliders
  - Keybinds
  - Tree nodes for organization
- Debug and logging configuration
- Performance tuning options

### API Integration
- Utilizes Sylvanas core API modules:
  - spell_helper: Spell casting validation and checks
  - unit_helper: Unit targeting and filtering
  - buff_manager: Buff/debuff tracking
  - spell_queue: Spell casting management
  - color: UI and visual feedback
  - enums: Standardized game constants
  - combat_forecast: Combat prediction
  - health_prediction: Health tracking
  - spell_prediction: Spell targeting optimization
  - target_selector: Smart target selection
  - inventory_helper: Item management
  - cooldown_tracker: Ability timing
  - movement_handler: Position control
  - plugin_helper: Core functionality access
- Implements standardized interfaces for:
  - Module configuration
  - Spec configuration
  - Callback handling
  - Menu rendering
  - Control panel integration
- Geometry utilities:
  - vec2: 2D vector operations
  - vec3: 3D vector operations
  - geometry: Shape calculations and checks

### Class Implementation

#### Holy Paladin
- Implements SpecConfig interface
- Organized in classes/paladin/holy/
- Components:
  - IDs: Centralized spell, aura, and talent definitions
  - Logic: Spell implementations and rotation logic
  - Drawing: Visual feedback and debug information
  - Variables: Shared state management

##### Rotation System
- Three distinct rotation modes:
  1. Avenging Crusader: Special healing rotation during cooldown
  2. Healing: Primary healing rotation with priority system
  3. Damage: Fallback damage rotation when healing not needed
- Priority-based spell selection within each mode
- Automatic mode switching based on:
  - Cooldown availability
  - Party health states
  - Combat conditions

##### Spell Implementations
- Holy Shock: Single target priority healing
- Divine Toll: Cluster-based healing from player position
- Beacon of Virtue: Position-based cluster healing
- Holy Prism: Enemy-based cluster healing
- Holy Armament: Role-based targeting (tank/healer)
- Judgment: Awakening buff management
- Crusader Strike: Blessed Assurance integration
- Hammer of Wrath: Execute phase damage

##### Variables and IDs
- Centralized spell ID definitions
- Shared state variables:
  - Resource tracking (Holy Power)
  - Buff state tracking
  - Talent availability
- Getter functions for dynamic values
- Clear separation of concerns:
  - Spells
  - Auras
  - Talents
  - Variables

##### Talent Integration
- Uses standardized talent IDs
- Supports dynamic feature enabling
- Validates talent requirements
- Adapts rotation based on talents

### Configuration
- Menu system with tree-based organization
- Standard configuration patterns:
  - Health thresholds (85-90% default)
  - Target count thresholds
  - Weight sliders (0.1-1.0 range)
- Settings normalized and accessed through getters
- Debug options for heal engine diagnostics
- Talent-based menu options
- Control panel integration for quick toggles

## Technical Notes
- Plugin must implement required interfaces
- Modules handle their own state and updates
- Health and damage tracking updated in real-time
- Menu settings follow consistent getter pattern
- Combat state determines module behavior
- Talent checks control feature availability
- Performance considerations:
  - Cache health values appropriately
  - Clean up old data periodically
  - Use fast_update for critical tracking
  - Optimize update frequencies per module
  - Settings follow consistent getter patterns
  - Debug logging available for troubleshooting
  - Combat transitions trigger proper cleanup
  - Historical data managed automatically
  - Resource tracking integrated with core systems
- Package distribution handled by pack.sh
- Code style enforced by .clinerules
- Documentation maintained in knowledge files
- Project structure follows Sylvanas guidelines
- Memory bank tracks:
  - Active development context
  - Technical decisions
  - Project progress
  - System patterns
- Uses standardized enum values
- Implements proper type definitions
- Follows plugin packaging guidelines
- Maintains API compatibility
- Supports proper talent validation

### Plugin Standards
- Follows Sylvanas plugin architecture guidelines
- Implements required interfaces:
  - ModuleConfig: Core module functionality
  - SpecConfig: Class-specific implementation
- Standardized initialization flow:
  - Module loading
  - Spec registration
  - Callback setup
- Structured error handling and validation

### Development Guidelines
- Follow consistent coding standards
- Use version control for changes
- Document code changes and updates
- Conduct code reviews before merging
- Test changes in a development environment
- Monitor performance and stability
- Address any issues promptly
- Keep documentation up-to-date
- Collaborate with team members
- Maintain a clean and organized codebase

### Module Architecture
- Each module must implement ModuleConfig interface:
  - on_update: Core logic updates
  - on_fast_update: High-frequency updates
  - on_render: Visual feedback
  - on_render_menu: Settings UI
  - on_render_control_panel: Quick toggles

### Spec Architecture
- Each spec must implement SpecConfig interface:
  - spec_id: Unique identifier
  - class_id: Class identifier
  - Required callbacks:
    - on_update: Rotation logic
    - on_render: Visual elements
    - on_render_menu: Settings
    - on_render_control_panel: Quick controls
- Bootstrap process:
  - Module initialization
  - Resource setup
  - Callback registration

- Strict interface implementation required
- Standardized initialization process
- Modular callback system
- Clear separation of concerns:
  - Core functionality
  - Class-specific logic
  - UI rendering
  - Settings management

### Module Loading
- Required modules loaded at initialization
- Error handling for module loading failures
- Support for optional module dependencies
- Module state management and cleanup

- Module loading follows strict error handling
- Supports multiple utility helpers
- Integrates with profiling tools
- Provides combat and spell prediction
- Handles inventory and cooldown tracking
- Manages movement and positioning
- Supports PvP and dungeon-specific logic

- Efficient vector operations for positioning
- Geometric calculations for targeting
- Multiple specialized target selection algorithms
- Comprehensive heal engine configuration options

## Namespace Guidelines

### Global Namespace
```lua
---@class FS
---@field public spec_config SpecConfig
---@field public loaded_modules ModuleConfig[]
---@field public entry_helper entry_helper
---@field public modules table<string, ModuleConfig>
---@field public variables core_variables
---@field public settings core_settings
---@field public humanizer humanizer
---@field public menu menu_system
FS = {}
```

### Namespace Structure
- All code lives under global FS namespace
- Modules use dot notation: FS.module_name
- Specs use nested paths: FS.class_name.spec_name
- Settings follow module path: FS.module_name.settings
- Variables follow module path: FS.module_name.variables

### Namespace Best Practices
- Initialize module tables before requiring submodules
- Use consistent path structure across modules
- Keep namespace hierarchy shallow (max 3-4 levels)
- Document namespace structure in module headers
- Follow consistent initialization pattern:
```lua
-- Initialize namespace
FS.module_name = {}

-- Require dependencies
require("path/to/dependencies")

-- Initialize submodules
FS.module_name.submodule = {}
```

### Module Organization
- Group related functionality under single namespace
- Use submodules for logical separation
- Keep interface modules separate from implementation
- Follow consistent file structure:
```lua
-- File: module_name/index.lua
FS.module_name = {}

require("module_name/settings")
require("module_name/variables")
require("module_name/logic/index")
```

### Namespace Access Patterns
- Use local references for frequently accessed paths
- Cache namespace lookups in hot paths
- Keep references up to date with resets
- Example pattern:
```lua
---@type module_settings
local settings = FS.module_name.settings
---@type module_variables 
local variables = FS.module_name.variables

local function update()
    if not settings.is_enabled() then
        return
    end
    -- Use cached references
end
```

### Initialization Order
1. Core systems (FS.core)
2. Required modules (FS.modules)
3. Spec modules (FS.spec_config)
4. Callbacks and hooks

### Cleanup Patterns
- Reset module state on combat end
- Clear cached references when needed
- Handle module unload properly
- Follow consistent cleanup pattern:
```lua
function FS.module_name.reset()
    -- Clear state
    FS.module_name.state = {}
    -- Reset cached values
    FS.module_name.cache = {}
end
```
