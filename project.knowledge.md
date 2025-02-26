# Project Knowledge

## Overview
Welcome to the main knowledge base for this FS Rotations project. This document provides a high-level summary of how all modules within the repository fit together, explaining our core architecture, usage patterns, best practices, and serves as a hub for more detailed references in sub-directories.

## File & Folder Structure
Below is an overview of the top-level directories and their roles:
- **_api/**
  • Core API abstraction layer and utilities
  • Geometry/math libraries and vector operations
  • Spell queue and prediction systems
  • Combat forecast and health prediction
  • Buff/debuff management system
  
- **classes/**
  • Class-specific implementations and specs
  • Standardized module structure per spec
  • Supported classes: Paladin (Holy)
  • Planned: Warriors, Hunters, Rogues, Priests, Death Knights, Shamans, Mages, Warlocks
  
- **core/**
  • Global menu and settings management
  • Heal engine with target prioritization
  • Humanizer and input handling
  • Shared variables and state management
  
- **entry/**
  • System initialization and bootstrapping
  • Callback registration (update/render)
  • Module loading and configuration
  • Spec detection and routing
  
- **docs/**
  • API documentation and usage guides
  • Plugin development tutorials
  • Architecture overviews
  • Best practices and patterns

## Key Modules & Systems

### 1. Entry System & Initialization
- Plugin bootstrap sequence in header.lua
  • Plugin metadata validation
  • Local player validation
  • Class/spec detection
  • Module prerequisites check
- Core initialization in main.lua
  • Entry helper system
  • Core callback registration
  • Module loading pipeline
  • Error handling

### 2. Core Systems
- API Integration (api.lua)
  • Centralized module access
  • Buff/debuff management
  • Combat state tracking
  • Health prediction
- Humanizer (humanizer.lua)
  • Dynamic delay calculation
  • Network-aware timing
  • Configurable jitter
  • Performance optimization
- Settings Management (settings.lua)
  • Global configuration
  • Per-module settings
  • User preferences
  • Runtime validation
- Menu System (menu.lua)
  • Hierarchical UI structure
  • Type-safe controls
  • Consistent styling
  • Event handling

### 3. Healing Engine
- Health & Damage Tracking
  • Multiple time windows
  • Role-based analysis
  • Performance optimization
  • State caching
- Target Selection Algorithms
  • Single target healing
  • Group healing optimization
  • Position-based selection
  • Role prioritization
- Combat State Management
  • Fight statistics
  • Damage prediction
  • Resource tracking
  • Performance monitoring

### 4. Class Implementation (Holy Paladin)
- Core Systems
  • Resource management
  • Buff tracking
  • Spell queueing
  • Target selection
- Rotation Logic
  • Priority-based decisions
  • State-driven actions
  • Resource optimization
  • Position management
- Settings & UI
  • Configurable thresholds
  • Role-specific options
  • Visual feedback
  • Performance tuning

## Best Practices

### 1. Module Development
- Clear interface definitions
- Strong type annotations
- Consistent error handling
- Performance optimization
- State cleanup procedures

### 2. Integration Patterns
- Use spell queue for all cast operations
- Leverage buff manager for aura states
- Utilize prediction for positioning
- Share state through core variables
- Follow module dependency patterns

### 3. Performance Guidelines
- Cache frequently accessed values
- Optimize update frequencies
- Manage memory efficiently
- Use appropriate data structures
- Monitor system impact

## Plugin Architecture

### Core Structure
```lua
FS = {
    spec_config = nil,    -- Current spec configuration
    loaded_modules = {},  -- Array of loaded module configs
    entry_helper = {      -- Core initialization system
        init,            -- System initialization
        check_spec,      -- Spec validation
        on_update,       -- Main update loop
        on_render,       -- Rendering system
        on_render_menu   -- UI system
    }
}
```

### Module Interface
```lua
---@class base_module
---@field on_update function() Update callback
---@field on_fast_update function()? Optional high-frequency update
---@field on_render function()? Optional render callback
---@field on_render_menu function()? Optional menu callback
```

## Change Log
- **2/12/2025**: Enhanced documentation structure
- **2/12/2025**: Updated spell queue integration
- **2/12/2025**: Added prediction system details
- **2/12/2025**: Improved module organization
