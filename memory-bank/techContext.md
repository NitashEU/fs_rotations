# Technical Context: Holy Paladin Rotation Plugin

## Technologies
1. Lua Programming Language
   - Primary implementation language
   - WoW API integration
   - Performance optimization
   - Error handling patterns
   - Type annotations for improved safety

2. Sylvanas Script System
   - Core API integration
   - Event system
   - Object management
   - Plugin lifecycle
   - Menu system framework

## Development Setup
1. Project Structure
   - `_api/`: Sylvanas interface (read-only)
   - `classes/`: Class-specific implementations
     * ids/: Constants (spells, auras, talents)
     * logic/: Rotation and spell implementations
     * settings.lua: Configuration
     * variables.lua: State management
     * menu.lua: UI interface
     * drawing.lua: Visual elements
   - `core/`: Core systems and modules
     * api.lua: Core API integration
     * humanizer.lua: Action timing system
     * menu.lua: UI/Settings interface
     * settings.lua: Configuration management
     * variables.lua: State management
   - `docs/`: Documentation
   - `entry/`: Plugin entry points and initialization

2. Key Dependencies
   - Sylvanas Core API
   - Custom utility modules
   - Heal engine module
   - Common modules:
     * buff_manager
     * spell_queue
     * unit_helper (partial)

## Technical Constraints
1. Performance Requirements
   - Minimal CPU usage
   - Efficient memory management
   - Fast update cycles
   - Optimized initialization
   - Lazy loading patterns
   - Humanized action timing

2. API Limitations
   - Sylvanas API boundaries
   - WoW API restrictions
   - Event system constraints
   - Plugin lifecycle rules
   - Menu system constraints

## Core Systems Implementation
1. Humanizer System
   - Dynamic delay calculation
   - Latency-aware jitter
   - Configurable boundaries
   - Performance optimization
   - Randomization controls

2. Menu System
   - Type-safe menu elements
   - Hierarchical organization
   - Consistent ID prefixing
   - Reusable components
   - Event handling

3. Settings Management
   - Type-safe getters
   - Centralized configuration
   - Runtime updates
   - Default value handling
   - Validation checks

4. Variable System
   - Game state tracking
   - Resource management
   - Buff/Aura monitoring
   - Target validation
   - Player state handling

5. Rotation System
   - Three-tiered priority
   - Spell queueing integration
   - Target selection logic
   - Performance optimization
   - State validation

## Development Tools
1. Code Organization
   - Modular file structure
   - Clear naming conventions
   - Documentation standards
   - Interface definitions
   - Type annotations

2. Testing Capabilities
   - Runtime verification
   - Performance monitoring
   - Error tracking
   - Module validation
   - State validation

## Technical Dependencies
1. Core Modules
   - buff_manager: Buff and aura tracking
   - spell_helper: Spell management utilities
   - spell_queue: Action queueing system
   - unit_helper: Unit management utilities (partial)
   - plugin_helper: Plugin lifecycle utilities
   - control_panel_helper: UI management
   - key_helper: Input handling

2. Custom Implementations
   - Heal engine: Target selection and healing logic
   - Health prediction: Custom implementation planned
   - Combat forecast: Custom implementation planned
   - Target selection: Integrated with heal engine

3. Utility Systems
   - Type definitions
   - Error handling
   - Event management
   - State validation
   - Performance optimization

## Implementation Focus
1. Performance Optimization
   - Efficient target selection
   - Smart spell queueing
   - Minimal state updates
   - Memory management
   - CPU usage optimization

2. Type Safety
   - Comprehensive annotations
   - Interface validation
   - Runtime checks
   - Error boundaries

3. Modularity
   - Clear separation of concerns
   - Encapsulated functionality
   - Defined interfaces
   - Dependency management

4. Error Handling
   - Graceful degradation
   - Clear error messages
   - Recovery mechanisms
   - State validation