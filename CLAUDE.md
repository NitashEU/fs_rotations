# FS Rotations Development Guide

## Build & Test Commands
- Package for distribution: `./pack.ps1` (PowerShell)
- Create a commit: `./commit.sh "<type>: <message>" <file1> [file2...]`
  - Types: feat, fix, perf, docs, style, refactor, test, chore

## Code Style Guidelines
- **Naming**: Use snake_case for variables, functions, modules
- **Organization**: Namespaced modules with table hierarchy (e.g., `FS.paladin_holy`)
- **Documentation**: Use LuaDoc style (---@param, ---@return, ---@class)
- **Structure**:
  - Place early validation/returns at the beginning of functions
  - Keep modules focused on a single responsibility
  - Organize by feature (spells, rotations, utilities)
- **Error Handling**: Use defensive programming with parameter validation
- **Commit Messages**: Follow conventional commits format
  - Format: `<type>: <description>` (all lowercase)
  - Example: `feat: add new healing rotation`

## Development Patterns
- Use the profiler module for performance optimization
- Apply humanization via jitter when simulating user actions
- Follow existing patterns for spell implementation
- Version bumps happen automatically based on commit type

## Class Spec Architecture
- **Entry Point**: `bootstrap.lua` initializes namespace and registers callbacks to return a `SpecConfig`
- **Core Files**:
  - `index.lua`: Requires all module files
  - `ids/`: Spell, aura, and talent ID definitions in separate files
  - `variables.lua`: Game state tracking functions and computed values
  - `settings.lua`: Settings accessor functions tied to menu options
  - `menu.lua`: UI configuration with sliders, checkboxes and settings windows
  - `drawing.lua`: Visual elements and UI rendering
- **Logic Organization**:
  - `logic/index.lua`: Contains main `on_update` function with rotation priority
  - `logic/rotations/`: Different rotation strategies (healing/damage/cooldowns)
  - `logic/spells/`: Individual spell implementations with consistent pattern:
    - Early validation checks (spell availability, resources)
    - Target selection using heal engine module
    - Dynamic thresholds based on game state
    - Spell queuing with priorities

To create a new spec, copy the Holy Paladin structure and modify each component according to the new spec's requirements and spell logic.