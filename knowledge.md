# Project Sylvanas Plugin Knowledge

## Project Overview
A plugin for Project Sylvanas WoW scripting platform providing Holy Paladin rotation and healing support.

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

## Best Practices
- Use heal engine's target selection functions
- Keep spell implementations minimal and focused
- Follow consistent menu structure patterns
- Normalize weights in scoring systems
- Use tree nodes for organized settings
- Queue all spells through Sylvanas spell queue
- Centralize IDs in dedicated files
- Use debug logging for troubleshooting
- Implement proper cleanup in module resets
- Cache frequently accessed values
- Use appropriate update frequencies
- Use centralized ID definitions
- Implement getters for dynamic values
- Structure variables by purpose
- Enable debug logging when needed
- Clean up resources in combat transitions

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
