# API Knowledge

## Overview
The `_api` directory provides a comprehensive abstraction layer over the game's API, offering standardized interfaces, helper functions, and utility modules that simplify rotation development and enhance code maintainability.

## Core Modules & Functions

### 1. Spell System
```lua
-- Spell Queue Interface
spell_queue:queue_spell_target(spell_id: number, target: game_object, priority: number, message?: string, allow_movement?: boolean)
spell_queue:queue_spell_target_fast(spell_id: number, target: game_object, priority: number, message?: string, allow_movement?: boolean)
spell_queue:queue_spell_position(spell_id: number, position: vec3, priority: number, message?: string, allow_movement?: boolean)
spell_queue:queue_spell_position_fast(spell_id: number, position: vec3, priority: number, message?: string, allow_movement?: boolean)
spell_queue:queue_item_self(item_id: number, priority: number, message?: string)
spell_queue:queue_item_target(item_id: number, target: game_object, priority: number, message?: string)

-- Spell Helper Interface
spell_helper:is_spell_castable(spell_id: number, caster: game_object, target: game_object, skip_facing: boolean, skips_range: boolean): boolean
spell_helper:is_spell_queueable(spell_id: number, caster: game_object, target: game_object, skip_facing: boolean, skips_range: boolean): boolean 
spell_helper:is_spell_in_range(spell_id: number, target: game_object, source: vec3, destination: vec3): boolean
spell_helper:has_spell_equipped(spell_id: number): boolean
spell_helper:is_spell_on_cooldown(spell_id: number): boolean
```

### 2. Unit Management
```lua
-- Unit Helper Interface
unit_helper:is_valid_unit(unit: game_object): boolean
unit_helper:get_role_id(unit: game_object): number
unit_helper:is_tank(unit: game_object): boolean

-- Target Selection Interface
target_selector:get_targets(limit?: number): table<game_object>
target_selector:get_targets_heal(limit?: number): table<game_object>
```

### 3. Combat & Prediction
```lua
-- Health Prediction
health_prediction:speculate_damage(caster: game_object, target: game_object, damage: number, spell_id: number): number
health_prediction:get_damage_types(target: game_object, deadline_time_in_seconds?: number): damage_types_table

-- Spell Prediction
spell_prediction:get_cast_position(target: game_object, spell_data: spell_data): prediction_result
spell_prediction:get_most_hits_position(main_position: vec3, spell_data: spell_data, target?: game_object): prediction_result
spell_prediction:new_spell_data(spell_id: number, max_range?: number, radius?: number, cast_time?: number, projectile_speed?: number, prediction_mode: prediction_type, geometry: geometry_type, source_position?: vec3): spell_data
```

### 4. Buff Management
```lua
-- Buff Manager Interface
buff_manager:get_buff_data(unit: game_object, buff_ids: number[]): buff_data
buff_manager:get_debuff_data(unit: game_object, debuff_ids: number[]): buff_data
buff_manager:get_aura_data(unit: game_object, enum_key: buff_db, custom_cache_duration_ms?: number): buff_manager_data
```

### 5. Game Object System
```lua
-- Game Object Core Interface
game_object:is_valid(): boolean
game_object:get_type(): number
game_object:get_position(): vec3
game_object:get_rotation(): number
game_object:get_direction(): vec3
game_object:get_name(): string
game_object:get_class(): number
game_object:get_level(): number

-- Combat Status
game_object:is_in_combat(): boolean
game_object:is_casting_spell(): boolean
game_object:is_channelling_spell(): boolean
game_object:get_active_spell_id(): number
game_object:get_threat_situation(obj: game_object): threat_table

-- Unit Stats & Resources
game_object:get_health(): number
game_object:get_max_health(): number
game_object:get_power(power_type: number): number
game_object:get_max_power(power_type: number): number
game_object:get_movement_speed(): number
game_object:get_total_shield(): number
```

### 6. Menu System
```lua
-- Tree Node Interface
tree_node:render(header: string, callback: function)
tree_node:is_open(): boolean
tree_node:set_open_state(state: boolean)

-- Control Elements
checkbox:render(label: string, tooltip?: string)
slider_int:render(label: string, tooltip?: string)
slider_float:render(label: string, tooltip?: string)
combobox:render(label: string, options: table, tooltip?: string)
button:render(label: string, tooltip?: string)
```

## Integration Points

### Core Integration
- Menu system hooks via `menu.lua`
- Settings management through core interfaces
- Event handling system for callbacks
- Input handling and spell queue management

### Class Integration
- Standard spell casting interface
- Buff/debuff monitoring system
- Movement and positioning control
- Resource management functions

### Utility Integration
- Geometry calculations for positioning
- Combat predictions and simulations
- Threat and aggro management
- Health and damage calculations

## Core System Integration

### Graphics System
- Text rendering (2D/3D)
- Shape drawing primitives
- Line of sight checks
- World to screen conversion
- Notification system

### Input System
```lua
core.input = {
    cast_target_spell(spell_id, target),
    cast_position_spell(spell_id, position),
    use_item(item_id),
    set_target(unit),
    set_focus(unit)
}
```

### Object Manager
```lua
core.object_manager = {
    get_local_player(),
    get_all_objects(),
    get_visible_objects(),
    get_arena_frames()
}
```

## Best Practices
1. Use spell queue for all spell casts
2. Validate spell requirements before queueing
3. Handle spell failures and cooldowns
4. Implement proper cleanup in rotation resets
5. Use consistent priority values (1-9)
6. Leverage prediction systems for AOE spells
7. Cache buff/debuff data when possible
8. Use fast queue variants for off-GCD abilities
9. Use notification system for important events
10. Implement proper event cleanup
11. Cache object manager results when possible
12. Use proper power type enums
13. Handle loss of control states

## Module Dependencies
- `spell_queue` requires `spell_helper`
- `health_prediction` uses `combat_forecast`
- `target_selector` depends on `unit_helper`
- All modules use core enums and constants
- `spell_prediction` requires geometry modules
- All UI elements require `menu.lua`
- Graphics functions use `core.graphics`
- Input handling requires `core.input`
- Object tracking uses `game_object.lua`

## Advanced Features

### Spell Prediction System
The spell prediction system supports multiple geometry types:
- CIRCLE: For circular AoE spells
- RECTANGLE: For line/rectangular AoE spells  
- CONE: For cone-shaped spells

### Spell Queue Priorities
- Priority 1: Default rotation abilities
- Priority 2-3: Situational abilities
- Priority 4-6: Defensive cooldowns
- Priority 7-9: Emergency/Critical abilities

### Combat Logging
```lua
-- Core Logging Interface
core.log(message)
core.log_warning(message)
core.log_error(message)
core.log_file(message)
```

### Event Registration
```lua
-- Core Event System
core.register_on_update_callback(callback)
core.register_on_render_callback(callback)
core.register_on_spell_cast_callback(callback)
core.register_on_legit_spell_cast_callback(callback)
```

### Performance Monitoring
```lua
-- Core Performance Interface
core.cpu_ticks()
core.cpu_ticks_per_second()
core.delta_time()
core.get_ping()
