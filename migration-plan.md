# Holy Paladin Migration Plan

## Core Changes
1. Leverage existing heal engine target selectors
2. Remove Unit wrapper dependency
3. Use standardized spell queueing
4. Integrate with damage tracking system

## Migration Steps

### Phase 1: Core Setup (Done)
- ✓ Basic file structure
- ✓ Module initialization
- ✓ Settings framework
- ✓ Heal engine integration

### Phase 2: Spell Implementation
1. Migrate core healing spells:
   - Holy Shock: Use get_single_target for priority healing ✓
   - Word of Glory: Use get_single_target with tank priority option ✓
   - Light of Dawn: Use get_clustered_heal_target ✓
   - Divine Toll: Use get_clustered_heal_target with position optimization ✓
   - Holy Prism: Already using get_enemy_clustered_heal_target ✓
   - Beacon of Virtue: Already using get_clustered_heal_target ✓

2. Migrate damage spells:
   - Crusader Strike: Direct target implementation
   - Judgment: Direct target with Awakening buff tracking
   - Hammer of Wrath: Already implemented with execute range check ✓
   - Consecration: Position-based implementation

3. Implement cooldowns:
   - Avenging Crusader: Special rotation mode
   - Divine Protection: Defensive tracking
   - Blessing of Sacrifice: Tank protection
   - Aura Mastery: Raid cooldown

### Phase 3: Rotation Logic
1. Core healing rotation:
   - Use heal engine's damage prediction
   - Track incoming damage windows
   - Integrate with buff tracking
   - Resource management (Holy Power)

2. Damage rotation:
   - Basic damage priority
   - Holy Power generation
   - Awakening optimization

3. Special modes:
   - Avenging Crusader optimization
   - Tank healing priority
   - Raid healing vs dungeon healing

### Phase 4: Target Selection
1. Integrate with heal engine:
   - Single target healing
   - Group healing
   - Tank priority
   - Enemy targeting for damage

2. Implement scoring systems:
   - Health-based priority
   - Role-based weights
   - Position-based decisions
   - Damage intake tracking

### Phase 5: Settings & UI
1. Core settings:
   - Health thresholds
   - Target count thresholds
   - Role priorities
   - Cooldown management

2. Advanced settings:
   - Healing weights
   - Damage weights
   - Position weights
   - Override toggles

### Phase 6: Testing & Optimization
1. Core functionality testing:
   - Verify heal engine integration
   - Test target selection
   - Validate damage tracking
   - Check resource management

2. Performance optimization:
   - Use heal engine's caching
   - Optimize update frequencies
   - Monitor memory usage

## Next Steps
1. Implement Holy Shock using get_single_target
2. Add Word of Glory with tank priority
3. Implement Light of Dawn using clustered healing

## Key Points
1. Use heal engine's target selection:
   - get_single_target
   - get_clustered_heal_target
   - get_group_heal_target
   - get_tank_damage_target
   - get_healer_damage_target
   - get_enemy_clustered_heal_target

2. Leverage existing systems:
   - Damage tracking
   - Health prediction
   - Buff management
   - Spell queueing

3. Focus on integration:
   - No custom target updates needed
   - Use standardized APIs
   - Follow existing patterns
