# FS Rotations

A sophisticated rotation automation plugin for Project Sylvanas, focusing on advanced combat optimization and decision-making capabilities.

## Overview

FS Rotations is a powerful plugin system that provides intelligent combat rotation automation with features including:

- Advanced healing prediction and target selection
- Combat state analysis and optimization
- Sophisticated spell queuing and prioritization
- Humanized action timing system
- Comprehensive buff/debuff tracking

## Project Structure

- **\_api/** - Core API abstraction and utilities
- **classes/** - Class-specific implementations
- **core/** - Core systems and shared functionality
- **entry/** - System initialization and bootstrapping
- **docs/** - Documentation and guides

## Features

- Real-time combat optimization
- Sophisticated healing prediction engine
- Intelligent damage tracking and forecasting
- Priority-based spell casting system
- Advanced humanization system
- Buff/debuff management
- Combat state forecasting
- Smart spell queue system
- Intelligent target selection
- Customizable settings per specialization

## Currently Supported Specializations

- Holy Paladin

## Requirements

- Project Sylvanas Core
- Lua 5.1+

## Installation

1. Download the latest release
2. Extract contents to your Sylvanas plugins directory
3. Restart Sylvanas if it was running

## Usage

1. Load the plugin through Project Sylvanas
2. Access settings through the menu system
3. Configure your preferences:
   - Enable/disable the rotation
   - Adjust humanizer settings (min/max delays)
   - Configure specialization-specific thresholds
   - Set up keybinds

## Development

For developers interested in contributing or creating new class modules:

1. Review the [Developer Getting Started Guide](docs/fs-rotations/api/getting-started-dev.md)
2. Follow our [coding standards and best practices](docs/fs-rotations/api/common-issues.md)
3. Refer to module-specific documentation in respective `knowledge.md` files

### Project Organization

- Core systems and shared utilities are located in `core/`
- Class-specific implementations are organized in `classes/`
- Specialization entry points are managed in `entry/`
- External interfaces are defined in `_api/`

## Configuration

The plugin provides extensive customization through its menu system:

### Core Settings

- Script enable/disable
- Humanizer configuration (delays)
- Performance options

### Holy Paladin Settings

- Holy Shock HP threshold
- Avenging Crusader settings
- Target selection preferences
- Healing priorities

## Technical Features

- Modular architecture with clear separation of concerns
- Type-safe configuration system
- Advanced combat prediction algorithms
- Efficient memory management and caching
- Comprehensive error handling

## HOW TO COMMIT

./commit.sh "refactor: extract dps calculation helpers into separate functions" core/modules/heal_engine/get_damage_taken_per_second.lua core/modules/heal_engine/on_update.lua

## Version

Current Version: 1.13.0

## Authors

- FS Team

## License

Copyright © 2025 FS. All rights reserved.
