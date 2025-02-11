# Project Sylvanas Plugin Knowledge

## Project Overview
A plugin for Project Sylvanas WoW scripting platform providing Holy Paladin rotation and healing support.

## Core Systems

### Heal Engine
- Uses modular target selection system for different healing scenarios
- Tracks health values and damage taken over time
- Supports clustered healing with configurable weights
- Position-based targeting available through `position_unit` parameter

### Target Selection
- `get_clustered_heal_target`: Core function for multi-target healing spells
  - Supports custom weights for health, damage, cluster size, and distance
  - Can calculate clusters from any unit's position
  - Used for spells like Divine Toll and Beacon of Virtue

### Spell Implementation Guidelines
- Use existing heal engine functions when possible
- Prefer generic solutions over spell-specific implementations
- For spells with automatic follow-up effects (like Divine Toll), only queue the initial cast
- Use Sylvanas spell queue system for all spell casts

### Configuration
- Use menu sliders for customizable thresholds and weights
- Health thresholds typically default to 85-90%
- Weight sliders range from 0.1 to 1.0
- Normalize weights in implementations to ensure they sum to 1.0

## Class Specifics

### Holy Paladin
- Divine Toll: Uses player position as center for cluster calculations
- Beacon of Virtue: Uses target position for cluster calculations
- Holy Shock: Single target healing based on health threshold

## Best Practices
- Reuse existing target selection logic where possible
- Add position_unit parameters for position-based spell effects
- Keep spell implementations minimal when effects are automatic
- Use consistent weight configuration patterns across similar spells
- Leverage Sylvanas built-in systems like health prediction and spell queue
