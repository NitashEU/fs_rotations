# Decision Log

## [2024-02-10] - Heal Engine Target Selection Design

**Context:** Need to implement target selection functionality in the heal engine to support healing spells based on health thresholds and spell castability.

**Decision:** Design a get_single_target function with the following specifications:
- Parameters:
  - hp_threshold: Maximum health percentage to consider a target for healing
  - spell_id: ID of the healing spell to check castability
- Returns: Target with maximum missing health that meets the criteria
- Implementation details:
  - Uses heal_engine.units for unit pool
  - Uses heal_engine.current_health_values for health data
  - Uses spell_helper.is_spell_castable for spell checks
  - Filters by HP threshold
  - Returns unit with highest missing health amount

**Rationale:** 
- This design provides a flexible foundation for target selection
- Integrates with existing heal_engine data structures
- Considers both health state and spell castability
- Returns the most efficient healing target (highest missing health)

**Implementation:**
- Function will be added to heal_engine module
- Will be implemented in Code mode following established Lua conventions

## [2024-02-10] - Holy Shock Implementation Design

**Context:** Need to implement Holy Shock (ID: 20473) as the first healing spell for Holy Paladin, with configurable health threshold.

**Decision:** Design Holy Shock implementation with the following specifications:
- Spell ID: 20473
- Default threshold: 0.9 (90%)
- Configurable through menu system
- Implementation details:
  - Create dedicated spell module in classes/paladin/holy/logic/spells/
  - Integrate with heal_engine's get_single_target for target selection
  - Add menu configuration for threshold customization
  - Follow functional programming paradigm as per project guidelines

**Rationale:**
- Holy Shock is a core healing spell for Holy Paladin
- Configurable threshold provides flexibility for different healing scenarios
- Integration with heal_engine ensures consistent target selection behavior
- Modular design allows for easy maintenance and future enhancements

**Implementation:**
- Will switch to Code mode for implementation following project's Lua conventions
- Will create necessary files and integrate with existing systems