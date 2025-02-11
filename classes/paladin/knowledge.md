# Paladin Class Knowledge

## Overview
Paladin class implementation focusing on healing specialization.

## Key Interfaces

### Paladin Base
```lua
---@class paladin_base
---@field public holy_power fun(): number
---@field public buff_up fun(aura_id: number): boolean
---@field public buff_remains fun(aura_id: number): number
```

### Rotation Interface
```lua
---@class rotation_interface
---@field public on_update fun(): boolean
---@field public get_priority fun(): number
---@field public is_enabled fun(): boolean
```

## Components

### Holy Specialization
- Implements SpecConfig interface
- Multiple rotation modes
- Priority-based spell selection
- Position-based healing

## Best Practices
- Follow talent-based logic
- Use heal engine targeting
- Maintain buff uptimes
- Track cooldown usage
