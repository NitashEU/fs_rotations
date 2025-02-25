# Heal Engine Implementation Guidelines

## Implementation Constraints
- Shares memory with WoW client and other plugins - memory management is critical
- Testing is done manually through user feedback and logs
- Performance-critical component that runs in game loop - optimize accordingly
- Maintain compatibility with _api interfaces (do not modify these)

## Module Structure
- Domain-oriented organization in subdirectories:
  - `core/` - Core functionality and initialization
  - `data/` - Data collection and caching
  - `analysis/` - Damage analysis and predictions
  - `logging/` - Logging functionality
  - `target_selections/` - Target selection algorithms

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

## Data Collection
- Use circular buffers for health history `data/collector.lua`
- Implement object pooling for performance `data/storage.lua`
- Cache positions and distances `data/cache.lua`
- Track health changes with configurable thresholds
- Store only significant health changes

## Damage Analysis
- Track damage patterns over time `analysis/damage.lua`
- Implement short-term prediction for incoming damage
- Calculate DPS over multiple time windows (1s, 5s, 10s, 15s)
- Cache DPS calculations to prevent redundant work
- Identify and track significant damage events

## Performance Standards
- Minimize calculations in hot paths
- Use spatial optimization for cluster calculations
- Implement early exit conditions
- Use position and distance caching (implemented with 200ms lifetime)
- Refresh position cache on every fast update cycle
- Access cached positions via `cache.get_position(unit)`
- Access cached distances via `cache.get_distance(pos1, pos2)`

## Input Validation
- Implement comprehensive parameter validation for all functions
- Check required parameters with specific error messages
- Validate parameter types and value ranges
- Check object methods and properties before use
- Use the error_handler system to report validation failures
- Add default values for optional boolean parameters
- Validate collections for existence and non-emptiness

## Logging
- Centralize logging in `logging/health.lua`
- Only log significant health and damage changes
- Provide configurable thresholds for all log types
- Implement combat state change logging
- Log fight-wide statistics when leaving combat

## Interface Integration
- Expose a consistent API for all healing specializations
- Document all public functions with type annotations
- Provide clear error messages for invalid inputs
- Allow for specialization-specific overrides
- Maintain backward compatibility with existing code

## State Management
- Track combat state centrally in `core/state.lua`
- Handle enter/exit combat transitions
- Track fight-wide statistics for post-combat analysis
- Reset data structures appropriately on state changes

## Best Practices
- Follow single responsibility principle for modules
- Use callbacks for cross-module communication
- Keep update functions clean and delegate to specialized modules
- Minimize global state and dependencies
- Document module interfaces thoroughly