# API Layer Knowledge

## Overview
Core API layer providing interfaces and utilities for WoW addon development.

## Key Interfaces

### Game Objects
```lua
---@class game_object
---@field public get_health fun(): number
---@field public get_max_health fun(): number
---@field public get_total_shield fun(): number
---@field public is_in_combat fun(): boolean
---@field public get_name fun(): string
```

### Spell Queue
```lua
---@class spell_queue
---@field public queue_spell_target fun(self: spell_queue, spell_id: number, target: game_object, priority: number, message?: string): nil
---@field public queue_spell_position fun(self: spell_queue, spell_id: number, position: vec3, priority: number, message?: string): nil
```

### Unit Helper
```lua
---@class unit_helper
---@field public get_health_percentage fun(self: unit_helper, unit: game_object): number
---@field public get_enemy_list_around fun(self: unit_helper, point: vec3, range: number): table<game_object>
---@field public get_ally_list_around fun(self: unit_helper, point: vec3, range: number): table<game_object>
```

### Spell Helper
```lua
---@class spell_helper
---@field public is_spell_castable fun(self: spell_helper, spell_id: number, caster: game_object, target: game_object): boolean
---@field public is_spell_in_range fun(self: spell_helper, spell_id: number, target: game_object): boolean
```

## Best Practices
- Use type definitions for API interfaces
- Handle object validity checks
- Cache frequently accessed values
- Clean up resources properly
