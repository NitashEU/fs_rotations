# Heal Engine Knowledge

## Overview
Core healing system providing target selection and health tracking.

## Key Interfaces

### Health Tracking
```lua
---@class HealthValue
---@field public health number
---@field public max_health number
---@field public health_percentage number
---@field public time number
```

### Target Selection Functions
```lua
---@class heal_engine
---@field public get_single_target fun(): game_object
---@field public get_clustered_heal_target fun(range: number, min_targets: number): game_object
---@field public get_enemy_clustered_heal_target fun(range: number, min_targets: number): game_object
---@field public get_tank_damage_target fun(): game_object
---@field public get_healer_damage_target fun(): game_object
```

## Components

### Health Tracking
- Historical health values
- Damage intake analysis
- Multiple time windows
- Automatic cleanup

### Target Selection
- Single target priority
- Cluster optimization
- Role-based targeting
- Position-based selection

### Performance
- Value caching
- Periodic cleanup
- Configurable frequencies
- Memory optimization

## Best Practices
- Clean old health data
- Cache frequent calculations
- Use appropriate windows
- Handle edge cases
