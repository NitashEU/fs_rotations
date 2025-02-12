# Paladin Class Knowledge

## Overview
Core Paladin implementation providing foundational systems and architecture shared across all specializations. Currently supports Holy healing specialization with extensibility for future specs.

## Class Architecture

### Base Interface
```lua
---@class paladin_base
---@field public holy_power fun(): number Current Holy Power resource level
---@field public buff_up fun(aura_id: number): boolean Check if specific aura is active
---@field public buff_remains fun(aura_id: number): number Remaining duration of aura
---@field public talent_selected fun(talent_id: number): boolean Check if talent is selected
---@field public get_active_seals fun(): table<number> Get currently active seals
```

### Core Systems
1. Resource Management
   - Holy Power system
   - Mana management
   - Specialization-specific resources
   - Shared cooldown tracking

2. Combat Systems
   - Role fulfillment
   - Target prioritization
   - Position optimization
   - Movement handling

3. Utility Systems
   - Blessing management
   - Aura maintenance
   - Crowd control 
   - Group support abilities

## Implementation Guidelines

### Resource Systems
1. Holy Power
   - Generation tracking
   - Spending optimization
   - Emergency pooling
   - Cap prevention

2. Mana Management  
   - Efficiency tracking
   - Regeneration optimization
   - Spell prioritization
   - Critical thresholds

3. Cooldowns
   - Usage timing
   - Resource alignment
   - Priority ordering
   - Defensive timing

### Combat Integration
1. Role Systems
   - Primary role focus
   - Secondary capabilities 
   - Emergency responses
   - Group coordination

2. Utility Usage
   - Blessing coordination
   - Protection timing
   - Freedom usage
   - Support optimization

## Specialization Framework
- Common interfaces
- Shared resources
- Base capabilities
- Extension points

### Current Specializations
1. Holy
   - Healing focus
   - Resource optimization
   - Position management
   - Group coordination

### Future Extensions
- Protection specialization
- Retribution specialization
- Shared system reuse
- Spec-specific optimizations

## Best Practices

### Architecture
1. Module Design
   - Clear interfaces
   - State management
   - Resource tracking
   - Error handling

2. Performance
   - State caching
   - Calculation optimization
   - Update frequency
   - Memory management

3. Combat Logic
   - Priority systems
   - Resource efficiency
   - Position awareness
   - Role optimization

### Integration Points
- Core menu system
- Combat engines
- Buff management
- Movement systems
- Spell handling

## Testing Guidelines
1. Core Systems
   - Resource handling
   - State management
   - Role fulfillment
   - Utility usage

2. Specialization
   - Role performance
   - Resource efficiency
   - Position handling
   - Target selection

3. Integration
   - Engine coordination
   - System communication
   - State consistency
   - Error recovery
