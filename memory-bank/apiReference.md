[read_file for 'memory-bank/apiReference.md'] Result:

# API Reference

## Module System

### SpecConfig Interface
```lua
---@class SpecConfig
---@field class_id number        # Class identifier
---@field spec_id number         # Specialization identifier
---@field on_update on_update    # Update callback
---@field on_render on_render    # Render callback
---@field on_render_menu on_render_menu  # Menu render callback
---@field on_render_control_panel on_render_control_panel  # Control panel callback
```

### Module Structure
Each specialization module follows a standardized structure:

```
classes/[class]/[spec]/
├── bootstrap.lua    # Module initialization and SpecConfig implementation
├── index.lua        # Main entry point, requires all components
├── drawing.lua      # Rendering and UI
├── menu.lua        # Menu system integration
├── settings.lua    # Configuration
├── ids/           # Game constants
│   ├── index.lua  # Constants entry point
│   ├── auras.lua  # Buff/debuff IDs
│   ├── spells.lua # Spell IDs
│   └── talents.lua # Talent IDs
└── logic/         # Core functionality
    └── index.lua  # Main logic implementation
```

### Module Initialization
```lua
-- bootstrap.lua
FS.[class]_[spec] = {}
require("classes/[class]/[spec]/index")

---@type SpecConfig
return {
    spec_id = [spec_id],
    class_id = [class_id],
    on_update = FS.[class]_[spec].logic.on_update,
    on_render = FS.[class]_[spec].drawing.on_render,
    on_render_menu = FS.[class]_[spec].menu.on_render_menu,
    on_render_control_panel = FS.[class]_[spec].menu.on_render_control_panel
}
```

### Component Integration
Each module component is integrated through the main namespace:

```lua
-- menu.lua
FS.[class]_[spec].menu = {
    main_tree = FS.menu.tree_node(),
    enable_toggle = FS.menu.keybind([id], false, [tag] .. "enable_toggle"),
}

-- settings.lua
FS.[class]_[spec].settings = {
    ---@type fun(): boolean
    is_enabled = function()
        return FS.settings.is_toggle_enabled(FS.[class]_[spec].menu.enable_toggle)
    end,
}

-- logic/index.lua
FS.[class]_[spec].logic = {
    ---@type on_update
    on_update = function()
        -- Update logic
    end
}
```

## Common Modules

### Buff Manager (buff_manager.lua)

#### Overview
The Buff Manager provides a caching system for handling buffs, debuffs, and auras. It optimizes performance by caching data and providing structured access to buff information.

#### Data Structures

```lua
---@class buff_manager_data
---@field public is_active boolean  -- Whether the buff is currently active
---@field public remaining number   -- Remaining duration
---@field public stacks number      -- Number of stacks

---@class buff_manager_cache_data
---@field public buff_id number        -- Unique identifier for the buff
---@field public count number          -- Stack count
---@field public expire_time number    -- When the buff expires
---@field public duration number       -- Total duration
---@field public caster userdata       -- Who cast the buff
---@field public buff_name string      -- Name of the buff
---@field public buff_type number      -- Type of buff
---@field public is_undefined boolean  -- If buff data is undefined
```

#### Core Functions

##### Buff Data Retrieval
- `get_aura_data(unit, enum_key, custom_cache_duration_ms?)` - Get cached aura data for a unit
  - Parameters:
    - unit: game_object - Target unit
    - enum_key: buff_db - Buff database enumeration key
    - custom_cache_duration_ms?: number - Optional custom cache duration
  - Returns: buff_manager_data

- `get_buff_data(unit, enum_key, custom_cache_duration_ms?)` - Get cached buff data for a unit
  - Parameters: Same as get_aura_data
  - Returns: buff_manager_data

- `get_debuff_data(unit, enum_key, custom_cache_duration_ms?)` - Get cached debuff data for a unit
  - Parameters: Same as get_aura_data
  - Returns: buff_manager_data

##### Cache Access
- `get_buff_cache(unit, custom_cache_duration_ms?)` - Get buff cache for a unit
  - Returns: buff_manager_cache_data[]

- `get_debuff_cache(unit, custom_cache_duration_ms?)` - Get debuff cache for a unit
  - Returns: buff_manager_cache_data[]

- `get_aura_cache(unit, custom_cache_duration_ms?)` - Get aura cache for a unit
  - Returns: buff_manager_cache_data[]

##### Utility Functions
- `get_buff_value_from_description(description_text, ignore_percentage, ignore_flat)` - Extract numeric value from buff description
  - Parameters:
    - description_text: string - Buff description text
    - ignore_percentage: boolean - Whether to ignore percentage values
    - ignore_flat: boolean - Whether to ignore flat values
  - Returns: number

#### Usage Example

```lua
---@type buff_manager
local buff_mgr = require("common/modules/buff_manager")

-- Get buff data with default cache duration
local buff_data = buff_mgr:get_buff_data(target_unit, SOME_BUFF_ENUM)

-- Check if buff is active and get stacks
if buff_data.is_active then
    local stack_count = buff_data.stacks
    local time_remaining = buff_data.remaining
    -- Handle buff logic
end

-- Get all buffs with custom cache duration
local all_buffs = buff_mgr:get_buff_cache(target_unit, 1000) -- 1 second cache
for _, buff in ipairs(all_buffs) do
    -- Process each buff
    local buff_name = buff.buff_name
    local expires_in = buff.expire_time - core.game_time()
end
```

#### Best Practices

1. Cache Management:
   - Use appropriate cache durations based on update frequency needs
   - Consider using shorter cache durations for critical buffs
   - Use longer durations for stable, long-duration buffs

2. Performance Optimization:
   - Prefer cached data access over direct buff queries
   - Batch buff checks when possible
   - Use enum_key lookups instead of string names

3. Error Handling:
   - Check for nil returns when accessing buff data
   - Verify buff existence before accessing properties
   - Handle undefined buff states appropriately

4. Integration:
   - Coordinate with spell prediction systems
   - Consider buff durations in combat calculations
   - Use buff data to inform decision-making logic

## Core Utilities

### Enumerations (enums.lua)

#### Overview
Provides a comprehensive set of enumerations for game-related constants and type definitions.

#### Class and Specialization
- `class_id` - Class identifiers (WARRIOR, PALADIN, etc.)
- `class_id_to_name` - Maps class IDs to names
- `spec_enum` - Specialization identifiers (ARMS_WARRIOR, HOLY_PALADIN, etc.)
- `class_spec_id` - Class/spec mapping utilities
  - `get_specialization_name(char_class_id, char_spec_id)` - Get spec name
  - `get_specialization_enum(char_class_id, char_spec_id)` - Get spec enum
  - `get_spec_id_from_enum(spec_enum)` - Convert enum to ID

#### Resource Types
- `power_type` - Resource types (MANA, RAGE, ENERGY, etc.)
- `group_role` - Role definitions (TANK, HEALER, DAMAGER)

#### Unit Classification
- `classification` - Unit types (NORMAL, ELITE, RARE, etc.)
- `mark_index` - Target markers (STAR, CIRCLE, DIAMOND, etc.)

#### Combat and Control
- `loss_of_control_type` - Control effects (STUN, FEAR, ROOT, etc.)
- `spell_schools_flags` - Spell schools (Physical, Holy, Fire, etc.)
  - `combine(...: string)` - Combine school flags
  - `contains(value, flag)` - Check flag presence
- `spell_type` - Spell targeting types (TARGET, POSITION)
- `trigger_mode` - Trigger types (BASIC, PREDICTION)

#### Buff System
- `buff_type` - Buff categories (MAGIC, CURSE, DISEASE, etc.)
- `buff_type_to_string` - Maps buff types to names

#### UI and Menu
- `menu_element_type` - UI element types (BUTTON, CHECKBOX, etc.)
- `window_enums` - Window-related enumerations
  - `window_behaviour_flags`
  - `font_id`
  - `rect_borders_rounding_flags`
  - `window_resizing_flags`
  - `window_cross_visuals`

#### World Interaction
- `collision_flags` - Collision types
  - `combine(...: string)` - Combine collision flags

### Unit Manager (unit_manager.lua)

#### Overview
Provides centralized unit list management and caching for efficient unit tracking and querying.

#### Core Functions

##### Cache Management
- `get_cache_unit_list_raw()` - Get raw unit cache list
  - Returns: table - Raw unit cache data

- `get_cache_unit_list()` - Get processed unit cache list
  - Returns: table - Processed unit cache data

##### Unit Queries
- `get_enemies_around_point(point, range, players_only, include_dead)` - Find nearby enemies
  - Parameters:
    - point: table - Center point
    - range: number - Search radius
    - players_only: boolean - Only include players
    - include_dead: boolean - Include dead units
  - Returns: table - List of enemy units

- `get_allies_around_point(point, range, players_only, party_only, include_dead)` - Find nearby allies
  - Parameters:
    - point: table - Center point
    - range: number - Search radius
    - players_only: boolean - Only include players
    - party_only: boolean - Only include party members
    - include_dead: boolean - Include dead units
  - Returns: table - List of allied units

##### Cache Processing
- `process()` - Update unit cache
  - Processes and updates the internal unit cache

#### Best Practices

1. Cache Usage:
   - Use cached lists when possible
   - Consider cache freshness requirements
   - Balance update frequency with performance

2. Query Optimization:
   - Use appropriate filters (players_only, party_only)
   - Consider range requirements carefully
   - Handle dead units appropriately

3. Performance:
   - Minimize cache processing frequency
   - Batch unit queries when possible
   - Use raw cache for bulk operations

4. Integration:
   - Coordinate with spell targeting systems
   - Consider unit visibility requirements
   - Handle dynamic unit updates


## Geometry System

### Overview
The geometry system provides comprehensive 2D and 3D vector operations along with shape manipulation capabilities. It consists of three main components:
- Vector operations (vec2.lua, vec3.lua)
- Shape definitions and operations (geometry.lua)

### Vector Operations

#### 2D Vector (vec2.lua)
The vec2 class provides operations for 2D vector manipulation.

##### Core Properties
- `x: number` - X coordinate
- `y: number` - Y coordinate

##### Basic Operations
- `new(x: number, y: number): vec2` - Create new vector
- `clone(): vec2` - Clone vector
- Operator overloads for +, -, *, /, ==

##### Vector Mathematics
- `normalize(): vec2` - Normalize vector
- `length(): number` - Get vector length
- `length_squared(): number` - Get squared length
- `dot(v: vec2): number` - Calculate dot product
- `lerp(target: vec2, alpha: number): vec2` - Linear interpolation

##### Vector Analysis
- `is_nan(): boolean` - Check for NaN values
- `is_zero(): boolean` - Check if zero vector
- `get_unit_vector(): vec2` - Get unit vector
- `dist_to(other: vec2): number` - Distance to other vector
- `squared_dist_to(other: vec2): number` - Squared distance

##### Geometric Operations
- `rotate_around(origin: vec2, degrees: number): vec2` - Rotate around point
- `get_angle(target: vec2, origin: vec2): number` - Get angle between vectors
- `intersects(segment_end: vec2, point: vec2, margin: number, radius: number, denominator: number): boolean` - Check intersection
- `get_perp_left/right(origin: vec2): vec2` - Get perpendicular vectors
- `get_perp_left/right_factor(origin: vec2, factor: number): vec2` - Get scaled perpendicular vectors

#### 3D Vector (vec3.lua)
The vec3 class extends 2D vector operations to three dimensions.

##### Core Properties
- `x: number` - X coordinate
- `y: number` - Y coordinate
- `z: number` - Z coordinate

##### Basic Operations
- `new(x: number, y: number, z: number): vec3` - Create new vector
- `clone(): vec3` - Clone vector
- Operator overloads for +, -, *, /, ==

##### Vector Mathematics
- `normalize(): vec3` - Normalize vector
- `length(): number` - Get vector length
- `length_squared(): number` - Get squared length
- `dot(v: vec3): number` - Calculate dot product
- `cross(v: vec3): vec3` - Calculate cross product
- `lerp(target: vec3, alpha: number): vec3` - Linear interpolation

##### Vector Analysis
- `is_nan(): boolean` - Check for NaN values
- `is_zero(): boolean` - Check if zero vector
- `get_unit_vector(): vec3` - Get unit vector
- `dist_to(other: vec3): number` - Distance to other vector
- `squared_dist_to(other: vec3): number` - Squared distance

##### Special Operations
- `dist_to_ignore_z(other: vec3): number` - Distance ignoring Z coordinate
- `squared_dist_to_ignore_z(other: vec3): number` - Squared distance ignoring Z
- `project_2d(): vec3` - Project onto 2D plane
- `rotate_3d_radians(angle_radians: number): vec3` - Rotate around Z axis

### Shape System (geometry.lua)

#### Circle
```lua
---@class circle
---@field public center vec3
---@field public radius number
```

##### Core Functions
- `create(center: vec3, radius: number): circle` - Create circle
- `is_inside(point: vec3, hitbox: number): boolean` - Check if point inside
- `get_units_inside(units_list: table<game_object>): table<game_object>` - Get units in circle
- `get_optimal_hit_position(search_center: vec3, search_radius: number, max_range: number, include_enemies: boolean, include_allies: boolean): circle_data` - Find optimal position

##### Visualization
- `draw(): nil` - Draw circle
- `draw_with_counter(units_hit_count: number?): nil` - Draw with unit counter

#### Rectangle
```lua
---@class rectangle
---@field public corner1 vec3
---@field public corner2 vec3
---@field public corner3 vec3
---@field public corner4 vec3
---@field public width number
---@field public length number
---@field public origin vec3
---@field public destination vec3
```

##### Core Functions
- `create(origin: vec3, destination: vec3, width: number, length: number?): rectangle` - Create rectangle
- `create_direction(position: vec3, direction: vec3, width: number, length: number): rectangle` - Create from direction
- `is_inside(point: vec3, hitbox: number): boolean` - Check if point inside
- `get_units_inside(units_list: table<game_object>): table<game_object>` - Get units in rectangle

##### Visualization
- `draw(): nil` - Draw rectangle
- `draw_with_counter(count: number?): nil` - Draw with unit counter

#### Cone
```lua
---@class cone
---@field public center vec3
---@field public radius number
---@field public angle_raw number
---@field public angle number
---@field public direction vec3
```

##### Core Functions
- `create(center: vec3, destination: vec3, radius: number, angle: number): cone` - Create cone
- `create_direction(center: vec3, direction: vec3, radius: number, angle: number): cone` - Create from direction
- `create_unit_frontal(unit: game_object, radius: number, angle: number): cone` - Create from unit
- `is_inside(point_position: vec3, hitbox: number): boolean` - Check if point inside
- `get_units_inside(units_list: table<game_object>): table<game_object>` - Get units in cone

##### Visualization
- `draw(color?: color, thickness?: number): nil` - Draw cone
- `draw_with_counter(count: number?): nil` - Draw with unit counter

### Best Practices

1. Vector Usage:
   - Use vec2 for 2D operations (UI, screen coordinates)
   - Use vec3 for 3D operations (world positions, directions)
   - Consider performance implications of vector operations

2. Shape Selection:
   - Use circles for radial effects and area detection
   - Use rectangles for linear effects and corridors
   - Use cones for directional effects and field of view

3. Performance Optimization:
   - Use squared distances when possible to avoid sqrt calculations
   - Cache vector calculations when used repeatedly
   - Consider using simpler shapes for collision detection

4. Integration:
   - Coordinate with spell prediction systems
   - Use with movement prediction
   - Integrate with rendering systems for debugging

## Utility Helpers

### Spell Queue System (spell_queue.lua)

#### Overview
The Spell Queue System provides functionality for queuing spells with priorities and managing their execution. It's particularly useful for implementing rotation systems and handling spell priorities.

#### Core Functions

##### Queue Management
- `queue_spell_target(spell_id, target, priority)` - Queue spell cast on target
  - Parameters:
    - spell_id: number - ID of spell to cast
    - target: game_object - Target for the spell
    - priority: number - Cast priority (lower numbers = higher priority)
  - Returns: boolean - Queue success status

- `is_spell_queueable(spell_id, caster, target, skip_facing, skip_range)` - Check if spell can be queued
  - Parameters:
    - spell_id: number - Spell to check
    - caster: game_object - Casting unit
    - target: game_object - Target unit
    - skip_facing: boolean - Skip facing requirement check
    - skip_range: boolean - Skip range requirement check
  - Returns: boolean - Whether spell can be queued

#### Usage Example

```lua
---@type spell_queue
local queue = require("common/modules/spell_queue")

-- Check if spell can be queued
if queue:is_spell_queueable(spell_id, caster, target, false, false) then
    -- Queue spell with priority
    queue:queue_spell_target(spell_id, target, 1)
end
```

### Rotation Implementation Patterns

#### Basic Rotation Structure
```lua
---@return boolean
function FS.[class]_[spec].logic.rotations.[rotation_name]()
    -- Check rotation conditions
    if not FS.[class]_[spec].variables.[condition]() then
        return false
    end
    
    -- Execute rotation priority
    if FS.[class]_[spec].logic.spells.[spell1]() then
        return true
    end
    if FS.[class]_[spec].logic.spells.[spell2]() then
        return true
    end
    return true
end
```

#### Spell Implementation Pattern
```lua
---@return boolean
function FS.[class]_[spec].logic.spells.[spell_name]()
    -- Get valid target
    local target = FS.variables.enemy_target()
    if not target then
        return false
    end
    
    -- Check conditions (buffs, resources, etc.)
    if not FS.[class]_[spec].variables.[condition]() then
        return false
    end
    
    -- Check spell can be cast
    if not FS.api.spell_helper:is_spell_queueable(FS.[class]_[spec].spells.[spell], FS.variables.me, target, false, false) then
        return false
    end
    
    -- Queue spell cast
    FS.api.spell_queue:queue_spell_target(FS.[class]_[spec].spells.[spell], target, 1)
    return true
end
```

#### Best Practices

1. Rotation Management:
   - Clear priority system
   - Proper condition checking
   - Resource management
   - Buff tracking integration

2. Spell Queueing:
   - Appropriate priority levels
   - Target validation
   - Condition verification
   - Error handling

3. Performance:
   - Efficient condition checks
   - Minimize redundant checks
   - Handle edge cases

4. Integration:
   - Coordinate with buff system
   - Handle resource management
   - Consider cooldown tracking
   - Manage spell priorities

### Spell Helper (spell_helper.lua)

#### Overview
The Spell Helper provides comprehensive spell management functionality, including range checking, resource management, line of sight verification, and spell castability validation.

#### Core Functions

##### Spell State Checks
- `has_spell_equipped(spell_id)` - Check if spell is in spellbook
- `is_spell_on_cooldown(spell_id)` - Check spell cooldown status
- `get_remaining_charge_cooldown(spell_id)` - Get charge cooldown info
  - Returns: number, number - Current charge cooldown, total cooldown

##### Range and Position Checks
- `is_spell_in_range(spell_id, target, source, destination)` - Check cast range
- `is_spell_within_angle(spell_id, caster, target, caster_position, target_position)` - Check cast angle
- `is_spell_in_line_of_sight(spell_id, caster, target)` - Check line of sight to target
- `is_spell_in_line_of_sight_position(spell_id, caster, cast_position)` - Check line of sight to position

##### Resource Management
- `get_spell_cost(spell_id)` - Get spell resource cost
  - Returns: table - Cost information
- `can_afford_spell(unit, spell_id, spell_costs)` - Check resource availability

##### Castability Validation
- `is_spell_castable(spell_id, caster, target, skip_facing, skips_range)` - Check if spell can be cast
- `is_spell_castable_position(spell_id, caster, target, cast_position, skip_facing, skips_range, is_queue?)` - Check position cast
- `is_spell_queueable(spell_id, caster, target, skip_facing, skips_range)` - Check if spell can be queued

##### Damage and Healing
- `get_spell_damage(spell_id, ignore_percentage?, ignore_flat?)` - Get spell damage
- `get_spell_healing(spell_id, ignore_percentage?, ignore_flat?)` - Get spell healing

#### Usage Example

```lua
---@type spell_helper
local spell = require("common/utility/spell_helper")

-- Check if spell is available
local spell_id = 12345
if spell:has_spell_equipped(spell_id) and not spell:is_spell_on_cooldown(spell_id) then
    -- Check resources and range
    local costs = spell:get_spell_cost(spell_id)
    if spell:can_afford_spell(caster, spell_id, costs) then
        if spell:is_spell_in_range(spell_id, target, caster_pos, target_pos) then
            -- Validate line of sight and castability
            if spell:is_spell_in_line_of_sight(spell_id, caster, target) then
                if spell:is_spell_castable(spell_id, caster, target, false, false) then
                    -- Cast spell
                    local damage = spell:get_spell_damage(spell_id)
                    -- Handle casting logic
                end
            end
        end
    end
end

-- Check charge cooldowns
local current_charge_cd, total_cd = spell:get_remaining_charge_cooldown(spell_id)
```

#### Best Practices

1. Validation Order:
   - Check basic requirements first (equipped, cooldown)
   - Validate resources before position checks
   - Perform line of sight checks last

2. Resource Management:
   - Cache spell costs when possible
   - Consider resource regeneration
   - Handle multiple resource types

3. Position Handling:
   - Use accurate position data
   - Consider movement prediction
   - Handle edge cases in range checks

4. Performance Optimization:
   - Cache frequently used results
   - Minimize redundant checks
   - Use appropriate skip flags

### Control Panel Helper (control_panel_helper.lua)

#### Overview
The Control Panel Helper provides functionality for managing and updating control panel elements, including toggles and combo boxes, with support for drag-and-drop functionality.

#### Core Functions

##### Panel Management
- `on_update(menu)` - Update control panel elements
  - Parameters:
    - menu: table - Menu configuration to update from

##### Toggle Controls
- `insert_toggle(control_panel_table, toggle_table, only_drag_drop?)` - Insert toggle from table
  - Parameters:
    - control_panel_table: table - Target control panel
    - toggle_table: table - Toggle configuration
    - only_drag_drop?: boolean - Optional drag-drop only mode
  - Returns: boolean - Success status

- `insert_toggle_(control_panel_table, display_name, keybind_element, only_drag_drop?, no_drag_and_drop?)` - Insert toggle with parameters
  - Parameters:
    - control_panel_table: table - Target control panel
    - display_name: string - Toggle display name
userdata - Associated keybind
    - only_drag_drop?: boolean - Optional drag-drop only mode
    - no_drag_and_drop?: boolean - Optional disable drag-drop
  - Returns: boolean - Success status

##### Combo Controls
- `insert_combo(control_panel_table, combo_table, increase_index_key, only_drag_drop?)` - Insert combo from table
  - Parameters:
    - control_panel_table: table - Target control panel
    - combo_table: table - Combo configuration
    - increase_index_key: userdata - Key for index increment
    - only_drag_drop?: boolean - Optional drag-drop only mode
  - Returns: boolean - Success status

- `insert_combo_(control_panel_table, display_name, combobox_element, preview_value, max_items, increase_index_key, only_drag_drop?)` - Insert combo with parameters
  - Parameters:
    - control_panel_table: table - Target control panel
    - display_name: string - Combo display name
    - combobox_element: userdata - Combo box element
    - preview_value: any - Preview value
    - max_items: number - Maximum items
    - increase_index_key: userdata - Key for index increment
    - only_drag_drop?: boolean - Optional drag-drop only mode
  - Returns: boolean - Success status

#### Usage Example

```lua
---@type control_panel_helper
local cp_helper = require("common/utility/control_panel_helper")

-- Insert toggle with keybind
local success = cp_helper:insert_toggle_(
    control_panel,           -- Control panel table
    "Enable Feature",        -- Display name
    some_keybind_element,   -- Keybind element
    false,                  -- Not drag-drop only
    false                   -- Allow drag-drop
)

-- Insert combo box
local combo_success = cp_helper:insert_combo_(
    control_panel,           -- Control panel table
    "Select Option",         -- Display name
    combo_element,           -- Combo box element
    "Default",               -- Preview value
    5,                      -- Max items
    increment_key,          -- Index increment key
    false                   -- Not drag-drop only
)

-- Update panel
cp_helper:on_update(menu_config)
```

#### Best Practices

1. Panel Organization:
   - Group related controls together
   - Use clear, descriptive display names
   - Maintain consistent layout patterns

2. Drag-Drop Management:
   - Consider user interaction needs
   - Handle drag-drop states properly
   - Provide appropriate feedback

3. Control Configuration:
   - Initialize controls with default values
   - Validate input parameters
   - Handle state changes gracefully

4. Performance Considerations:
   - Batch control updates when possible
   - Minimize unnecessary panel updates
   - Handle large control sets efficiently

### Inventory Helper (inventory_helper.lua)

#### Overview
The Inventory Helper provides centralized inventory management functionality, simplifying access to items across bags, bank slots, and tracking consumables like potions and elixirs.

#### Data Structures

```lua
---@class slot_data
---@field public item game_object          -- The item object in this slot
---@field public global_slot number        -- Global slot identifier
---@field public bag_id integer            -- ID of the bag containing the item
---@field public bag_slot integer          -- Slot number within the bag
---@field public stack_count integer       -- Stack count of the item in this slot

---@class consumable_data
---@field public is_mana_potion boolean    -- Whether the item is a mana potion
---@field public is_health_potion boolean  -- Whether the item is a health potion
---@field public is_damage_bonus_potion boolean -- Whether the item is a damage bonus potion
---@field public item game_object          -- The item object for the consumable
---@field public bag_id integer            -- ID of the bag containing the item
---@field public bag_slot integer          -- Slot number within the bag
---@field public stack_count integer       -- Stack count of the item in this slot
```

#### Core Functions

##### Slot Management
- `get_all_slots()` - Get all inventory slots
  - Returns: table<slot_data> - All available slots

- `get_character_bag_slots()` - Get character bag slots
  - Returns: table<slot_data> - Character bag slots

- `get_bank_slots()` - Get bank slots
  - Returns: table<slot_data> - Bank slots

##### Consumable Management
- `get_current_consumables_list()` - Get consumable items
  - Returns: table<consumable_data> - Available consumables

- `update_consumables_list()` - Update consumable tracking
  - Updates internal consumable tracking

- `debug_print_consumables()` - Print consumable debug info
  - Outputs debug information about consumables

#### Usage Example

```lua
---@type inventory_helper
local inventory = require("common/utility/inventory_helper")

-- Get all inventory slots
local all_slots = inventory:get_all_slots()
for _, slot in ipairs(all_slots) do
    local item = slot.item
    local count = slot.stack_count
    -- Process items
end

-- Check consumables
local consumables = inventory:get_current_consumables_list()
for _, consumable in ipairs(consumables) do
    if consumable.is_health_potion then
        -- Handle health potions
    elseif consumable.is_mana_potion then
        -- Handle mana potions
    end
end

-- Update tracking
inventory:update_consumables_list()
```

#### Best Practices

1. Slot Management:
   - Track slot changes efficiently
   - Handle bag updates properly
   - Consider slot organization

2. Consumable Tracking:
   - Update consumables regularly
   - Monitor stack counts
   - Handle consumable types appropriately

3. Bank Integration:
   - Handle bank access states
   - Track bank slot changes
   - Consider bank organization

4. Performance Optimization:
   - Cache inventory states
   - Batch inventory updates
   - Minimize unnecessary scans

### Key Helper (key_helper.lua)

#### Overview
The Key Helper provides functionality for translating key codes into human-readable key names, making it easier to work with keyboard input and keybindings.

#### Core Functions

##### Key Name Translation
- `get_key_name(key_code)` - Get human-readable key name
  - Parameters:
    - key_code: number - Virtual key code to translate
  - Returns: string - Human-readable key name

#### Usage Example

```lua
---@type key_helper
local keys = require("common/utility/key_helper")

-- Translate key code to name
local key_code = 65  -- 'A' key
local key_name = keys:get_key_name(key_code)  -- Returns "A"

-- Use in keybind display
local function display_keybind(code)
    local name = keys:get_key_name(code)
    -- Show keybind in UI
end
```

#### Best Practices

1. Key Code Handling:
   - Validate key codes before translation
   - Handle special key cases
   - Consider keyboard layouts

2. UI Integration:
   - Use for keybind displays
   - Update key names dynamically
   - Handle localization if needed

3. Error Prevention:
   - Handle invalid key codes
   - Consider platform differences
   - Validate input ranges

4. Performance Considerations:
   - Cache frequently used key names
   - Batch key name translations
   - Update only when necessary

### Plugin Helper (plugin_helper.lua)

#### Overview
The Plugin Helper provides functionality for managing plugin states, toggle elements, and UI drawing capabilities, with support for combat timing and defensive action management.

#### Core Functions

##### Toggle and Keybind Management
- `is_toggle_binded(element)` - Check toggle binding state
  - Parameters:
    - element: keybind - Toggle element to check
  - Returns: boolean - Binding status

- `is_toggle_enabled(element)` - Check toggle enabled state
  - Parameters:
    - element: keybind - Toggle element to check
  - Returns: boolean - Toggle state

- `is_keybind_enabled(element)` - Check keybind state
  - Parameters:
    - element: keybind - Keybind to check
  - Returns: boolean - Keybind state

##### UI Drawing
- `draw_text_character_center(text, text_color?, y_offset?, is_static?, counter_special_id?)` - Draw centered character text
  - Parameters:
    - text: string - Text to draw
    - text_color?: color - Optional text color
    - y_offset?: number - Optional vertical offset
    - is_static?: boolean - Optional static positioning
    - counter_special_id?: string - Optional counter ID

- `draw_text_message(text, text_color, border_color, screen_position, size, is_static, add_rectangles, unique_id, counter_special_id?)` - Draw message text
  - Parameters:
    - text: string - Text to draw
    - text_color: color - Text color
    - border_color: color - Border color
    - screen_position: vec2 - Position on screen
    - size: vec2 - Text size
    - is_static: boolean - Static positioning
    - add_rectangles: boolean - Add background rectangles
    - unique_id: string - Message identifier
    - counter_special_id?: string - Optional counter ID

##### Combat and Timing
- `get_latency()` - Get current latency
  - Returns: number - Clamped latency value

- `get_current_combat_length_seconds()` - Get combat length in seconds
  - Returns: number - Combat duration in core time

- `get_current_combat_length_miliseconds()` - Get combat length in milliseconds
  - Returns: number - Combat duration in game time

##### Defensive Management
- `is_defensive_allowed()` - Check defensive action status
  - Returns: boolean - Whether defensive actions are allowed

- `get_defensive_block_time()` - Get defensive block duration
  - Returns: number - Current block time

- `set_defensive_block_time(extra_time)` - Set defensive block duration
  - Parameters:
    - extra_time: number - Additional block time

#### Usage Example

```lua
---@type plugin_helper
local plugin = require("common/utility/plugin_helper")

-- Check toggle and keybind states
if plugin:is_toggle_enabled(some_toggle) then
    if plugin:is_keybind_enabled(some_keybind) then
        -- Handle enabled state
    end
end

-- Draw UI elements
plugin:draw_text_character_center(
    "Active Effect",
    color.new(255, 255, 255),
    20,  -- y offset
    true -- static
)

-- Handle defensive timing
if plugin:is_defensive_allowed() then
    -- Use defensive ability
    plugin:set_defensive_block_time(5.0)  -- Block for 5 seconds
end

-- Get combat timing
local combat_time = plugin:get_current_combat_length_seconds()
local latency = plugin:get_latency()
```

#### Best Practices

1. Toggle Management:
   - Validate toggle states
   - Handle special cases
   - Consider state combinations

2. UI Drawing:
   - Use appropriate positioning
   - Handle screen boundaries
   - Consider visibility conditions

3. Combat Timing:
   - Account for latency
   - Use appropriate time units
   - Handle combat state changes

4. Defensive Management:
   - Coordinate defensive timings
   - Handle overlapping blocks
   - Consider combat conditions

### UI Buttons Info (ui_buttons_info.lua)

#### Overview
The UI Buttons Info helper provides functionality for managing UI buttons, their states, and associated logic. It handles button creation, state tracking, and timeout management for UI interactions.

#### Core Properties
- `launch_checkbox: checkbox` - Checkbox for launch control
- `force_render: checkbox` - Checkbox for forcing render state

#### Core Functions

##### Button Management
- `are_buttons_empty()` - Check if no buttons exist
  - Returns: boolean - Empty status

- `push_button(button_id, title, spell_ids, logic_function)` - Add new button
  - Parameters:
    - button_id: string - Unique button identifier
    - title: string - Button display title
    - spell_ids: table<integer> - Associated spell IDs
    - logic_function: function - Button click handler
  - Returns: nil

##### Button Information
- `get_button_info(button_id)` - Get specific button data
  - Parameters:
    - button_id: string - Button to retrieve
nil - Button information or nil

- `get_current_buttons_infos()` - Get all button data
  - Returns: table - Current button information

##### Logic and Timing
- `is_logic_attempting_only_once()` - Check logic execution mode
  - Returns: boolean - Single attempt status

- `get_timeout_time()` - Get button timeout duration
  - Returns: number - Timeout time

- `set_no_render_timeout_time_slider_flag(state)` - Set timeout slider visibility
  - Parameters:
    - state: boolean - Slider visibility state
  - Returns: nil

##### Target Management
- `is_target_dr_allowed(target, cc_type, hit_time)` - Check diminishing returns
  - Parameters:
    - target: game_object - Target to check
    - cc_type: number - Crowd control type
    - hit_time: number - Time of hit
  - Returns: nil

#### Usage Example

```lua
---@type ui_buttons_info
local ui = require("common/utility/ui_buttons_info")

-- Check button state
if ui:are_buttons_empty() then
    -- Add new button
    ui:push_button(
        "combat_button",     -- Button ID
        "Combat Action",     -- Display title
        {12345, 67890},     -- Spell IDs
        function()          -- Click handler
            -- Handle button click
        end
    )
end

-- Get button information
local button_info = ui:get_button_info("combat_button")
if button_info then
    -- Process button info
end

-- Configure timing
local timeout = ui:get_timeout_time()
ui:set_no_render_timeout_time_slider_flag(true)

-- Check target DR
if ui:is_target_dr_allowed(target, cc_type, current_time) then
    -- Process allowed target
end
```

#### Best Practices

1. Button Management:
   - Use unique button IDs
   - Group related buttons
   - Handle button states properly

2. Logic Handling:
   - Keep logic functions focused
   - Handle errors gracefully
   - Consider timing constraints

3. State Management:
   - Track button states
   - Handle timeouts properly
   - Manage render flags

4. Performance Considerations:
   - Minimize button updates
   - Cache button information
   - Handle timing efficiently

## Core API (core.lua)

### Logging Functions
- `core.log(message)` - Log message to console
- `core.log_file(message)` - Log message to files
- `core.log_warning(message)` - Log warning message
- `core.log_error(message)` - Log error message

### Event Registration
- `core.register_on_pre_tick_callback(callback)` - Register pre-tick callback
- `core.register_on_render_window_callback(callback)` - Register render window callback
- `core.register_on_update_callback(callback)` - Register update callback
- `core.register_on_render_callback(callback)` - Register render callback
- `core.register_on_render_menu_callback(callback)` - Register menu render callback
- `core.register_on_render_control_panel_callback(callback)` - Register control panel callback
- `core.register_on_legit_spell_cast_callback(callback)` - Register legit spell cast callback
- `core.register_on_spell_cast_callback(callback)` - Register spell cast callback

### Time and State Functions
- `core.get_ping()` - Get current ping
- `core.time()` - Get time since injection in milliseconds
- `core.game_time()` - Get time since game start in milliseconds
- `core.delta_time()` - Get time since last frame in seconds
- `core.cpu_ticks()` - Get CPU ticks (for profiling)
- `core.cpu_ticks_per_second()` - Get CPU ticks per second

### Game State Information
- `core.get_map_id()` - Get current map ID
- `core.get_instance_id()` - Get instance ID
- `core.get_difficulty_id()` - Get difficulty ID
- `core.get_keystone_level()` - Get keystone level
- `core.get_map_name()` - Get map name
- `core.get_instance_name()` - Get instance name
- `core.get_difficulty_name()` - Get difficulty name
- `core.is_debug()` - Check if in debug mode

### Input System (core.input)
- Spell Casting:
  - `core.input.cast_target_spell(spell_id, target)` - Cast spell on target
  - `core.input.cast_position_spell(spell_id, position)` - Cast spell at position
  - `core.input.use_item(item_id)` - Use item
  - `core.input.use_item_target(item_id, target)` - Use item on target
  - `core.input.use_item_position(item_id, position)` - Use item at position

- Movement Control:
  - `core.input.turn_right_start/stop()` - Control right turning
  - `core.input.turn_left_start/stop()` - Control left turning
  - `core.input.strafe_right_start/stop()` - Control right strafing
  - `core.input.strafe_left_start/stop()` - Control left strafing
  - `core.input.move_forward_start/stop()` - Control forward movement
  - `core.input.move_backward_start/stop()` - Control backward movement

- Pet Commands:
  - `core.input.set_pet_passive()` - Set pet to passive mode
  - `core.input.set_pet_defensive()` - Set pet to defensive mode
  - `core.input.set_pet_aggressive()` - Set pet to aggressive mode
  - `core.input.set_pet_assist()` - Set pet to assist mode
  - `core.input.set_pet_wait()` - Command pet to wait
  - `core.input.set_pet_follow()` - Command pet to follow
  - `core.input.pet_attack(target)` - Command pet to attack
  - `core.input.pet_cast_target_spell(spell_id, target)` - Pet cast spell on target
  - `core.input.pet_cast_position_spell(spell_id, position)` - Pet cast spell at position

### Object Manager (core.object_manager)
- `core.object_manager.get_local_player()` - Get local player object
- `core.object_manager.get_all_objects()` - Get all game objects
- `core.object_manager.get_visible_objects()` - Get visible objects
- `core.object_manager.get_arena_frames()` - Get arena frames
- `core.object_manager.get_mouse_over_object()` - Get mouse over object

### Spell Book (core.spell_book)
- Spell Information:
  - `core.spell_book.get_spell_name(spell_id)` - Get spell name
  - `core.spell_book.get_spell_description(spell_id)` - Get spell description
  - `core.spell_book.get_spell_cooldown(spell_id)` - Get spell cooldown
  - `core.spell_book.get_spell_range_data(spell_id)` - Get spell range data
  - `core.spell_book.get_spell_costs(spell_id)` - Get spell costs

### Graphics System (core.graphics)
- 2D Drawing:
  - `core.graphics.text_2d(text, position, font_size, color, centered, font_id)` - Draw 2D text
  - `core.graphics.line_2d(start_point, end_point, color, thickness)` - Draw 2D line
  - `core.graphics.rect_2d(top_left_point, width, height, color, thickness, rounding)` - Draw 2D rectangle
  - `core.graphics.circle_2d(center, radius, color, thickness)` - Draw 2D circle

- 3D Drawing:
  - `core.graphics.text_3d(text, position, font_size, color, centered, font_id)` - Draw 3D text
  - `core.graphics.line_3d(start_point, end_point, color, thickness, fade_factor)` - Draw 3D line
  - `core.graphics.circle_3d(center, radius, color, thickness, fade_factor)` - Draw 3D circle

### Menu System (core.menu)
- UI Elements:
  - `core.menu.checkbox(default_state, id)` - Create checkbox
  - `core.menu.slider_int(min_value, max_value, default_value, id)` - Create integer slider
  - `core.menu.slider_float(min_value, max_value, default_value, id)` - Create float slider
  - `core.menu.combobox(default_index, id)` - Create combobox
  - `core.menu.button(id)` - Create button
  - `core.menu.colorpicker(default_color, id)` - Create color picker
  - `core.menu.text_input(id)` - Create text input
  - `core.menu.window(window_id)` - Create window

## Usage Notes

1. Event System:
   - Register callbacks for various game events
   - Use for monitoring and responding to game state changes

2. Object Management:
   - Access and manipulate game objects
   - Track player, units, and world objects

3. Input System:
   - Control character movement
   - Cast spells and use items
   - Manage pet commands

4. Graphics:
   - Draw UI elements and overlays
   - Render text, shapes, and images
   - Handle 2D and 3D drawing operations

5. Menu System:
   - Create interactive UI elements
   - Build custom control panels
   - Handle user input through UI

## Game Object Interface (game_object.lua)

### Basic Properties and Type Checking
- `is_valid()` - Check if object is valid
- `is_visible()` - Check if object is visible
- `get_type()` - Get object type
- `get_class()` - Get object class
- `get_specialization_id()` - Get specialization ID
- `get_npc_id()` - Get NPC ID
- `get_item_id()` - Get item ID
- `get_level()` - Get object level
- `get_faction_id()` - Get faction ID

### Object Classification
- `get_target_marker_index()` - Get target marker (0-8)
  - 0: No Icon
  - 1: Yellow Star
  - 2: Orange Circle
  - 3: Purple Diamond
  - 4: Green Triangle
  - 5: White Moon
  - 6: Blue Square
  - 7: Red Cross
  - 8: White Skull

- `get_creature_type()` - Get creature type
  - 1: Beast
  - 2: Dragonkin
  - 3: Demon
  - 4: Elemental
  - 5: Giant
  - 6: Undead
  - 7: Humanoid
  - 8: Critter
  - 9: Mechanical
  - 10: Not specified
  - 11: Totem
  - 12: Non-combat Pet
  - 13: Gas Cloud
  - 14: Wild Pet
  - 15: Aberration

- `get_classification()` - Get classification
  - -1: Unknown
  - 0: Normal
  - 1: Elite
  - 2: Rare Elite
  - 3: World Boss
  - 4: Rare
  - 5: Trivial
  - 6: Minus

### Role and Status
- `get_group_role()` - Get group role
  - -1: None/Unknown
  - 0: Tank
  - 1: Healer
  - 2: Damager

### Physical Properties
- `get_bounding_radius()` - Get bounding radius
- `get_height()` - Get height
- `get_scale()` - Get scale
- `get_position()` - Get position (vec3)
- `get_rotation()` - Get rotation
- `get_direction()` - Get direction (vec3)
- `get_movement_direction()` - Get movement direction (vec3)

### State Checks
- `is_dead()` - Check if dead
- `is_ghost()` - Check if ghost
- `is_feign_death()` - Check if feigning death
- `is_mounted()` - Check if mounted
- `is_outdoors()` - Check if outdoors
- `is_indoors()` - Check if indoors
- `is_in_combat()` - Check if in combat
- `is_moving()` - Check if moving
- `is_dashing()` - Check if dashing

### Type Checks
- `is_basic_object()` - Check if basic object
- `is_player()` - Check if player
- `is_unit()` - Check if unit
- `is_boss()` - Check if boss
- `is_item()` - Check if item
- `is_pet()` - Check if pet
- `is_minion()` - Check if minion

### Stats and Resources
- `get_health()` - Get current health
- `get_max_health()` - Get maximum health
- `get_max_health_modifier()` - Get max health modifier
- `get_power(power_type)` - Get current power
- `get_max_power(power_type)` - Get maximum power
- `get_xp()` - Get experience points
- `get_max_xp()` - Get maximum experience points
- `get_total_shield()` - Get total absorb shield
- `get_incoming_heals()` - Get total incoming heals
- `get_incoming_heals_from()` - Get incoming heals from specific source

### Movement and Speed
- `get_movement_speed()` - Get current movement speed
- `get_movement_speed_max()` - Get maximum movement speed
- `get_swim_speed_max()` - Get maximum swim speed
- `get_flight_speed_max()` - Get maximum flight speed
- `get_attack_speed()` - Get auto attack swing speed

### Relationships and Targeting
- `can_attack(other_object)` - Check if can attack target
- `is_enemy_with(other_object)` - Check if enemy
- `is_friend_with(other_object)` - Check if friendly
- `get_owner()` - Get owner object
- `get_pet()` - Get pet object
- `get_target()` - Get current target
- `get_threat_situation(obj)` - Get threat table for target

### Spell Casting
- `is_casting_spell()` - Check if casting
- `get_active_spell_id()` - Get active spell ID
- `get_active_spell_target()` - Get spell target
- `get_active_spell_cast_start_time()` - Get cast start time
- `get_active_spell_cast_end_time()` - Get cast end time
- `is_active_spell_interruptable()` - Check if interruptible
- `is_channelling_spell()` - Check if channeling
- `get_active_channel_spell_id()` - Get channel spell ID
- `get_active_channel_cast_start_time()` - Get channel start time
- `get_active_channel_cast_end_time()` - Get channel end time

### Buffs and Debuffs
- `get_auras()` - Get all auras
- `get_buffs()` - Get buffs
- `get_debuffs()` - Get debuffs

### Items and Equipment
- `get_item_cooldown(item_id)` - Get item cooldown
- `has_item(item_id)` - Check if has item
- `is_item_bag()` - Check if item is bag
- `get_item_stack_count()` - Get item stack count
- `get_equipped_items()` - Get equipped items
- `get_item_at_inventory_slot(slot)` - Get item in slot

### Interaction States
- `can_be_looted()` - Check if lootable
- `can_be_used()` - Check if usable
- `can_be_skinned()` - Check if skinnable
- `get_loss_of_control_info()` - Get loss of control info

## Data Structures

### Threat Table
```lua
---@class threat_table
---@field public is_tanking boolean
---@field public status integer -- 0, 1, 2, 3
---@field public threat_percent number -- 0 to 100
```

### Buff
```lua
---@class buff
---@field public buff_name string
---@field public buff_id integer
---@field public count number
---@field public expire_time number
---@field public duration number
---@field public type integer
---@field public caster game_object
```

### Loss of Control Info
```lua
---@class loss_of_control_info
---@field public valid boolean
---@field public spell_id integer
---@field public start_time integer
---@field public end_time integer
---@field public duration integer
---@field public type integer
---@field public lockout_school schools_flag
```

### Item Slot Info
```lua
---@class item_slot_info
---@field public object game_object
---@field public slot_id integer

## Menu System (menu.lua)

### UI Components

#### Tree Node
```lua
---@class tree_node
- is_open() - Check if node is open
- render(header, callback) - Render tree node with header and callback
- get_widget_bounds() - Get node boundaries
- set_open_state(state) - Set node open/closed state
```

#### Checkbox
```lua
---@class checkbox
- get_state() - Get checkbox state
- set(new_state) - Set checkbox state
- render(label, tooltip) - Render checkbox with label and optional tooltip
```

#### Key Checkbox
```lua
---@class key_checkbox
- get_main_checkbox_state() - Get main checkbox state
- get_key_code() - Get key code
- get_keybind_state() - Get keybind state
- set_toggle_state(state) - Set toggle state
- set_key(key) - Set key code
- set_mode(mode) - Set mode (0=hold, 1=toggle, 2=always)
```

#### Sliders
```lua
---@class slider_int
- get() - Get current value
- set(new_value) - Set integer value
- render(label, tooltip) - Render slider with label

---@class slider_float
- get() - Get current value
- set(new_value) - Set float value
- render(label, tooltip) - Render slider with label
```

#### Combobox
```lua
---@class combobox
- get() - Get selected index
- set(new_value) - Set selected index
- render(label, options, tooltip) - Render combobox with options
- is_showing_on_control_panel() - Check control panel visibility
- set_is_showing_on_control_panel() - Set control panel visibility
```

#### Keybind
```lua
---@class keybind
- get_state() - Get current state
- get_key_code() - Get key code
- get_toggle_state() - Get toggle state
- set_key(new_key) - Set key code
- set_toggle_state(new_state) - Set toggle state
- render(label, tooltip) - Render keybind control
```

#### Button
```lua
---@class button
- is_clicked() - Check if button was clicked
- render(label, tooltip) - Render button with label
```

#### Text Input
```lua
---@class text_input
- get_text() - Get input text
- get_text_as_number() - Get text as number
- render(label, tooltip) - Render text input
- render_custom(label, tooltip, frame_bg, border_color, text_selected_bg_col, text_color, width_offset) - Custom rendering
```

#### Color Picker
```lua
---@class color_picker
- get() - Get selected color
- render(label, tooltip) - Render color picker
```

#### Header
```lua
---@class header
- render(label, color) - Render header with color
```

### Window Management

#### Window Configuration
```lua
---@class window
- set_initial_size(size) - Set initial window size
- set_initial_position(pos) - Set initial window position
- set_visibility(visibility) - Set window visibility
- set_next_widget_width(width) - Set next widget width
- set_next_window_padding(padding) - Set window padding
- set_next_window_min_size(min_size) - Set minimum window size
- set_next_window_items_spacing(spacing) - Set items spacing
```

#### Window State
- get_size() - Get window size
- get_position() - Get window position
- get_mouse_pos() - Get mouse position
- is_being_shown() - Check if window is visible
- is_window_clicked() - Check for window clicks
- is_window_hovered() - Check if window is hovered
- is_window_double_clicked() - Check for double clicks

#### Window Drawing
- render_text(font_id, pos_offset, col, text) - Render text
- render_rect(pos_min_offset, pos_max_offset, col, rounding, thickness) - Draw rectangle
- render_rect_filled(pos_min_offset, pos_max_offset, col, rounding) - Draw filled rectangle
- render_circle(center, radius, color, thickness) - Draw circle
- render_circle_filled(center, radius, color) - Draw filled circle
- render_line(p1, p2, col, thickness) - Draw line
- render_triangle(p1, p2, p3, col, thickness) - Draw triangle
- render_triangle_filled(p1, p2, p3, col) - Draw filled triangle

#### Window Animation
- animate_widget(animation_id, start_pos, end_pos, starting_alpha, max_alpha, alpha_speed, movement_speed, only_once) - Animate widget
- make_loading_circle_animation(id, center, radius, color, thickness, animation_type) - Create loading animation
- is_animation_finished(id) - Check if animation completed

### Usage Examples

1. Creating a Basic Window:
```lua
local window = core.menu.window("my_window")
window:set_initial_size(vec2.new(300, 200))
window:set_initial_position(vec2.new(100, 100))
window:begin(0, true, color.new(0,0,0,200), color.new(255,255,255), 0, function()
    -- Window content here
end)
```

2. Adding Controls:
```lua
local checkbox = core.menu.checkbox(false, "my_checkbox")
checkbox:render("Enable Feature", "Toggle this feature on/off")

local slider = core.menu.slider_int(0, 100, 50, "my_slider")
slider:render("Adjustment", "Adjust the value")

local button = core.menu.button("my_button")
button:render("Click Me", "Click to perform action")
```

3. Creating a Tree Structure:
```lua
local tree = core.menu.tree_node()
tree:render("Settings", function()
    -- Nested controls here
end)
```

4. Handling Input:
```lua
local keybind = core.menu.keybind(0, false, "my_key")
keybind:render("Hotkey", "Press key to bind")

local text_input = core.menu.text_input("my_input")
text_input:render("Name", "Enter your name")
```

### Best Practices

1. Window Management:
   - Always set initial size and position
   - Use appropriate padding and spacing
   - Handle window visibility properly

2. Controls:
   - Provide clear labels and tooltips
   - Group related controls together
   - Use appropriate control types for data

3. Animation:
   - Use animations sparingly
   - Ensure smooth transitions
   - Clean up completed animations

4. Performance:
   - Minimize dynamic content updates
   - Use efficient rendering methods
   - Handle window events appropriately