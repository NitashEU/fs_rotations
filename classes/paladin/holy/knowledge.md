# Holy Paladin Knowledge

## Overview
Holy Paladin specialization implementation.

## UI Guidelines

### Settings Window
- Use separate window instead of menu tree for complex settings
- Window styling:
  - Background: Gradient from darker (20,20,31) to lighter (31,31,46)
  - Text: White (255,255,255,255)
  - Window background: Semi-transparent dark (20,20,31,200)
  - Separators: Light purple (77,77,102,255)
- Layout:
  - Two columns (380px each)
  - 15px padding
  - Headers with separators
  - Group related settings

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
