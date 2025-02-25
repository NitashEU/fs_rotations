---@class HealthValue
---@field public health number
---@field public max_health number
---@field public health_percentage number
---@field public time number

-- Object pool constants
local MAX_HISTORY_SIZE = 100 -- Maximum health records per unit
local MAX_EXPECTED_UNITS = 40 -- Maximum expected party size (raid)
local POOL_INITIAL_SIZE = 100 -- Initial pool size
local CACHE_LIFETIME = 2000 -- Cache lifetime in ms

-- Initialize heal engine module
FS.modules.heal_engine = {
    is_in_combat = false,
    ---@type game_object[]
    units = {},
    ---@type game_object[]
    tanks = {},
    ---@type game_object[]
    healers = {},
    ---@type game_object[]
    damagers = {},
    ---@type table<game_object, { health: number, max_health: number, health_percentage: number, time: number }[]>
    health_values = {},
    ---@type table<game_object, { health: number, max_health: number, health_percentage: number, time: number }>
    current_health_values = {},
    ---@type table<game_object, number>
    damage_taken_per_second = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_5_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_10_seconds = {},
    ---@type table<game_object, number>
    damage_taken_per_second_last_15_seconds = {},
    ---@type table<game_object, number>
    last_dps_values = {},
    ---@type table<game_object, number>
    fight_start_health = {},
    ---@type table<game_object, number>
    fight_total_damage = {},
    ---@type number
    fight_start_time = nil,
    ---@type table<game_object, {last_update: number, values: table<number, number>}>
    dps_cache = {},
    
    -- Object pool implementation
    ---@type HealthValue[] Pool of reusable health value objects
    health_value_pool = {},
    ---@type table[] Pool of reusable array objects
    array_pool = {},
    ---@type table<string, number> Distance calculation cache
    distance_cache = {},
    ---@type number Last time the distance cache was cleared
    distance_cache_last_cleared = 0,
    ---@type table Statistics for object pooling
    pool_stats = {
        health_value_created = 0,
        health_value_recycled = 0,
        array_created = 0,
        array_recycled = 0
    }
}

-- Object pool helper functions
---@return HealthValue
function FS.modules.heal_engine.get_health_value()
    local obj = table.remove(FS.modules.heal_engine.health_value_pool)
    if not obj then
        obj = {}
        FS.modules.heal_engine.pool_stats.health_value_created = 
            FS.modules.heal_engine.pool_stats.health_value_created + 1
    else
        FS.modules.heal_engine.pool_stats.health_value_recycled = 
            FS.modules.heal_engine.pool_stats.health_value_recycled + 1
    end
    return obj
end

---@param obj HealthValue
function FS.modules.heal_engine.release_health_value(obj)
    if not obj then return end
    
    -- Clear all fields to prevent memory leaks
    for k in pairs(obj) do
        obj[k] = nil
    end
    
    table.insert(FS.modules.heal_engine.health_value_pool, obj)
end

---@return table
function FS.modules.heal_engine.get_array()
    local arr = table.remove(FS.modules.heal_engine.array_pool)
    if not arr then
        arr = {}
        FS.modules.heal_engine.pool_stats.array_created = 
            FS.modules.heal_engine.pool_stats.array_created + 1
    else
        FS.modules.heal_engine.pool_stats.array_recycled = 
            FS.modules.heal_engine.pool_stats.array_recycled + 1
    end
    return arr
end

---@param arr table
function FS.modules.heal_engine.release_array(arr)
    if not arr then return end
    
    -- Clear all elements but preserve the table
    for i = 1, #arr do
        arr[i] = nil
    end
    
    table.insert(FS.modules.heal_engine.array_pool, arr)
end

---@param unit game_object
---@param capacity number
function FS.modules.heal_engine.initialize_circular_buffer(unit, capacity)
    -- Create a circular buffer for this unit if it doesn't exist
    if not FS.modules.heal_engine.health_values[unit] then
        FS.modules.heal_engine.health_values[unit] = {
            records = FS.modules.heal_engine.get_array(),
            next_index = 1,
            count = 0,
            capacity = capacity or MAX_HISTORY_SIZE
        }
    end
end

---@param unit game_object
---@param health_value HealthValue
function FS.modules.heal_engine.store_health_value(unit, health_value)
    local buffer = FS.modules.heal_engine.health_values[unit]
    if not buffer then
        FS.modules.heal_engine.initialize_circular_buffer(unit)
        buffer = FS.modules.heal_engine.health_values[unit]
    end
    
    -- If position already has a value, recycle it
    local old_value = buffer.records[buffer.next_index]
    if old_value then
        FS.modules.heal_engine.release_health_value(old_value)
    end
    
    -- Store the new value
    buffer.records[buffer.next_index] = health_value
    
    -- Update indices
    buffer.next_index = (buffer.next_index % buffer.capacity) + 1
    buffer.count = math.min(buffer.count + 1, buffer.capacity)
end

---@param from_pos table Vector3 position
---@param to_pos table Vector3 position
---@return number
function FS.modules.heal_engine.get_cached_distance(from_pos, to_pos)
    -- Create a unique key for this position pair
    local key = tostring(from_pos.x) .. "," .. tostring(from_pos.y) .. "," .. tostring(from_pos.z) .. "_" .. 
                tostring(to_pos.x) .. "," .. tostring(to_pos.y) .. "," .. tostring(to_pos.z)
    
    -- Return cached value if it exists
    if FS.modules.heal_engine.distance_cache[key] then
        return FS.modules.heal_engine.distance_cache[key]
    end
    
    -- Calculate and cache the distance
    local distance = from_pos:dist_to(to_pos)
    FS.modules.heal_engine.distance_cache[key] = distance
    
    return distance
end

-- Initialize object pools
function FS.modules.heal_engine.initialize_pools()
    -- Pre-allocate health value objects
    for i = 1, POOL_INITIAL_SIZE do
        table.insert(FS.modules.heal_engine.health_value_pool, {})
    end
    
    -- Pre-allocate array objects
    for i = 1, MAX_EXPECTED_UNITS do
        table.insert(FS.modules.heal_engine.array_pool, {})
    end
    
    -- Reset stats
    FS.modules.heal_engine.pool_stats = {
        health_value_created = 0,
        health_value_recycled = 0,
        array_created = 0,
        array_recycled = 0
    }
end

-- Clear caches periodically to prevent stale data
function FS.modules.heal_engine.maintain_caches(current_time)
    -- Clear distance cache if it's been too long since last clear
    if current_time - FS.modules.heal_engine.distance_cache_last_cleared > CACHE_LIFETIME then
        FS.modules.heal_engine.distance_cache = {}
        FS.modules.heal_engine.distance_cache_last_cleared = current_time
    end
end

-- Load module files
require("core/modules/heal_engine/menu")
require("core/modules/heal_engine/settings")
require("core/modules/heal_engine/start")
require("core/modules/heal_engine/reset")
require("core/modules/heal_engine/get_damage_taken_per_second")
require("core/modules/heal_engine/target_selections/index")
require("core/modules/heal_engine/on_update")

-- Initialize object pools when the module loads
FS.modules.heal_engine.initialize_pools()

-- Export module interface
---@type ModuleConfig
return {
    on_update = FS.modules.heal_engine.on_update,
    on_fast_update = FS.modules.heal_engine.on_fast_update,
    on_render_menu = FS.modules.heal_engine.menu.on_render_menu,
    on_render = function() end,
}
