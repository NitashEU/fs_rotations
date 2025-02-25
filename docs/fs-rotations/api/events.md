# Event System

The FS Rotations Event System provides a publish/subscribe (pub/sub) mechanism for decoupled component communication. This allows modules to communicate with each other without direct dependencies.

## Overview

The event system follows these design principles:

1. **Decoupled Communication**: Modules can communicate without knowing about each other
2. **Type Safety**: Events have consistent data structures for reliable communication
3. **Error Isolation**: Failures in event handlers don't propagate to other handlers
4. **Hierarchical Events**: Events can follow a parent/child relationship for broader subscriptions
5. **Debugging Support**: Built-in tools for monitoring event flow

## Core Components

### Event Subscription

Modules can subscribe to events using `FS.events:on()`:

```lua
-- Basic event subscription
local listener_id = FS.events:on("player.combat.enter", function(data)
  -- Handle the event
  print("Combat started with target: " .. (data.target or "unknown"))
end)

-- One-time event subscription
FS.events:once("spell.cast.success", function(data)
  -- Handle the event once
  print("Spell cast successful: " .. data.spell_id)
end)

-- Prioritized event handling
FS.events:on("system.update", function(data)
  -- High priority handler runs first
  print("High priority update")
end, {priority = 10})
```

### Event Emission

Components can emit events using `FS.events:emit()`:

```lua
-- Basic event emission
FS.events:emit("player.health.changed", {
  old_value = 80,
  new_value = 75,
  timestamp = core.game_time() / 1000
})

-- Source tracking
FS.events:emit("spell.cast.started", {
  spell_id = 12345,
  target = "Enemy",
  timestamp = core.game_time() / 1000
}, "spell_handler")

-- Hierarchical events
FS.events:emit_hierarchical("healing.spells.holy_light.success", {
  target = "Tank",
  amount = 5000
})
-- This will trigger both "healing.spells.holy_light.success" and "healing.spells" listeners
```

### Event Unsubscription

```lua
-- Unsubscribe from an event
local success = FS.events:off("player.health.changed", listener_id)

-- Unsubscribe all listeners from an event
FS.events:off_all("player.health.changed")
```

## Standard Event Types

The system defines several standard event types that are emitted automatically:

### System Events

- `system.update`: Emitted on each regular update cycle
- `system.fast_update`: Emitted on each fast update cycle
- `system.render`: Emitted during render
- `system.update.end`: Emitted after all update handlers have executed

### Player Events

- `player.combat.enter`: Emitted when the player enters combat
- `player.combat.exit`: Emitted when the player leaves combat
- `player.state.changed`: Emitted when player state changes significantly

### Module Events

- `module.loaded`: Emitted when a core module is loaded
- `spec.loaded`: Emitted when a specialization module is loaded

## Data Structures

### EventListener

```lua
---@class EventListener
---@field id string Unique identifier for this listener
---@field callback function Function to call when event is triggered
---@field once boolean Whether this listener should be removed after first trigger
---@field priority number Priority of this listener (higher executes first)
```

### EventData

```lua
---@class EventData
---@field name string Name of the event
---@field source string|nil Source component that triggered the event
---@field timestamp number When the event was triggered
---@field data any Event-specific data
```

## Debugging

The event system includes built-in debugging features:

### Debug UI

The event system includes a comprehensive debug UI that can be accessed by enabling the "Show Event Debug Window" setting in the settings menu. The UI displays:

1. Current event listeners and their properties
2. Recent event history
3. Tools to generate test events
4. Statistics about event usage

### Programmatic Debugging

You can also access debug information programmatically:

```lua
-- Enable debug mode
FS.events:enable_debug()

-- Get debug history
local history = FS.events:get_debug_history()

-- Check if an event has listeners
local has_listeners = FS.events:has_listeners("player.combat.enter")

-- Count listeners for an event
local listener_count = FS.events:count_listeners("player.combat.enter")
```

## Best Practices

1. **Naming Convention**: Use dot notation to create hierarchical events (e.g., `module.action.result`)
2. **Event Data**: Always include a timestamp in event data
3. **Error Handling**: Don't assume event handlers won't throw errors - the system handles this internally
4. **Cleanup**: Remember to unsubscribe listeners when they're no longer needed
5. **Source Tracking**: Always provide a source component when emitting events
6. **Prioritization**: Use priorities sparingly - only when order truly matters

## Integration with Other Systems

The event system integrates with other core systems:

- **Error Handler**: All event callbacks are executed via the error handler for safety
- **Settings System**: Debug UI visibility is controlled via the settings system
- **Profiler**: Event dispatching can be profiled for performance analysis
- **Modules**: Core modules can emit and subscribe to events