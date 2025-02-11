# FS Rotations

A sophisticated rotation automation plugin for Project Sylvanas, focusing on advanced combat optimization and decision-making capabilities.

## Overview

FS Rotations is a Lua-based plugin for Project Sylvanas that provides automated combat rotation assistance. The system features advanced healing prediction, damage tracking, and priority-based decision making.

## Project Structure

The codebase is organized into the following components:

- `main.lua` - Primary entry point and core execution logic
- `header.lua` - Plugin configuration and initialization
- `entry/` - Specialization-specific entry points and routing
- `core/` - Core systems and shared functionality
- `classes/` - Class-specific rotation implementations
- `_api/` - Interface definitions for external integration

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

## Supported Specializations

- Holy Paladin
- (Additional specs to be added)

## Installation

1. Download the latest release
2. Extract the contents to your Project Sylvanas plugins directory
3. Restart Project Sylvanas if it's running

## Usage

1. Load the plugin through Project Sylvanas
2. Access settings through the menu system
3. Configure your preferences:
   - Enable/disable the rotation
   - Adjust humanizer settings (min/max delays)
   - Configure specialization-specific thresholds
   - Set up keybinds

## Development

### Project Organization
- Core systems and shared utilities are located in `core/`
- Class-specific implementations are organized in `classes/`
- Specialization entry points are managed in `entry/`
- External interfaces are defined in `_api/`

## Requirements

- Project Sylvanas (latest version)
- Supported game version

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

- Advanced heal engine with predictive healing
- Combat state tracking and analysis
- Performance-optimized spell queuing
- Intelligent resource management
- Built-in profiling system

## Version

Current Version: 1.0.0

## Authors

- FS Team

## License

All rights reserved. For personal use only.