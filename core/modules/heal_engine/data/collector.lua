--- Heal Engine Data Collector
--- Handles health data collection and storage management

-- Import required modules
local cache = require("core/modules/heal_engine/data/cache")

-- Get configuration values
local MAX_HISTORY_SIZE = FS.config:get("heal_engine.history.max_records", 100)

-- Module namespace
local collector = {
    -- References to main engine module
    health_values = FS.modules.heal_engine.health_values,
    current_health_values = FS.modules.heal_engine.current_health_values,
    fight_start_health = FS.modules.heal_engine.fight_start_health,
    fight_total_damage = FS.modules.heal_engine.fight_total_damage,
    fight_start_time = FS.modules.heal_engine.fight_start_time
}

--- Create a circular buffer for a unit's health history
---@param unit game_object The unit to create buffer for
---@param capacity number Optional custom capacity
---@param component_name string Component name for error tracking
function collector.initialize_circular_buffer(unit, capacity, component_name)
    -- Create a circular buffer for this unit if it doesn't exist
    if not collector.health_values[unit] then
        collector.health_values[unit] = {
            records = FS.modules.heal_engine.get_array(),
            next_index = 1,
            count = 0,
            capacity = capacity or MAX_HISTORY_SIZE
        }
    end
end

--- Store a health value in a unit's circular buffer
---@param unit game_object The unit to store health for
---@param health_value table The health value object
function collector.store_health_value(unit, health_value)
    local buffer = collector.health_values[unit]
    if not buffer then
        collector.initialize_circular_buffer(unit, nil, "heal_engine.collector.store_health_value")
        buffer = collector.health_values[unit]
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

--- Update unit health data for all tracked units
---@param current_time number Current game time
---@param on_damage_callback function Callback function when damage is detected
function collector.update_health_data(current_time, on_damage_callback)
    -- Get config values for health tracking
    local significant_change = FS.config:get("heal_engine.history.significant_change", 0.01)
    local record_interval = FS.config:get("heal_engine.history.record_interval", 250)
    
    -- Update health values for all units
    for _, unit in pairs(FS.modules.heal_engine.units) do
        -- Ensure circular buffer is initialized
        if not collector.health_values[unit] then
            collector.initialize_circular_buffer(unit, nil, "heal_engine.collector.update_health_data")
        end
        
        local buffer = collector.health_values[unit]
        local records = buffer.records
        local last_index = (buffer.next_index - 2) % buffer.capacity + 1
        local last_value = buffer.count > 0 and records[last_index] or nil
        
        local current_health = unit:get_health()
        local current_shield = unit:get_total_shield() or 0
        local total_health = current_health + current_shield

        -- Initialize fight-wide tracking if needed
        if not collector.fight_start_time then
            collector.fight_start_time = current_time
            collector.fight_start_health[unit] = total_health
            collector.fight_total_damage[unit] = 0
        end
        
        -- Only store if health changed or enough time passed
        local should_store = not last_value
        if last_value then
            local health_changed = math.abs(last_value.health - total_health) > significant_change
            local time_passed = current_time - last_value.time >= record_interval
            should_store = health_changed or time_passed

            -- Track fight-wide damage
            if health_changed and last_value.health > total_health then
                local damage = last_value.health - total_health
                collector.fight_total_damage[unit] = (collector.fight_total_damage[unit] or 0) + damage
                
                -- Call damage callback if provided
                if on_damage_callback then
                    on_damage_callback(unit, damage, total_health, last_value.health, current_time)
                end
            end
        end

        if should_store then
            -- Get a health value object from the pool
            local new_value = FS.modules.heal_engine.get_health_value()
            new_value.health = total_health
            new_value.max_health = unit:get_max_health()
            new_value.health_percentage = current_health / unit:get_max_health()
            new_value.time = current_time

            -- Store in circular buffer
            collector.store_health_value(unit, new_value)
            
            -- Update current health values reference
            collector.current_health_values[unit] = new_value
        end
    end
end

-- Export the module
FS.modules.heal_engine.collector = collector
return collector