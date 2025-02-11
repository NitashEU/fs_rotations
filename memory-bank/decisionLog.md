# Decision Log

## [11.2.2025] - Multi-Target Heal Selection Implementation

**Context:**
Need to implement a new target selector for spells like Beacon of Virtue that require selecting a primary target based on their proximity to other potential targets, considering both health and damage metrics.

**Decision:**
Create a new generic target selector that will:

1. Consider both health missing and DPS taken as primary metrics
2. Support distance-based target prioritization
3. Validate minimum and maximum target requirements
4. Check spell castability and range
5. Optimize for affecting maximum number of valid targets

**Rationale:**

- Multiple spells will need this type of target selection
- Target selection should be spell-agnostic for reusability
- Distance-based prioritization allows for tactical positioning
- Must ensure minimum target requirements are met for spell efficiency
- Should maximize multi-target potential

**Implementation:**

1. Create new target selector: get_clustered_heal_target.lua
   - Name reflects functionality rather than specific spell
   - Indicates its purpose for healing targets in proximity
2. Key Parameters:
   - threshold: Minimum health/damage threshold
   - min_targets: Minimum targets required
   - max_targets: Maximum targets affected
   - range: Maximum range for target consideration
   - prioritize_distance: Boolean to prioritize targets closer to player
3. Integration Points:
   - Health prediction system
   - Damage tracking metrics
   - Distance calculation system
   - Spell castability validation

**Technical Considerations:**

- Location: core/modules/heal_engine/target_selections/get_clustered_heal_target.lua
- Will be used by spells like Beacon of Virtue initially
- Extensible for future spells with similar targeting needs
- Distance prioritization adds tactical depth to healing decisions
