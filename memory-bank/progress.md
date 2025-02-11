# Progress Log

## [11.2.2025] - Clustered Heal Target Selection Implementation

### Work Done

- Created new generic clustered heal target selector
- Implemented health-based prioritization within clusters
- Added distance-based target prioritization option
- Integrated with heal engine's target selection system

### Key Features

- Prioritizes lowest health targets within range
- Supports configurable target counts (min/max)
- Optional distance-based prioritization
- Combines health, damage, and positioning metrics
- Bonus scoring for lowest health clusters

### Technical Details

- Location: core/modules/heal_engine/target_selections/get_clustered_heal_target.lua
- Integration: Added to heal engine's index.lua
- Key Components:
  - Parameter validation
  - Target filtering by health threshold
  - Cluster evaluation with health prioritization
  - Multi-metric scoring system
  - Distance-based prioritization support

### Usage Example

```lua
local target = FS.modules.heal_engine.get_clustered_heal_target(
    80,             -- hp_threshold (80%)
    3,              -- min_targets
    4,              -- max_targets
    20,             -- range
    spell_id,       -- spell to cast
    true,           -- prioritize_distance
    false,          -- skip_facing
    false           -- skip_range
)
```

### Next Steps

- Test with various group compositions
- Validate behavior with different health/damage scenarios
- Fine-tune scoring weights if needed
- Consider adding movement prediction in future updates
