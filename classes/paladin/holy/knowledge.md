# Holy Paladin Knowledge

## Overview
Holy Paladin specialization implementation focused on intelligent healing prioritization, buff tracking, and resource management with support for multiple playstyles.

## Implementation Architecture

### Core Systems
```lua
---@class holy_paladin
---@field public variables table<string, function> Runtime state tracking
---@field public settings table<string, function> Configuration getters
---@field public logic table Core rotation implementation
---@field public menu table UI configuration
---@field public drawing table Visualization systems
---@field public spells table<string, number> Spell IDs
---@field public auras table<string, number> Aura/buff IDs
---@field public talents table<string, boolean> Talent availability
```

### State Management
```lua
-- Key Variables
variables = {
    holy_power: function(),           -- Current Holy Power
    avenging_crusader_up: function(), -- Avenging Crusader active check
    awakening_max_remains: function(), -- Awakening buff remaining time
    blessed_assurance_up: function(), -- Blessed Assurance buff check
    holy_armament_override_up: function(), -- Holy Armament state
    rising_sunlight_up: function(),   -- Rising Sunlight buff check
    holy_shock_charges: function()     -- Fractional Holy Shock charge tracking
}
```

## Core Mechanics

### 1. Healing Priority System
The rotation system follows a strict priority order:
1. Avenging Crusader burst healing phase
2. Core healing rotation
3. Damage dealing abilities

### 2. Ability Priorities
#### Healing Rotation
1. Avenging Crusader (when conditions met)
2. Divine Toll (based on cluster healing needs)
3. Beacon of Virtue (for group healing)
4. Holy Prism (talent-based healing)
5. Holy Armament (context-aware targeting)
6. Light of Dawn (frontal cone healing)
7. Word of Glory (single target and tank healing)
8. Holy Shock (charge-based healing)
9. Judgment (for Holy Power generation)
10. Crusader Strike
11. Hammer of Wrath

#### Damage Rotation
1. Judgment
2. Crusader Strike 
3. Hammer of Wrath
4. Consecration

## Key Spells

### Holy Shock
- Smart charge management system
- Variable thresholds based on:
  - Base healing: 85% HP
  - Last charge: 80% HP
  - Rising Sunlight: 90% HP
- Fractional charge tracking

### Word of Glory
- Role-based targeting system
- Priority thresholds:
  - Tanks: 90% HP
  - Regular targets: 85% HP
- Skip facing requirements

### Light of Dawn
- Frontal cone healing
- Configurable requirements:
  - Health threshold
  - Minimum targets (default 3)
  - 15 yard range
  - 46 degree angle

### Holy Armament
- Dual mode functionality:
  1. Sacred Weapon: Targets healer with highest damage
  2. Holy Bulwark: Targets tank with highest damage
- Context-aware mode switching

### Divine Toll
Intelligent targeting using weighted criteria:
- Health status (40%)
- Damage intake (30%)
- Cluster density (20%)
- 30 yard range
- 5 target maximum

### Beacon of Virtue
Advanced targeting system with:
- Configurable weights:
  - Health priority
  - Damage intake
  - Cluster density
  - Optional distance weighting
- 30 yard range
- 5 target maximum

## Settings System

### Core Settings
- Base ability thresholds
- Role-specific healing thresholds
- Minimum target requirements
- Buff state tracking

### Weight Systems
Implemented for key abilities:
- Divine Toll weights
- Beacon of Virtue weights
Both supporting:
- Health priority
- Damage priority
- Cluster priority
- Distance priority (BoV only)

## UI Implementation
- Toggle controls
- Health threshold sliders
- Target count requirements
- Weight configuration
- Separate windows for settings and weights

## Integration
- Heal engine targeting system
- Spell queue management
- Buff/aura tracking
- Talent validation
- Resource monitoring

## Core Files
- bootstrap.lua: Module initialization
- index.lua: Component loading
- logic/rotations/: Rotation implementations
- logic/spells/: Individual spell logic
- ids/: Spell, aura, and talent definitions
- menu.lua: UI configuration
- settings.lua: User preferences
- variables.lua: State tracking
