# Heal Engine Knowledge

## Overview
Core healing system providing health tracking with multiple time windows and sophisticated damage tracking. The system supports detailed logging and configurable settings through an extensive menu system.

## Core Components

### Health & Damage Tracking
- Tracks historical health values with timestamps
- Maintains separate lists for tanks, healers, and damage dealers
- Multiple time window analysis (1s, 5s, 10s, 15s)
- Shield value tracking (current_health + total_shield)
- Fight-wide damage tracking
- Automated cleanup of old data
- Cache system for DPS calculations

### Unit Management
```lua
FS.modules.heal_engine = {
    is_in_combat: boolean,
    units: game_object[],      -- All valid units
    tanks: game_object[],      -- Tank role units
    healers: game_object[],    -- Healer role units
    damagers: game_object[],   -- DPS role units
}
```

### Health Record Format
```lua
---@class HealthValue
---@field health number Current total health (including shields)
---@field max_health number Maximum health value
---@field health_percentage number Health as percentage
---@field time number Timestamp of record
```

### Damage Tracking System
- Multiple time windows (1s, 5s, 10s, 15s)
- Binary search optimization for time window calculations
- Configurable damage thresholds for logging
- Fight-wide statistics:
  - Total damage taken
  - Fight duration tracking
  - Average DPS calculation

## Configuration System

### Logging Settings
- Debug logging toggle
- Health change threshold configuration
- DPS tracking thresholds
- Fight-wide DPS logging options
- Window-based DPS logging options

### Tracking Windows
- Configurable time windows (1s, 5s, 10s, 15s)
- Individual enable/disable options
- Performance optimized calculations

## Target Selection Summary

The heal engine supports various target selection algorithms through modules in the target_selections directory. Each module is designed for specific healing scenarios:

### Single Target Selection
- Optimized for direct healing spells
- Prioritizes based on missing health
- Supports spell castability validation
- Optional facing/range requirement skipping

### Group Heal Target Selection
- For area healing spells
- Considers minimum injured allies count
- Supports position-based casting
- Override target capability
- Range-based validation

### Tank-Focused Selection
- Specialized for tank healing
- Uses 5-second damage window
- Prioritizes based on recent damage
- Tank role validation

### Healer Priority Selection
- Focused on supporting other healers
- Uses 15-second damage window
- Optional self-exclusion
- Role-based filtering

### Clustered Healing
- Optimizes AoE healing efficiency
- Advanced scoring system:
  - Health deficit weighting
  - Recent damage consideration
  - Position optimization
  - Cluster density calculation
- Customizable priorities

### Enemy-Based Healing
- For spells cast through enemies
- Uses enemy target as reference point
- Validates ally positioning
- Health-based prioritization

### Positional Healing
- Supports cone and directional spells
- Geometric validation
- Player position reference
- Minimum target requirements

## Combat State Management

### Combat Detection
```lua
-- Initializes on combat start
if is_in_combat and not FS.modules.heal_engine.is_in_combat then
    FS.modules.heal_engine.is_in_combat = true
    FS.modules.heal_engine.start()
end

-- Cleanup on combat end
if not is_in_combat and FS.modules.heal_engine.is_in_combat then
    FS.modules.heal_engine.is_in_combat = false
    FS.modules.heal_engine.reset()
end
```

### Performance Optimizations
- Binary search for time window calculations
- Cached DPS calculations
- Periodic data cleanup
- Configurable update frequencies
- Profiler integration

## Best Practices

### Data Management
- Regular cleanup of old health records
- Cache invalidation on state changes
- Efficient data structure usage
- Memory optimization

### Configuration
- Use appropriate time windows for different roles
- Configure logging thresholds based on needs
- Enable only needed tracking windows
- Monitor performance impact

### Target Selection
- Validate spell requirements
- Consider role priorities
- Use appropriate algorithms for spell types
- Handle edge cases properly

## Integration

### Module Setup
```lua
-- Required module initialization
require("menu")
require("settings")
require("start")
require("reset")
require("get_damage_taken_per_second")
require("target_selections/index")
require("on_update")
```

### Update Cycles
- Fast update for health tracking
- Regular update for state management
- Configurable logging frequency
- Combat state transitions
