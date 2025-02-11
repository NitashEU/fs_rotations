# Holy Paladin Knowledge

## Overview
Holy Paladin specialization implementation.

## Key Interfaces

### Spell Implementation
```lua
---@class holy_spell
---@field public cast fun(target: game_object): boolean
---@field public is_ready fun(): boolean
---@field public get_healing fun(): number
```

### Settings Interface
```lua
---@class holy_settings
---@field public is_enabled fun(): boolean
---@field public get_hp_threshold fun(): number
---@field public get_min_targets fun(): number
```

## Components

### Rotations
- Avenging Crusader mode
- Standard healing priority
- Damage rotation fallback

### Spells
- Holy Shock: Priority healing with dynamic thresholds
  - Base threshold: 85%
  - Last charge threshold: 80%
  - Rising Sunlight threshold: 90%
- Divine Toll: Cluster healing
- Beacon of Virtue: Position-based
- Holy Prism: Enemy-based healing
- Word of Glory: Tank priority (90%) and normal healing (85%)

### Systems
- Resource management
- Buff tracking
- Cooldown optimization
- Target selection
- Charge tracking with fractional precision

## Best Practices
- Use heal engine targeting
- Track Awakening procs
- Maintain beacon uptime
- Position for maximum coverage
- Centralize buff and charge tracking in variables
- Use dynamic healing thresholds based on buffs/charges

## Key Buffs
- Rising Sunlight (414204): Increases Holy Shock healing threshold
- Awakening
- Avenging Crusader
- Blessed Assurance
