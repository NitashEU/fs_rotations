# FS Rotations - Project Knowledge

## Project Overview

FS Rotations is a World of Warcraft addon that provides automated rotation assistance for various class specializations. The addon analyzes game state and suggests optimal spell usage based on configurable settings and priorities.

## Core Architecture

- **Entry System**: Handles initialization, spec detection, and module loading
- **Core API**: Provides common utilities and interfaces for all specializations
- **Class Modules**: Implements rotation logic for specific class specializations
- **Heal Engine**: Specialized module for healing target selection and prioritization

## Key Components

### Version Management
- Centralized in `version.lua` with major.minor.patch format
- Automatic version bumping based on commit type (feat, fix, etc.)
- Version displayed in addon name

### Module System
- Each class specialization is a separate module
- Modules are loaded dynamically based on player's current spec
- Required modules (like heal_engine) are loaded for all specs

### Spell Execution Pattern
1. Validate spell can be cast
2. Get relevant settings from menu
3. Select appropriate target
4. Queue spell with priority

## File Structure

```
/
├── classes/                  # Class-specific implementations
│   └── [class_name]/         # e.g., paladin, warrior
│       └── [spec_name]/      # e.g., holy_herald, protection
├── core/                     # Core functionality
│   └── modules/              # Shared modules (heal_engine, etc.)
├── entry/                    # Initialization and loading
├── _api/                     # External API interfaces
```

## Coding Standards

- Use early returns for validation
- Follow consistent namespace patterns: `FS.[class_name]_[spec_name]`
- Implement spell logic in individual files
- Use proper target selection methods from heal_engine
- Maintain consistent priority systems in rotation files

## Current Focus

- Holy Herald (Paladin) implementation
- Heal engine improvements
- Buff tracking and visualization enhancements

## Terminal Commands

- `commit.sh`: Handles version bumping and commit formatting
- `pack.ps1`: Creates distribution package for the addon

## Best Practices

- Check spell IDs carefully for accuracy
- Test rotation priorities against class guides
- Maintain clear separation between UI and logic
- Use consistent naming patterns across similar files

## Holy Paladin Herald of the Sun

- Herald of the Sun is a hero talent that replaces Word of Glory with Eternal Flame
- Avenging Crusader is not used with Herald of the Sun
- Dawnlight is a key mechanic applied after using Holy Prism followed by Holy Power spenders
- During Avenging Wrath, beams between the player and Dawnlight targets can intersect for additional healing
- Optimal positioning for beam intersections is important during Avenging Wrath
