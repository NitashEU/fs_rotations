# Holy Paladin Implementation Guidelines

## Implementation Constraints
- Shares memory with WoW client - validate all inputs thoroughly
- No automated testing - testing done manually through user feedback
- Performance optimization is critical for smooth gameplay experience
- Maintain compatibility with _api interfaces (do not modify these)

## Rotation Logic
- Implement all rotation logic in `logic/rotations/*.lua`
- Healing priority follows HP thresholds and role priority
- Keep AoE healing and single target healing logic separate
- Implement cooldown usage based on damage patterns
- Track Holy Power generation and consumption

## Spell Implementation
- Create individual spell files in `logic/spells/`
- Document ALL functions with LuaDoc (---@param and ---@return)
- Begin each spell function with:
  1. Component name declaration (`local component = "paladin_holy.spells.spell_name"`)
  2. Early exit if not castable (using `is_spell_queueable`)
  3. Validation of all settings using FS.validator
- Use FS.validator for ALL parameter validation
- Return boolean success/failure status from all spell functions
- Cache frequently used values (spell IDs, cooldowns)
- Add detailed inline comments for complex logic

## IDs Management
- Keep all spell IDs in `ids/spells.lua`
- Keep all talent IDs in `ids/talents.lua`
- Keep all aura IDs in `ids/auras.lua`
- Avoid hardcoding IDs in implementation files

## Settings Standards
- All healing thresholds: 0-100 (percentage-based)
- Group settings by functionality (AoE, ST, Cooldowns)
- Provide tooltips for all configurable values
- Document all settings in `settings.lua`

## State Management
- Use `variables.lua` for runtime state
- Reset state properly in event handlers
- Cache values that don't change frequently