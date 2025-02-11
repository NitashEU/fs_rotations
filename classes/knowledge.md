# Classes Knowledge

## Overview
Contains class-specific implementations for supported WoW classes.

## Key Interfaces

### Class Module
```lua
---@class class_module
---@field public spec_id number
---@field public class_id number
---@field public settings table<string, function>
---@field public variables table<string, function>
---@field public talents table<number, boolean>
```

### Spell Base
```lua
---@class spell_base
---@field public cast fun(target: game_object): boolean
---@field public is_ready fun(): boolean
---@field public get_damage fun(): number
---@field public get_healing fun(): number
```

## Structure
- Each class has its own directory
- Class directories contain spec-specific implementations
- Specs implement SpecConfig interface

## Implementation Guidelines
- Keep rotation logic separate from spell implementations
- Centralize spell/talent IDs
- Use consistent menu structure
- Implement proper cleanup in resets
