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
- Holy Shock: Priority healing
- Divine Toll: Cluster healing
- Beacon of Virtue: Position-based
- Holy Prism: Enemy-based healing

### Systems
- Resource management
- Buff tracking
- Cooldown optimization
- Target selection

## Best Practices
- Use heal engine targeting
- Track Awakening procs
- Maintain beacon uptime
- Position for maximum coverage
