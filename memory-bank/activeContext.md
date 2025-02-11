# Active Context

## Current Focus

Implementing clustered heal target selection system

### Requirements

- Create new generic target selector for clustered healing
- Balance multiple metrics:
  - Health missing
  - DPS taken
  - Number of nearby targets
  - Distance to player (optional priority)
- Support flexible configuration:
  - Threshold values
  - Target count requirements
  - Range limitations
  - Distance prioritization toggle

### Technical Scope

- Location: core/modules/heal_engine/target_selections/
- Key Files:
  - New: get_clustered_heal_target.lua
  - Reference: get_group_heal_target.lua
  - Reference: get_tank_damage_target.lua

### Implementation Strategy

1. Core Components:

   - Parameter validation system
   - Target filtering logic
   - Metric calculation system
   - Result validation

2. Scoring System:

   - Health score (40% weight)
   - Damage score (30% weight)
   - Nearby targets score (20% weight)
   - Distance score (10% weight when enabled)

3. Integration Points:
   - Health prediction system
   - Damage tracking metrics
   - Distance calculation
   - Spell castability validation

### Next Steps

1. Create get_clustered_heal_target.lua
2. Implement core selection logic
3. Add parameter validation
4. Integrate with heal engine
5. Test with various scenarios:
   - Different group sizes
   - Various positioning setups
   - With/without distance priority

### Current Status

- Architectural decisions documented
- Implementation patterns defined
- Ready for code implementation
- Initial use case: Beacon of Virtue
- Designed for reuse with similar spells

### Open Questions

- Should weight distributions be configurable per spell?
- Do we need additional metrics for specific scenarios?
- Should we add movement prediction for better clustering?
