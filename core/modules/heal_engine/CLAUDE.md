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
- Cache position data where possible

## Interface Integration
- Expose a consistent API for all healing specializations
- Document all public functions with type annotations
- Provide clear error messages for invalid inputs
- Allow for specialization-specific overrides