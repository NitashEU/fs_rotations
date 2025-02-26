--- Heal Engine Cache Management
--- Handles position and distance caching for performance optimization

-- Cache related configuration
local CACHE_LIFETIME = FS.config:get("heal_engine.caching.lifetime", 200) -- 200ms, aligned with average human reaction time

-- Module namespace
local cache = {
    ---@type table<game_object, table> Position cache for unit positions
    position_cache = {},
    ---@type number Last time the position cache was cleared
    position_cache_last_cleared = 0,
    ---@type table<string, number> Distance calculation cache
    distance_cache = {},
    ---@type number Last time the distance cache was cleared
    distance_cache_last_cleared = 0
}

--- Get cached position for a unit
---@param unit game_object The unit to get position for
---@return table Vector3 The position of the unit
function cache.get_position(unit)
    -- Return cached position if it exists
    if cache.position_cache[unit] then
        return cache.position_cache[unit]
    end
    
    -- Get and cache the position
    local position = unit:get_position()
    cache.position_cache[unit] = position
    
    return position
end

--- Get cached distance between two positions
---@param from_pos table Vector3 position
---@param to_pos table Vector3 position
---@return number The distance between positions
function cache.get_distance(from_pos, to_pos)
    -- Create a unique key for this position pair
    local key = tostring(from_pos.x) .. "," .. tostring(from_pos.y) .. "," .. tostring(from_pos.z) .. "_" .. 
                tostring(to_pos.x) .. "," .. tostring(to_pos.y) .. "," .. tostring(to_pos.z)
    
    -- Return cached value if it exists
    if cache.distance_cache[key] then
        return cache.distance_cache[key]
    end
    
    -- Calculate and cache the distance
    local distance = from_pos:dist_to(to_pos)
    cache.distance_cache[key] = distance
    
    return distance
end

--- Clear caches periodically to prevent stale data
---@param current_time number The current game time
function cache.maintain_caches(current_time)
    -- Clear distance cache if it's been too long since last clear
    if current_time - cache.distance_cache_last_cleared > CACHE_LIFETIME then
        cache.distance_cache = {}
        cache.distance_cache_last_cleared = current_time
    end
    
    -- Clear position cache if it's been too long since last clear
    if current_time - cache.position_cache_last_cleared > CACHE_LIFETIME then
        cache.position_cache = {}
        cache.position_cache_last_cleared = current_time
    end
end

--- Refresh position cache for all units
---@param current_time number The current game time
function cache.refresh_position_cache(current_time)
    cache.position_cache = {}
    cache.position_cache_last_cleared = current_time
end

-- Export the module
FS.modules.heal_engine.cache = cache
return cache