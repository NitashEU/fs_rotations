# FS Rotations Control Flow Graph

## 1. Introduction

FS Rotations is a plugin for Project Sylvanas that provides advanced combat rotation automation. It offers sophisticated combat assistance through specialized modules for different class specializations, a healing engine, and a humanizer system to ensure actions appear natural and human-like.

## 2. Architecture Overview

The FS Rotations plugin consists of several key components:

- **Core System**: Fundamental utilities and shared functionality
- **Entry/Initialization**: Plugin startup and module loading
- **Heal Engine Module**: Specialized system for healing-related decisions
- **Specialization Modules**: Class-specific modules (e.g., Holy Paladin)
- **Humanizer System**: Adds realistic delays to actions
- **Event System**: Facilitates communication between modules

## 3. Initialization Flow

```
main.lua
   |
   v
FS.entry_helper.init()
   |
   ├─> load_required_modules()
   |      |
   |      ├─> Load core modules
   |      └─> Load utility modules
   |
   ├─> load_spec_module()
   |      |
   |      └─> Load specialization-specific module
   |
   └─> Handle settings migration
```

The initialization process begins in `main.lua`, which calls `FS.entry_helper.init()` from `entry/entry_helper.lua`. This function orchestrates the loading of required modules through `load_required_modules()` defined in `entry/load_required_modules.lua`. This loads all core and utility modules needed for the plugin to function.

Next, `load_spec_module()` from `entry/load_spec_module.lua` is called to load the appropriate specialization module based on the player's current class and specialization (e.g., Holy Paladin).

During initialization, settings migration is also handled to ensure compatibility with previous versions of the plugin.

## 4. Runtime Flow

```
on_update callback (entry/callbacks/on_update.lua)
   |
   ├─> Check if plugin is enabled
   |
   ├─> Update error handler from menu settings
   |
   ├─> Emit system.fast_update event
   |
   ├─> Iterate through loaded modules
   |      |
   |      ├─> Execute fast updates
   |      └─> Execute normal updates (if interval elapsed)
   |
   ├─> Special handling for spec module
   |
   ├─> Emit system.update event
   |
   ├─> Check combat state changes
   |      |
   |      ├─> Emit player.combat.enter (if entering combat)
   |      └─> Emit player.combat.exit (if exiting combat)
   |
   └─> Emit system.update.end event
```

The runtime flow is centered around the `on_update` callback defined in `entry/callbacks/on_update.lua`. This function is called regularly by the game engine and serves as the heartbeat of the plugin.

The callback first checks if the plugin is enabled through settings. It then updates the error handler based on menu settings and emits the `system.fast_update` event.

Next, it iterates through all loaded modules, executing their fast update functions and, if the appropriate interval has elapsed, their normal update functions. The specialization module receives special handling to ensure its rotation logic is executed properly.

The callback also checks for changes in the player's combat state, emitting `player.combat.enter` or `player.combat.exit` events as appropriate. Finally, it emits the `system.update.end` event to signal the completion of the update cycle.

## 5. Heal Engine Flow

```
Heal Engine (core/modules/heal_engine/index.lua)
   |
   ├─> Core Logic (core/modules/heal_engine/core/index.lua)
   |      |
   |      ├─> Data Collection
   |      ├─> Unit Analysis
   |      └─> Target Selection
   |
   ├─> Damage Analysis (analysis/damage.lua)
   |      |
   |      └─> Incoming damage prediction
   |
   ├─> Logging
   |
   └─> Target Selection Logic
```

The Heal Engine module is loaded from `core/modules/heal_engine/index.lua` and its core logic is defined in `core/modules/heal_engine/core/index.lua`. This module is responsible for making healing-related decisions.

The Heal Engine collects data about units in the game, analyzes their health, incoming damage, and other relevant factors. The damage analysis component (`analysis/damage.lua`) predicts incoming damage to help prioritize healing targets.

The module includes logging functionality to track healing decisions and a sophisticated target selection system that determines which units should receive healing based on various factors such as health percentage, incoming damage, and role importance.

## 6. Humanizer Flow

```
Humanizer (core/humanizer.lua)
   |
   ├─> Configuration values
   |      |
   |      ├─> Base delay
   |      ├─> Variance
   |      └─> Jitter settings
   |
   ├─> Calculate action delay
   |      |
   |      ├─> Consider network latency
   |      ├─> Apply configured variance
   |      └─> Add random jitter
   |
   └─> Apply delay to action execution
```

The Humanizer module, defined in `core/humanizer.lua`, adds realistic delays to actions to make the plugin's behavior appear more human-like. It calculates action delays based on configuration values, network latency, and random jitter.

The module takes into account the base delay specified in the configuration, adds variance based on settings, and incorporates network latency to ensure actions are executed with timing that mimics human reaction times. Random jitter is added to prevent predictable patterns in action execution.

## 7. Inter-module Interactions and Events

```
Event System
   |
   ├─> Event Emission
   |      |
   |      ├─> system.fast_update
   |      ├─> system.update
   |      ├─> system.update.end
   |      ├─> player.combat.enter
   |      └─> player.combat.exit
   |
   └─> Event Handling
          |
          ├─> Module event listeners
          ├─> Specialization module responses
          └─> Heal Engine reactions
```

The FS Rotations plugin uses an event system to facilitate communication between modules. Events are emitted during the update cycle and in response to game state changes.

Key events include `system.fast_update`, `system.update`, and `system.update.end`, which mark different phases of the update cycle. Combat state changes trigger `player.combat.enter` and `player.combat.exit` events.

Modules register event listeners to respond to these events. For example, the Heal Engine might adjust its behavior when entering or exiting combat, and specialization modules might activate different rotation priorities based on combat state.

The event system depends on proper error handling and module interface validations to ensure reliable communication between components.

## 8. Conclusion

The FS Rotations plugin follows a structured control flow that begins with initialization in `main.lua` and continues through regular update cycles via the `on_update` callback. The plugin's behavior is determined by the interaction of various modules, including the Core System, Heal Engine, Specialization Modules, and Humanizer System.

The event system facilitates communication between these modules, allowing them to respond to changes in game state and coordinate their actions. The Humanizer ensures that actions are executed with realistic timing, making the plugin's behavior appear natural and human-like.

Understanding this control flow is essential for maintaining and extending the FS Rotations plugin, as it provides insight into how the various components interact and how changes to one module might affect the behavior of others.