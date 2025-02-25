# CLAUDE.md - FS Rotations Guidelines

## Project Constraints
- Plugin for World of Warcraft that shares memory with game, other plugins, and scripts
- `/_api/` directory contains interfaces to the game that CANNOT be modified
- No automated testing available - testing is manual with user feedback and logs
- Memory management is critical due to shared environment

## Build & Development Commands
- `./commit.sh "<type>: <message>" <file1> <file2>...` - Commit with version bump
  - Types: feat, fix, perf, docs, style, refactor, test, chore
  - Example: `./commit.sh "fix: correct healing threshold" classes/paladin/holy/logic/healing.lua`
- VSCode + sumneko Lua extension recommended for intellisense

## Module Interface System
- All modules must implement appropriate interfaces from `FS.module_interface`
- Core modules should implement the `core_module` interface
- Specialization modules should implement the `spec_module` interface
- Four standard interfaces available:
  - `core_module`: Base functionality modules with update cycles and menu
  - `spec_module`: Class specialization modules with rotation logic
  - `ui_module`: Interface components and visualizations
  - `data_module`: Data collection, analysis, and reporting
- See `docs/fs-rotations/plugin/architecture/module-interfaces.md` for details
- Use `FS.module_interface:validate(module, interface_name, component_name)` to validate

## Event System
- Use the event system for decoupled communication between components
- Subscribe to events with `FS.events:on(event_name, callback, options)`
- Emit events with `FS.events:emit(event_name, data, source)`
- Use hierarchical event names with dot notation (e.g., `module.action.result`)
- Always include timestamps in event data
- Standard event types:
  - System: `system.update`, `system.fast_update`, `system.render`
  - Player: `player.combat.enter`, `player.combat.exit`
  - Module: `module.loaded`, `spec.loaded`
- Event debugging can be enabled through settings
- Use `emit_hierarchical` for events that should trigger parent handlers
- See `docs/fs-rotations/api/events.md` for full documentation

## Code Style Guidelines
- Indentation: Use spaces (2 or 4), be consistent with file
- Documentation:
  - EVERY function MUST have LuaDoc comments with `---@param` and `---@return` annotations
  - ALL parameters and return values must be documented with types and descriptions
  - Complex functions should include usage examples in comments
- Types: Use strong annotations with `---@class` and `---@field` for interfaces
- Naming: snake_case for files/functions/variables, meaningful descriptive names
- Module Structure:
  - Keep rotation logic separate from spell implementations
  - Define settings in settings.lua, runtime state in variables.lua
  - Centralize IDs in ids/ directory
  - Handle visualization in drawing.lua
- Settings: 
  - All thresholds should be percentage-based (0-100)
  - Use FS.settings_manager for centralized settings management
  - Always provide validation mappings for all settings
  - Register settings change listeners for reactive components
  - Use typed settings with appropriate validation rules
  - Implement real-time validation for menu elements
- Performance: 
  - Cache frequently accessed values (positions, distances)
  - Use FS.object_pool for all frequently created objects 
  - Implement proper reset functions for pooled objects
  - Configure appropriate pre-allocation based on expected usage
  - Monitor pool health and memory leaks through UI
  - Optimize update frequencies for different operation types
  - Use FS.profiler to identify and address bottlenecks 
  - Take memory snapshots to identify potential memory leaks
- Error Handling: 
  - Use FS.validator for ALL input parameter validation (never validate manually)
  - Always use FS.error_handler:safe_execute for critical operations with proper component names
  - Use consistent component naming with dot notation (module.submodule.function)
  - Add component name to all validation calls for clear error tracking
  - Handle all potential nil values and provide meaningful default values
  - Implement fallback behavior for error cases 
  - Use nested structure for component names to enable parent/child error relationship

## Code Organization
- `/classes/` - Class-specific implementations organized by class/spec
- `/core/` - Core systems and shared functionality
- `/entry/` - System initialization and bootstrapping
- `/_api/` - Core API abstraction and utilities (don't modify)

## Documentation Locations
- Main class implementation guidelines: `/classes/{class}/{spec}/CLAUDE.md`
- Core module guidelines: `/core/modules/CLAUDE.md`
- Heal engine guidelines: `/core/modules/heal_engine/CLAUDE.md`

## Versioning System
- Centralized in `version.lua` - single source of truth
- Automatically updated by commit script based on commit type:
  - `feat:` - Increments minor version (1.2.0 → 1.3.0)
  - `fix:`, `perf:`, `refactor:` - Increments patch version (1.2.3 → 1.2.4)
- Changelog automatically updated with each version bump
- Version displayed in UI menu
- Version-based settings migration handled during initialization

## CLAUDE.md Knowledge Management
- **IMPORTANT RULE**: Always document knowledge, learnings, and best practices in CLAUDE.md
- Update this file whenever discovering new patterns or solutions
- Document common pitfalls and their solutions
- Use this as the central knowledge repository for consistent development
- Reference specific CLAUDE.md sections when discussing implementations with developers

## Lua Diagnostics Best Practices
- Type System:
  - Define custom extension classes using `---@class extended_type : base_type` syntax
  - Document all fields with `---@field name type description` annotations
  - Type local variables with `---@type typename` for static analysis
  - Properly document function parameters and return values
  - Be explicit with union types using `type1|type2` notation
  - Always include `nil` in return types if a function can return nil (`string|nil`)
  - Use `table<keyType, valueType>` for typed tables/dictionaries
- UI Extensions:
  - Maintain parameter signature compatibility when extending components
  - Use consistent extension patterns (save original → extend → return)
  - Handle parameter overloading when original functions have optional parameters
  - Specify empty tables ({}) when UI functions expect table parameters
- Common Fixes:
  - `undefined-field`: Implement missing methods or properties on objects
  - `param-type-mismatch`: Check parameter types match function signatures
  - `undefined-global`: Ensure functions/variables are properly scoped
  - `undefined-doc-name`: Define all referenced types before using them
  - `return-type-mismatch`: Ensure functions return values matching their type annotations
  - `assign-type-mismatch`: Verify variable type declarations match assigned values
- Error Handling:
  - Always pass component names to error tracking functions
  - Add validation for external module dependencies before usage
  - Handle nil values with appropriate default responses
  - Properly document deprecated code when replacing functionality
  - Use numeric values for stack_level parameter in error_handler:record (not boolean)
  - Pass 2 as stack_level for warnings in error_handler:record

## Module Interface System Learnings
- Interface validation should use validator patterns consistently
- Validate fields individually before validating full interfaces
- Always define clear required vs. optional fields distinction
- Use component_name for error context in all validation functions
- Only validate properties that directly affect functionality
- Handle interface evolution with deprecated fields system
- Include examples in interface documentation
- Return both success state and detailed error messages from validation
- Use automated documentation generation to ensure docs stay current
- Common module interfaces patterns:
  - Lifecycle hooks (init, update, render)
  - Settings/configuration fields
  - Core API methods
  - Extension points
- Avoid tight coupling between module interfaces

## Event System Learnings
- Use dot notation for hierarchical events (system.type.subtype.action)
- Emit with detailed source context for better debugging
- Create utility functions for common event patterns
- Implement error isolation to prevent one handler from breaking others
- Add debug views early in development cycle
- Ensure all callbacks are wrapped with error_handler:safe_execute
- Use standardized event data structures with timestamps
- Implement event priorities where execution order matters
- Use emit_hierarchical for events that should bubble up
- Create standardized events for core system operations
- Properly clean up one-time listeners to avoid memory leaks
- Integrate with existing systems like settings and error handling
- Implement lifecycle state tracking (e.g., combat state changes)
- Collect events in debug mode for troubleshooting
- Support testing tools for event emission and reception verification