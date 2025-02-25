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

## Lua Diagnostics Best Practices
- Type System:
  - Define custom extension classes using `---@class extended_type : base_type` syntax
  - Document all fields with `---@field name type description` annotations
  - Type local variables with `---@type typename` for static analysis
  - Properly document function parameters and return values
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
- Error Handling:
  - Always pass component names to error tracking functions
  - Add validation for external module dependencies before usage
  - Handle nil values with appropriate default responses
  - Properly document deprecated code when replacing functionality