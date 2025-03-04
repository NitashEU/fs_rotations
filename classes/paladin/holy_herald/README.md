# Herald of the Sun - Holy Paladin Specialization

## Overview

Herald of the Sun is a specialized Holy Paladin implementation focusing on the unique mechanics and playstyle of this specialization. This module provides comprehensive automation for Herald's distinctive features:

- **Sun's Avatar Beam System**: Visualization and optimization of healing beams between the paladin and allies with Dawnlight, including beam intersection maximization
- **Dawnlight Application**: Smart application of Dawnlight HoTs after Holy Prism casts, with adaptive targeting based on role, health, and positioning
- **Holy Power Management**: Sophisticated resource tracking and spending, including Eternal Flame HoT management and overcap prevention
- **Cooldown Integration**: Specialized handling for Avenging Wrath, Awakening, and other major cooldowns
- **Visual Feedback**: Comprehensive UI elements showing buff status, cooldown tracking, positioning guidance, and HoT uptime

## Key Mechanics

### Dawnlight Application Cycle

1. Cast Holy Prism
2. Use Holy Power spenders (Word of Glory, Light of Dawn, Eternal Flame) within the next 2 casts
3. Monitor Dawnlight HoTs on allies through visual indicators
4. During Avenging Wrath, optimize positioning for beam intersections

### Beam Optimization

During Avenging Wrath, the implementation:
- Visualizes beams between the paladin and allies with Dawnlight
- Calculates the optimal player position for maximum beam intersections
- Shows beam intersection points and effectiveness in the UI
- Provides a positioning indicator to help you find the best location

### Holy Power Management

The module uses an advanced Holy Power tracking system to:
- Balance between Light of Dawn and Eternal Flame based on healing needs
- Prevent overcapping through predictive resource generation modeling
- Prioritize Holy Power spending during critical moments (Empyrean Legacy, Rising Sunlight)
- Efficiently maintain Eternal Flame HoTs on appropriate targets

## Design Decisions

### Priority System

The healing rotation follows a specific priority system:
1. Dawnlight application during the Holy Prism window
2. Beam intersection optimization during Avenging Wrath
3. Major cooldown management (Avenging Wrath, Divine Toll)
4. Holy Power generation and spending
5. Supplemental healing through filler abilities

### Targeting Algorithm

Dawnlight targets are selected based on a weighted scoring system that considers:
- Player role (tanks > melee > ranged)
- Current health percentage
- Position relative to the paladin (mastery benefit)
- Special conditions during Avenging Wrath and Awakening

### Visualization Hierarchy

UI elements are organized in layers to provide important information without overwhelming the player:
- Critical status indicators (Empyrean Legacy, Rising Sunlight)
- HoT duration bars with color-coding for expiration warning
- Positional guidance during Avenging Wrath
- Cooldown tracking with remaining time

## Usage Instructions

### Settings

The implementation provides extensive customization options:
- **HoT Management**: Toggle Eternal Flame usage, adjust targeting priorities
- **Beam Optimization**: Enable/disable automatic positioning optimization
- **Visual Elements**: Configure which visual indicators are displayed
- **Cooldown Usage**: Set health thresholds and target counts for major cooldowns
- **Spell Thresholds**: Customize when different healing spells are used

### Recommended Settings

For optimal performance:
- Enable Eternal Flame usage for efficient HoT management
- Enable beam optimization during Avenging Wrath for maximum healing output
- Set appropriate health thresholds based on your group's damage patterns
- Configure visual indicators based on your UI preferences

### Performance Tips

- Position yourself centrally in the group to maximize mastery benefit
- Watch for the "Dawnlight Ready" indicator after Holy Prism casts
- During Avenging Wrath, follow the beam optimization indicator
- Use the Empyrean Legacy proc immediately on critical healing targets
- Monitor your Holy Power to avoid overcapping during Rising Sunlight

## Dependencies

This implementation requires:
- FS API Core module
- Heal Engine module
- Target Selection subsystem
- Drawing and visualization components

## Specialization ID

Class ID: 2 (Paladin)
Spec ID: 65 (Holy)
Variant: Herald of the Sun

## Maintainers

This Herald of the Sun implementation is maintained by the FS Rotations team.