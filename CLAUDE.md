# CLAUDE.md - FS Rotations Guidelines

## Build & Development Commands
- `./commit.sh "<type>: <message>" <file1> <file2>...` - Commit with version bump
  - Types: feat, fix, perf, docs, style, refactor, test, chore
  - Example: `./commit.sh "fix: correct healing threshold" classes/paladin/holy/logic/healing.lua`
- VSCode + sumneko Lua extension recommended for intellisense

## Code Style Guidelines
- Indentation: Use spaces (2 or 4), be consistent with file
- Types: Use strong annotations with `---@class` and `---@field` for interfaces
- Naming: snake_case for files/functions/variables, meaningful descriptive names
- Module Structure:
  - Keep rotation logic separate from spell implementations
  - Define settings in settings.lua, runtime state in variables.lua
  - Centralize IDs in ids/ directory
  - Handle visualization in drawing.lua
- Settings: All thresholds should be percentage-based (0-100)
- Performance: Cache frequently accessed values, optimize update frequencies
- Error Handling: Validate input parameters, check for nil before operations

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