# Core Modules System

## Overview
Core modules providing shared functionality across the system. Each module is designed to be independent, maintainable, and follows consistent patterns for integration.

## Module Registry

### Core Systems
Each core system has dedicated documentation describing its functionality, interfaces, and implementation details:

- **Heal Engine** - Advanced health tracking and healing target selection
  - [Core Documentation](heal_engine/knowledge.md)
  - [Target Selection System](heal_engine/target_selections/knowledge.md)
- **Combat Analysis** - Fight statistics and damage analysis
  - [Documentation](combat_analysis/knowledge.md) *(Planned)*
- **Performance Monitor** - System optimization and tracking
  - [Documentation](performance_monitor/knowledge.md) *(Planned)*

### Module Interface
```lua
---@class base_module
---@field public on_update fun(): nil Primary update callback
---@field public on_fast_update fun()?: nil Optional high-frequency update
---@field public on_render fun()?: nil Optional render callback
---@field public on_render_menu fun()?: nil Optional menu render callback
```

### Configuration Interface
```lua
---@class module_config
---@field public settings table<string, function> Module settings
---@field public variables table<string, function> Shared state
---@field public menu table<string, any> UI configuration
```

## Module Architecture

### Core Principles
1. Single Responsibility
   - Each module handles one primary concern
   - Clear boundaries between functionalities
   - Minimal dependencies between modules

2. State Management
   - Controlled shared state access
   - Clear state ownership
   - Proper cleanup routines
   - Combat state transitions

3. Update Cycle Management
   - Standard update (game loop)
   - Fast update (high priority)
   - Render update (visuals)
   - Menu update (configuration)

### Resource Guidelines
1. Initialization
   - Clear startup sequence
   - Resource preallocation
   - Error handling
   - Configuration validation

2. Runtime Management
   - Memory optimization
   - Cache strategies
   - State cleanup
   - Performance monitoring

3. Error Handling
   - Input validation
   - Type checking
   - Error reporting
   - Recovery procedures

## Implementation Standards

### Code Organization
1. Structure
   - Consistent file organization
   - Clear module boundaries
   - Standard naming conventions
   - Documentation requirements

2. Type System
   - Strong type annotations
   - Interface definitions
   - Validation helpers
   - Error types

3. Performance
   - Optimization patterns
   - Cache strategies
   - Memory management
   - Update frequency control

### Integration Guidelines
1. Module Registration
   - Standard entry points
   - Dependency declaration
   - Version compatibility
   - Feature flags

2. State Handling
   - Shared resource access
   - State synchronization
   - Cache invalidation
   - Cleanup procedures

3. Event System
   - Combat transitions
   - State changes
   - Error conditions
   - Performance triggers

## Module-Specific Documentation

### Individual Module Structure
Each module should maintain its own knowledge.md with:
- Functionality overview
- Configuration options
- API documentation
- Usage examples
- Performance considerations

### Documentation Requirements
- Clear API contracts
- Configuration examples
- Error handling procedures
- Performance guidelines
- Integration patterns
