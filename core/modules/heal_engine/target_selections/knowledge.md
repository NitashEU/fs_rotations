# Heal Engine Target Selections

This directory contains various target selection algorithms for the healing engine. Each module provides specialized logic for different healing scenarios and spell types.

## Overview

The target selection modules provide different strategies for selecting healing targets based on various criteria such as:
- Health thresholds
- Number of affected targets
- Damage taken patterns
- Positional requirements
- Role-specific healing priorities

## Modules

### Single Target Selection (`get_single_target.lua`)
- Purpose: Selects individual targets based on missing health and health threshold
- Key features:
  - Prioritizes targets with highest missing health
  - Respects spell castability requirements
  - Returns the most injured valid target

### Group Heal Target Selection (`get_group_heal_target.lua`)
- Purpose: Finds optimal targets for group healing spells
- Key features:
  - Checks for minimum number of injured allies in range
  - Supports override targets and position references
  - Validates spell castability for potential targets

### Tank Damage Target Selection (`get_tank_damage_target.lua`)
- Purpose: Specifically targets tanks based on recent damage taken
- Key features:
  - Tracks damage taken in last 5 seconds
  - Prioritizes tanks with highest recent damage
  - Useful for tank-focused healing abilities

### Healer Damage Target Selection (`get_healer_damage_target.lua`)
- Purpose: Focuses on healing fellow healers under pressure
- Key features:
  - Tracks damage taken in last 15 seconds
  - Option to skip self as target
  - Prioritizes healers taking sustained damage

### Clustered Heal Target Selection (`get_clustered_heal_target.lua`)
- Purpose: Optimizes AoE healing spells for maximum efficiency
- Key features:
  - Sophisticated scoring system using weighted criteria:
    - Health deficits
    - Recent damage taken
    - Cluster density
    - Distance from healer
  - Supports customizable weights for different healing priorities
  - Normalizes scores for balanced decision making

### Enemy Clustered Heal Target Selection (`get_enemy_clustered_heal_target.lua`)
- Purpose: Handles healing spells that emanate from enemy targets
- Key features:
  - Uses current enemy target as the center point
  - Checks for minimum viable targets in range
  - Sorts nearby allies by health percentage

### Frontal Cone Heal Target Selection (`get_frontal_cone_heal_target.lua`)
- Purpose: Optimizes directional cone healing spells
- Key features:
  - Creates geometric cone representation
  - Validates targets within cone angle and radius
  - Returns player as target if conditions are met

## Common Features

All target selection modules share these common characteristics:
- Parameter validation
- Spell castability checking
- Support for skipping facing/range requirements
- Integration with heal engine's health tracking system

## Technical Notes

- Health values are tracked as percentages (0-100)
- Distance calculations use game unit positions
- Damage tracking uses different time windows (5s or 15s) based on role
- All modules support spell castability validation
- Support for optional parameters to customize behavior