--- Heal Engine Storage Management
--- Handles object pooling and buffer management

-- Get configuration values
local POOL_INITIAL_SIZE = FS.config:get("heal_engine.pooling.initial_size", 100)
local MAX_EXPECTED_UNITS = FS.config:get("heal_engine.pooling.expected_units", 40)

---@class HealthValue
---@field health number Total health including shields
---@field max_health number Maximum health of the unit
---@field health_percentage number Health percentage between 0-1
---@field time number Timestamp when this value was recorded

-- Module namespace
local storage = {
    ---@type HealthValue[] Pool of reusable health value objects
    health_value_pool = {},
    ---@type table[] Pool of reusable array objects
    array_pool = {},
    ---@type table Statistics for object pooling
    pool_stats = {
        health_value_created = 0,
        health_value_recycled = 0,
        array_created = 0,
        array_recycled = 0
    }
}

--- Get a health value object from the pool or create a new one
---@return table A health value object
function storage.get_health_value()
    local obj = table.remove(storage.health_value_pool)
    if not obj then
        obj = {}
        storage.pool_stats.health_value_created = 
            storage.pool_stats.health_value_created + 1
    else
        storage.pool_stats.health_value_recycled = 
            storage.pool_stats.health_value_recycled + 1
    end
    return obj
end

--- Return a health value object to the pool
---@param obj table The health value object to recycle
function storage.release_health_value(obj)
    if not obj then return end
    
    -- Clear all fields to prevent memory leaks
    for k in pairs(obj) do
        obj[k] = nil
    end
    
    table.insert(storage.health_value_pool, obj)
end

--- Get an array from the pool or create a new one
---@return table A reusable array
function storage.get_array()
    local arr = table.remove(storage.array_pool)
    if not arr then
        arr = {}
        storage.pool_stats.array_created = 
            storage.pool_stats.array_created + 1
    else
        storage.pool_stats.array_recycled = 
            storage.pool_stats.array_recycled + 1
    end
    return arr
end

--- Return an array to the pool
---@param arr table The array to recycle
function storage.release_array(arr)
    if not arr then return end
    
    -- Clear all elements but preserve the table
    for i = 1, #arr do
        arr[i] = nil
    end
    
    table.insert(storage.array_pool, arr)
end

--- Initialize object pools with pre-allocated objects
function storage.initialize_pools()
    -- Pre-allocate health value objects
    for i = 1, POOL_INITIAL_SIZE do
        table.insert(storage.health_value_pool, {})
    end
    
    -- Pre-allocate array objects
    for i = 1, MAX_EXPECTED_UNITS do
        table.insert(storage.array_pool, {})
    end
    
    -- Reset stats
    storage.pool_stats = {
        health_value_created = 0,
        health_value_recycled = 0,
        array_created = 0,
        array_recycled = 0
    }
end

-- Export the module
FS.modules.heal_engine.storage = storage
return storage