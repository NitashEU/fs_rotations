# Heal Engine Implementation Guidelines

## Algorithm Design
- Implement target selection algorithms in `target_selections/`
- Use position-based calculations for AoE healing
- Implement damage prediction for proactive healing
- Consider target role, current health, and incoming damage
- Optimize for performance in high-frequency updates

## Target Selection
- Implement role-based priority (tank > healer > dps)
- Consider movement and positioning for AoE healing
- Validate targets before returning selections
- Handle edge cases (no targets, all targets full health)
- Return appropriate defaults when no valid target found

## Damage Prediction
- Track damage patterns over time
- Implement short-term prediction for incoming damage
- Consider boss abilities and mechanics
- Cache frequent calculations

## Performance Standards
- Minimize calculations in hot paths
- Use spatial optimization for cluster calculations
- Implement early exit conditions
- Use position and distance caching (implemented with 200ms lifetime)
- Refresh position cache on every fast update cycle
- Access cached positions via `get_cached_position(unit)`
- Access cached distances via `get_cached_distance(pos1, pos2)`

## Input Validation
- Implement comprehensive parameter validation for all functions
- Check required parameters with specific error messages
- Validate parameter types and value ranges
- Check object methods and properties before use
- Use the error_handler system to report validation failures
- Add default values for optional boolean parameters
- Validate collections for existence and non-emptiness

## Interface Integration
- Expose a consistent API for all healing specializations
- Document all public functions with type annotations
- Provide clear error messages for invalid inputs
- Allow for specialization-specific overrides